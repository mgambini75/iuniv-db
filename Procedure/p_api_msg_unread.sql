CREATE OR REPLACE procedure                  P_API_MSG_UNREAD (p_ID number, p_MSG OUT NUMBER ) as
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
                 SET FLG_READ = 1 
                 WHERE mid = p_ID;
      
      END IF;
                 
      
    END;

END;
/
