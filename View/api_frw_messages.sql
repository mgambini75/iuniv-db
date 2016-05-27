/* Formatted on 14/03/2016 11:45:35 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_FRW_MESSAGES
(
   MID,
   LANG,
   TITOLO,
   DESCRIZIONE
)
AS
   SELECT mid, ln_code AS lang, titolo, descrizione FROM t_message;
