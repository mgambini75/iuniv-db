CREATE OR REPLACE PROCEDURE                  p_agg_gen_notifiche
AS
   v_com_id   NUMBER (9);
   v_com_id2  NUMBER (9);
   v_testo    VARCHAR2 (4000);

BEGIN
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Spedisci notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    /*
    Controllo se esistono notifiche da inviare
    */
    SELECT NVL (MAX (age_avt_id), -1)
    INTO v_com_id
    FROM t_notifiche;

    /*
    Se non ci sono dati, significa che e' la prima volta che eseguo la procedura,
    quindi metto un record iniziale con il progressivo massimo.
    La prossima volta parto da quello
    */
    if v_com_id = -1 then
        -- Quale e' il progressivo piu' alto ?
        SELECT NVL (MAX (com_id), 0)
        INTO v_com_id2
        FROM p16_com_est;

        -- Inserisco un record dummy
        INSERT INTO T_NOTIFICHE
        (
            MATRICOLA,
            TESTO,
            TESTO_ITA,
            TESTO_ENG,
            DATA_INS,
            TIPO,
            FLG_SPED,
            DATA_SPED,
            NOTA,
            STU_ID,
            CDS_ID,
            AD_ID,
            APP_ID,
            AGE_AVT_ID
        )
        VALUES
        (
            'X',
            'Prima elaborazione',
            'X',
            'X',
            sysdate,
            'X',
            1,
            null,
            null,
            null,
            null,
            null,
            null,
            v_com_id2
        );

        return;
    end if;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- recupero notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   FOR f1
      IN (SELECT d.user_id AS user_id,
         e.des AS des_categoria,
         e.cod AS cod_categoria,
         a.titolo AS titolo,
         a.oggetto AS oggetto,
         a.com_id AS com_id
            FROM p16_com_est a
                 JOIN p16_com_est_dest b ON b.com_id = a.com_id
                 JOIN p16_destinatari c
                    ON c.dest_id = b.dest_id AND origine_dato = 'EXTERNAL'
                 JOIN p18_user d
                    ON     d.id = c.id_user
                       AND disable_flg = 0
                 JOIN p16_tipo_com_est e
                    ON a.tipo_com_est_id = e.tipo_com_est_id
           WHERE  a.notif_push_flg = 1
                 AND a.com_id > v_com_id)
   LOOP
      v_testo := f1.des_categoria||' - '||f1.titolo;

      --- sistemazione caratteri speciali
      v_testo := replace(v_testo, 'è', 'e''');
      v_testo := replace(v_testo, 'à', 'a''');
      v_testo := replace(v_testo, 'ò', 'o''');
      v_testo := replace(v_testo, 'ì', 'i''');

      INSERT INTO T_NOTIFICHE (MATRICOLA,
                               TESTO,
                               TESTO_ITA,
                               TESTO_ENG,
                               DATA_INS,
                               TIPO,
                               FLG_SPED,
                               DATA_SPED,
                               NOTA,
                               STU_ID,
                               CDS_ID,
                               AD_ID,
                               APP_ID,
                               AGE_AVT_ID)
           VALUES (f1.user_id,
                   v_testo,
                   v_testo,
                   v_testo,
                   sysdate,
                   f1.cod_categoria,
                   0,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   f1.com_id);
   END LOOP;

END;
/
