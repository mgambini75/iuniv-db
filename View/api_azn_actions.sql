/* Formatted on 14/03/2016 11:45:32 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_AZN_ACTIONS
(
   MID,
   MID_CAT,
   LANG,
   STU_ID,
   TITOLO,
   TESTO,
   URL_LINK,
   BLOCCO
)
AS
     SELECT AGE_AZN_ID AS MID,
            AGE_AVT_ID AS MID_CAT,
            LN_CODE AS LANG,
            AGE_AZN_STU_ID AS STU_ID,
            DECODE (LN_CODE,
                    'it', AGE_AVT_TITOLO_ITA,
                    'en', AGE_AVT_TITOLO_ENG,
                    NULL)
               AS TITOLO,
            DECODE (LN_CODE,
                    'it', AGE_AVT_TESTO_ITA,
                    'en', AGE_AVT_TESTO_ENG,
                    NULL)
               AS TESTO,
            AGE_AZN_LINK AS URL_LINK,
            DECODE (AGE_AZT_BLOCCO_APP, 'Y', 1, 0) AS BLOCCO
       FROM AGE_AZIONI A
            JOIN AGE_AZIONI_TIPI B ON AGE_AVT_ID = AGE_AZN_RIF_TIPO
            JOIN T_AGE_AZIONI ON MID = AGE_AZN_ID
      WHERE AGE_AZN_STATO = 'N'
   ORDER BY BLOCCO DESC, TITOLO;
