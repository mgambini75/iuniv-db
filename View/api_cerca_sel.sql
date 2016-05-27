/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CERCA_SEL
(
   MID,
   MID_AD,
   TITOLO,
   SOTTOTITOLO,
   CERCA
)
AS
   SELECT MID,
          MID_AD,
          INITCAP (des_ad) || ' [' || cod || ']' AS titolo,
          INITCAP (titolare || ' (' || des_part || ')') AS sottotitolo,
             /*
             * aa
             * Codice
             * Nome attività
             * Docente
             * Ordinamento
             * Corso di Studio
             * Lingua
             * Sett. Scientifico
             * Semestre
             * Tipologia
             */
             AA_OFF_ID
          || ','
          || REPLACE (cod, ',', '')
          || ','
          || REPLACE (des_ad, ',', '')
          || ','
          || REPLACE (titolare, ',', '')
          || ','
          || REPLACE (tipo_corso_cod, ',', '')
          || ','
          || REPLACE (acr, ',', '')
          || ','
          || REPLACE (des_lungua_did, ',', '')
          || ','
          || REPLACE (sett_cod, ',', '')
          || ','
          || REPLACE (des_part, ',', '')
          || ','
          || REPLACE (tipo_ins_cod, ',', '')
             AS cerca
     FROM GOL_CERCA;
