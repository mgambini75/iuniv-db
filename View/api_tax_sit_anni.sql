/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_TAX_SIT_ANNI
(
   MID,
   LN_CODE,
   STU_ID,
   AA_ISCR_ID,
   TITOLO,
   DESCRIZIONE,
   SEMAFORO,
   NOTE,
   PAGATO,
   NON_PAGATO
)
AS
   SELECT A.MID,
          LN_CODE,
          STU_ID,
          AA_ISCR_ID,
          B.TITOLO,
          B.DESCRIZIONE,
          SEMAFORO,
          B.NOTE,
          NVL (
             (SELECT SUM (IMPORTO)
                FROM TAX_SIT_DETT X
               WHERE     X.STU_ID = A.STU_ID
                     AND X.AA_ISCR_ID = A.AA_ISCR_ID
                     AND X.DAT_PAG IS NOT NULL),
             0)
             AS PAGATO,
          NVL (
             (SELECT SUM (IMPORTO)
                FROM TAX_SIT_DETT X
               WHERE     X.STU_ID = A.STU_ID
                     AND X.AA_ISCR_ID = A.AA_ISCR_ID
                     AND X.DAT_PAG IS NULL),
             0)
             AS NON_PAGATO
     FROM TAX_SIT_ANNI A JOIN TAX_SIT_ANNI_LN B ON A.MID = B.MID;
