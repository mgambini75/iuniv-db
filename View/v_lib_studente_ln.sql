/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_LIB_STUDENTE_LN
(
   MID,
   LN_CODE,
   DES_AD,
   DES_ANNO,
   DES_PESO,
   DES_TIPO_INS,
   DES_STATO,
   DES_VOTO
)
AS
   SELECT MID,
          'it' AS LN_CODE,
          DES_AD,
          DES_ANNO,
          DECODE (DES_PESO,
                  '1 Annualità', 'Una Annualità',
                  ',5 Annualità', 'Mezza Annualità',
                  '0 Annualità', 'Nessuna Annualità',
                  ' Annualità', 'Nessuna Annualità',
                  DES_PESO)
             AS des_peso,
          DES_TIPO_INS,
          DES_STATO,
          DES_VOTO
     FROM v_LIB_STUDENTE
   UNION
   SELECT MID,
          'en' AS LN_CODE,
          DES_AD,
          DECODE (DES_ANNO,
                  'Primo', 'First',
                  'Secondo', 'Second',
                  'Terzo', 'Third',
                  DES_ANNO)
             AS DES_ANNO,
          DECODE (DES_PESO,
                  '1 Annualità', 'One Annuity',
                  ',5 Annualità', 'Half Annuity',
                  '0 Annualità', 'No Annuity',
                  ' Annualità', 'No Annuity',
                  DES_PESO)
             AS DES_PESO,
          DECODE (
             DES_TIPO_INS,
             'Altro Insegnamento', 'Other teaching',
             'Caratteriz. corso di laurea', 'Characterizing couse',
             'Caratteriz. opzionale', 'Characterizing elective course',
             'Fondamentale', 'Fundamental',
             'Obblig. a scelta', 'Compulsory course chosen',
             'Obblig. base comune', 'Compulsory course',
             'Obblig. di curriculum', 'Curriculum compulsory course',
             'Obblig. di curriculum a scelta', 'Curriculum compulsory course chosen',
             'Obbligatorio', 'Compulsory',
             'Opzionale', 'Elective course',
             'Precorso', 'Pre-course',
             'Rosa Ristretta', 'Shortlist',
             'obbligatorio d''indirizzo', 'Curriculum compulsory',
             'Obbligatorio di indirizzo', 'Curriculum compulsory',
             'Altra attività formativa', 'Other teaching',
             'Debito Formativo', 'Educational debt',
             'Fittizio', 'Dummy',
             'Non Definito', 'Undefined')
             AS DES_TIPO_INS,
          DECODE (DES_STATO,
                  'Superata', 'Exceeded',
                  'Frequentata', 'Attended',
                  'In piano', 'Flat',
                  DES_ANNO)
             AS DES_STATO,
          DECODE (DES_VOTO,
                  'IDONEO', 'Suitable',
                  '30 e lode', '30 laude',
                  'Approvato', 'Approved',
                  'Buono', 'Good',
                  'Ottimo', 'Excellent',
                  'Distinto', 'Discrete',
                  'Sufficiente', 'Sufficient',
                  DES_VOTO)
             AS DES_VOTO
     FROM v_LIB_STUDENTE;
