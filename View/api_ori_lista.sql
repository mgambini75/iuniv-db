/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_ORI_LISTA
(
   MID,
   LN_CODE,
   TIPO,
   DATA_INIZIO,
   DATA_FINE,
   SUPERTITOLO,
   TITOLO,
   DESCRIZIONE,
   STU_ID
)
AS
   SELECT A.MID,
          LN_CODE AS LN_CODE,
          2 AS TIPO,
          A.DATA_ESAME AS DATA_INIZIO,
          TO_DATE (NULL) AS DATA_FINE,
          b.des || '  [' || COD_AD || ']' AS SUPERTITOLO,
          UPPER (A1.DES_APPELLO) AS TITOLO,
             DECODE (A1.DES_ESAME, NULL, '', A1.DES_ESAME || ' - ')
          || DECODE (
                NUMERO_ISCRITTI,
                0, DECODE (LN_CODE, 'en', 'No Registered', 'Nessun Iscritto'),
                   DECODE (LN_CODE,
                           'en', 'Students Registered ',
                           'N° Iscritti ')
                || NUMERO_ISCRITTI)
             AS DESCRIZIONE,
          STU_ID
     FROM ORI_ESAMI A
          JOIN ORI_ESAMI_LN A1 ON A.MID = A1.MID
          JOIN P09_AD_GEN B ON COD_AD = COD
          JOIN ORI_ESAMI_USER A3 ON A.MID = A3.MID_ESAME
   UNION
   SELECT A.MID,
          LN_CODE AS LN_CODE,
          1 AS TIPO,
          DATA_INIZIO AS DATA_INIZIO,
          DATA_FINE AS DATA_FINE,
          A1.DES_TIPO_ATT AS SUPERTITOLO,
          A1.DES_AD || '  [' || CDA_AD || ']' AS TITOLO,
          A1.DES_DOCENTI AS DESCRIZIONE,
          STU_ID
     FROM ORI_LEZIONI A
          JOIN ORI_LEZIONI_LN A1 ON A.MID = A1.MID
          JOIN ORI_LEZIONI_USER A3 ON A.MID = A3.MID_LEZIONE;
