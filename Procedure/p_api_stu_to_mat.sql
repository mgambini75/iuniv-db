CREATE OR REPLACE PROCEDURE P_API_STU_TO_MAT (P_STU_ID         NUMBER,
                                              P_MAT_ID    OUT SYS_REFCURSOR)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   DECLARE
   
   BEGIN

         OPEN P_MAT_ID FOR
            SELECT MAT_ID
              FROM P04_MAT
             WHERE STU_ID = P_STU_ID
               AND STA_MAT_COD = 'A';
      
   END;
END; 
/
