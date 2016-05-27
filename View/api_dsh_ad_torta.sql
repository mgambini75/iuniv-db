/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_DSH_AD_TORTA
(
   MID,
   LANG,
   STU_ID,
   TIPO_CORSO_COD,
   STA_STU_COD,
   MOT_STASTU_COD,
   DES_PESO,
   VAL_TOTALE,
   PESO_SUP,
   PESO_FRE,
   PESO_PIA
)
AS
   SELECT MID,
          'it',
          STU_ID,
          TIPO_CORSO_COD,
          STA_STU_COD,
          MOT_STASTU_COD,
          DES_PESO,
          VAL_TOTALE,
          PESO_SUP,
          PESO_FRE,
          PESO_PIA
     FROM DSH_AD_TORTA;
