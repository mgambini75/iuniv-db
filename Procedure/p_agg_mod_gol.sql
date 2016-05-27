CREATE OR REPLACE PROCEDURE P_AGG_MOD_GOL (p_aa_id NUMBER, v_liv1 VARCHAR default 'FACOLTA')
AS
   /*
   Se si vuole mettere il TIPO_CORSO come primo livello, passarlo alla procedura nel seguente modo:
   
   exec P_AGG_MOD_GOL (2014, v_liv1 => 'TIPO_CORSO');
   
   altrimenti viene messa la facolta

   */
   ---------------------------------------------------------------------------------
   --- CALCOLO DEGLI ID
   --- NOTE:   v_liv1  VARCHAR2(50) := 'FACOLTA';   -- FACOLTA oppure TIPO_CORSO
   ---------------------------------------------------------------------------------
   ---
   ---------------------------------------------------------------------------------

   --- CURSORE PRIMO LIVELLO
   -- Facolta
   CURSOR c_liv_1_fac
   IS
        SELECT aa_off_id, fac_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY aa_off_id, fac_id
      ORDER BY aa_off_id, fac_id;

   -- Tipo corso
   CURSOR c_liv_1_tipo_corso
   IS
        SELECT aa_off_id, TIPO_CORSO_COD
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY aa_off_id, TIPO_CORSO_COD
      ORDER BY aa_off_id, TIPO_CORSO_COD;
      
      
   --- CURSORE SECONDO LIVELLO
   CURSOR c_liv_2
   IS
        SELECT mid_liv_1, cds_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1, cds_id
      ORDER BY mid_liv_1, cds_id;

   --- CURSORE TERZO LIVELLO
   CURSOR c_liv_3
   IS
        SELECT mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id
      ORDER BY mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id;

   --- CURSORE QUARTO LIVELLO
   CURSOR c_liv_4
   IS
        SELECT mid_liv_1,
               mid_liv_2,
               NVL (mid_liv_3, 99999) AS mid_liv_3,
               ad_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1,
               mid_liv_2,
               mid_liv_3,
               ad_id
      ORDER BY mid_liv_1,
               mid_liv_2,
               NVL (mid_liv_3, 99999),
               ad_id;

   --- CURSORE AD
   CURSOR c_ad
   IS
        SELECT DISTINCT mid_liv_4
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_liv_4;

   --- CURSORE AD_CLA
   CURSOR c_ad_cla
   IS
        SELECT DISTINCT mid_ad, fat_part_cod, dom_part_cod
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, fat_part_cod, dom_part_cod;

   --- CURSORE AD_MOD
   CURSOR c_ad_mod
   IS
        SELECT DISTINCT mid_ad, ud_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, ud_id;

   --- CURSORE AD_DOC
   CURSOR c_ad_doc
   IS
        SELECT DISTINCT mid_ad, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, docente_id;

   --- CURSORE AD_MOD_DOC
   CURSOR c_ad_mod_doc
   IS
        SELECT DISTINCT mid_ad_mod, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad_mod, docente_id;

   --- CURSORE AD_CLA_DOC
   CURSOR c_ad_cla_doc
   IS
        SELECT DISTINCT mid_ad_cla, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad_cla, docente_id;

   v_id                 GOL_IUNI.mid_ad%TYPE;
   v_old_aa_off_id      GOL_IUNI.aa_off_id%TYPE;
   v_old_fac_id         GOL_IUNI.fac_id%TYPE;
   v_old_cds_id         GOL_IUNI.cds_id%TYPE;
   v_old_aa_ord_id      GOL_IUNI.aa_ord_id%TYPE;
   v_old_pds_id         GOL_IUNI.pds_id%TYPE;
   v_old_ad_id          GOL_IUNI.ad_id%TYPE;
   v_old_tipo_corso_cod GOL_IUNI.TIPO_CORSO_COD%TYPE;

   v_old_mid_liv_1      GOL_IUNI.mid_liv_1%TYPE;
   v_old_mid_liv_2      GOL_IUNI.mid_liv_2%TYPE;
   v_old_mid_liv_3      GOL_IUNI.mid_liv_3%TYPE;
   v_old_mid_liv_4      GOL_IUNI.mid_liv_4%TYPE;

   v_old_mid_ad         GOL_IUNI.mid_ad%TYPE;
   v_old_mid_ad_mod     GOL_IUNI.mid_ad_mod%TYPE;
   v_old_mid_ad_cla     GOL_IUNI.mid_ad_cla%TYPE;
   v_old_mid_ad_doc     GOL_IUNI.mid_ad_doc%TYPE;

   v_old_fat_part_cod   GOL_IUNI.fat_part_cod%TYPE;
   v_old_dom_part_cod   GOL_IUNI.dom_part_cod%TYPE;
   v_old_ud_id          GOL_IUNI.ud_id%TYPE;

   v_old_docente_id     GOL_IUNI.docente_id%TYPE;


   v_time_start         DATE;
   v_time_end           DATE;
   v_step               VARCHAR2 (100);
   
   -- Default
  

