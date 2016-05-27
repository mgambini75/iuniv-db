CREATE OR REPLACE PROCEDURE                  P_API_PRE_INSERT (
                                              P_STU         NUMBER,
                                              P_CDS         NUMBER,
                                              P_AD         NUMBER,
                                              P_APP         NUMBER,
                                              p_MSG OUT NUMBER)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   BEGIN

        INSERT INTO T_PRENOTAZIONI (STU_ID, CDS_ID, AD_ID, APP_ID, NOTA, DATA_INS)
        SELECT P_STU, P_CDS, P_AD, P_APP, NULL, SYSDATE
        FROM DUAL;

   END;
END;
/
