/* Formatted on 14/03/2016 11:45:39 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_TAX_DETT_ESSE3_LN
(
   MID,
   LN_CODE,
   STU_ID,
   AA_ISCR_ID,
   FATT_ID,
   DES_GRUPPO,
   DES_TASSA,
   DES_VOCE,
   DES_RATA,
   IMPORTO,
   DAT_SCAD,
   DAT_PAG
)
AS
   SELECT MID,
          'it' AS LN_CODE,
          STU_ID,
          AA_ISCR_ID,
          FATT_ID,
          DES_GRUPPO,
          DES_TASSA,
          DES_VOCE,
          DES_RATA,
          IMPORTO,
          DAT_SCAD,
          DAT_PAG
     FROM v_tax_dett_esse3
   UNION
   SELECT MID,
          'en' AS LN_CODE,
          STU_ID,
          AA_ISCR_ID,
          FATT_ID,
          DES_GRUPPO,
          DES_TASSA,
          DES_VOCE,
          DES_RATA,
          IMPORTO,
          DAT_SCAD,
          DAT_PAG
     FROM v_tax_dett_esse3;
