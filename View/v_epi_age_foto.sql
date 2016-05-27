/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_EPI_AGE_FOTO
(
   FOTO_ID,
   USER_ID,
   USER_NAME,
   PERS_ID,
   DOCENTE_ID,
   SOGG_EST_ID,
   FOTO
)
AS
   SELECT NVL (per.foto_id, NVL (doc.foto_id, pta.foto_id)) AS foto_id,
          user_id,
          user_name,
          per.pers_id,
          doc.docente_id,
          pta.sogg_est_id,
          NVL (per.foto, NVL (doc.foto, pta.foto)) AS foto
     FROM p18_user a
          JOIN p18_grp b ON b.grp_id = a.grp_id
          LEFT JOIN p01_foto per
             ON b.tab_ana = 'P01_ANAPER' AND per.pers_id = a.ana_id
          LEFT JOIN p01_foto doc
             ON b.tab_ana = 'DOCENTI' AND doc.docente_id = a.ana_id
          LEFT JOIN p01_foto pta
             ON b.tab_ana = 'SOGG_EST' AND pta.SOGG_EST_ID = a.ana_id
    WHERE     1 = 1
          AND (   per.pers_id IS NOT NULL
               OR doc.docente_id IS NOT NULL
               OR pta.sogg_est_id IS NOT NULL);
