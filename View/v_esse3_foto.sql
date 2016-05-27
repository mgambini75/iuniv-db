/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_ESSE3_FOTO
(
   FOTO_ID,
   USER_ID,
   USER_NAME,
   PERS_ID,
   DOCENTE_ID,
   FOTO
)
AS
   SELECT "FOTO_ID",
          "USER_ID",
          "USER_NAME",
          "PERS_ID",
          "DOCENTE_ID",
          "FOTO"
     FROM v_epi_age_foto;

ALTER VIEW V_ESSE3_FOTO
 ADD PRIMARY KEY
  (FOTO_ID)
  DISABLE;
