/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_MODULI
(
   MID,
   FLG_ATT_IOS,
   FLG_ATT_ANDROID,
   FLG_ATT_WP,
   FLG_ATT_WS,
   FLG_ACC_UTE_BLOC,
   CDN_ORDIN,
   FLG_ATT_TABLET,
   FLG_ATT_PHONE,
   FLG_PUB,
   FLG_STU,
   FLG_DOC,
   FLG_PTA
)
AS
   SELECT mid,
          flg_att_ios,
          flg_att_android,
          flg_att_wp,
          flg_att_ws,
          flg_acc_ute_bloc,
          cdn_ordin,
          flg_att_tablet,
          flg_att_phone,
          flg_pub,
          flg_stu,
          flg_doc,
          flg_pta
     FROM frw_moduli;
