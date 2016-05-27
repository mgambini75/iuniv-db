CREATE OR REPLACE PROCEDURE                  P_API_MSG_OUTPREFER (P_ID NUMBER, P_MSG OUT NUMBER ) AS
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
DECLARE
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  
      
      --- MSG 3 (messaggio non è fra i preferiti)
      SELECT COUNT(*) INTO P_CONTR
      FROM MSG_MESSAGE
      WHERE MID = P_ID
      AND UPPER(FLG_PREFERITI) = 'N';
      
      IF P_CONTR = 0
      
         THEN    UPDATE MSG_MESSAGE
                 SET FLG_PREFERITI = 'n'
                 WHERE MID = P_ID
                 AND UPPER(FLG_PREFERITI) = 'S';
                 
         ELSE    P_MSG := 2010003;   
      
      END IF;
                 
      
    END;

END;
/
