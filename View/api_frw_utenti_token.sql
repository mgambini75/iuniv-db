/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_UTENTI_TOKEN
(
   MID,
   USER_ID,
   DES_TOKEN,
   DES_HASH,
   DATA_SCAD,
   DATA_INS,
   DATA_MOD
)
AS
   SELECT "MID",
          "USER_ID",
          "DES_TOKEN",
          "DES_HASH",
          "DATA_SCAD",
          "DATA_INS",
          "DATA_MOD"
     FROM FRW_UTENTI_TOKEN;
