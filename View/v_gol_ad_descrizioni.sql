/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_GOL_AD_DESCRIZIONI
(
   MID,
   CDS_ID,
   AD_ID,
   AA_OFF_ID,
   AA_ORD_ID,
   PDS_ID,
   FAT_PART_COD,
   DOM_PART_COD,
   PART_COD,
   AD_LOG_ID,
   METODI_DID_DES,
   OBIETT_FORM_DES,
   PREREQUISITI_DES,
   CONTENUTI_DES,
   TESTI_RIF_DES,
   MOD_VER_APPR_DES,
   ALTRE_INFO_DES
)
AS
   SELECT "MID",
          "CDS_ID",
          "AD_ID",
          "AA_OFF_ID",
          "AA_ORD_ID",
          "PDS_ID",
          "FAT_PART_COD",
          "DOM_PART_COD",
          "PART_COD",
          "AD_LOG_ID",
          "METODI_DID_DES",
          "OBIETT_FORM_DES",
          "PREREQUISITI_DES",
          "CONTENUTI_DES",
          "TESTI_RIF_DES",
          "MOD_VER_APPR_DES",
          "ALTRE_INFO_DES"
     FROM v_gol_ad_descrizioni_tutte
    WHERE MID NOT IN (  SELECT mid
                          FROM v_gol_ad_descrizioni_tutte
                      GROUP BY mid
                        HAVING COUNT (*) > 1);
