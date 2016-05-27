CREATE OR REPLACE PROCEDURE                  P_AGG_CERCA_SEL
AS
BEGIN

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento dei dati
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM GOL_CERCA; 

    INSERT INTO GOL_CERCA
    SELECT ROWNUM,
           MID_AD,
           AA_OFF_ID,
           --- ricerca insegnamenti per codice
           COD_AD,
           --- ricerca insegnamenti per nome
           DES_AD,
           TIPO_CORSO_COD,
           DES_LUNGUA_DID,
           SETT_COD,
           ACR,
           DES_PART,
           TIPO_INS_COD, 
           --- ricerca insegnamenti per docente
           TITOLARE
    FROM (  
            SELECT DISTINCT 
                   MID_AD,
                   AA_OFF_ID,
                   --- ricerca insegnamenti per codice
                   a.COD_ad,
                   --- ricerca insegnamenti per nome
                   DES_AD,
                   TIPO_CORSO_COD,
                   DES_LUNGUA_DID,
                   a.SETT_COD,
                   COD_CDS ACR,
                   NVL(DES_PART, 'Non Definito') as DES_PART,
                   NVL(TIPO_INS_COD, 'ND') as TIPO_INS_COD, 
                   --- ricerca insegnamenti per docente
                   CASE WHEN COGNOME IS  NULL AND NOME IS NULL
                            THEN  'Non Definito'
                            ELSE  COGNOME||' '||NOME
                   END TITOLARE
            FROM GOL_IUNI A
                 LEFT JOIN DOCENTI B ON A.DOCENTE_ID = B.DOCENTE_ID
            where aa_off_id in (2010, 2011, 2012)
         );

    --- eliminazione dati valori
    DELETE GOL_CERCA_VAL;
    
    --- caricamento dati valori in italiano
    INSERT INTO GOL_CERCA_VAL
    select rownum as mid,
           LN_CODE as LN_CODE,
           MID_CAMPO,
           AA_OFF_ID,
           substr(TITOLO, 1, 40),
           VAL,
           VAL_PADRE
    from (
    --- tipologia del corso
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
             X.TIPO_CORSO_COD||' - '||TIPO_CORSO_DES AS TITOLO, 
           X.TIPO_CORSO_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 4
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
         JOIN TIPI_CORSO C ON X.TIPO_CORSO_COD = C.TIPO_CORSO_COD
    union
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
             X.TIPO_CORSO_COD||' - '||TIPO_CORSO_DES AS TITOLO, 
           X.TIPO_CORSO_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 4
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
         JOIN TIPI_CORSO C ON X.TIPO_CORSO_COD = C.TIPO_CORSO_COD
    UNION     
    --- codice del corso
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, ACR AS TITOLO, ACR AS VAL, TIPO_CORSO_COD AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 5
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    union    
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, ACR AS TITOLO, ACR AS VAL, TIPO_CORSO_COD AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 5
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- lingua
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           DES_LUNGUA_DID AS TITOLO, DES_LUNGUA_DID AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 6
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           decode ( DES_LUNGUA_DID, 'francese', 'french', 
                                    'inglese', 'english',
                                    'italiano', 'italian',
                                    'portoghese', 'portuguese',
                                    'spagnolo', 'spanish',
                                    'tedesco', 'german',
                                    DES_LUNGUA_DID ) AS TITOLO, 
           DES_LUNGUA_DID AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 6
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- settore
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, SETT_COD AS TITOLO, SETT_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 7
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, SETT_COD AS TITOLO, SETT_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 7
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- periodo    
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES_PART AS TITOLO, DES_PART AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 8
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION     
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES_PART AS TITOLO, DES_PART AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 8
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- tipo insegnamento
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES AS TITOLO, B.TIPO_INS_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 9
         LEFT JOIN TIPI_INS B ON B.TIPO_INS_COD = X.TIPO_INS_COD
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           decode (DES, 'Altro Insegnamento','Other teaching',
                        'Caratteriz. corso di laurea','Characterizing couse',
                        'Caratteriz. opzionale','Characterizing elective course',
                        'Fondamentale','Fundamental',
                        'Obblig. a scelta','Compulsory course chosen',
                        'Obblig. base comune','Compulsory course',
                        'Obblig. di curriculum','Curriculum compulsory course',
                        'Obblig. di curriculum a scelta','Curriculum compulsory course chosen',
                        'Obbligatorio','Compulsory',
                        'Opzionale','Elective course',
                        'Precorso','Pre-course',
                        'Rosa Ristretta','Shortlist',
                        des ) AS TITOLO, B.TIPO_INS_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 9
         LEFT JOIN TIPI_INS B ON B.TIPO_INS_COD = X.TIPO_INS_COD
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    );


END;
/
