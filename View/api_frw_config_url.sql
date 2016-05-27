/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_CONFIG_URL
(
   MID,
   MID_MODULO,
   COD,
   DESCRIPTION,
   DES_URL,
   FLG_AUTH,
   CDA_TYPE,
   VALUE_STRING_IOS,
   VALUE_STRING_ANDROID,
   VALUE_STRING_WP,
   VALUE_STRING_WS,
   FLG_PUB,
   FLG_STU,
   FLG_DOC,
   FLG_PTA,
   FLG_ATT_IOS,
   FLG_ATT_ANDROID,
   FLG_ATT_WP,
   FLG_ATT_WS
)
AS
   SELECT mid,
          mid_modulo,
          cod,
          description,
          des_url,
          flg_auth,
          cda_type,
          value_string_ios,
          value_string_android,
          value_string_wp,
          value_string_ws,
          flg_pub,
          flg_stu,
          flg_doc,
          flg_pta,
          FLG_ATT_IOS,
          FLG_ATT_ANDROID,
          FLG_ATT_WP,
          FLG_ATT_WS
     FROM frw_config_url;
