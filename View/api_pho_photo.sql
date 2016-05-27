/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_PHO_PHOTO
(
   MID,
   DESCRIPTION,
   TIPO,
   TITLE,
   COD,
   IS_DEFAULT
)
AS
     SELECT MID,
            DESCRIPTION,
            TIPO,
            TITLE,
            COD,
            IS_DEFAULT
       FROM PHO_PHOTO
   ORDER BY DESCRIPTION;
