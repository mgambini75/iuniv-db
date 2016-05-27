/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_LNK_LINK
(
   MID,
   PROFILE,
   LN_CODE,
   TITLE,
   DESCRIPTION,
   URL,
   FLG_AUTH,
   ORDINAMENTO,
   MID_PADRE
)
AS
     SELECT MID,
            PROFILE,
            LN_CODE,
            TITLE,
            DESCRIPTION,
            URL,
            FLG_AUTH,
            ORDINAMENTO,
            MID_PADRE
       FROM TAB_LNK_LINK
   ORDER BY PROFILE, ORDINAMENTO;
