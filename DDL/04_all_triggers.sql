CREATE OR REPLACE TRIGGER local_grants_row_tbi BEFORE INSERT ON local_GRANTS    
        FOR EACH ROW
BEGIN   
   -- popola il progressivo
      SELECT s_local_GRANTs.NEXTVAL
        INTO :NEW.ID
        FROM DUAL;
END local_grants_row_tbi;
/


CREATE OR REPLACE TRIGGER T_AGE_AZIONI AFTER
INSERT OR DELETE OR UPDATE 
ON AGE_AZIONI
FOR EACH ROW
DECLARE
CONT NUMBER(10);
BEGIN
  
  SELECT COUNT(*) INTO CONT
  FROM T_AGE_AZIONI
  WHERE MID = :NEW.AGE_AZN_ID; 
  
  IF INSERTING 
  
      THEN 
              IF CONT = 0
              
                 THEN  INSERT INTO T_AGE_AZIONI
                       SELECT :NEW.AGE_AZN_ID, LN_CODE 
                       FROM T_LANGUAGE;
              
              END IF;
  
  END IF;

  IF UPDATING 
  
      THEN 
              IF CONT = 0
              
                 THEN  delete from T_AGE_AZIONI
                       where mid = :OLD.AGE_AZN_ID;
                 
                       INSERT INTO T_AGE_AZIONI
                       SELECT :NEW.AGE_AZN_ID, LN_CODE 
                       FROM T_LANGUAGE;
              
              END IF;
  
  END IF;

  IF deleting 
  
      THEN 
              IF CONT = 0
              
                 THEN  delete from T_AGE_AZIONI
                       where mid = :old.AGE_AZN_ID;
              
              END IF;
  
  END IF;

  
  -- 
END;
/


CREATE OR REPLACE TRIGGER trg_elmah$error_bi
BEFORE INSERT ON elmah$error
FOR EACH ROW
BEGIN
    SELECT elmah$error_seq.NEXTVAL INTO :new.sequencenumber FROM dual;
END trg_elmah$error_bi;
/


CREATE OR REPLACE TRIGGER TRG_PRENOTAZIONI
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
