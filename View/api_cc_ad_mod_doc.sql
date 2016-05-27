/* Formatted on 14/03/2016 11:45:33 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_AD_MOD_DOC
(
   MID,
   LANG,
   PERCORSO,
   MODULO,
   DOCENTE,
   COD_MATR_DOC,
   TITOLARE,
   MID_AD_MOD,
   MID_DOC
)
AS
   SELECT A.MID,
          A.LN_CODE AS LANG,
          A.PERCORSO,
          A.MODULO,
          A.DOCENTE,
          B.COD_MATR_DOC,
          B.TITOLARE,
          B.MID_AD_MOD,
          B.MID_DOC
     FROM GOL_AD_MOD_DOC_LN A JOIN GOL_AD_MOD_DOC B ON a.mid = b.mid;
