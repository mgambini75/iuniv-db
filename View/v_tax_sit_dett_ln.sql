/* Formatted on 14/03/2016 11:45:39 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_TAX_SIT_DETT_LN
(
   MID,
   LN_CODE,
   STU_ID,
   AA_ID,
   FATT_ID,
   DES_GRUPPO,
   TASSA,
   VOCE,
   RATA,
   IMPORTO_VOCE,
   DATA_SCADENZA,
   DATA_PAGAMENTO
)
AS
   SELECT MID,
          'it' AS LN_CODE,
          STU_ID,
          AA_ID,
          FATT_ID,
          DES_GRUPPO,
          TASSA,
          VOCE,
          RATA,
          IMPORTO_VOCE,
          DATA_SCADENZA,
          DATA_PAGAMENTO
     FROM v_tax_sit_dett
   UNION
   SELECT MID,
          'en' AS LN_CODE,
          STU_ID,
          AA_ID,
          FATT_ID,
          DES_GRUPPO,
          TASSA,
          VOCE,
          RATA,
          IMPORTO_VOCE,
          DATA_SCADENZA,
          DATA_PAGAMENTO
     FROM v_tax_sit_dett;
