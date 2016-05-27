/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_ORARIO_LEZIONI_USER
(
   PERS_ID,
   STU_ID,
   ID_USER,
   PRG_IMP,
   DES_EVENTO,
   DATA_INIZIO,
   DATA_FINE,
   DES_DOCENTI,
   DES_AULE,
   CDA_GRUPPO,
   CDA_AD,
   DES_AD,
   CDA_TIPO_ATT,
   CDS_COD
)
AS
   SELECT /* $Id: V16_STU_NOTIFICHE_VAR_UP.vw,v 1.3 2015/09/16 10:45:22 lficarra Exp $ */
         stu.pers_id,
          stu.stu_id,
          usr.id,
          var.mid,
          var.des_evento,
          var.data_inizio,
          var.data_fine,
          var.des_docenti,
          var.des_aule,
          --          (SELECT ' - edificio ' || ed.des
          --             FROM p09_edifici ed INNER JOIN p09_aule au
          --                     ON (ed.edificio_id = au.edificio_id)
          --            WHERE (   au.des = var.des_aule
          --                   OR INSTR (var.des_aule, au.des || ',') > 0
          --                   OR INSTR (var.des_aule, ',' || au.des) > 0)
          --                  AND ROWNUM = 1)
          --             AS des_edificio,
          var.cda_gruppo,
          --  var.data_impegno,
          --var.dat_imp_sosp,
          var.cda_ad,
          var.des_ad,
          --var.cda_partion,
          --var.des_partion,
          --var.cda_ud,
          var.cod_tipo_att,
          var.des_corsi
     FROM ori_lezioni var
          INNER JOIN p09_ad_gen ag ON (ag.cod = var.cda_ad)
          JOIN p11_ad_sce adsce ON (adsce.ad_id = ag.ad_id)
          INNER JOIN p04_mat mat ON (adsce.mat_id = mat.mat_id)
          INNER JOIN p01_stu stu ON (mat.stu_id = stu.stu_id)
          JOIN p18_user usr ON (usr.ana_id = stu.pers_id)
          INNER JOIN p06_cds cds ON (adsce.cds_ad_id = cds.cds_id)
    WHERE     (   cds.cod = var.des_corsi
               OR INSTR (var.des_corsi, cds.cod || ',') > 0
               OR INSTR (var.des_corsi, ',' || cds.cod) > 0)
          AND mat.sta_mat_cod = 'A'
          AND stu.sta_stu_cod = 'A'
          AND adsce.sta_sce_cod IN ('P', 'F');
