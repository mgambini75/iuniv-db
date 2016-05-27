CREATE OR REPLACE PROCEDURE P_AGG_LIBRETTO
AS
BEGIN

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento libretto
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    DELETE FROM LIB_STUDENTE;

    INSERT INTO LIB_STUDENTE ( MID, STU_ID, COD_AD, DES_AD, ANNO_CORSO, DES_ANNO, PESO, des_peso, COD_TIPO_INS, DES_TIPO_INS, COD_STATO, DES_STATO, VOTO,  LODE_FLG, TIPO_GIUD_COD, DES_VOTO, DATA_SUP, AA_SUP_ID)
    SELECT ADSCE_ID AS MID,
           A.STU_ID,
           A.COD AS COD_AD,
           FU_DES_UP_LOW(A.DES) AS DES_AD,
           A.ANNO_CORSO as ANNO_CORSO,
           nvl(E.DES2, 'nd') AS DES_ANNO,
           A.PESO as PESO,
           A.PESO||decode(f.um_peso_cod, 'A', ' Annualità',
                                         'C', ' Cfu',
                                         f.um_peso_cod ) as des_peso,
           A.TIPO_INS_COD AS COD_TIPO_INS, 
           D.DES AS DES_TIPO_INS,
           A.STA_SCE_COD AS COD_STATO,
           DECODE( A.STA_SCE_COD, 'P', 'In piano',
                                  'F', 'Frequentata',
                                  'S', 'Superata') AS DES_STATO,
           A.VOTO as VOTO,
           A.LODE_FLG as LODE_FLG,
           A.TIPO_GIUD_COD as TIPO_GIUD_COD,
           DECODE ( A.VOTO, NULL,C.DES, TO_CHAR(A.VOTO)|| DECODE(A.LODE_FLG, 0, '', 1, ' e lode')) AS DES_VOTO,
           TRUNC(A.DATA_SUP) AS DATA_SUP,
           A.AA_SUP_ID as AA_SUP_ID
    FROM P11_AD_SCE A
         JOIN P04_MAT B ON B.MAT_ID = A.MAT_ID AND B.STA_MAT_COD = 'A'
         LEFT JOIN TIPI_GIUDIZIO C ON A.TIPO_GIUD_COD = C.TIPO_GIUD_COD
         LEFT JOIN TIPI_INS D ON A.TIPO_INS_COD = D.TIPO_INS_COD
         LEFT JOIN TIPI_ANNO E ON TO_CHAR(A.ANNO_CORSO) = E.ANNO_COD
         JOIN P06_CDS F ON F.CDS_ID = A.CDS_ID;


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento libretto in lingua
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    DELETE FROM LIB_STUDENTE_LN;


    INSERT INTO LIB_STUDENTE_LN (MID,LN_CODE, DES_AD, DES_ANNO, DES_PESO,  DES_TIPO_INS, DES_STATO, DES_VOTO)
    SELECT MID, 'it' as LN_CODE, DES_AD, DES_ANNO, 
           decode( DES_PESO, '1 Annualità', 'Una Annualità',
                             ',5 Annualità', 'Mezza Annualità',
                             '0 Annualità', 'Nessuna Annualità',
                             ' Annualità', 'Nessuna Annualità',
                             DES_PESO ) as des_peso, 
           DES_TIPO_INS, DES_STATO, DES_VOTO
    FROM LIB_STUDENTE;

    INSERT INTO LIB_STUDENTE_LN (MID,LN_CODE, DES_AD,DES_ANNO , DES_PESO, DES_TIPO_INS, DES_STATO, DES_VOTO)
    SELECT MID, 'en' as LN_CODE, 
           DES_AD, 
           decode(DES_ANNO, 'Primo','First',
                            'Secondo','Second',
                            'Terzo','Third',
                            DES_ANNO) AS DES_ANNO,
           decode( DES_PESO, '1 Annualità', 'One Annuity',
                             ',5 Annualità', 'Half Annuity',
                             '0 Annualità', 'No Annuity',
                             ' Annualità', 'No Annuity',
                             DES_PESO ) AS DES_PESO,                  
           decode( DES_TIPO_INS, 'Altro Insegnamento','Other teaching',
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
                                 'obbligatorio d''indirizzo', 'Curriculum compulsory',
                                 'Obbligatorio di indirizzo', 'Curriculum compulsory',
                                 'Altra attività formativa', 'Other teaching',
                                 'Debito Formativo', 'Educational debt',
                                 'Fittizio', 'Dummy'
                                 ) AS DES_TIPO_INS, 
           decode(DES_STATO, 'Superata','Exceeded',
                             'Frequentata','Attended',
                             'In piano','Flat',
                             DES_ANNO) AS DES_STATO, 
           decode(DES_VOTO, 'IDONEO', 'Suitable',
                            '30 e lode', '30 laude', 
                            'Approvato',  'Approved',
                            'Buono', 'Good',
                            'Ottimo', 'Excellent',
                            'Distinto', 'Discrete',
                            'Sufficiente','Sufficient',
                            DES_VOTO) AS DES_VOTO
    FROM LIB_STUDENTE;

END;
/
