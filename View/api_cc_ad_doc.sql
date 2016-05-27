/* Formatted on 14/03/2016 11:45:33 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_AD_DOC
(
   MID,
   LANG,
   PERCORSO,
   ATTIVITA,
   DOCENTE,
   COD_MATR_DOC,
   TITOLARE,
   MID_AD,
   MID_DOC
)
AS
   SELECT A.MID,
          A.LN_CODE AS LANG,
          A.PERCORSO,
          A.ATTIVITA,
          A.DOCENTE AS DOCENTE,
          B.COD_MATR_DOC,
          B.TITOLARE,
          B.MID_AD AS MID_AD,
          B.MID_DOC
     FROM GOL_AD_DOC_LN a JOIN GOL_AD_DOC b ON a.mid = b.mid;
