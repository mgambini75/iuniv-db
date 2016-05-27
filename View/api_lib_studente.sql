/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_LIB_STUDENTE
(
   MID,
   LANG,
   STU_ID,
   COD_AD,
   DES_AD,
   ANNO_CORSO,
   DES_ANNO,
   PESO,
   DES_PESO,
   COD_TIPO_INS,
   DES_TIPO_INS,
   COD_STATO,
   DES_STATO,
   VOTO,
   LODE_FLG,
   TIPO_GIUD_COD,
   DES_VOTO,
   DATA_SUP,
   AA_SUP_ID
)
AS
   SELECT B.MID,
          B.LN_CODE,
          A.STU_ID,
          A.COD_AD,
          B.DES_AD,
          ANNO_CORSO,
          B.DES_ANNO,
          PESO,
          B.DES_PESO,
          COD_TIPO_INS,
          B.DES_TIPO_INS,
          COD_STATO,
          B.DES_STATO,
          VOTO,
          LODE_FLG,
          TIPO_GIUD_COD,
          B.DES_VOTO,
          DATA_SUP,
          AA_SUP_ID
     FROM LIB_STUDENTE A JOIN LIB_STUDENTE_LN B ON A.MID = B.MID;
