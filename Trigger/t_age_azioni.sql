CREATE OR REPLACE TRIGGER "T_AGE_AZIONI" AFTER
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
ALTER TRIGGER "T_AGE_AZIONI" ENABLE;
/