BEGIN
   v_old_fac_id := 0;
   v_old_aa_off_id := 0;
   v_old_cds_id := 0;
   v_old_aa_ord_id := 0;
   v_old_pds_id := 0;
   v_old_ad_id := 0;
   v_old_mid_liv_1 := 0;
   v_old_mid_liv_2 := 0;
   v_old_mid_liv_3 := 0;

   v_old_mid_ad := 0;
   v_old_mid_ad_cla := 0;
   v_old_mid_ad_doc := 0;
   v_old_mid_ad_mod := 0;

   v_old_fat_part_cod := 'x';
   v_old_dom_part_cod := 'x';
   v_old_ud_id := 0;
   v_old_docente_id := 0;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- ELIMINAZIONE TABELLA DI APPOGGIO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE GOL_IUNI
    WHERE aa_off_id = p_aa_id;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- CARICAMENTO TABELLA DI APPOGGIO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO GOL_IUNI (mid_pk,
                         mid_liv_1,
                         mid_liv_2,
                         mid_liv_3,
                         mid_liv_4,
                         mid_ad,
                         mid_ad_cla,
                         mid_ad_doc,
                         mid_ad_mod,
                         mid_ad_mod_doc,
                         mid_ad_cla_doc,
                         AA_OFF_ID,
                         FAC_ID,
                         CDS_ID,
                         AD_ID,
                         AA_ORD_ID,
                         PDS_ID,
                         UD_ID,
                         SEG_ID,
                         TIPO_CORSO_COD,
                         COD_FAC,
                         DES_FAC,
                         COD_CDS,
                         DES_CDS,
                         COD_AD,
                         DES_AD,
                         COD_MOD,
                         DES_MOD,
                         TIPO_INS_COD,
                         DUR_UNI_VAL,
                         DUR_STU_IND,
                         PESO_TOT,
                         PESO_DET,
                         TIPO_AF_COD,
                         DES_TAF,
                         AMB_ID,
                         DES_AMB,
                         SETT_COD,
                         DOCENTE_ID,
                         TIPO_COPERTURA_COD,
                         FAT_PART_COD,
                         DOM_PART_COD,
                         TITOLARE_FLG,
                         PART_COD,
                         DES_PART,
                         TIPO_DID_COD,
                         DES_TIPI_DID,
                         LINGUA_DID_ID,
                         DES_LUNGUA_DID)
      --CREATE TABLE GOL_IUNI AS
      SELECT ROWNUM AS mid_pk,
             CAST (NULL AS NUMBER) AS mid_liv_1,                   --- facoltà
             CAST (NULL AS NUMBER) AS mid_liv_2,                     --- corso
             CAST (NULL AS NUMBER) AS mid_liv_3,    --- ordinamento / persorso
             CAST (NULL AS NUMBER) AS mid_liv_4,                  --- attività
             CAST (NULL AS NUMBER) AS mid_ad,
             CAST (NULL AS NUMBER) AS mid_ad_cla,
             CAST (NULL AS NUMBER) AS mid_ad_doc,
             CAST (NULL AS NUMBER) AS mid_ad_mod,
             CAST (NULL AS NUMBER) AS mid_ad_mod_doc,
             CAST (NULL AS NUMBER) AS mid_ad_cla_doc,
             AA_OFF_ID,
             FAC_ID,
             CDS_ID,
             AD_ID,
             AA_ORD_ID,
             PDS_ID,
             UD_ID,
             SEG_ID,
             TIPO_CORSO_COD,
             COD_FAC,
             DES_FAC,
             COD_CDS,
             DES_CDS,
             COD_AD,
             DES_AD,
             COD_MOD,
             DES_MOD,
             TIPO_INS_COD,
             DUR_UNI_VAL,
             DUR_STU_IND,
             PESO_TOT,
             PESO_DET,
             TIPO_AF_COD,
             DES_TAF,
             AMB_ID,
             DES_AMB,
             SETT_COD,
             DOCENTE_ID,
             TIPO_COPERTURA_COD,
             FAT_PART_COD,
             DOM_PART_COD,
             TITOLARE_FLG,
             PART_COD,
             DES_PART,
             TIPO_DID_COD,
             DES_TIPI_DID,
             LINGUA_DID_ID,
             DES_LUNGUA_DID
        FROM v_gol_offerta_esse3 a
       WHERE aa_off_id = p_aa_id;


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- DEFINIZIONE PROGRESSIVI
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- Livello 1
   -- ---------
   SELECT NVL (MAX (mid_liv_1), 10000) INTO v_id FROM GOL_IUNI;

   if v_liv1 = 'FACOLTA' then
       FOR r_liv_1 IN c_liv_1_fac
       LOOP
          IF     v_old_fac_id = r_liv_1.fac_id
             AND v_old_aa_off_id = r_liv_1.aa_off_id
          THEN
             v_id := v_id;
          ELSE
             v_id := v_id + 1;
          END IF;

          UPDATE GOL_IUNI
             SET mid_liv_1 = v_id
           WHERE aa_off_id = r_liv_1.aa_off_id AND fac_id = r_liv_1.fac_id;

          v_old_aa_off_id := r_liv_1.aa_off_id;
          v_old_fac_id := r_liv_1.fac_id;
       END LOOP;
    end if;
    
   if v_liv1 = 'TIPO_CORSO' then
       FOR r_liv_1 IN c_liv_1_tipo_corso
       LOOP
          IF     v_old_tipo_corso_cod = r_liv_1.tipo_corso_cod
             AND v_old_aa_off_id = r_liv_1.aa_off_id
          THEN
             v_id := v_id;
          ELSE
             v_id := v_id + 1;
          END IF;

          UPDATE GOL_IUNI
             SET mid_liv_1 = v_id
           WHERE aa_off_id = r_liv_1.aa_off_id AND tipo_corso_cod = r_liv_1.tipo_corso_cod;

          v_old_aa_off_id := r_liv_1.aa_off_id;
          v_old_tipo_corso_cod := r_liv_1.tipo_corso_cod;
       END LOOP;
   end if;
    
   -- Livello 2
   -- ---------
   SELECT NVL (MAX (mid_liv_2), 20000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_2 IN c_liv_2
   LOOP
      IF     v_old_mid_liv_1 = r_liv_2.mid_liv_1
         AND v_old_cds_id = r_liv_2.cds_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_2 = v_id
       WHERE mid_liv_1 = r_liv_2.mid_liv_1 AND cds_id = r_liv_2.cds_id;

      v_old_mid_liv_1 := r_liv_2.mid_liv_1;
      v_old_cds_id := r_liv_2.cds_id;
   END LOOP;

   SELECT NVL (MAX (mid_liv_3), 30000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_3 IN c_liv_3
   LOOP
      IF     v_old_mid_liv_1 = r_liv_3.mid_liv_1
         AND v_old_mid_liv_2 = r_liv_3.mid_liv_2
         AND v_old_aa_ord_id = r_liv_3.aa_ord_id
         AND v_old_pds_id = r_liv_3.pds_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_3 = v_id
       WHERE     mid_liv_1 = r_liv_3.mid_liv_1
             AND mid_liv_2 = r_liv_3.mid_liv_2
             AND aa_ord_id = r_liv_3.aa_ord_id
             AND pds_id = r_liv_3.pds_id;

      v_old_mid_liv_1 := r_liv_3.mid_liv_1;
      v_old_mid_liv_2 := r_liv_3.mid_liv_2;
      v_old_aa_ord_id := r_liv_3.aa_ord_id;
      v_old_pds_id := r_liv_3.pds_id;
   END LOOP;

   --- doce è presente un solo ordinamento e un solo percorso
   UPDATE GOL_IUNI
      SET mid_liv_3 = NULL
    WHERE (mid_liv_1, mid_liv_2) IN (  SELECT mid_liv_1, mid_liv_2
                                         FROM (SELECT DISTINCT
                                                      mid_liv_1,
                                                      mid_liv_2,
                                                      mid_liv_3
                                                 FROM GOL_IUNI)
                                     GROUP BY mid_liv_1, mid_liv_2
                                       HAVING COUNT (*) = 1);

   SELECT NVL (MAX (mid_liv_4), 40000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_4 IN c_liv_4
   LOOP
      IF     v_old_mid_liv_1 = r_liv_4.mid_liv_1
         AND v_old_mid_liv_2 = r_liv_4.mid_liv_2
         AND v_old_mid_liv_3 = r_liv_4.mid_liv_3
         AND v_old_ad_id = r_liv_4.ad_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_4 = v_id
       WHERE     mid_liv_1 = r_liv_4.mid_liv_1
             AND mid_liv_2 = r_liv_4.mid_liv_2
             AND NVL (mid_liv_3, 99999) = r_liv_4.mid_liv_3
             AND ad_id = r_liv_4.ad_id;

      v_old_mid_liv_1 := r_liv_4.mid_liv_1;
      v_old_mid_liv_2 := r_liv_4.mid_liv_2;
      v_old_mid_liv_3 := r_liv_4.mid_liv_3;
      v_old_ad_id := r_liv_4.ad_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad IN c_ad
   LOOP
      IF v_old_mid_liv_4 = r_ad.mid_liv_4
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad = v_id
       WHERE mid_liv_4 = r_ad.mid_liv_4;

      v_old_mid_liv_4 := r_ad.mid_liv_4;
   END LOOP;

   SELECT NVL (MAX (mid_ad_cla), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_cla IN c_ad_cla
   LOOP
      IF     v_old_mid_ad = r_ad_cla.mid_ad
         AND v_old_fat_part_cod = r_ad_cla.fat_part_cod
         AND v_old_dom_part_cod = r_ad_cla.dom_part_cod
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_cla = v_id
       WHERE     mid_ad = r_ad_cla.mid_ad
             AND fat_part_cod = r_ad_cla.fat_part_cod
             AND dom_part_cod = r_ad_cla.dom_part_cod;

      v_old_mid_ad := r_ad_cla.mid_ad;
      v_old_fat_part_cod := r_ad_cla.fat_part_cod;
      v_old_dom_part_cod := r_ad_cla.dom_part_cod;
   END LOOP;

   SELECT NVL (MAX (mid_ad_mod), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_mod IN c_ad_mod
   LOOP
      IF v_old_mid_ad = r_ad_mod.mid_ad AND v_old_ud_id = r_ad_mod.ud_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_mod = v_id
       WHERE mid_ad = r_ad_mod.mid_ad AND ud_id = r_ad_mod.ud_id;

      v_old_mid_ad := r_ad_mod.mid_ad;
      v_old_ud_id := r_ad_mod.ud_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_doc IN c_ad_doc
   LOOP
      IF     v_old_mid_ad = r_ad_doc.mid_ad
         AND v_old_docente_id = r_ad_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_doc = v_id
       WHERE mid_ad = r_ad_doc.mid_ad AND docente_id = r_ad_doc.docente_id;

      v_old_mid_ad := r_ad_doc.mid_ad;
      v_old_docente_id := r_ad_doc.docente_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_mod_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_mod_doc IN c_ad_mod_doc
   LOOP
      IF     v_old_mid_ad_mod = r_ad_mod_doc.mid_ad_mod
         AND v_old_docente_id = r_ad_mod_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_mod_doc = v_id
       WHERE     mid_ad_mod = r_ad_mod_doc.mid_ad_mod
             AND docente_id = r_ad_mod_doc.docente_id;

      v_old_mid_ad_mod := r_ad_mod_doc.mid_ad_mod;
      v_old_docente_id := r_ad_mod_doc.docente_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_cla_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_cla_doc IN c_ad_cla_doc
   LOOP
      IF     v_old_mid_ad_cla = r_ad_cla_doc.mid_ad_cla
         AND v_old_docente_id = r_ad_cla_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_cla_doc = v_id
       WHERE     mid_ad_cla = r_ad_cla_doc.mid_ad_cla
             AND docente_id = r_ad_cla_doc.docente_id;

      v_old_mid_ad_cla := r_ad_cla_doc.mid_ad_cla;
      v_old_docente_id := r_ad_cla_doc.docente_id;
   END LOOP;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- CARICAMENTO DEI DATI NELLE TABELLE
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

   --- eliminazione dati lingua
   DELETE FROM gol_liv_ln
         WHERE mid IN (SELECT mid
                         FROM gol_liv
                        WHERE aa_id = p_aa_id);

   DELETE FROM gol_liv
         WHERE aa_id = p_aa_id;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- PRIMO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- Se primo livello = FACOLTA
   -- --------------------------
   if v_liv1 = 'FACOLTA' then
        INSERT INTO gol_liv (mid,
                    code,
                    name,
                    description,
                    mid_liv_padre,
                    mid_dett,
                    aa_id,
                    ordine)
        SELECT a.mid_liv_1 AS mid,
           cod AS code,
           nvl(decode(b.des_breve, b.cod, null, b.des_breve), b.des) as name,
           INITCAP (via || ', ' || citta) AS description,
           NULL AS mid_liv_padre,
           NULL AS mid_dett,
           aa_off_id AS aa_id,
           NULL AS ordine
        FROM GOL_IUNI a JOIN p06_fac b ON a.fac_id = b.fac_id
        WHERE aa_off_id = 2014
        GROUP BY a.mid_liv_1,
           a.aa_off_id,
           b.cod,
           NVL (b.des_breve, b.des),
           via || ', ' || citta
        ORDER BY a.mid_liv_1;

        --- inglese
        INSERT INTO gol_liv_ln (mid,
                       ln_code,
                       name,
                       description)
        SELECT a.mid_liv_1 AS mid,
           'en' AS ln_code,
           fu_des_up_low(nvl(c.des, nvl(b.des_breve, b.des))) as name,
           INITCAP (via || ', ' || citta) AS description
        FROM GOL_IUNI a
           JOIN p06_fac b ON a.fac_id = b.fac_id
           LEFT JOIN p06_fac_des_lin c
              ON c.fac_id = b.fac_id AND lingua_id = 1
        WHERE aa_off_id = p_aa_id
        GROUP BY a.mid_liv_1,
           a.aa_off_id,
           b.cod,
           NVL (c.des, NVL (b.des_breve, b.des)),
           via || ', ' || citta
        ORDER BY a.mid_liv_1;
    end if;
    
     -- Se primo livello = TIPO_CORSO
   -- --------------------------
    if v_liv1 = 'TIPO_CORSO' then
        INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_1 AS mid,
               c.tipo_corso_cod AS code,
               fu_des_up_low (c.tipo_corso_des) AS name,
               c.tipo_corso_cod AS description,
               NULL AS mid_liv_padre,
               NULL AS mid_dett,
               aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a 
               JOIN p06_cds b ON a.cds_id = b.cds_id
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
         WHERE aa_off_id = 2014
        GROUP BY a.mid_liv_1,
               a.aa_off_id,
               c.tipo_corso_cod,
               fu_des_up_low (c.tipo_corso_des),
               c.tipo_corso_cod
        ORDER BY a.mid_liv_1;
      
         --- inglese
        INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_1 AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (c.des, NVL (b.des_breve, b.des))) AS name,
               INITCAP (via || ', ' || citta) AS description
          FROM GOL_IUNI a
               JOIN p06_fac b ON a.fac_id = b.fac_id
               LEFT JOIN p06_fac_des_lin c
                  ON c.fac_id = b.fac_id AND lingua_id = 1
         WHERE aa_off_id = p_aa_id
        GROUP BY a.mid_liv_1,
               a.aa_off_id,
               b.cod,
               NVL (c.des, NVL (b.des_breve, b.des)),
               via || ', ' || citta
        ORDER BY a.mid_liv_1;
    end if;
    
    
   v_time_end := SYSDATE;

   v_step := 'step 1';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- SECONDO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_2 AS mid,
               cod AS code,
               fu_des_up_low (b.des) AS name,
                  '['
               || cod
               || '] '
               || c.tipo_corso_cod
               || ' - '
               || fu_des_up_low (c.tipo_corso_des)
                  AS description,
               a.mid_liv_1 AS mid_liv_padre,
               NULL AS mid_dett,
               aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a
               JOIN p06_cds b ON a.cds_id = b.cds_id
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.aa_off_id,
               a.mid_liv_2,
               b.cod,
               b.des,
               c.tipo_corso_cod,
               c.tipo_corso_des
      ORDER BY a.mid_liv_2;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_2 AS mid,
               'en' AS ln_cod,
               fu_des_up_low (b1.des) AS name,
                  '['
               || cod
               || '] '
               || c.tipo_corso_cod
               || ' - '
               || fu_des_up_low (NVL (c1.ds_tipo_corso_des, c.tipo_corso_des))
                  AS description
          FROM GOL_IUNI a
               JOIN p06_cds b ON a.cds_id = b.cds_id
               LEFT JOIN p06_cds_des_lin b1
                  ON a.cds_id = b1.cds_id AND b1.lingua_id = 1
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
               LEFT JOIN tipi_corso_des_lin c1
                  ON b.tipo_corso_cod = c1.tipo_corso_cod AND c1.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.aa_off_id,
               a.mid_liv_2,
               b.cod,
               b1.des,
               c.tipo_corso_cod,
               NVL (c1.ds_tipo_corso_des, c.tipo_corso_des)
      ORDER BY a.mid_liv_2;

   v_time_end := SYSDATE;

   v_step := 'step 2';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- TERZO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_3 AS mid,
               b.aa_ord_id || '/' || c.cod AS code,
               b.aa_ord_id || ' - ' || c.cod AS name,
               'Ind: ' || fu_des_up_low (c.des) AS description,
               a.mid_liv_2 AS mid_liv_padre,
               NULL AS mid_dett,
               a.aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a
               JOIN p06_cdsord b
                  ON a.cds_id = b.cds_id AND a.aa_ord_id = b.aa_ord_id
               JOIN p06_pdsord c
                  ON     a.cds_id = c.cds_id
                     AND a.aa_ord_id = c.aa_ord_id
                     AND a.pds_id = c.pds_id
         WHERE mid_liv_3 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               b.aa_ord_id,
               c.cod,
               a.aa_off_id,
               c.des,
               a.cds_id
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.aa_ord_id || '/' || c.cod;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_3 AS mid,
               'en' AS ln_code,
               b.aa_ord_id || ' - ' || c.cod AS name,
               'Ind: ' || fu_des_up_low (NVL (c1.des, c.des)) AS description
          FROM GOL_IUNI a
               JOIN p06_cdsord b
                  ON a.cds_id = b.cds_id AND a.aa_ord_id = b.aa_ord_id
               JOIN p06_pdsord c
                  ON     a.cds_id = c.cds_id
                     AND a.aa_ord_id = c.aa_ord_id
                     AND a.pds_id = c.pds_id
               LEFT JOIN p06_pdsord_des_lin c1
                  ON     a.cds_id = c1.cds_id
                     AND a.aa_ord_id = c1.aa_ord_id
                     AND a.pds_id = c1.pds_id
                     AND c1.lingua_id = 1
         WHERE mid_liv_3 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               b.aa_ord_id,
               c.cod,
               a.aa_off_id,
               NVL (c1.des, c.des),
               a.cds_id
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.aa_ord_id || '/' || c.cod;

   v_time_end := SYSDATE;

   v_step := 'step 3';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- ULTIMO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_4 AS mid,
               b.cod AS code,
               fu_des_up_low (b.des) AS name,
               'lista docenti...' AS description,
               NVL (a.mid_liv_3, a.mid_liv_2) AS mid_liv_padre,
               mid_ad AS mid_dett,
               a.aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a JOIN p09_ad_gen b ON a.ad_id = b.ad_id
         WHERE mid_liv_4 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.aa_off_id,
               a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               a.mid_liv_4,
               b.des,
               b.cod,
               mid_ad
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.des;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_4 AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (b1.ds_ad_des, b.des)) AS name,
               'lista docenti...' AS description
          FROM GOL_IUNI a
               JOIN p09_ad_gen b ON a.ad_id = b.ad_id
               LEFT JOIN p09_ad_des_lin b1
                  ON a.ad_id = b1.ad_id AND b1.lingua_id = 1
         WHERE mid_liv_4 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.aa_off_id,
               a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               a.mid_liv_4,
               NVL (b1.ds_ad_des, b.des),
               b.cod,
               mid_ad
      ORDER BY a.mid_liv_1, a.mid_liv_2, NVL (b1.ds_ad_des, b.des);


   v_time_end := SYSDATE;

   v_step := 'step 4';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- caricamento totale ITALIANO
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
      SELECT mid,
             'it' ln_code,
             name,
             description
        FROM gol_liv
       WHERE aa_id = p_aa_id;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad (mid,
                       percorso,
                       attivita,
                       descrizione,
                       metodi_did_des,
                       obiett_form_des,
                       prerequisiti_des,
                       contenuti_des,
                       testi_rif_des,
                       mod_ver_appr_des,
                       altre_info_des,
                       peso,
                       struttura_cfu,
                       cds_id,
                       ad_id,
                       aa_off_id,
                       aa_ord_id,
                       pds_id,
                       ext_id)
      SELECT DISTINCT a.mid_ad AS mid,
                      a.des_cds AS percorso,
                      a.des_ad AS attivita,
                      NULL AS descrizione,
                      NULL AS metodi_did_des,
                      NULL AS obiett_form_des,
                      NULL AS prerequisiti_des,
                      NULL AS contenuti_des,
                      NULL AS testi_rif_des,
                      NULL AS mod_ver_appr_des,
                      NULL AS altre_info_des,
                      a.peso_tot AS peso,
                      'Convenzionale in italiano' AS struttura_cfu,
                      a.cds_id AS cds_id,
                      a.ad_id AS ad_id,
                      a.aa_off_id AS aa_off_id,
                      a.aa_ord_id AS aa_ord_id,
                      a.pds_id AS pds_id,
                      NULL AS ext_id
        FROM GOL_IUNI a
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_ln (mid,
                          ln_code,
                          percorso,
                          attivita,
                          descrizione,
                          metodi_did_des,
                          obiett_form_des,
                          prerequisiti_des,
                          contenuti_des,
                          testi_rif_des,
                          mod_ver_appr_des,
                          altre_info_des,
                          struttura_cfu)
      SELECT DISTINCT
             a.mid_ad AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (b.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (b1.ds_ad_des, a.des_ad)) AS attivita,
             NULL AS descrizione,
             NULL AS metodi_did_des,
             NULL AS obiett_form_des,
             NULL AS prerequisiti_des,
             NULL AS contenuti_des,
             NULL AS testi_rif_des,
             NULL AS mod_ver_appr_des,
             NULL AS altre_info_des,
             'Conventional in Italian' AS struttura_cfu
        FROM GOL_IUNI a
             LEFT JOIN p06_cds_des_lin b
                ON a.cds_id = b.cds_id AND lingua_id = 1
             LEFT JOIN p09_ad_des_lin b1
                ON a.ad_id = b1.ad_id AND b1.lingua_id = 1
       WHERE aa_off_id = p_aa_id;


   v_time_end := SYSDATE;

   v_step := 'step 5';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiornamento descrizione in italiano e in lingua
   unixx_descrizione_ad (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 6';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- AGGIORNO I TESTI
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM T_GOL_AD_DESCRIZIONI_TUTTE;

   INSERT INTO T_GOL_AD_DESCRIZIONI_TUTTE
      SELECT DISTINCT a.mid,
                      c.cds_id,
                      c.ad_id,
                      c.aa_off_id,
                      c.aa_ord_id,
                      c.pds_id,
                      c.fat_part_cod,
                      c.dom_part_cod,
                      c.part_cod,
                      ad_log_id,
                      c.metodi_did_des,
                      c.obiett_form_des,
                      c.prerequisiti_des,
                      c.contenuti_des,
                      c.testi_rif_des,
                      c.mod_ver_appr_des,
                      c.altre_info_des,
                      'it'
        FROM gol_ad a
             JOIN GOL_IUNI b ON a.mid = b.mid_ad
             JOIN p09_ad_log_pds c
                ON     b.cds_id = c.cds_id
                   AND b.ad_id = c.ad_id
                   AND b.aa_off_id = c.aa_off_id
                   AND b.aa_ord_id = c.aa_ord_id
                   AND b.pds_id = c.pds_id
       WHERE     (   c.metodi_did_des IS NOT NULL
                  OR c.obiett_form_des IS NOT NULL
                  OR c.prerequisiti_des IS NOT NULL
                  OR c.contenuti_des IS NOT NULL
                  OR c.testi_rif_des IS NOT NULL
                  OR c.mod_ver_appr_des IS NOT NULL
                  OR c.altre_info_des IS NOT NULL)
             AND a.aa_off_id = p_aa_id;

   INSERT INTO T_GOL_AD_DESCRIZIONI_TUTTE
      SELECT DISTINCT a.mid,
                      c.cds_id,
                      c.ad_id,
                      c.aa_off_id,
                      c.aa_ord_id,
                      c.pds_id,
                      c.fat_part_cod,
                      c.dom_part_cod,
                      c.part_cod,
                      ad_log_id,
                      c.metodi_did_des,
                      c.obiett_form_des,
                      c.prerequisiti_des,
                      c.contenuti_des,
                      c.testi_rif_des,
                      c.mod_ver_appr_des,
                      c.altre_info_des,
                      'en'
        FROM gol_ad a
             JOIN GOL_IUNI b ON a.mid = b.mid_ad
             JOIN p09_ad_log_pds_des_lin c
                ON     b.cds_id = c.cds_id
                   AND b.ad_id = c.ad_id
                   AND b.aa_off_id = c.aa_off_id
                   AND b.aa_ord_id = c.aa_ord_id
                   AND b.pds_id = c.pds_id
                   AND c.lingua_id = 1
       WHERE     (   c.metodi_did_des IS NOT NULL
                  OR c.obiett_form_des IS NOT NULL
                  OR c.prerequisiti_des IS NOT NULL
                  OR c.contenuti_des IS NOT NULL
                  OR c.testi_rif_des IS NOT NULL
                  OR c.mod_ver_appr_des IS NOT NULL
                  OR c.altre_info_des IS NOT NULL)
             AND a.aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 6.1';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   DELETE FROM T_GOL_AD_DESCRIZIONI;

   INSERT INTO T_GOL_AD_DESCRIZIONI (MID,
                                     CDS_ID,
                                     AD_ID,
                                     AA_OFF_ID,
                                     AA_ORD_ID,
                                     PDS_ID,
                                     FAT_PART_COD,
                                     DOM_PART_COD,
                                     PART_COD,
                                     AD_LOG_ID,
                                     METODI_DID_DES,
                                     OBIETT_FORM_DES,
                                     PREREQUISITI_DES,
                                     CONTENUTI_DES,
                                     TESTI_RIF_DES,
                                     MOD_VER_APPR_DES,
                                     ALTRE_INFO_DES,
                                     LN_CODE)
      SELECT MID,
             CDS_ID,
             AD_ID,
             AA_OFF_ID,
             AA_ORD_ID,
             PDS_ID,
             FAT_PART_COD,
             DOM_PART_COD,
             PART_COD,
             AD_LOG_ID,
             METODI_DID_DES,
             OBIETT_FORM_DES,
             PREREQUISITI_DES,
             CONTENUTI_DES,
             TESTI_RIF_DES,
             MOD_VER_APPR_DES,
             ALTRE_INFO_DES,
             LN_CODE
        FROM T_GOL_AD_DESCRIZIONI_TUTTE
       WHERE (mid, ln_code) NOT IN (  SELECT mid, ln_code
                                        FROM T_GOL_AD_DESCRIZIONI_TUTTE
                                    GROUP BY mid, ln_code
                                      HAVING COUNT (*) > 1);

   v_time_end := SYSDATE;

   v_step := 'step 6.2';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- METODI_DID_DES = '<strong>Metodi didattici ???</strong><br/>'
   UPDATE gol_ad a
      SET metodi_did_des =
             (SELECT    '<strong>Metodi didattici </strong><br/>
    '
                     || b.metodi_did_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     metodi_did_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET metodi_did_des =
             (SELECT    '<strong>Teaching Methods </strong><br/>
    '
                     || b.metodi_did_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     metodi_did_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 7';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---     OBIETT_FORM_DES = '<strong>Obiettivi ???</strong><br/>'
   UPDATE gol_ad a
      SET obiett_form_des =
             (SELECT DISTINCT
                        '<strong>Obiettivi </strong><br/>
    '
                     || b.obiett_form_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     obiett_form_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET obiett_form_des =
             (SELECT DISTINCT
                        '<strong>Objective </strong><br/>
    '
                     || b.obiett_form_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     obiett_form_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 8';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---     PREREQUISITI_DES = '<strong>Prerequisiti ???</strong><br/>'
   UPDATE gol_ad a
      SET prerequisiti_des =
             (SELECT DISTINCT
                        '<strong>Prerequisiti </strong><br/>
    '
                     || b.prerequisiti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     prerequisiti_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET prerequisiti_des =
             (SELECT DISTINCT
                        '<strong>Prerequisites </strong><br/>
    '
                     || b.prerequisiti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     prerequisiti_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 9';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    CONTENUTI_DES = '<strong>Contenuti ???</strong><br/>'
   UPDATE gol_ad a
      SET contenuti_des =
             (SELECT DISTINCT
                        '<strong>Contenuti </strong><br/>
    '
                     || contenuti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     contenuti_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET contenuti_des =
             (SELECT DISTINCT
                        '<strong>Contents </strong><br/>
    '
                     || contenuti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     contenuti_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 10';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;


   v_time_start := SYSDATE;

   ---    TESTI_RIF_DES = '<strong>testi di riferimento ???</strong><br/>'
   UPDATE gol_ad a
      SET testi_rif_des =
             (SELECT DISTINCT
                        '<strong>Testi di riferimento </strong><br/>
    '
                     || b.testi_rif_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     testi_rif_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET testi_rif_des =
             (SELECT DISTINCT
                        '<strong>Reference Books </strong><br/>
    '
                     || b.testi_rif_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     testi_rif_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 11';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    MOD_VER_APPR_DES = '<strong>Modalita di apprendimento ???</strong><br/>'
   UPDATE gol_ad a
      SET mod_ver_appr_des =
             (SELECT DISTINCT
                        '<strong>Modalita di apprendimento </strong><br/>
    '
                     || b.mod_ver_appr_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     mod_ver_appr_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET mod_ver_appr_des =
             (SELECT DISTINCT
                        '<strong>Learning Model </strong><br/>
    '
                     || b.mod_ver_appr_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     mod_ver_appr_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 12';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    ALTRE_INFO_DES = '<strong>Altre info ???</strong><br/>'
   UPDATE gol_ad a
      SET altre_info_des =
             (SELECT DISTINCT
                        '<strong>Altre info </strong><br/>
    '
                     || b.altre_info_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     altre_info_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET altre_info_des =
             (SELECT DISTINCT
                        '<strong>More info </strong><br/>
    '
                     || b.altre_info_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     altre_info_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 13';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_CLA
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

   DELETE FROM gol_ad_cla_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_cla
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_cla
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla (mid,
                           mid_ad,
                           percorso,
                           attivita,
                           classe,
                           descrizione,
                           info_sem_classe,
                           info_aule_edifici,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           dom_part_cod,
                           cod_corso,
                           cod_percorso,
                           cod_ad,
                           fat_part_cod)
      SELECT DISTINCT a.mid_ad_cla AS mid,
                      a.mid_ad AS mid_ad,
                      a.des_cds AS percorso,
                      a.des_ad AS attivita,
                      b.des AS classe,
                      ' ' AS descrizione,
                      NULL AS info_sem_classe,
                      NULL AS info_aule_edifici,
                      a.cds_id AS cds_id,
                      a.ad_id AS ad_id,
                      a.aa_off_id AS aa_off_id,
                      a.aa_ord_id AS aa_ord_id,
                      a.pds_id AS pds_id,
                      a.dom_part_cod AS dom_part_cod,
                      a.cod_cds AS cod_corso,
                      NULL AS cod_percorso,
                      a.cod_ad AS cod_ad,
                      a.fat_part_cod AS fat_part_cod
        FROM GOL_IUNI a
             JOIN dom_part b
                ON     a.fat_part_cod = b.fat_part_cod
                   AND a.dom_part_cod = b.dom_part_cod
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 14';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   UPDATE gol_ad_cla a
      SET info_sem_classe =
             (SELECT DISTINCT des_part
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_cla AND des_part IS NOT NULL)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 15';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_cla a
      SET info_sem_classe = 'Annuale'
    WHERE info_sem_classe IS NULL AND aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 16';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- inglese
   INSERT INTO gol_ad_cla_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              classe,
                              descrizione,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT DISTINCT
             a.mid_ad_cla AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
             b.des AS classe,
             ' ' AS descrizione,
             info_sem_classe AS info_sem_classe,
             info_aule_edifici AS info_aule_edifici
        FROM GOL_IUNI a
             JOIN gol_ad_cla a1 ON a1.MID = a.mid_ad_cla
             JOIN dom_part b
                ON     a.fat_part_cod = b.fat_part_cod
                   AND a.dom_part_cod = b.dom_part_cod
             LEFT JOIN p06_cds_des_lin c1
                ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
             LEFT JOIN p09_ad_des_lin c2
                ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
       WHERE a.aa_off_id = p_aa_id;

   --- update CLASSE
   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Iniziale cognome', 'Initial surname')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Iniziali cognome', 'Initial surname')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Nessun partizionamento', 'No partition')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Matricole dispari', 'Matricola unequal')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Matricole pari', 'Matricola equal')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   --- update INFO_SEM_CLASSE
   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Unico', 'Unique')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Ciclo', 'Cycle')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Annuale', 'Annual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Semestrale', 'Semiannual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Bimestrale', 'Bimestrial')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Primo', 'First')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Secondo', 'Second')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Terzo', 'Third')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Quarto', 'Fourth')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_MOD
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_mod_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_mod
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_mod
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod (mid,
                           mid_ad,
                           percorso,
                           attivita,
                           modulo,
                           descrizione,
                           metodi_did_des,
                           obiett_form_des,
                           prerequisiti_des,
                           contenuti_des,
                           testi_rif_des,
                           mod_ver_appr_des,
                           altre_info_des,
                           peso,
                           struttura_cfu,
                           info_sem_classe,
                           info_aule_edifici,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           ud_id,
                           cod_corso,
                           cod_percorso,
                           cod_ad,
                           cod_mod)
      SELECT DISTINCT
             a.mid_ad_mod AS mid,
             a.mid_ad AS mid_ad,
             a.des_cds AS percorso,
             a.des_ad AS attivita,
             a.des_mod AS modulo,
             NULL AS descrizione,
             '<strong>Metodi didattici ???</strong><br/>' AS metodi_did_des,
             '<strong>Obiettivi ???</strong><br/>' AS obiett_form_des,
             '<strong>Prerequisiti ???</strong><br/>' AS prerequisiti_des,
             '<strong>Contenuti ???</strong><br/>' AS contenuti_des,
             '<strong>Testi di riferimento ???</strong><br/>'
                AS testi_rif_des,
             '<strong>Modalita di apprendimento ???</strong><br/>'
                AS mod_ver_appr_des,
             '<strong>Altre info ???</strong><br/>' AS altre_info_des,
             NULL AS peso,
             NULL AS struttura_cfu,
             NULL AS info_sem_classe,
             'Info aule ???' AS info_aule_edifici,
             a.cds_id AS cds_id,
             a.ad_id AS ad_id,
             a.aa_off_id AS aa_off_id,
             a.aa_ord_id AS aa_ord_id,
             a.pds_id AS pds_id,
             a.ud_id AS ud_id,
             a.cod_cds AS cod_corso,
             NULL AS cod_percorso,
             a.cod_ad AS cod_ad,
             a.cod_mod AS cod_mod
        FROM GOL_IUNI a
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 17';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_sem_classe =
             (SELECT DISTINCT des_part
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_mod)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 18';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_sem_classe = 'Annuale'
    WHERE info_sem_classe IS NULL AND aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 19';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_aule_edifici =
             (SELECT 'Ore ' || SUM (dur_uni_val)
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_mod)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 20';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   unixx_struttura_cfu_ad_mod (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 21';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- inglese
   INSERT INTO gol_ad_mod_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              modulo,
                              descrizione,
                              metodi_did_des,
                              obiett_form_des,
                              prerequisiti_des,
                              contenuti_des,
                              testi_rif_des,
                              mod_ver_appr_des,
                              altre_info_des,
                              struttura_cfu,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT DISTINCT
             a.mid_ad_mod AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
             a.des_mod AS modulo,
             a1.descrizione AS descrizione,
             '<strong>Metodi didattici ???</strong><br/>' AS metodi_did_des,
             '<strong>Obiettivi ???</strong><br/>' AS obiett_form_des,
             '<strong>Prerequisiti ???</strong><br/>' AS prerequisiti_des,
             '<strong>Contenuti ???</strong><br/>' AS contenuti_des,
             '<strong>Testi di riferimento ???</strong><br/>'
                AS testi_rif_des,
             '<strong>Modalita di apprendimento ???</strong><br/>'
                AS mod_ver_appr_des,
             '<strong>Altre info ???</strong><br/>' AS altre_info_des,
             a1.struttura_cfu,
             a1.info_sem_classe,
             a1.info_aule_edifici
        FROM GOL_IUNI a
             JOIN gol_ad_mod a1 ON a.mid_ad_mod = a1.mid
             LEFT JOIN p06_cds_des_lin c1
                ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
             LEFT JOIN p09_ad_des_lin c2
                ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
       WHERE a.aa_off_id = p_aa_id;

   -- update INFO_SEM_CLASSE
   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Unico', 'Unique')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Ciclo', 'Cycle')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Annuale', 'Annual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Semestrale', 'Semiannual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Bimestrale', 'Bimestrial')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Primo', 'First')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Secondo', 'Second')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Terzo', 'Third')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Quarto', 'Fourth')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);


   -- update INFO_AULE_EDIFICI
   UPDATE gol_ad_mod_ln
      SET info_aule_edifici = REPLACE (info_aule_edifici, 'Ore', 'Hours')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);


   UPDATE gol_ad_mod_ln
      SET modulo = attivita
    WHERE     mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE attivita = modulo AND aa_off_id = p_aa_id)
          AND ln_code = 'en';


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_DOC
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_doc (mid,
                           mid_doc,
                           mid_ad,
                           percorso,
                           attivita,
                           docente,
                           cod_matr_doc,
                           titolare,
                           nominativo_docente,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           docente_id)
        SELECT DISTINCT
               a.mid_ad_doc AS mid,
               b.mid AS mid_doc,
               mid_ad AS mid_ad,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome                                                 --||
                  --DECODE(DES, NULL, '',' ('||DES||')')
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               a.docente_id AS docente_id
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN tipi_copertura c
                  ON a.tipo_copertura_cod = c.tipo_copertura_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_ad_doc,
               b.mid,
               mid_ad,
               a.des_cds,
               a.des_ad,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;


   --- inglese
   INSERT INTO gol_ad_doc_ln (MID,
                              LN_CODE,
                              percorso,
                              attivita,
                              docente)
        SELECT DISTINCT
               a.mid_ad_doc AS mid,
               'en' AS ln_codE,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN tipi_copertura c
                  ON a.tipo_copertura_cod = c.tipo_copertura_cod
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_ad_doc,
               b.mid,
               mid_ad,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;



   v_time_end := SYSDATE;

   v_step := 'step 22';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_CLA_DOC
   DELETE FROM gol_ad_cla_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_cla_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_cla_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_doc (mid,
                               mid_ad_cla,
                               mid_doc,
                               percorso,
                               attivita,
                               classe,
                               docente,
                               cod_matr_doc,
                               titolare,
                               nominativo_docente,
                               cds_id,
                               ad_id,
                               aa_off_id,
                               aa_ord_id,
                               pds_id,
                               dom_part_cod,
                               docente_id)
        SELECT DISTINCT
               mid_ad_cla_doc AS mid,
               mid_ad_cla AS mid_ad_cla,
               b.mid AS mid_doc,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
               c.des AS classe,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome                                                 --||
                  --DECODE(DES, NULL, '',' ('||D.DES||')')
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               NULL AS dom_part_cod,
               a.docente_id AS docente_id
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               JOIN dom_part c
                  ON     a.fat_part_cod = c.fat_part_cod
                     AND a.dom_part_cod = c.dom_part_cod
               LEFT JOIN tipi_copertura d
                  ON a.tipo_copertura_cod = d.tipo_copertura_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_cla_doc,
               mid_ad_cla,
               b.mid,
               a.des_cds,
               a.des_ad,
               c.des,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;


   INSERT INTO gol_ad_cla_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  attivita,
                                  classe,
                                  docente,
                                  nominativo_docente)
        SELECT DISTINCT
               mid_ad_cla_doc AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
               c.des AS classe,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               JOIN dom_part c
                  ON     a.fat_part_cod = c.fat_part_cod
                     AND a.dom_part_cod = c.dom_part_cod
               LEFT JOIN tipi_copertura d
                  ON a.tipo_copertura_cod = d.tipo_copertura_cod
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_cla_doc,
               a.des_cds,
               a.des_ad,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
               c.des,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome;


   v_time_end := SYSDATE;

   v_step := 'step 23';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_MOD_DOC
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_mod_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_mod_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_mod_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_doc
        SELECT DISTINCT
               mid_ad_mod_doc AS mid,
               mid_ad_mod AS mid_ad_mod,
               b.mid AS mid_doc,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
               a.des_mod AS modulo,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               a.ud_id AS ud_id,
               a.docente_id AS docente_id
          FROM GOL_IUNI a JOIN t_docenti b ON a.docente_id = b.docente_id
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_mod_doc,
               mid_ad_mod,
               b.mid,
               a.des_cds,
               a.des_ad,
               a.des_mod,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.ud_id,
               a.docente_id;


   INSERT INTO gol_ad_mod_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  modulo,
                                  docente,
                                  nominativo_docente)
        SELECT DISTINCT
               mid_ad_mod_doc AS mid,
               'en' AS ln_cod,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               a.des_mod AS modulo,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente
          --  fu_des_up_low(nvl(c2.ds_ad_des, a.des_ad)) as attivita
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_mod_doc,
               mid_ad_mod,
               b.mid,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
               a.des_mod,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome;

   v_time_end := SYSDATE;

   v_step := 'step 24';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiorno la descrizione del livello AD
   unixx_description_liv (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 25';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiorno la tabella delle lingue relative al livetto
   UPDATE gol_liv_ln a
      SET a.DESCRIPTION =
             (SELECT DESCRIPTION
                FROM gol_liv b
               WHERE a.mid = b.mid)
    WHERE a.mid IN (SELECT mid
                      FROM gol_liv
                     WHERE aa_id = p_aa_id AND mid_dett IS NOT NULL);

   v_time_end := SYSDATE;

   v_step := 'step 26';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   ---- creo la struttur ain lingua italiana
   INSERT INTO gol_ad_ln (mid,
                          ln_code,
                          percorso,
                          attivita,
                          descrizione,
                          metodi_did_des,
                          obiett_form_des,
                          prerequisiti_des,
                          contenuti_des,
                          testi_rif_des,
                          mod_ver_appr_des,
                          altre_info_des,
                          struttura_cfu)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             descrizione,
             metodi_did_des,
             obiett_form_des,
             prerequisiti_des,
             contenuti_des,
             testi_rif_des,
             mod_ver_appr_des,
             altre_info_des,
             struttura_cfu
        FROM gol_ad
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              classe,
                              descrizione,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             classe,
             descrizione,
             info_sem_classe,
             info_aule_edifici
        FROM gol_ad_cla
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_doc_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             docente
        FROM gol_ad_doc
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              modulo,
                              descrizione,
                              metodi_did_des,
                              obiett_form_des,
                              prerequisiti_des,
                              contenuti_des,
                              testi_rif_des,
                              mod_ver_appr_des,
                              altre_info_des,
                              struttura_cfu,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             modulo,
             descrizione,
             metodi_did_des,
             obiett_form_des,
             prerequisiti_des,
             contenuti_des,
             testi_rif_des,
             mod_ver_appr_des,
             altre_info_des,
             struttura_cfu,
             info_sem_classe,
             info_aule_edifici
        FROM gol_ad_mod
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  attivita,
                                  classe,
                                  docente,
                                  nominativo_docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             classe,
             docente,
             nominativo_docente
        FROM gol_ad_cla_doc
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  modulo,
                                  docente,
                                  nominativo_docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             modulo,
             docente,
             nominativo_docente
        FROM gol_ad_mod_doc
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 27';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;
END;

/
