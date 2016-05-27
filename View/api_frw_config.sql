/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_CONFIG
(
   MID,
   COD,
   VALUE_STRING,
   APP_VISIBLE_IOS,
   APP_VISIBLE_ANDROID,
   APP_VISIBLE_WP,
   APP_VISIBLE_WS
)
AS
     SELECT mid,
            cod,
            value_string,
            app_visible_ios,
            app_visible_android,
            app_visible_wp,
            app_visible_ws
       FROM frw_config
   ORDER BY mid;
