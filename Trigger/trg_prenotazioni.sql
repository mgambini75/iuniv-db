CREATE OR REPLACE TRIGGER "TRG_PRENOTAZIONI" 
   AFTER INSERT
   ON t_prenotazioni
   FOR EACH ROW
DECLARE
   cont          NUMBER (10);
   v_matricola   VARCHAR (20);
   v_testo       VARCHAR (255);
   log_test      VARCHAR (2000);
BEGIN
   --
   IF INSERTING
   THEN
      -- inserimento delle notifiche PUSH
      INSERT INTO t_notifiche (MATRICOLA,
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
                               APP_ID)
         SELECT user_id,
                   'Prenotazione all''appello del '
                || TO_CHAR (data_inizio_app, 'dd/mm/yyyy')
                || ' per '
                || UPPER (c.des)
                || ' di '
                || UPPER (d.des)
                   AS testo,
                   'Prenotazione all''appello del '
                || TO_CHAR (data_inizio_app, 'dd/mm/yyyy')
                || ' per '
                || UPPER (c.des)
                || ' di '
                || UPPER (d.des)
                   AS testo_ITA,
                   'Reservation call the '
                || TO_CHAR (data_inizio_app, 'dd/mm/yyyy')
                || ' for '
                || DECODE (
                      UPPER (c.des),
                      'SCRITTO', 'WRITTEN',
                      'ORALE', 'ORAL',
                      'INTERMEDIO', 'INTERMEDIATE',
                      'SCRITTO PER SCAMBISTI', 'EXCHANGE ORAL',
                      'ORALE PER SCAMBISTI', 'EXCHANGE WRITTEN',
                      'INTERMEDIO PER SCAMBISTI', 'EXCHANGE INTERMEDIATE',
                      UPPER (c.des))
                || ' of '
                || UPPER (NVL (e.ds_ad_des, d.des))
                   AS testo_eng,
                SYSDATE,
                'PreNot' AS tipo,
                0,
                NULL,
                NULL,
                :new.stu_id,
                :new.cds_id,
                :new.ad_id,
                :new.app_id
           FROM p01_stu b
                JOIN p10_app c
                   ON     :new.cds_id = c.cds_id
                      AND :new.ad_id = c.ad_id
                      AND :new.app_id = c.app_id
                JOIN p09_ad_gen d ON :new.ad_id = d.ad_id
                LEFT JOIN p09_ad_des_lin e
                   ON c.ad_id = e.ad_id AND lingua_id = 1
                JOIN p18_user f ON b.pers_id = f.ana_id AND grp_id = 6
          WHERE b.stu_id = :new.stu_id;
   END IF;
END;

/
ALTER TRIGGER "TRG_PRENOTAZIONI" ENABLE;
/

