/* Formatted on 14/03/2016 11:45:33 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_AD_MOD
(
   MID,
   LANG,
   CURRICULUM,
   COURSE,
   PARTITION,
   DESCRIPTION,
   METODI_DID_DES,
   OBIETT_FORM_DES,
   PREREQUISITI_DES,
   CONTENUTI_DES,
   TESTI_RIF_DES,
   MOD_VER_APPR_DES,
   ALTRE_INFO_DES,
   CREDITS_DES,
   INFO_SEM_CLASSE,
   INFO_AULE_EDIFICI,
   CREDITS,
   MID_AD
)
AS
   SELECT a.MID,
          a.LN_CODE AS LANG,
          a.PERCORSO AS CURRICULUM,
          a.ATTIVITA AS COURSE,
          a.MODULO AS PARTITION,
          a.DESCRIZIONE AS DESCRIPTION,
          a.METODI_DID_DES,
          a.OBIETT_FORM_DES,
          a.PREREQUISITI_DES,
          a.CONTENUTI_DES,
          a.TESTI_RIF_DES,
          a.MOD_VER_APPR_DES,
          a.ALTRE_INFO_DES,
          a.STRUTTURA_CFU AS CREDITS_DES,
          a.INFO_SEM_CLASSE,
          a.INFO_AULE_EDIFICI,
          b.peso AS CREDITS,
          MID_AD AS MID_AD
     FROM GOL_AD_MOD_LN a JOIN GOL_AD_MOD b ON a.mid = b.mid;
