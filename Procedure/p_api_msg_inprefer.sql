CREATE OR REPLACE procedure                  P_API_MSG_INPREFER (p_ID NUMBER, p_MSG OUT NUMBER ) as
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

      --- MSG 2 (messaggio è già fra i preferiti)
      SELECT COUNT(*) INTO P_CONTR
      FROM MSG_MESSAGE
      WHERE mid = p_ID
      AND UPPER(FLG_PREFERITI) = 'S';

      
      IF P_CONTR =0
      
         THEN    UPDATE MSG_MESSAGE
                 SET FLG_PREFERITI = 's'
                 WHERE mid = p_ID;
                 
         ELSE    P_MSG := 2010002;   
      
                 
      END IF;
                 
      
    END;

END;
/
