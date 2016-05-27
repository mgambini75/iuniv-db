/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_UTENTI
(
   MID,
   USER_ID,
   PROFILE,
   ANA_ID,
   CARRIERA_ID,
   CARRIERA,
   NOME,
   COGNOME,
   MATRICOLA,
   DESCRIZIONE,
   NOTE,
   DATA_INIZIO,
   DATA_FINE,
   URL_PHOTO,
   FLG_BLOCK
)
AS
   SELECT a.MID,
          a.USER_ID,
          a.PROFILE,
          a.ANA_ID,
          a.CARRIERA_ID,
          a.CARRIERA,
          a.NOME,
          a.COGNOME,
          a.MATRICOLA,
          a.DESCRIZIONE,
          a.NOTE,
          a.DATA_INIZIO,
          a.DATA_FINE,
          a.URL_PHOTO,
          0
     FROM T_UTENTI A
    WHERE 1 = 1 AND a.PROFILE <> 0 AND a.DISABLE_FLG = 0;
