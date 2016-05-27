/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CERCA_UI
(
   MID,
   DES_SEZIONE,
   DES_CAMPO,
   TIPO_CAMPO,
   MID_PADRE,
   ORDER_SEZ,
   ORDER_CAM,
   IS_OPTIONAL
)
AS
     SELECT MID,
            DES_SEZIONE,
            DES_CAMPO,
            TIPO_CAMPO,
            MID_PADRE,
            ORDER_SEZ,
            ORDER_CAM,
            0 IS_OPTIONAL
       FROM GOL_CERCA_SEL
   ORDER BY MID;
