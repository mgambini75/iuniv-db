/* Formatted on 14/03/2016 11:45:33 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_AD_CLA
(
   MID,
   LANG,
   PERCORSO,
   ATTIVITA,
   CLASSE,
   DESCRIZIONE,
   INFO_SEM_CLASSE,
   INFO_AULE_EDIFICI,
   MID_AD
)
AS
     SELECT A.MID,
            A.LN_CODE AS LANG,
            A.PERCORSO,
            A.ATTIVITA,
            A.CLASSE,
            A.DESCRIZIONE,
            A.INFO_SEM_CLASSE,
            A.INFO_AULE_EDIFICI,
            B.MID_AD AS MID_AD
       FROM GOL_AD_cla_LN a JOIN GOL_AD_cla b ON a.mid = b.mid
   ORDER BY LPAD (DOM_PART_COD, 10);
