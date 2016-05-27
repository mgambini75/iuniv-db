/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_TAX_SIT_DETT
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
   DES_IMPORTO,
   IMPORTO,
   DAT_SCAD,
   DAT_PAG
)
AS
   SELECT a.mid,
          ln_code,
          stu_id,
          AA_ISCR_ID,
          FATT_ID,
          b.DES_GRUPPO,
          b.DES_TASSA,
          b.DES_VOCE,
          b.DES_RATA,
          REPLACE ('€ ' || TRIM (TO_CHAR (IMPORTO, '999999999.00')),
                   '.',
                   ',')
             AS des_importo,
          IMPORTO,
          NVL (DAT_SCAD, DAT_PAG),
          DAT_PAG
     FROM TAX_SIT_DETT a JOIN TAX_SIT_DETT_LN b ON a.mid = b.mid;
