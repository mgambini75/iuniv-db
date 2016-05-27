/* Formatted on 14/03/2016 11:45:39 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_TAX_SIT_DETT
(
   MID,
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
   SELECT a.ROWID AS mid,
          stu_id,
          aa_id,
          a.fatt_id,
             'Doc. '
          || NVL (fatt_cod, DECODE (a.fatt_id, 0, 'ND', TO_CHAR (a.fatt_id)))
             AS des_gruppo,
          b.des AS tassa,
          c.des AS voce,
          d.des AS rata,
          importo_voce,
          e.data_scadenza,
          f.data_pagamento
     FROM p05_tax_stu a
          JOIN p05_tax b ON a.tassa_id = b.tassa_id
          JOIN p05_voci c ON a.voce_id = c.voce_id
          JOIN p05_rate d ON a.rata_id = d.rata_id
          JOIN p05_fatt e ON a.fatt_id = e.fatt_id
          LEFT JOIN p05_pag f ON a.fatt_id = f.fatt_id
    WHERE annullata_flg = 0;
