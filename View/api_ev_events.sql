/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_EV_EVENTS
(
   MID,
   LANG,
   TODAY,
   USER_ID,
   DATA,
   DATA_STRING,
   ICONS,
   TITLE,
   DESCRIPTION,
   DETAIL
)
AS
   SELECT MID,
          LANG,
          TODAY,
          USER_ID,
          DATA,
          DATA_STRING,
          ICONS,
          TITLE,
          DESCRIPTION,
          DETAIL
     FROM TAB_EV_EVENTS;
