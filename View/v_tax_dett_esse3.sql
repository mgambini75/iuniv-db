/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_TAX_DETT_ESSE3
(
   MID,
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
   SELECT ROWNUM AS mid,
          STU_ID,
          AA_ID AS aa_iscr_id,
          a.fatt_id,
             'Doc. '
          || NVL (FATT_COD, DECODE (a.fatt_id, 0, 'ND', TO_CHAR (a.fatt_id)))
             AS DES_GRUPPO,
          B.DES AS des_tassa,
          C.DES AS des_voce,
          D.DES AS des_rata,
          IMPORTO_VOCE AS importo,
          E.DATA_SCADENZA AS dat_scad,
          F.DATA_PAGAMENTO AS dat_pag
     FROM P05_TAX_STU A
          JOIN P05_TAX B ON A.TASSA_ID = B.TASSA_ID
          JOIN P05_VOCI C ON A.VOCE_ID = C.VOCE_ID
          JOIN P05_RATE D ON A.RATA_ID = D.RATA_ID
          JOIN P05_FATT E ON A.FATT_ID = E.FATT_ID
          LEFT JOIN P05_PAG F ON A.FATT_ID = F.FATT_ID
    WHERE ANNULLATA_FLG = 0;
