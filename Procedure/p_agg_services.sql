CREATE OR REPLACE PROCEDURE                  P_AGG_SERVICES
AS
prima_volta number(10);
BEGIN

    /* Nel caso avessi righe che non hanno valorizzato il type_source (ad: esempio migrazione) cancello tutta la tabella */
    select count(*) into prima_volta from srv_services where type_source is null;
    if prima_volta <> 0 then
       DELETE FROM SRV_SERVICES;
    end if;
    select count(*) into prima_volta from srv_services_ln where type_source is null;
    if prima_volta <> 0 then
       DELETE FROM SRV_SERVICES_LN;
    end if;
    
    /* Aggiorno la tabella dei docenti (in modo incrementale) */
    P_AGG_T_DOCENTI;  

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- popolamento della SRV_SERVICES per rubrica docenti PUBBLICA
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM SRV_SERVICES where type_source = 1;

    INSERT INTO SRV_SERVICES (MID, ATTRIBUTE,FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS,EMAIL, TEL, FAX, CELL, URL, HOURS,NOTE1, NOTE2, NOTE3, TAG_SRV,TYPE_SRV,  PROFILE, ANA_ID,TYPE, LAT,LON, TYPE_SOURCE)
    SELECT ROWNUM MID,
           A.DES_APPELLATIVO AS ATTRIBUTE,
           A.COGNOME AS FIRSTNAME,
           A.NOME AS LASTNAME,
           A.DES_APPELLATIVO||' ' ||A.NOME||' '||A.COGNOME AS DESCRIPTION,
           C.VIA||DECODE(C.CAP, NULL, '', ' - '||C.CAP)||' '||C.CITTA||DECODE(C.PROV, NULL, '',' ('||C.PROV||')') AS ADDRESS, -- INDIRIZZO DIPARTIMENTO
           A.E_MAIL AS EMAIL,
           C.TEL AS TEL, -- TEL DIPARTIMENTO
           C.FAX AS FAX, -- FAX DIPARTIMENTO
           NULL AS CELL, --A.CELLULARE
           NULL AS URL,
           NULL AS HOURS,
           A.DES_GRUPPO AS NOTE1,
           NULL AS NOTE2,
           NULL AS NOTE3,
           'Docente' AS TAG_SRV,
           1 AS TYPE_SRV,
           0 AS PROFILE,
           MID AS ANA_ID,
           'MID_DOC' AS TYPE,
           null as LAT,
           null as LON,
           1
    FROM T_DOCENTI A
         JOIN DOCENTI B ON B.DOCENTE_ID = A.DOCENTE_ID
         left JOIN P06_DIP C ON C.DIP_ID = B.DIP_ID;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- popolamento della SRV_SERVICES_LN
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM SRV_SERVICES_LN where type_source = 1;

    INSERT INTO SRV_SERVICES_LN (MID,LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS,NOTE1,NOTE2, NOTE3,TAG_SRV, TYPE_SOURCE ) 
    SELECT A.MID,
           'en' AS LN_CODE,
           DECODE(ATTRIBUTE, 'Dott.', 'Dr.',
                             'Dott.ssa', 'Dr.',
                             'Prof.', 'Prof.',
                             ATTRIBUTE) AS ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NVL(D.DES, DECODE(C.DES, NULL, 'Dipartimento da assegnare', C.DES))||' ('||NVL(C.COD,'DA.ASSEGN') ||')' AS NOTE1,
           NOTE2,
           NOTE3,
           DECODE( TAG_SRV, 'Docente', 'Teacher',  TAG_SRV) AS  TAG_SRV,
           1
    FROM SRV_SERVICES A
         JOIN T_DOCENTI A1 ON A1.MID = ANA_ID
         JOIN DOCENTI B ON B.DOCENTE_ID = A1.DOCENTE_ID
         LEFT JOIN P06_DIP C ON C.DIP_ID = B.DIP_ID
         LEFT JOIN P06_DIP_DES_LIN D ON (D.DIP_ID = C.DIP_ID AND D.LINGUA_ID = 1)
    WHERE TYPE_SOURCE = 1;

    INSERT INTO SRV_SERVICES_LN (MID,LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS,NOTE1,NOTE2, NOTE3,TAG_SRV, TYPE_SOURCE ) 
    SELECT MID,
           'it' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           1
    FROM SRV_SERVICES A
    WHERE TYPE_SOURCE = 1;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- STRUTTURE
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE from SRV_SERVICES WHERE TYPE_SOURCE = 2;

    insert into SRV_SERVICES (MID,  ATTRIBUTE, FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS, EMAIL, TEL, FAX, CELL, URL, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SRV, PROFILE, ANA_ID, TYPE, LAT, LON, TYPE_SOURCE )
    select (
    select max(mid) from SRV_SERVICES) + rownum MID,
    ATTRIBUTE, FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS, EMAIL, TEL, FAX, CELL, URL, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SRV, PROFILE, ANA_ID, TYPE, LAT, LON, TYPE_SOURCE
    from
    (
    SELECT null as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des as DESCRIPTION,
           via as ADDRESS,
           null as EMAIL,
           null as TEL,
           null as FAX,
           null as CELL,
           url_sito_web as URL,
           null as HOURS,
           null as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Facolta' as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           FAC_ID ANA_ID,
           'ID_FAC' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2 as TYPE_SOURCE
    FROM P06_FAC
    where fac_id <> 9999
    union
    SELECT DES_BREVE as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des as DESCRIPTION,
           via as ADDRESS,
           null as EMAIL,
           tel as TEL,
           fax as FAX,
           null as CELL,
           null as URL,
           null as HOURS,
           presdir as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Dipartimento' as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           DIP_ID ANA_ID,
           'ID_DIP' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2
    FROM P06_DIP
    union
    select acronimo as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des||' ['||COD||']' as DESCRIPTION,
           null as ADDRESS,
           null as EMAIL,
           null as TEL,
           null as FAX,
           null as CELL,
           url_sito_web as URL,
           null as HOURS,
           null as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Corsi '||tipo_corso_cod as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           cds_ID ANA_ID,
           'ID_CDS' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2
    from P06_CDS
    );


    DELETE FROM SRV_SERVICES_LN WHERE TYPE_SOURCE = 2;

    INSERT INTO SRV_SERVICES_LN (MID, LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SOURCE)
    SELECT MID,
           'it' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           2
    FROM SRV_SERVICES A
    where TYPE_SOURCE = 2;

    INSERT INTO SRV_SERVICES_LN  (MID, LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SOURCE)
    SELECT MID,
           'en' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           2
    FROM SRV_SERVICES A
    where TYPE_SOURCE = 2;


END;
/
