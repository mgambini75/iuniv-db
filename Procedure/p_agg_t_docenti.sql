CREATE OR REPLACE PROCEDURE                  P_AGG_T_DOCENTI
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --

   BEGIN
      --Aggiorno i dati della T_DOCENTI
      UPDATE t_docenti a
         SET (sett_cod,
              matricola,
              cognome,
              nome,
              cellulare,
              e_mail,
              des_appellativo,
              des_gruppo,
              des_luogo,
              note_biografiche,
              note_pubblicazioni,
              note_curriculum,
              note_docente,
              giorno,
              ora_inizio,
              ora_fine,
              prg_persona) =
                (SELECT sett_cod AS sett_cod,
                        matricola AS matricola,
                        INITCAP (TRIM (cognome)) AS cognome,
                        INITCAP (TRIM (nome)) AS nome,
                        TRIM (cellulare) AS cellulare,
                        TRIM (LOWER (e_mail)) AS e_mail,
                        NVL (fu_des_up_low (b.appellativo),
                             DECODE (sesso, 'F', 'Prof.ssa', 'Prof.'))
                           AS des_appellativo,
                        DECODE (
                           d.des,
                           NULL, 'Dipartimento da assegnare (DA.ASSEGN)',
                           d.des || ' (' || d.cod || ')')
                           AS des_gruppo,
                        NULL AS des_luogo,
                        fu_des_up_low (note_biografiche) AS note_biografiche,
                        fu_des_up_low (note_pubblicazioni)
                           AS note_pubblicazioni,
                        fu_des_up_low (note_curriculum) AS note_curriculum,
                        fu_des_up_low (note_docente) AS note_docente,
                        NULL AS giorno,
                        NULL AS ora_inizio,
                        NULL AS ora_fine,
                        NULL AS prg_persona
                   FROM docenti b
                        LEFT JOIN docenti_note c
                           ON b.docente_id = c.docente_id
                        LEFT JOIN v06_dip d ON d.dip_id = b.dip_id
                  WHERE a.docente_id = b.docente_id)
       WHERE EXISTS
                (SELECT 1
                   FROM t_docenti x
                  WHERE x.docente_id = a.docente_id);

      -- inserisco i dati mancanti della T_DOCENTI
      INSERT INTO t_docenti
         SELECT ROWNUM + (SELECT NVL (MAX (mid), 0) FROM t_docenti) mid,
                sett_cod AS sett_cod,
                matricola AS matricola,
                INITCAP (TRIM (cognome)) AS cognome,
                INITCAP (TRIM (nome)) AS nome,
                TRIM (cellulare) AS cellulare,
                TRIM (LOWER (e_mail)) AS e_mail,
                NVL (fu_des_up_low (b.appellativo),
                     DECODE (sesso, 'F', 'Prof.ssa', 'Prof.'))
                   AS des_appellativo,
                DECODE (d.des,
                        NULL, 'Dipartimento da assegnare (DA.ASSEGN)',
                        d.des || ' (' || d.cod || ')')
                   AS des_gruppo,
                NULL AS des_luogo,
                fu_des_up_low (note_biografiche) AS note_biografiche,
                fu_des_up_low (note_pubblicazioni) AS note_pubblicazioni,
                fu_des_up_low (note_curriculum) AS note_curriculum,
                fu_des_up_low (note_docente) AS note_docente,
                NULL AS giorno,
                NULL AS ora_inizio,
                NULL AS ora_fine,
                NULL AS prg_persona,
                b.docente_id AS docente_id
           FROM docenti b
                LEFT JOIN docenti_note c ON b.docente_id = c.docente_id
                LEFT JOIN V06_dip d ON d.dip_id = b.dip_id
          WHERE     NOT EXISTS
                       (SELECT 1
                          FROM t_docenti x
                         WHERE x.docente_id = b.docente_id)
                AND UPPER (COGNOME) NOT LIKE '%XXX%'
                AND UPPER (COGNOME) NOT LIKE '%XX%';


      COMMIT;
   END;
END;
/
