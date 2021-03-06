/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_ORI_ESAMI
(
   MID,
   LN_CODE,
   TIPO,
   DATA_INIZIO,
   DATA_FINE,
   COD_APP,
   COD_AD,
   COD_CDS,
   DES_APPELLO,
   DES_ESAME,
   DES_PROVA,
   NUMERO_ISCRITTI
)
AS
   SELECT A.MID,
          B.LN_CODE,
          2 AS TIPO,
          A.DATA_ESAME AS DATA_INIZIO,
          A.DATA_FINE_ISCRIZIONE AS DATA_FINE,
          COD_APP,
          COD_AD AS COD_AD,
          COD_CDS AS COD_CDS,
          B.DES_APPELLO,
          B.DES_ESAME,
          B.DES_PROVA,
          NUMERO_ISCRITTI
     FROM ORI_ESAMI A JOIN ORI_ESAMI_LN B ON A.MID = B.MID;
