/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CERCA_VAL
(
   MID,
   MID_CAMPO,
   AA_OFF_ID,
   TITOLO,
   VAL,
   VAL_PADRE
)
AS
   SELECT MID,
          MID_CAMPO,
          AA_OFF_ID,
          TITOLO,
          VAL,
          VAL_PADRE
     FROM GOL_CERCA_VAL;
