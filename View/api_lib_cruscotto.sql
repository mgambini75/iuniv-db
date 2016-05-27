/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_LIB_CRUSCOTTO
(
   MID,
   LANG,
   PERS_ID,
   STU_ID,
   MATRICOLA,
   TIPO_MEDIA_COD,
   NUM_ESAMI,
   MEDIA_ACCADEMICA,
   CFU_MATURATI,
   NUM_AD_PIANIF,
   CFU_AD_PIANIF,
   NUM_ESA_SUP,
   NUM_ESA_NO_SUP,
   CFU_PIANO
)
AS
   SELECT stu_id,
          'it',
          pers_id,
          stu_id,
          matricola,
          tipo_media_cod,
          num_esami,
          media_accademica,
          cfu_maturati,
          num_ad_pianif,
          cfu_ad_pianif,
          num_esa_sup,
          num_esa_no_sup,
          cfu_piano
     FROM v_epi_replica_stu_dat_carr
   UNION
   SELECT stu_id,
          'en',
          pers_id,
          stu_id,
          matricola,
          tipo_media_cod,
          num_esami,
          media_accademica,
          cfu_maturati,
          num_ad_pianif,
          cfu_ad_pianif,
          num_esa_sup,
          num_esa_no_sup,
          cfu_piano
     FROM v_epi_replica_stu_dat_carr;
