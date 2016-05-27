CREATE OR REPLACE TRIGGER "LOCAL_GRANTS_ROW_TBI" BEFORE INSERT ON local_GRANTS    
        FOR EACH ROW
BEGIN   
   -- popola il progressivo
      SELECT s_local_GRANTs.NEXTVAL
        INTO :NEW.ID
        FROM DUAL;
END local_grants_row_tbi;

/
ALTER TRIGGER "LOCAL_GRANTS_ROW_TBI" ENABLE;
/

