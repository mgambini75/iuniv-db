CREATE OR REPLACE procedure                  P_API_MSG_READ (p_ID number, p_MSG OUT NUMBER ) as
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  
      
      IF P_CONTR =0
      
         THEN    UPDATE MSG_MESSAGE
                 SET DATA_PR_LET = SYSDATE
                 WHERE MID = p_ID
                 AND NVL(NUM_LETTURE, 0) = 0;
                 
                 UPDATE MSG_MESSAGE
                 SET NUM_LETTURE = NVL(NUM_LETTURE, 0) + 1,  
                     DATA_UL_LET = SYSDATE,
                     FLG_READ = 0 
                 WHERE MID = p_ID;
      
      END IF;
                 
      
    END;

END;
/
