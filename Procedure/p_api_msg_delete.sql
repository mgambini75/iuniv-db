CREATE OR REPLACE PROCEDURE                  P_API_MSG_DELETE (P_ID         NUMBER,
                                              P_LANG       VARCHAR,
                                              P_MSG    OUT SYS_REFCURSOR)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   DECLARE
      P_CONTR   NUMBER (10);
   BEGIN
      P_CONTR := 0;

      --- MSG 1 (messaggio in primo piano non ancora letto)
      SELECT COUNT (*)
        INTO P_CONTR
        FROM MSG_MESSAGE
       WHERE     mid = P_ID
             AND UPPER (flg_PRIMO) = 'S'
             AND NUM_VISIBILITA > NUM_LETTURE;


      IF P_CONTR = 0
      THEN
         UPDATE MSG_MESSAGE
            SET FLG_CANC = 's'
          WHERE mid = P_ID;

         OPEN P_MSG FOR
            SELECT M.MID, M.TITOLO, M.DESCRIZIONE
              FROM API_FRW_MESSAGES M
             WHERE M.LANG = LANG AND M.MID = 0;
      ELSE
         OPEN P_MSG FOR
            SELECT M.MID, M.TITOLO, M.DESCRIZIONE
              FROM API_FRW_MESSAGES M
             WHERE M.LANG = LANG AND M.MID = 2010001;
             
      END IF;
   END;
END;
/
