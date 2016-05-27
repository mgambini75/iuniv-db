/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_GOL_AD_DESCRIZIONI_TUTTE
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
   SELECT DISTINCT a.mid,
                   c.CDS_ID,
                   c.AD_ID,
                   c.AA_OFF_ID,
                   c.AA_ORD_ID,
                   c.PDS_ID,
                   c.FAT_PART_COD,
                   c.DOM_PART_COD,
                   c.PART_COD,
                   AD_LOG_ID,
                   c.METODI_DID_DES,
                   c.OBIETT_FORM_DES,
                   c.PREREQUISITI_DES,
                   c.CONTENUTI_DES,
                   c.TESTI_RIF_DES,
                   c.MOD_VER_APPR_DES,
                   c.ALTRE_INFO_DES
     FROM gol_ad a
          JOIN gol_iuni b ON a.mid = b.mid_ad
          JOIN p09_ad_log_pds c
             ON     b.cds_id = c.cds_id
                AND b.ad_id = c.ad_id
                AND b.aa_off_id = c.aa_off_id
                AND b.aa_ord_id = c.aa_ord_id
                AND b.pds_id = c.pds_id
    WHERE (   c.METODI_DID_DES IS NOT NULL
           OR c.OBIETT_FORM_DES IS NOT NULL
           OR c.PREREQUISITI_DES IS NOT NULL
           OR c.CONTENUTI_DES IS NOT NULL
           OR c.TESTI_RIF_DES IS NOT NULL
           OR c.MOD_VER_APPR_DES IS NOT NULL
           OR c.ALTRE_INFO_DES IS NOT NULL);
