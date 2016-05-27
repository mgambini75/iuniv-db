

CREATE TABLE AGE_AZIONI
(
  AGE_AZN_ID          NUMBER(10),
  AGE_AZN_DELETED     VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_AZN_DATA_INS    DATE                      DEFAULT SYSDATE,
  AGE_AZN_DATA_MOD    DATE,
  AGE_AZN_DATA_ELI    DATE,
  AGE_AZN_DATA_DA     DATE,
  AGE_AZN_DATA_A      DATE,
  AGE_AZN_USERNAME    VARCHAR2(20 CHAR),
  AGE_AZN_PERS_ID     NUMBER(10),
  AGE_AZN_STU_ID      NUMBER(10),
  AGE_AZN_RIF_TIPO    NUMBER(10),
  AGE_AZN_STATO       VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_AZN_LINK        VARCHAR2(255 CHAR),
  AGE_AVT_TITOLO_ITA  VARCHAR2(300 CHAR),
  AGE_AVT_TITOLO_ENG  VARCHAR2(300 CHAR),
  AGE_AVT_TESTO_ITA   VARCHAR2(4000 CHAR),
  AGE_AVT_TESTO_ENG   VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_ID IS 'ID    Progressivo numerico azione - autoincrementale';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DELETED IS 'Flag: n = online , s = offline    Visibilità dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DATA_INS IS 'Data Creazione    Data di inserimento dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DATA_MOD IS 'Data Modifica    Data di ultima modifica dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DATA_ELI IS 'Data Eliminazione    Data di eliminazione dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DATA_DA IS 'Data visibilità DA    Data di inizio visibilità dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_DATA_A IS 'Data visibilità A    Data di fine visibilità dell''azione';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_USERNAME IS 'USERNAME LDAP    Riferimento alla persona (docenti, pta, studenti...)';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_PERS_ID IS 'ESSE3_PERS_ID    Riferimento ESSE3 alla persona (PERS_ID studenti)';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_STU_ID IS 'ESSE3_STU_ID    Riferimento alla carriera. Le azioni sono indirizzate alla carriera';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_RIF_TIPO IS 'Tipologia    "Riferimento alla tipologia di azione todo o bloccante - Campo AGE_AZT_ID tabella AGE_AZIONI_TIPI, tipologia = g"';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_STATO IS 'Flag: n = DA FARE , s = FATTO    Stato del blocco';

COMMENT ON COLUMN AGE_AZIONI.AGE_AZN_LINK IS 'Link    Link alla procedura sbloccante, richiamata nella lingua di navigazione dell''utente';

COMMENT ON COLUMN AGE_AZIONI.AGE_AVT_TITOLO_ITA IS 'Titolo ITA    Titolo dell''azione in italiano';

COMMENT ON COLUMN AGE_AZIONI.AGE_AVT_TITOLO_ENG IS 'Titolo ENG    Titolo dell''azione in inglese';

COMMENT ON COLUMN AGE_AZIONI.AGE_AVT_TESTO_ITA IS 'Testo_ITA    Testo in lingua italiana';

COMMENT ON COLUMN AGE_AZIONI.AGE_AVT_TESTO_ENG IS 'Testo_ENG    Testo in lingua inglese';


CREATE TABLE AGE_AZIONI_TIPI
(
  AGE_AVT_ID           NUMBER(10),
  AGE_AVT_DELETED      VARCHAR2(1 CHAR)         DEFAULT 'n',
  AGE_AVT_DATA_INS     DATE                     DEFAULT SYSDATE,
  AGE_AVT_DATA_MOD     DATE,
  AGE_AVT_DATA_ELI     DATE,
  AGE_AZT_BLOCCO_APP   VARCHAR2(1 CHAR)         DEFAULT 'n',
  AGE_AZT_BLOCCO_UATB  VARCHAR2(1 CHAR)         DEFAULT 'n',
  AGE_AZT_TITOLO_ITA   VARCHAR2(250 CHAR),
  AGE_AZT_TITOLO_ENG   VARCHAR2(250 CHAR),
  AGE_AZT_NOTE         VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AVT_ID IS 'ID    Progressivo numerico azione - autoincrementale';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AVT_DELETED IS 'Flag: n = online , s = offline    Visibilità dell''azione';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AVT_DATA_INS IS 'Data Creazione    Data di inserimento dell''azione';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AVT_DATA_MOD IS 'Data Modifica    Data di ultima modifica dell''azione';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AVT_DATA_ELI IS 'Data Eliminazione    Data di eliminazione dell''azione';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AZT_BLOCCO_APP IS 'Flag: n = NON BLOCCATO , s = BLOCCATO    Messaggio bloccante per iphone';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AZT_BLOCCO_UATB IS 'Flag: n = NON BLOCCATO , s = BLOCCATO    Messaggio bloccante per agenda';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AZT_TITOLO_ITA IS 'Titolo ITA    Titolo dell''azione in italiano';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AZT_TITOLO_ENG IS 'Titolo ENG    Titolo dell''azione in inglese';

COMMENT ON COLUMN AGE_AZIONI_TIPI.AGE_AZT_NOTE IS 'Testo    Note di servizio';


CREATE TABLE AGE_BOX_EMAIL
(
  AGE_BEM_ID          NUMBER(10)                DEFAULT 0,
  AGE_BEM_DELETED     VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BEM_DATA_INS    DATE,
  AGE_BEM_DATA_MOD    DATE,
  AGE_BEM_DATA_ELI    DATE,
  AGE_BEM_RIF_EVENTO  NUMBER(10)                DEFAULT 0,
  AGE_BEM_DATA_INVIO  DATE,
  AGE_BEM_DATA_DA     DATE,
  AGE_BEM_DATA_A      DATE,
  AGE_BEM_INVIO_NR    NUMBER(10)                DEFAULT 0,
  AGE_BEM_INVIO       VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BEM_TIPO        VARCHAR2(1 CHAR)          DEFAULT 'r',
  AGE_BEM_DEST        VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BEM_LISTA       NUMBER(10)                DEFAULT 0,
  AGE_BEM_FILE        VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BEM_MITTENTE    VARCHAR2(60 CHAR),
  AGE_BEM_TITOLO_ITA  VARCHAR2(250 CHAR),
  AGE_BEM_TITOLO_ENG  VARCHAR2(250 CHAR),
  AGE_BEV_TESTO_ITA   VARCHAR2(4000 CHAR),
  AGE_BEV_TESTO_ENG   VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_BOX_GESTORI
(
  AGE_BGE_ID        NUMBER(10),
  AGE_BGE_DELETED   VARCHAR2(1 CHAR)            DEFAULT 'n',
  AGE_BGE_DATA_INS  DATE                        DEFAULT SYSDATE,
  AGE_BGE_DATA_MOD  DATE,
  AGE_BGE_DATA_ELI  DATE,
  AGE_BGE_TIPO      VARCHAR2(2 CHAR),
  AGE_BGE_RIF_GRP   NUMBER(10),
  AGE_BGE_USERNAME  VARCHAR2(20 CHAR),
  AGE_BGE_PERS_ID   NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_ID IS 'ID. Progressivo gestore';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_DELETED IS 'Flag: n = valido , s = eliminato. Validità del gestore';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_DATA_INS IS 'Data Creazione. Data di inserimento del gestore';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_DATA_MOD IS 'Data Modifica. Data di ultima modifica del gestore';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_DATA_ELI IS 'Data Eliminazione. Data di eliminazione del gestore';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_TIPO IS 'Flag: a = admin , s = gestore. Admin accede alla gestione di tutti i box e di tutti gli eventi';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_RIF_GRP IS 'ID_GRUPPO    Associazione gruppo (zero per admin) - Campo AGE_BGR_ID tabella AGE_BOX_IMPOSTA';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_USERNAME IS 'USERNAME LDAP    Associazione gestore - Riferimento LDAP alla persona (docenti, pta, studenti...)';

COMMENT ON COLUMN AGE_BOX_GESTORI.AGE_BGE_PERS_ID IS 'ESSE3_PERS_ID    Associazione gestore - Riferimento ESSE3 alla persona (studenti)';


CREATE TABLE AGE_BOX_ISCRITTI
(
  AGE_BIS_ID             NUMBER(10)             DEFAULT 0,
  AGE_BIS_DELETED        VARCHAR2(1 CHAR)       DEFAULT 'n',
  AGE_BIS_DATA_INS       DATE,
  AGE_BIS_DATA_MOD       DATE,
  AGE_BIS_DATA_ELI       DATE,
  AGE_BIS_RIF_EVENTO     NUMBER(10)             DEFAULT 0,
  AGE_BIS_USERNAME       VARCHAR2(20 CHAR),
  AGE_BIS_PERS_ID        NUMBER(10)             DEFAULT 0,
  AGE_BIS_LINGUA         VARCHAR2(10 CHAR),
  AGE_BIS_INDIRIZZO_IP   VARCHAR2(20 CHAR),
  AGE_BIS_PRIVACY        VARCHAR2(1 CHAR)       DEFAULT 'n',
  AGE_BIS_DOC_TIPO       VARCHAR2(1 CHAR),
  AGE_BIS_DOC_NUMERO     VARCHAR2(20 CHAR),
  AGE_BIS_DATA_NASCITA   DATE,
  AGE_BIS_COGNOME        VARCHAR2(60 CHAR),
  AGE_BIS_NOME           VARCHAR2(60 CHAR),
  AGE_BIS_PROFESSIONE    VARCHAR2(60 CHAR),
  AGE_BIS_AZIENDA        VARCHAR2(100 CHAR),
  AGE_BIS_CAP            VARCHAR2(20 CHAR),
  AGE_BIS_CFS_NAZIONE    VARCHAR2(4 CHAR),
  AGE_BIS_COD_PROVINCIA  VARCHAR2(2 CHAR),
  AGE_BIS_CFS_COMUNE     VARCHAR2(4 CHAR),
  AGE_BIS_STATO          VARCHAR2(100 CHAR),
  AGE_BIS_LOCALITA       VARCHAR2(100 CHAR),
  AGE_BIS_INDIRIZZO      VARCHAR2(100 CHAR),
  AGE_BIS_TELEFONO       VARCHAR2(25 CHAR),
  AGE_BIS_CELLULARE      VARCHAR2(25 CHAR),
  AGE_BIS_FAX            VARCHAR2(25 CHAR),
  AGE_BIS_EMAIL_PRIMA    VARCHAR2(60 CHAR),
  AGE_BIS_EMAIL_SECONDA  VARCHAR2(60 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_BOX_LISTE
(
  AGE_BLI_ID          INTEGER,
  AGE_BLI_DELETED     VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BLI_DATA_INS    DATE                      DEFAULT SYSDATE,
  AGE_BLI_DATA_MOD    DATE,
  AGE_BLI_DATA_ELI    DATE,
  AGE_BLI_RIF_GRP     INTEGER,
  AGE_BLI_OBBLIGO     VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_BLI_TITOLO_ITA  VARCHAR2(250 CHAR),
  AGE_BLI_TITOLO_ENG  VARCHAR2(250 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_ID IS 'ID. Progressivo canale';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_DELETED IS 'Flag: n = valido , s = eliminato. Validità del canale';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_DATA_INS IS 'Data Creazione. Data di inserimento del canale';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_DATA_MOD IS 'Data Modifica. Data di ultima modifica del canale';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_DATA_ELI IS 'Data Eliminazione. Data di eliminazione del canale';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_RIF_GRP IS 'ID_GRUPPO    Associazione a gruppo di 1° o 2° livello (almeno una lista per ogni gruppo di 1° livello e di 2° per ogni dipartimento e per ogni sport/associazione)';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_OBBLIGO IS 'Flag: 
n = liste gestori
s = liste ufficiali    
Gestione della lista di utenti:
n = lista creabile/modificabile dai gestori es. liste utenti aggiunte dal gestore per un evento
s = lista creata/aggiornata da script schedulati e da sottoscrizioni volontarie es. liste docenti afferenti un dipartimento';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_TITOLO_ITA IS 'Descrizione ITA. Descrizione del canale in italiano';

COMMENT ON COLUMN AGE_BOX_LISTE.AGE_BLI_TITOLO_ENG IS 'Descrizione ENG. Descrizione del canale in inglese';


CREATE TABLE AGE_CAL_ESAMI
(
  AGE_CAES_ID        NUMBER(10),
  AGE_CAES_DELETED   VARCHAR2(1 CHAR)           DEFAULT 'n',
  AGE_CAES_DATA_INS  DATE,
  AGE_CAES_DATA_MOD  DATE,
  AGE_CAES_DATA_ELI  DATE,
  AGE_CAES_USERNAME  VARCHAR2(20 CHAR),
  AGE_CAES_PERS_ID   NUMBER(10),
  AGE_CAES_STU_ID    NUMBER(10),
  AGE_CAES_CDL       VARCHAR2(10 CHAR),
  AGE_CAES_COD       VARCHAR2(5 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_CAL_EVENTI
(
  AGE_CAEV_ID           NUMBER(10),
  AGE_CAEV_DELETED      VARCHAR2(1 CHAR)        DEFAULT 'n',
  AGE_CAEV_DATA_INS     DATE,
  AGE_CAEV_DATA_MOD     DATE,
  AGE_CAEV_DATA_ELI     DATE,
  AGE_CAEV_DATA         DATE,
  AGE_CAEV_DALLE        DATE,
  AGE_CAEV_ALLE         DATE,
  AGE_CAEV_USERNAME     VARCHAR2(20 CHAR),
  AGE_CAEV_PERS_ID      NUMBER(10),
  AGE_CAEV_STU_ID       NUMBER(10),
  AGE_CAEV_DESCRIZIONE  VARCHAR2(500 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_CAL_LEZIONI
(
  AGE_CALE_ID        NUMBER(10),
  AGE_CALE_DELETED   VARCHAR2(1 CHAR)           DEFAULT 'n',
  AGE_CALE_DATA_INS  DATE,
  AGE_CALE_DATA_MOD  DATE,
  AGE_CALE_DATA_ELI  DATE,
  AGE_CALE_USERNAME  VARCHAR2(20 CHAR),
  AGE_CALE_PERS_ID   NUMBER(10),
  AGE_CALE_STU_ID    NUMBER(10),
  AGE_CALE_COD       VARCHAR2(5 CHAR),
  AGE_CALE_CLASSE    VARCHAR2(2 CHAR),
  AGE_CALE_GRUPPO    VARCHAR2(2 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_IMPOSTA_T
(
  AGE_TIMP_ID         NUMBER(10),
  AGE_TIMP_DELETED    VARCHAR2(1 CHAR)          DEFAULT 'n',
  AGE_TIMP_DATA_INS   DATE                      DEFAULT SYSDATE,
  AGE_TIMP_DATA_MOD   DATE,
  AGE_TIMP_DATA_ELI   DATE,
  AGE_TIMP_DT_ULTACC  DATE,
  AGE_TIMP_NUM_ACC    INTEGER,
  AGE_TIMP_DT_ULTMOB  DATE,
  AGE_TIMP_NUM_MOB    INTEGER,
  AGE_TIMP_USERNAME   VARCHAR2(20 CHAR),
  AGE_TIMP_PERS_ID    NUMBER(10),
  AGE_TIMP_TIPO       VARCHAR2(1 CHAR),
  AGE_TIMP_LINGUA     VARCHAR2(10 CHAR),
  AGE_TIMP_STILE      VARCHAR2(10 CHAR),
  AGE_TIMP_CELL       VARCHAR2(25 CHAR),
  AGE_TIMP_EMAIL      VARCHAR2(100 CHAR),
  AGE_TIMP_ALIAS      VARCHAR2(100 CHAR),
  AGE_TIMP_APPUNTI    VARCHAR2(500 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_ID IS 'ID. Progressivo registrazione';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DELETED IS 'Flag: n = valido , s = eliminato. Validità della registrazione';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DATA_INS IS 'Data Creazione. Data di inserimento della registrazione';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DATA_MOD IS 'Data Modifica. Data di ultima modifica della registrazione';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DATA_ELI IS 'Data Eliminazione. Data di eliminazione della registrazione';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DT_ULTACC IS 'Data Ultimo accesso. Data di ultimo accesso in login - agenda web';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_NUM_ACC IS 'N. accessi. Numero di accessi totali per utente - agenda web';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_DT_ULTMOB IS 'Data Ultimo accesso. Data di ultimo accesso in login - mobile';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_NUM_MOB IS 'N. accessi. Numero di accessi totali per utente - mobile';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_USERNAME IS 'USERNAME LDAP corrisponde al valore del campo USER_ID della tabella P18_USER. Riferimento alla persona (docenti, pta, studenti)';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_PERS_ID IS 'Esse3_pers_id. Chiave di studenti/laureati';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_TIPO IS 'Tipologia utenti. P = pta, D = docenti, vuoto = studenti/laureati';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_LINGUA IS 'Lingua. Lingua di navigazione in agenda';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_STILE IS 'CSS. Colore dei box in agenda';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_CELL IS 'N. cellulare personale. Configurazione dati personali in agenda';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_EMAIL IS 'Email personale. Configurazione dati personali in agenda';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_ALIAS IS 'Alias email ufficiale @dominio. Alias assegnato es. nome.cognome@studbocconi.it';

COMMENT ON COLUMN AGE_IMPOSTA_T.AGE_TIMP_APPUNTI IS 'Appunti in agenda. Configurazione dati personali in agenda';


CREATE TABLE AGE_LINK
(
  AGE_LINK_ID          NUMBER(10),
  AGE_LINK_DELETED     VARCHAR2(1 CHAR)         DEFAULT 'n',
  AGE_LINK_DATA_INS    DATE,
  AGE_LINK_DATA_MOD    DATE,
  AGE_LINK_DATA_ELI    DATE,
  AGE_LINK_USERNAME    VARCHAR2(20 CHAR),
  AGE_LINK_PERS_ID     NUMBER(10),
  AGE_LINK_STU_ID      NUMBER(10),
  AGE_LINK_TITOLO_ITA  VARCHAR2(300 CHAR),
  AGE_LINK_TITOLO_ENG  VARCHAR2(300 CHAR),
  AGE_LINK_URL         VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE AGE_SCAD_AMM
(
  AGE_SCAD_ID        NUMBER(10),
  AGE_SCAD_DELETED   VARCHAR2(1 CHAR)           DEFAULT 'n',
  AGE_SCAD_DATA_INS  DATE,
  AGE_SCAD_DATA_MOD  DATE,
  AGE_SCAD_DATA_ELI  DATE,
  AGE_SCAD_DATA_DA   DATE,
  AGE_SCAD_DATA_A    DATE,
  AGE_SCAD_MSG_ITA   VARCHAR2(500 CHAR),
  AGE_SCAD_MSG_ENG   VARCHAR2(500 CHAR),
  AGE_SCAD_ORDIN     VARCHAR2(10 CHAR),
  AGE_SCAD_CDL       VARCHAR2(10 CHAR),
  AGE_SCAD_AC        VARCHAR2(1 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE DSH_AD_TORTA
(
  MID             NUMBER(10)                    NOT NULL,
  STU_ID          NUMBER(10),
  TIPO_CORSO_COD  VARCHAR2(25 CHAR),
  STA_STU_COD     VARCHAR2(25 CHAR),
  MOT_STASTU_COD  VARCHAR2(25 CHAR),
  DES_PESO        VARCHAR2(25 CHAR),
  VAL_TOTALE      NUMBER,
  PESO_SUP        NUMBER,
  PESO_FRE        NUMBER,
  PESO_PIA        NUMBER,
  DATA_INS        DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE DSH_AD_VOTI
(
  MID             NUMBER(10),
  STU_ID          NUMBER(10),
  PROG            NUMBER(10),
  DESCRIZIONE     VARCHAR2(255 CHAR),
  DATA            DATE,
  MOD_VAL_COD     VARCHAR2(5 CHAR),
  VOTO            NUMBER(5,2),
  LODE_FLG        NUMBER(1),
  TIPO_GIUD_COD   VARCHAR2(5 CHAR),
  NO_MEDIA_FLG    NUMBER(1),
  VOTO_DES        VARCHAR2(255 CHAR),
  PESO            NUMBER(5,2),
  VOTO_ELAB       NUMBER(8,2),
  MEDIA_ART_PROG  NUMBER(8,2),
  MEDIA_PON_PROG  NUMBER(8,2),
  PESO_ELAB       NUMBER(8,2),
  DATA_INS        DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ELMAH$ERROR
(
  ERRORID         NVARCHAR2(32)                 NOT NULL,
  APPLICATION     NVARCHAR2(60)                 NOT NULL,
  HOST            NVARCHAR2(30)                 NOT NULL,
  TYPE            NVARCHAR2(100)                NOT NULL,
  SOURCE          NVARCHAR2(60),
  MESSAGE         NVARCHAR2(500)                NOT NULL,
  USERNAME        NVARCHAR2(50),
  STATUSCODE      NUMBER                        NOT NULL,
  TIMEUTC         DATE                          NOT NULL,
  SEQUENCENUMBER  NUMBER                        NOT NULL,
  ALLXML          NCLOB                         NOT NULL
)
LOB (ALLXML) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FEE_TIPI_FEED
(
  MID            NUMBER,
  DES_LISTA      VARCHAR2(4000 CHAR),
  DES_DETTAGLIO  VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_ACCESSI
(
  MID          NUMBER(10)                       NOT NULL,
  DTM_LOGIN    DATE                             NOT NULL,
  MID_FRW_UTE  NUMBER(10)                       NOT NULL,
  DTM_LOGOUT   DATE
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_CONFIG
(
  MID                  NUMBER(10)               NOT NULL,
  COD                  VARCHAR2(50 CHAR),
  VALUE_STRING         VARCHAR2(4000 CHAR),
  DESCRIPTION          VARCHAR2(4000 CHAR),
  APP_VISIBLE_IOS      NUMBER(1)                DEFAULT 0                     NOT NULL,
  APP_VISIBLE_ANDROID  NUMBER(1)                DEFAULT 0                     NOT NULL,
  APP_VISIBLE_WP       NUMBER(1)                DEFAULT 0,
  APP_VISIBLE_WS       NUMBER(1)                DEFAULT 0
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_CONFIG_URL
(
  MID                   NUMBER(10)              NOT NULL,
  MID_MODULO            NUMBER(10),
  COD                   VARCHAR2(50 CHAR),
  DESCRIPTION           VARCHAR2(255 CHAR),
  DES_URL               VARCHAR2(255 CHAR),
  FLG_AUTH              NUMBER(1)               DEFAULT 0,
  CDA_TYPE              VARCHAR2(3 CHAR),
  VALUE_STRING_IOS      VARCHAR2(4000 CHAR),
  VALUE_STRING_ANDROID  VARCHAR2(4000 CHAR),
  VALUE_STRING_WP       VARCHAR2(4000 CHAR),
  VALUE_STRING_WS       VARCHAR2(4000 CHAR),
  FLG_PUB               NUMBER(1)               DEFAULT 1,
  FLG_STU               NUMBER(1)               DEFAULT 1,
  FLG_DOC               NUMBER(1)               DEFAULT 1,
  FLG_PTA               NUMBER(1)               DEFAULT 1,
  FLG_ATT_IOS           NUMBER(1),
  FLG_ATT_ANDROID       NUMBER(1),
  FLG_ATT_WP            NUMBER(1),
  FLG_ATT_WS            NUMBER(1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_ESECUZIONE_COMANDI
(
  MID          NUMBER(10)                       NOT NULL,
  DES_COMANDO  VARCHAR2(2000 CHAR)              NOT NULL,
  DES_NOTE     VARCHAR2(2000 CHAR),
  FLG_CONFIG   NUMBER(9)                        DEFAULT 0                     NOT NULL,
  FLG_MODULI   NUMBER(9)                        DEFAULT 0                     NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_MODULI
(
  MID               NUMBER(10)                  NOT NULL,
  COD               VARCHAR2(50 CHAR),
  DESCRIPTION       VARCHAR2(255 CHAR),
  FLG_ATT_IOS       NUMBER(1),
  FLG_ATT_ANDROID   NUMBER(1),
  FLG_ACC_UTE_BLOC  NUMBER(1),
  CDN_ORDIN         NUMBER(3)                   DEFAULT 0,
  FLG_ATT_TABLET    NUMBER(1)                   DEFAULT 1,
  FLG_ATT_PHONE     NUMBER(1)                   DEFAULT 1,
  FLG_PUB           NUMBER(1)                   DEFAULT 1,
  FLG_STU           NUMBER(1)                   DEFAULT 1,
  FLG_DOC           NUMBER(1)                   DEFAULT 1,
  FLG_PTA           NUMBER(1)                   DEFAULT 1,
  FLG_ATT_WP        NUMBER(1),
  FLG_ATT_WS        NUMBER(1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_MODULI_BK
(
  MID               NUMBER(10)                  NOT NULL,
  COD               VARCHAR2(50 CHAR),
  DESCRIPTION       VARCHAR2(255 CHAR),
  FLG_ATT_IOS       NUMBER(1),
  FLG_ATT_ANDROID   NUMBER(1),
  FLG_ACC_UTE_BLOC  NUMBER(1),
  CDN_ORDIN         NUMBER(3),
  FLG_ATT_TABLET    NUMBER(1),
  FLG_ATT_PHONE     NUMBER(1),
  FLG_PUB           NUMBER(1),
  FLG_STU           NUMBER(1),
  FLG_DOC           NUMBER(1),
  FLG_PTA           NUMBER(1),
  FLG_ATT_WP        NUMBER(1),
  FLG_ATT_WS        NUMBER(1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_UTENTI
(
  MID                NUMBER(10)                 NOT NULL,
  CDA_USER           VARCHAR2(10 CHAR)          NOT NULL,
  CDA_PASSW          VARCHAR2(10 CHAR)          NOT NULL,
  CDA_REENTER_PASSW  VARCHAR2(10 CHAR)          NOT NULL,
  IND_RUOLO          NUMBER(1)                  NOT NULL,
  DAT_SCAD_PASSW     DATE,
  FLG_ATTIVO         CHAR(1 CHAR)               DEFAULT 'S'                   NOT NULL,
  DES_NOME           VARCHAR2(30 CHAR),
  DES_COGNOME        VARCHAR2(30 CHAR),
  IND_SESSO          VARCHAR2(2 CHAR),
  DAT_NASCITA        DATE,
  CDA_COD_FISC       CHAR(16 CHAR),
  DES_INDIR          VARCHAR2(50 CHAR),
  DES_RECAPITO       VARCHAR2(20 CHAR),
  DES_EMAIL          VARCHAR2(30 CHAR)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE FRW_UTENTI_TOKEN
(
  MID        NUMBER(9),
  USER_ID    VARCHAR2(20 CHAR),
  DES_TOKEN  VARCHAR2(255 CHAR),
  DES_HASH   VARCHAR2(255 CHAR),
  DATA_SCAD  DATE,
  DATA_INS   DATE,
  DATA_MOD   DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD
(
  MID               NUMBER(10),
  PERCORSO          VARCHAR2(255 CHAR),
  ATTIVITA          VARCHAR2(255 CHAR),
  DESCRIZIONE       VARCHAR2(4000 CHAR),
  METODI_DID_DES    CLOB,
  OBIETT_FORM_DES   CLOB,
  PREREQUISITI_DES  CLOB,
  CONTENUTI_DES     CLOB,
  TESTI_RIF_DES     CLOB,
  MOD_VER_APPR_DES  CLOB,
  ALTRE_INFO_DES    CLOB,
  PESO              VARCHAR2(255 CHAR),
  STRUTTURA_CFU     CLOB,
  CDS_ID            NUMBER(10),
  AD_ID             NUMBER(10),
  AA_OFF_ID         NUMBER(10),
  AA_ORD_ID         NUMBER(10),
  PDS_ID            NUMBER(10),
  EXT_ID            NUMBER(10)
)
LOB (TESTI_RIF_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONTENUTI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (PREREQUISITI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (STRUTTURA_CFU) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (METODI_DID_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ALTRE_INFO_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (MOD_VER_APPR_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (OBIETT_FORM_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_CLA
(
  MID                NUMBER(10),
  MID_AD             NUMBER(10),
  PERCORSO           VARCHAR2(255 CHAR),
  ATTIVITA           VARCHAR2(255 CHAR),
  CLASSE             VARCHAR2(255 CHAR),
  DESCRIZIONE        VARCHAR2(4000 CHAR),
  INFO_SEM_CLASSE    VARCHAR2(4000 CHAR),
  INFO_AULE_EDIFICI  VARCHAR2(4000 CHAR),
  CDS_ID             NUMBER(10),
  AD_ID              NUMBER(10),
  AA_OFF_ID          NUMBER(10),
  AA_ORD_ID          NUMBER(10),
  PDS_ID             NUMBER(10),
  DOM_PART_COD       VARCHAR2(10 CHAR),
  COD_CORSO          VARCHAR2(10 CHAR),
  COD_PERCORSO       VARCHAR2(10 CHAR),
  COD_AD             VARCHAR2(10 CHAR),
  FAT_PART_COD       VARCHAR2(10 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_CLA_DOC
(
  MID                 NUMBER(10),
  MID_AD_CLA          NUMBER(10),
  MID_DOC             NUMBER(10),
  PERCORSO            VARCHAR2(255 CHAR),
  ATTIVITA            VARCHAR2(255 CHAR),
  CLASSE              VARCHAR2(255 CHAR),
  DOCENTE             VARCHAR2(255 CHAR),
  COD_MATR_DOC        VARCHAR2(10 CHAR),
  TITOLARE            NUMBER(1),
  NOMINATIVO_DOCENTE  VARCHAR2(255 CHAR),
  CDS_ID              NUMBER(10),
  AD_ID               NUMBER(10),
  AA_OFF_ID           NUMBER(10),
  AA_ORD_ID           NUMBER(10),
  PDS_ID              NUMBER(10),
  DOM_PART_COD        VARCHAR2(10 CHAR),
  DOCENTE_ID          NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_CLA_DOC_LN
(
  MID                 NUMBER(10),
  LN_CODE             VARCHAR2(10 CHAR),
  PERCORSO            VARCHAR2(255 CHAR),
  ATTIVITA            VARCHAR2(255 CHAR),
  CLASSE              VARCHAR2(255 CHAR),
  DOCENTE             VARCHAR2(255 CHAR),
  NOMINATIVO_DOCENTE  VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_CLA_LN
(
  MID                NUMBER(10),
  LN_CODE            VARCHAR2(10 CHAR),
  PERCORSO           VARCHAR2(255 CHAR),
  ATTIVITA           VARCHAR2(255 CHAR),
  CLASSE             VARCHAR2(255 CHAR),
  DESCRIZIONE        VARCHAR2(4000 CHAR),
  INFO_SEM_CLASSE    VARCHAR2(4000 CHAR),
  INFO_AULE_EDIFICI  VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_DOC
(
  MID                 NUMBER(10),
  MID_DOC             NUMBER(10),
  MID_AD              NUMBER(10),
  PERCORSO            VARCHAR2(255 CHAR),
  ATTIVITA            VARCHAR2(255 CHAR),
  DOCENTE             VARCHAR2(255 CHAR),
  COD_MATR_DOC        VARCHAR2(10 CHAR),
  TITOLARE            NUMBER(1),
  NOMINATIVO_DOCENTE  VARCHAR2(255 CHAR),
  CDS_ID              NUMBER(10),
  AD_ID               NUMBER(10),
  AA_OFF_ID           NUMBER(10),
  AA_ORD_ID           NUMBER(10),
  PDS_ID              NUMBER(10),
  DOCENTE_ID          NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_DOC_LN
(
  MID       NUMBER(10),
  LN_CODE   VARCHAR2(10 CHAR),
  PERCORSO  VARCHAR2(255 CHAR),
  ATTIVITA  VARCHAR2(255 CHAR),
  DOCENTE   VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_LN
(
  MID               NUMBER(10),
  LN_CODE           VARCHAR2(10 CHAR),
  PERCORSO          VARCHAR2(255 CHAR),
  ATTIVITA          VARCHAR2(255 CHAR),
  DESCRIZIONE       VARCHAR2(4000 CHAR),
  METODI_DID_DES    CLOB,
  OBIETT_FORM_DES   CLOB,
  PREREQUISITI_DES  CLOB,
  CONTENUTI_DES     CLOB,
  TESTI_RIF_DES     CLOB,
  MOD_VER_APPR_DES  CLOB,
  ALTRE_INFO_DES    CLOB,
  STRUTTURA_CFU     CLOB
)
LOB (ALTRE_INFO_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (MOD_VER_APPR_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TESTI_RIF_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONTENUTI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (PREREQUISITI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (OBIETT_FORM_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (METODI_DID_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (STRUTTURA_CFU) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_MOD
(
  MID                NUMBER(10),
  MID_AD             NUMBER(10),
  PERCORSO           VARCHAR2(255 CHAR),
  ATTIVITA           VARCHAR2(255 CHAR),
  MODULO             VARCHAR2(255 CHAR),
  DESCRIZIONE        VARCHAR2(4000 CHAR),
  METODI_DID_DES     CLOB,
  OBIETT_FORM_DES    CLOB,
  PREREQUISITI_DES   CLOB,
  CONTENUTI_DES      CLOB,
  TESTI_RIF_DES      CLOB,
  MOD_VER_APPR_DES   CLOB,
  ALTRE_INFO_DES     CLOB,
  PESO               VARCHAR2(255 CHAR),
  STRUTTURA_CFU      VARCHAR2(4000 CHAR),
  INFO_SEM_CLASSE    VARCHAR2(4000 CHAR),
  INFO_AULE_EDIFICI  VARCHAR2(4000 CHAR),
  CDS_ID             NUMBER(10),
  AD_ID              NUMBER(10),
  AA_OFF_ID          NUMBER(10),
  AA_ORD_ID          NUMBER(10),
  PDS_ID             NUMBER(10),
  UD_ID              NUMBER(10),
  COD_CORSO          VARCHAR2(10 CHAR),
  COD_PERCORSO       VARCHAR2(10 CHAR),
  COD_AD             VARCHAR2(10 CHAR),
  COD_MOD            VARCHAR2(20 CHAR)
)
LOB (METODI_DID_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (OBIETT_FORM_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (PREREQUISITI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONTENUTI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TESTI_RIF_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (MOD_VER_APPR_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ALTRE_INFO_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_MOD_DOC
(
  MID                 NUMBER(10),
  MID_AD_MOD          NUMBER(10),
  MID_DOC             NUMBER(10),
  PERCORSO            VARCHAR2(255 CHAR),
  ATTIVITA            VARCHAR2(255 CHAR),
  MODULO              VARCHAR2(255 CHAR),
  DOCENTE             VARCHAR2(255 CHAR),
  COD_MATR_DOC        VARCHAR2(10 CHAR),
  TITOLARE            NUMBER(1),
  NOMINATIVO_DOCENTE  VARCHAR2(255 CHAR),
  CDS_ID              NUMBER(10),
  AD_ID               NUMBER(10),
  AA_OFF_ID           NUMBER(10),
  AA_ORD_ID           NUMBER(10),
  PDS_ID              NUMBER(10),
  UD_ID               NUMBER(10),
  DOCENTE_ID          NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_MOD_DOC_LN
(
  MID                 NUMBER(10),
  LN_CODE             VARCHAR2(10 CHAR),
  PERCORSO            VARCHAR2(255 CHAR),
  MODULO              VARCHAR2(255 CHAR),
  DOCENTE             VARCHAR2(255 CHAR),
  NOMINATIVO_DOCENTE  VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_AD_MOD_LN
(
  MID                NUMBER(10),
  LN_CODE            VARCHAR2(10 CHAR),
  PERCORSO           VARCHAR2(255 CHAR),
  ATTIVITA           VARCHAR2(255 CHAR),
  MODULO             VARCHAR2(255 CHAR),
  DESCRIZIONE        VARCHAR2(4000 CHAR),
  METODI_DID_DES     CLOB,
  OBIETT_FORM_DES    CLOB,
  PREREQUISITI_DES   CLOB,
  CONTENUTI_DES      CLOB,
  TESTI_RIF_DES      CLOB,
  MOD_VER_APPR_DES   CLOB,
  ALTRE_INFO_DES     CLOB,
  STRUTTURA_CFU      VARCHAR2(4000 CHAR),
  INFO_SEM_CLASSE    VARCHAR2(4000 CHAR),
  INFO_AULE_EDIFICI  VARCHAR2(4000 CHAR)
)
LOB (METODI_DID_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (OBIETT_FORM_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ALTRE_INFO_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (MOD_VER_APPR_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (PREREQUISITI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONTENUTI_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TESTI_RIF_DES) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_CERCA
(
  MID             NUMBER(10),
  MID_AD          NUMBER(10),
  AA_OFF_ID       NUMBER(4),
  COD             VARCHAR2(10 CHAR)             NOT NULL,
  DES_AD          VARCHAR2(255 CHAR)            NOT NULL,
  TIPO_CORSO_COD  VARCHAR2(10 CHAR)             NOT NULL,
  DES_LUNGUA_DID  VARCHAR2(40 CHAR),
  SETT_COD        VARCHAR2(12 CHAR)             NOT NULL,
  ACR             VARCHAR2(20 CHAR),
  DES_PART        VARCHAR2(40 CHAR),
  TIPO_INS_COD    VARCHAR2(10 CHAR),
  TITOLARE        VARCHAR2(101 CHAR)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_CERCA_SEL
(
  MID          NUMBER(10),
  COD_SEZIONE  VARCHAR2(10 CHAR),
  DES_SEZIONE  VARCHAR2(40 CHAR),
  COD_CAMPO    VARCHAR2(10 CHAR),
  DES_CAMPO    VARCHAR2(40 CHAR),
  TIPO_CAMPO   NUMBER(2),
  MID_PADRE    NUMBER(10),
  VAL_DEFAULT  VARCHAR2(255 CHAR),
  ORDER_SEZ    NUMBER(3),
  ORDER_CAM    NUMBER(3)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_CERCA_VAL
(
  MID        NUMBER,
  LN_CODE    VARCHAR2(10 CHAR),
  MID_CAMPO  NUMBER(10),
  AA_OFF_ID  NUMBER(4),
  TITOLO     VARCHAR2(40 CHAR),
  VAL        VARCHAR2(40 CHAR),
  VAL_PADRE  VARCHAR2(10 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_IUNI
(
  MID_PK              NUMBER,
  MID_LIV_1           NUMBER,
  MID_LIV_2           NUMBER,
  MID_LIV_3           NUMBER,
  MID_LIV_4           NUMBER,
  MID_AD              NUMBER,
  MID_AD_CLA          NUMBER,
  MID_AD_DOC          NUMBER,
  MID_AD_MOD          NUMBER,
  MID_AD_MOD_DOC      NUMBER,
  MID_AD_CLA_DOC      NUMBER,
  AA_OFF_ID           NUMBER(10),
  FAC_ID              NUMBER(10),
  CDS_ID              NUMBER(10),
  AD_ID               NUMBER(10),
  AA_ORD_ID           NUMBER(10),
  PDS_ID              NUMBER(10),
  UD_ID               NUMBER(10),
  SEG_ID              NUMBER(10),
  TIPO_CORSO_COD      VARCHAR2(10 CHAR),
  COD_FAC             VARCHAR2(10 CHAR),
  DES_FAC             VARCHAR2(4000 CHAR),
  COD_CDS             VARCHAR2(10 CHAR),
  DES_CDS             VARCHAR2(4000 CHAR),
  COD_PDS             VARCHAR2(10 CHAR),
  DES_PDS             VARCHAR2(4000 CHAR),
  COD_AD              VARCHAR2(10 CHAR),
  DES_AD              VARCHAR2(4000 CHAR),
  COD_MOD             VARCHAR2(20 CHAR),
  DES_MOD             VARCHAR2(4000 CHAR),
  TIPO_INS_COD        VARCHAR2(10 CHAR),
  DUR_UNI_VAL         NUMBER(5,2),
  DUR_STU_IND         NUMBER(5,2),
  PESO_TOT            NUMBER(5,2),
  PESO_DET            NUMBER(5,2),
  TIPO_AF_COD         VARCHAR2(10 CHAR),
  DES_TAF             VARCHAR2(80 CHAR),
  AMB_ID              NUMBER(10),
  DES_AMB             VARCHAR2(255 CHAR),
  SETT_COD            VARCHAR2(12 CHAR),
  DOCENTE_ID          NUMBER(10),
  TIPO_COPERTURA_COD  VARCHAR2(5 CHAR),
  FAT_PART_COD        VARCHAR2(10 CHAR),
  DOM_PART_COD        VARCHAR2(10 CHAR),
  TITOLARE_FLG        NUMBER(1),
  PART_COD            VARCHAR2(5 CHAR),
  DES_PART            VARCHAR2(40 CHAR),
  TIPO_DID_COD        VARCHAR2(10 CHAR),
  DES_TIPI_DID        VARCHAR2(255 CHAR),
  LINGUA_DID_ID       NUMBER,
  DES_LUNGUA_DID      VARCHAR2(40 CHAR),
  SEDE_DES            VARCHAR2(255 CHAR),
  MATRICOLA_TITOLARE  VARCHAR2(6 CHAR),
  AF_ID               NUMBER(10),
  AF_RADICE_ID        NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_LIV
(
  MID            NUMBER(10),
  CODE           VARCHAR2(20 CHAR),
  NAME           VARCHAR2(255 CHAR),
  DESCRIPTION    VARCHAR2(4000 CHAR),
  MID_LIV_PADRE  NUMBER(10),
  MID_DETT       NUMBER(10),
  AA_ID          NUMBER(10)                     NOT NULL,
  ORDINE         NUMBER(9)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE GOL_LIV_LN
(
  MID          NUMBER(10),
  LN_CODE      VARCHAR2(10 CHAR),
  NAME         VARCHAR2(255 CHAR),
  DESCRIPTION  VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE JAVA$OPTIONS
(
  WHAT   VARCHAR2(128 CHAR),
  OPT    VARCHAR2(20 CHAR),
  VALUE  VARCHAR2(128 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE K_ESITO_FIX
(
  MODULO      VARCHAR2(30 CHAR),
  VERSIONE    VARCHAR2(20 CHAR),
  DATA_APPL   VARCHAR2(50 CHAR),
  FNAME       VARCHAR2(255 CHAR),
  ESITO       VARCHAR2(4000 CHAR),
  N_ERRORI    NUMBER(10),
  VALIDA_FLG  NUMBER(1)                         DEFAULT 1                     NOT NULL,
  DURATION    NUMBER(9)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LIB_STUDENTE
(
  MID            NUMBER(10)                     NOT NULL,
  STU_ID         NUMBER(10),
  COD_AD         VARCHAR2(20 CHAR),
  DES_AD         VARCHAR2(4000 CHAR),
  ANNO_CORSO     NUMBER(3),
  DES_ANNO       VARCHAR2(255 CHAR),
  PESO           NUMBER(5,2),
  DES_PESO       VARCHAR2(255 CHAR),
  COD_TIPO_INS   VARCHAR2(10 CHAR),
  DES_TIPO_INS   VARCHAR2(255 CHAR),
  COD_STATO      VARCHAR2(5 CHAR),
  DES_STATO      VARCHAR2(255 CHAR),
  VOTO           NUMBER(5,2),
  LODE_FLG       NUMBER(1),
  TIPO_GIUD_COD  VARCHAR2(5 CHAR),
  DES_VOTO       VARCHAR2(255 CHAR),
  DATA_SUP       DATE,
  AA_SUP_ID      NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LIB_STUDENTE_CRUSC
(
  MID               NUMBER(10),
  PERS_ID           NUMBER(10),
  STU_ID            NUMBER(10),
  MATRICOLA         VARCHAR2(20 CHAR),
  TIPO_MEDIA_COD    VARCHAR2(10 CHAR),
  NUM_ESAMI         NUMBER,
  MEDIA_ACCADEMICA  NUMBER,
  CFU_MATURATI      NUMBER,
  NUM_AD_PIANIF     NUMBER,
  CFU_AD_PIANIF     NUMBER,
  NUM_ESA_SUP       NUMBER,
  NUM_ESA_NO_SUP    NUMBER,
  CFU_PIANO         NUMBER,
  DATA_INS          DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LIB_STUDENTE_LN
(
  MID           NUMBER(10)                      NOT NULL,
  LN_CODE       VARCHAR2(10 CHAR)               NOT NULL,
  DES_AD        VARCHAR2(4000 CHAR),
  DES_PESO      VARCHAR2(255 CHAR),
  DES_ANNO      VARCHAR2(255 CHAR),
  DES_TIPO_INS  VARCHAR2(255 CHAR),
  DES_STATO     VARCHAR2(255 CHAR),
  DES_VOTO      VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LNK_LINK_COPY
(
  MID          NUMBER(10)                       NOT NULL,
  TITLE        VARCHAR2(255 CHAR),
  DESCRIPTION  VARCHAR2(1000 CHAR),
  URL          VARCHAR2(255 CHAR),
  NAME_PHOTO   NUMBER(20),
  URL_PHOTO    VARCHAR2(1000 CHAR),
  PROFILE      NUMBER(10),
  LN_CODE      VARCHAR2(10 CHAR),
  ORDINAMENTO  NUMBER(10),
  FLG_AUTH     NUMBER(1),
  MID_PADRE    NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LOCAL_GRANTS
(
  ID            NUMBER(10)                      NOT NULL,
  PROD_GRANTEE  VARCHAR2(15 CHAR),
  WHAT          VARCHAR2(30 CHAR)               NOT NULL,
  GRANT_PRIVS   VARCHAR2(255 CHAR)              NOT NULL,
  GRANT_OPTION  NUMBER(1)                       NOT NULL,
  ID_APP_CLI    NUMBER(10),
  POST_SCRIPT   VARCHAR2(255 CHAR),
  REVOKE_FLG    NUMBER(1)                       NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE LOCAL_PROD_LINK_STATUS
(
  PROD                  VARCHAR2(15 CHAR)       NOT NULL,
  LINKED_PROD           VARCHAR2(15 CHAR)       NOT NULL,
  SYSTEM_STATUS         NUMBER(1)               NOT NULL,
  USER_STATUS           NUMBER(1)               NOT NULL,
  OVERRIDE_USER_STATUS  NUMBER(1)               NOT NULL,
  CURRENT_STATUS        NUMBER(1),
  SAVED_STATUS          NUMBER(1),
  LAST_REFRESH          DATE,
  PRIORITY              NUMBER(2)               NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE MSG_MESSAGE
(
  MID             NUMBER(10),
  FLG_CANC        VARCHAR2(1 CHAR),
  DATA_INS        DATE,
  DATA_MOD        DATE,
  DATA_ELI        DATE,
  DATA_DA         DATE,
  DATA_A          DATE,
  DATA_PR_LET     DATE,
  DATA_UL_LET     DATE,
  NUM_VISIBILITA  INTEGER,
  NUM_LETTURE     INTEGER,
  USER_ID         VARCHAR2(20 CHAR),
  PERS_ID         NUMBER(10),
  STU_ID          NUMBER(10),
  COM_ID          NUMBER(10),
  RAG_ID          NUMBER(10),
  IMP_ID          NUMBER(10),
  DES_FONTE       VARCHAR2(20 CHAR),
  FLG_PRIMO       VARCHAR2(1 CHAR),
  FLG_PREFERITI   VARCHAR2(1 CHAR),
  FLG_APERTO      VARCHAR2(1 CHAR),
  FLG_EMAIL       VARCHAR2(1 CHAR),
  FLG_SMS         VARCHAR2(1 CHAR),
  FLG_PUSH        VARCHAR2(1 CHAR),
  CODICE          VARCHAR2(5 CHAR),
  DATA_PROVA      DATE,
  DES_AULA        VARCHAR2(60 CHAR),
  DES_GESTORE     VARCHAR2(60 CHAR),
  CAT_ID          NUMBER(10),
  FLG_READ        NUMBER(1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE MSG_MESSAGE_LN
(
  MID            NUMBER(10),
  LN_CODE        VARCHAR2(10 CHAR),
  DES_CATEGORIA  VARCHAR2(150 CHAR),
  DES_TITOLO     VARCHAR2(300 CHAR),
  DES_SMS        VARCHAR2(340 CHAR),
  DES_PUSH       VARCHAR2(340 CHAR),
  DES_TESTO      CLOB
)
LOB (DES_TESTO) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE MV_API_EV_EVENTS
(
  MID          NUMBER(10),
  LANG         VARCHAR2(10 CHAR),
  TODAY        NUMBER,
  USER_ID      VARCHAR2(20 CHAR),
  DATA         DATE,
  DATA_STRING  VARCHAR2(4000 CHAR),
  ICONS        VARCHAR2(250 CHAR),
  TITLE        VARCHAR2(4000 CHAR),
  DESCRIPTION  VARCHAR2(4000 CHAR),
  DETAIL       VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_ESAMI
(
  MID                   NUMBER(10),
  COD_APP               VARCHAR2(255 CHAR),
  COD_AD                VARCHAR2(20 CHAR),
  COD_CDS               VARCHAR2(20 CHAR),
  DES_APPELLO           VARCHAR2(4000 BYTE),
  DATA_ESAME            DATE,
  DATA_FINE_ISCRIZIONE  DATE,
  TIPO_ESAME            VARCHAR2(20 CHAR),
  DES_ESAME             VARCHAR2(80 CHAR),
  TIPO_PROVA            VARCHAR2(20 CHAR),
  DES_PROVA             VARCHAR2(80 CHAR),
  NUMERO_ISCRITTI       NUMBER(10),
  EXT_PRG               VARCHAR2(80 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_ESAMI_LN
(
  MID          NUMBER(10),
  LN_CODE      VARCHAR2(10 CHAR),
  DES_APPELLO  VARCHAR2(4000 BYTE),
  DES_ESAME    VARCHAR2(80 CHAR),
  DES_PROVA    VARCHAR2(80 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_ESAMI_USER
(
  MID        NUMBER(10),
  MID_ESAME  NUMBER(10),
  USER_ID    NUMBER(10),
  STU_ID     NUMBER(10),
  DATA_INS   DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_LEZIONI
(
  MID            NUMBER(10),
  ANNO_ACC       NUMBER(4),
  CDA_AD         VARCHAR2(20 CHAR),
  CDA_CLASSE     VARCHAR2(20 CHAR),
  CDA_GRUPPO     VARCHAR2(20 CHAR),
  DATA_INIZIO    DATE,
  DATA_FINE      DATE,
  DES_AD         VARCHAR2(4000 BYTE),
  DES_EVENTO     VARCHAR2(4000 BYTE),
  DES_NOTA_IMP   VARCHAR2(4000 BYTE),
  DES_NOTA_EVE   VARCHAR2(4000 BYTE),
  COD_TIPO_ATT   VARCHAR2(20 CHAR),
  DES_TIPO_ATT   VARCHAR2(4000 BYTE),
  DES_CORSI      VARCHAR2(4000 BYTE),
  DES_PATIZ      VARCHAR2(4000 BYTE),
  DES_DOC_RESP   VARCHAR2(4000 BYTE),
  DES_DOCENTI    VARCHAR2(4000 BYTE),
  DES_AULE       VARCHAR2(4000 BYTE),
  LINGUA_CLASSE  VARCHAR2(4000 BYTE),
  LINGUA_INSEGN  VARCHAR2(4000 BYTE),
  EXT_PRG        NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_LEZIONI_LN
(
  MID            NUMBER(10),
  LN_CODE        VARCHAR2(10 CHAR),
  DES_AD         VARCHAR2(4000 BYTE),
  DES_EVENTO     VARCHAR2(4000 BYTE),
  DES_NOTA_IMP   VARCHAR2(4000 BYTE),
  DES_NOTA_EVE   VARCHAR2(4000 BYTE),
  DES_TIPO_ATT   VARCHAR2(4000 BYTE),
  DES_CORSI      VARCHAR2(4000 BYTE),
  DES_PATIZ      VARCHAR2(4000 BYTE),
  DES_DOC_RESP   VARCHAR2(4000 BYTE),
  DES_DOCENTI    VARCHAR2(4000 BYTE),
  DES_AULE       VARCHAR2(4000 BYTE),
  LINGUA_CLASSE  VARCHAR2(4000 BYTE),
  LINGUA_INSEGN  VARCHAR2(4000 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE ORI_LEZIONI_USER
(
  MID          NUMBER(10),
  MID_LEZIONE  NUMBER(10),
  USER_ID      NUMBER(10),
  STU_ID       NUMBER(10),
  DATA_INS     DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE PHO_PHOTO
(
  MID          NUMBER(10)                       NOT NULL,
  DESCRIPTION  VARCHAR2(255 CHAR),
  TIPO         NUMBER(3),
  TITLE        VARCHAR2(255 CHAR),
  COD          VARCHAR2(255 CHAR),
  IS_DEFAULT   INTEGER                          DEFAULT 0                     NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE "schema_version"
(
  "version_rank"    INTEGER,
  "installed_rank"  INTEGER,
  "version"         VARCHAR2(50 CHAR),
  "description"     VARCHAR2(200 CHAR),
  "type"            VARCHAR2(20 CHAR),
  "script"          VARCHAR2(1000 CHAR),
  "checksum"        INTEGER,
  "installed_by"    VARCHAR2(100 CHAR),
  "installed_on"    TIMESTAMP(6)                DEFAULT CURRENT_TIMESTAMP,
  "execution_time"  INTEGER,
  "success"         NUMBER(1)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE SRV_SERVICES
(
  MID          NUMBER(10)                       NOT NULL,
  ATTRIBUTE    VARCHAR2(80 CHAR),
  FIRSTNAME    VARCHAR2(50 CHAR),
  LASTNAME     VARCHAR2(50 CHAR),
  DESCRIPTION  VARCHAR2(255 CHAR),
  ADDRESS      VARCHAR2(255 CHAR),
  EMAIL        VARCHAR2(255 CHAR),
  TEL          VARCHAR2(20 CHAR),
  FAX          VARCHAR2(20 CHAR),
  CELL         VARCHAR2(20 CHAR),
  URL          VARCHAR2(255 CHAR),
  HOURS        VARCHAR2(1000 CHAR),
  NOTE1        VARCHAR2(1000 CHAR),
  NOTE2        VARCHAR2(1000 CHAR),
  NOTE3        VARCHAR2(1000 CHAR),
  TAG_SRV      VARCHAR2(255 CHAR),
  TYPE_SRV     NUMBER(3),
  PROFILE      NUMBER(10),
  ANA_ID       NUMBER(10),
  TYPE         VARCHAR2(40 CHAR),
  LAT          NUMBER(10,7),
  LON          NUMBER(10,7),
  TYPE_SOURCE  NUMBER(2)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SRV_SERVICES.ATTRIBUTE IS 'Dott.
Dott.sa
Prof.';

COMMENT ON COLUMN SRV_SERVICES.DESCRIPTION IS 'Facoltà di Ingegneria
Ufficio Tasse';

COMMENT ON COLUMN SRV_SERVICES.HOURS IS 'Monday 14.00 - 16.00';

COMMENT ON COLUMN SRV_SERVICES.TYPE_SRV IS '1 - rubrica
2 - strutture';


CREATE TABLE SRV_SERVICES_LN
(
  MID          NUMBER(10)                       NOT NULL,
  LN_CODE      VARCHAR2(10 CHAR)                NOT NULL,
  ATTRIBUTE    VARCHAR2(80 CHAR),
  DESCRIPTION  VARCHAR2(255 CHAR),
  HOURS        VARCHAR2(1000 CHAR),
  NOTE1        VARCHAR2(1000 CHAR),
  NOTE2        VARCHAR2(1000 CHAR),
  NOTE3        VARCHAR2(1000 CHAR),
  TAG_SRV      VARCHAR2(255 CHAR),
  TYPE_SOURCE  NUMBER(2)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_AA
(
  MID          NUMBER(10)                       NOT NULL,
  AA_ID        NUMBER(10)                       NOT NULL,
  DATA_INIZIO  DATE,
  DATA_FINE    DATE,
  DES          VARCHAR2(80 CHAR),
  FLG_ATTIVO   NUMBER(1)                        DEFAULT 0
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAB_CHA_CHANNEL
(
  MID          NUMBER(10)                       NOT NULL,
  DESCRIPTION  VARCHAR2(255 CHAR),
  TIPO         NUMBER(3),
  TITLE        VARCHAR2(255 CHAR),
  COD          VARCHAR2(255 CHAR),
  IS_DEFAULT   INTEGER                          DEFAULT 0                     NOT NULL,
  ORDINAMENTO  NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN TAB_CHA_CHANNEL.TIPO IS '1 - Youtube Canale
2 - Youtube Playlist
3 - Youtube Favorites
3 - Vimeo';

COMMENT ON COLUMN TAB_CHA_CHANNEL.COD IS '1 - Flickr
2 - Picasa';


CREATE TABLE TABELLA_LOG
(
  ID         NUMBER(10),
  TESTO      VARCHAR2(4000 CHAR),
  ORA1       DATE,
  ORA2       DATE,
  DURATA     VARCHAR2(255 CHAR),
  HOST_NAME  VARCHAR2(1000 CHAR),
  DB_NAME    VARCHAR2(1000 CHAR),
  OPTIMIZER  VARCHAR2(512 CHAR),
  NOTE       VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAB_EV_DETAIL
(
  MID                  VARCHAR2(50 CHAR),
  LANG                 VARCHAR2(10 CHAR),
  TITLE                VARCHAR2(500 CHAR),
  SPEAKER              VARCHAR2(500 CHAR),
  PAGAMENTO            VARCHAR2(300 CHAR),
  LOCATION             VARCHAR2(500 CHAR),
  DATA_STRING          VARCHAR2(100 CHAR),
  ICONS                VARCHAR2(500 CHAR),
  ACTION_DATA_TO       DATE,
  ACTION_DATA_FROM     DATE,
  ACTION_LOC_LAT       NUMBER(10,7),
  ACTION_LOC_LON       NUMBER(10,7),
  ACTION_URL           VARCHAR2(1000 CHAR),
  ACTION_ATTACHMENT    VARCHAR2(1000 CHAR),
  ACTION_SUBSCRIPTION  VARCHAR2(1000 CHAR),
  TESTO                CLOB
)
LOB (TESTO) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAB_EV_EVENTS
(
  MID          VARCHAR2(50 CHAR),
  LANG         VARCHAR2(10 CHAR),
  TODAY        NUMBER,
  USER_ID      VARCHAR2(50 CHAR),
  DATA         DATE,
  DATA_STRING  VARCHAR2(100 CHAR),
  ICONS        VARCHAR2(500 CHAR),
  TITLE        VARCHAR2(500 CHAR),
  DESCRIPTION  VARCHAR2(4000 CHAR),
  DETAIL       VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAB_FEE_FEED
(
  MID            NUMBER(10)                     NOT NULL,
  TITLE          VARCHAR2(255 CHAR),
  DESCRIPTION    VARCHAR2(1000 CHAR),
  URL            VARCHAR2(3000 CHAR),
  ORDINAMENTO    NUMBER(10),
  MID_PADRE      NUMBER(10),
  MID_TIPO_FEED  NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAB_LNK_LINK
(
  MID          NUMBER(10)                       NOT NULL,
  TITLE        VARCHAR2(255 CHAR),
  DESCRIPTION  VARCHAR2(1000 CHAR),
  URL          VARCHAR2(255 CHAR),
  NAME_PHOTO   NUMBER(20),
  URL_PHOTO    VARCHAR2(1000 CHAR),
  PROFILE      NUMBER(10),
  LN_CODE      VARCHAR2(10 CHAR),
  ORDINAMENTO  NUMBER(10),
  FLG_AUTH     NUMBER(1),
  MID_PADRE    NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_AGE_AZIONI
(
  MID      NUMBER(10),
  LN_CODE  VARCHAR2(10 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_AULE
(
  CDA_RIS_FISSA  VARCHAR2(40 CHAR)              NOT NULL,
  DES_RISORSA    VARCHAR2(2000 CHAR),
  DESCRIZIONE    VARCHAR2(519 CHAR),
  DES_INDIRIZZO  VARCHAR2(255 CHAR)             NOT NULL,
  LAT            NUMBER(10,7),
  LON            NUMBER(10,7)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAX_SIT_ANNI
(
  MID          NUMBER,
  STU_ID       NUMBER(10)                       NOT NULL,
  AA_ISCR_ID   NUMBER(10)                       NOT NULL,
  TITOLO       VARCHAR2(400 CHAR),
  DESCRIZIONE  VARCHAR2(1000 CHAR),
  SEMAFORO     NUMBER,
  NOTE         VARCHAR2(4000 CHAR),
  DATA_INS     DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAX_SIT_ANNI_LN
(
  MID          NUMBER,
  LN_CODE      VARCHAR2(10 CHAR),
  TITOLO       VARCHAR2(400 CHAR),
  DESCRIZIONE  VARCHAR2(1000 CHAR),
  NOTE         VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAX_SIT_DETT
(
  MID         NUMBER,
  STU_ID      NUMBER(10)                        NOT NULL,
  AA_ISCR_ID  NUMBER(10)                        NOT NULL,
  FATT_ID     NUMBER(10),
  DES_GRUPPO  VARCHAR2(400 CHAR),
  DES_TASSA   VARCHAR2(400 CHAR),
  DES_VOCE    VARCHAR2(400 CHAR),
  DES_RATA    VARCHAR2(400 CHAR),
  IMPORTO     NUMBER(13,2),
  DAT_SCAD    DATE,
  DAT_PAG     DATE,
  DATA_INS    DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TAX_SIT_DETT_LN
(
  MID         NUMBER,
  LN_CODE     VARCHAR2(10 CHAR),
  DES_GRUPPO  VARCHAR2(400 CHAR),
  DES_TASSA   VARCHAR2(400 CHAR),
  DES_VOCE    VARCHAR2(400 CHAR),
  DES_RATA    VARCHAR2(400 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_DOCENTI
(
  MID                 NUMBER(10),
  SETT_COD            VARCHAR2(12 CHAR),
  MATRICOLA           VARCHAR2(10 CHAR),
  COGNOME             VARCHAR2(50 CHAR),
  NOME                VARCHAR2(50 CHAR),
  CELLULARE           VARCHAR2(20 CHAR),
  E_MAIL              VARCHAR2(255 CHAR),
  DES_APPELLATIVO     VARCHAR2(40 CHAR),
  DES_GRUPPO          VARCHAR2(4000 CHAR),
  DES_LUOGO           VARCHAR2(4000 CHAR),
  NOTE_BIOGRAFICHE    VARCHAR2(4000 CHAR),
  NOTE_PUBBLICAZIONI  VARCHAR2(4000 CHAR),
  NOTE_CURRICULUM     VARCHAR2(4000 CHAR),
  NOTE_DOCENTE        VARCHAR2(4000 CHAR),
  GIORNO              NUMBER(1),
  ORA_INIZIO          DATE,
  ORA_FINE            DATE,
  PRG_PERSONA         NUMBER(10),
  DOCENTE_ID          NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_GOL_AD_DESCRIZIONI
(
  MID               NUMBER(10),
  CDS_ID            NUMBER(10)                  NOT NULL,
  AD_ID             NUMBER(10)                  NOT NULL,
  AA_OFF_ID         NUMBER(10)                  NOT NULL,
  AA_ORD_ID         NUMBER(10)                  NOT NULL,
  PDS_ID            NUMBER(10)                  NOT NULL,
  FAT_PART_COD      VARCHAR2(10 CHAR)           NOT NULL,
  DOM_PART_COD      VARCHAR2(10 CHAR)           NOT NULL,
  PART_COD          VARCHAR2(5 CHAR)            NOT NULL,
  AD_LOG_ID         NUMBER(10)                  NOT NULL,
  METODI_DID_DES    VARCHAR2(4000 CHAR),
  OBIETT_FORM_DES   VARCHAR2(4000 CHAR),
  PREREQUISITI_DES  VARCHAR2(4000 CHAR),
  CONTENUTI_DES     VARCHAR2(4000 CHAR),
  TESTI_RIF_DES     VARCHAR2(4000 CHAR),
  MOD_VER_APPR_DES  VARCHAR2(4000 CHAR),
  ALTRE_INFO_DES    VARCHAR2(4000 CHAR),
  LN_CODE           VARCHAR2(5 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_GOL_AD_DESCRIZIONI_TUTTE
(
  MID               NUMBER(10),
  CDS_ID            NUMBER(10)                  NOT NULL,
  AD_ID             NUMBER(10)                  NOT NULL,
  AA_OFF_ID         NUMBER(10)                  NOT NULL,
  AA_ORD_ID         NUMBER(10)                  NOT NULL,
  PDS_ID            NUMBER(10)                  NOT NULL,
  FAT_PART_COD      VARCHAR2(10 CHAR)           NOT NULL,
  DOM_PART_COD      VARCHAR2(10 CHAR)           NOT NULL,
  PART_COD          VARCHAR2(5 CHAR)            NOT NULL,
  AD_LOG_ID         NUMBER(10)                  NOT NULL,
  METODI_DID_DES    VARCHAR2(4000 CHAR),
  OBIETT_FORM_DES   VARCHAR2(4000 CHAR),
  PREREQUISITI_DES  VARCHAR2(4000 CHAR),
  CONTENUTI_DES     VARCHAR2(4000 CHAR),
  TESTI_RIF_DES     VARCHAR2(4000 CHAR),
  MOD_VER_APPR_DES  VARCHAR2(4000 CHAR),
  ALTRE_INFO_DES    VARCHAR2(4000 CHAR),
  LN_CODE           VARCHAR2(5 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_LANGUAGE
(
  LN_CODE      VARCHAR2(10 CHAR)                NOT NULL,
  DESCRIPTION  VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_LOCATION
(
  MID           NUMBER(10)                      NOT NULL,
  DES_LOCATION  VARCHAR2(255 CHAR),
  LAT           NUMBER(10,7),
  LON           NUMBER(10,7)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_MESSAGE
(
  MID          NUMBER(10),
  LN_CODE      VARCHAR2(10 CHAR),
  TITOLO       VARCHAR2(255 CHAR),
  DESCRIZIONE  VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_NOTIFICHE
(
  MATRICOLA   VARCHAR2(20 CHAR),
  TESTO       VARCHAR2(2000 CHAR),
  TESTO_ITA   VARCHAR2(2000 CHAR),
  TESTO_ENG   VARCHAR2(2000 CHAR),
  DATA_INS    DATE,
  TIPO        VARCHAR2(20 CHAR),
  FLG_SPED    NUMBER(1),
  DATA_SPED   DATE,
  NOTA        VARCHAR2(4000 CHAR),
  STU_ID      NUMBER(10),
  CDS_ID      NUMBER(10),
  AD_ID       NUMBER(10),
  APP_ID      NUMBER(10),
  AGE_AVT_ID  NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE TOAD_PLAN_TABLE
(
  STATEMENT_ID       VARCHAR2(30 BYTE),
  PLAN_ID            NUMBER,
  TIMESTAMP          DATE,
  REMARKS            VARCHAR2(4000 BYTE),
  OPERATION          VARCHAR2(30 BYTE),
  OPTIONS            VARCHAR2(255 BYTE),
  OBJECT_NODE        VARCHAR2(128 BYTE),
  OBJECT_OWNER       VARCHAR2(30 BYTE),
  OBJECT_NAME        VARCHAR2(30 BYTE),
  OBJECT_ALIAS       VARCHAR2(65 BYTE),
  OBJECT_INSTANCE    INTEGER,
  OBJECT_TYPE        VARCHAR2(30 BYTE),
  OPTIMIZER          VARCHAR2(255 BYTE),
  SEARCH_COLUMNS     NUMBER,
  ID                 INTEGER,
  PARENT_ID          INTEGER,
  DEPTH              INTEGER,
  POSITION           INTEGER,
  COST               INTEGER,
  CARDINALITY        INTEGER,
  BYTES              INTEGER,
  OTHER_TAG          VARCHAR2(255 BYTE),
  PARTITION_START    VARCHAR2(255 BYTE),
  PARTITION_STOP     VARCHAR2(255 BYTE),
  PARTITION_ID       INTEGER,
  OTHER              LONG,
  DISTRIBUTION       VARCHAR2(30 BYTE),
  CPU_COST           INTEGER,
  IO_COST            INTEGER,
  TEMP_SPACE         INTEGER,
  ACCESS_PREDICATES  VARCHAR2(4000 BYTE),
  FILTER_PREDICATES  VARCHAR2(4000 BYTE),
  PROJECTION         VARCHAR2(4000 BYTE),
  TIME               INTEGER,
  QBLOCK_NAME        VARCHAR2(30 BYTE),
  OTHER_XML          CLOB
)
LOB (OTHER_XML) STORE AS BASICFILE (
  TABLESPACE  IUNIV_UNITO_PROD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_PRENOTAZIONI
(
  STU_ID    NUMBER(10)                          NOT NULL,
  CDS_ID    NUMBER(10)                          NOT NULL,
  AD_ID     NUMBER(10)                          NOT NULL,
  APP_ID    NUMBER(10)                          NOT NULL,
  NOTA      VARCHAR2(4000 CHAR),
  DATA_INS  DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_PROFILE
(
  MID     NUMBER(10)                            NOT NULL,
  DES     VARCHAR2(80 CHAR),
  GRP_ID  NUMBER(4)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_URL_STUDENTI
(
  USER_ID  VARCHAR2(20 CHAR),
  ANA_ID   NUMBER(10),
  STU_ID   NUMBER(10),
  URL_01   VARCHAR2(65 CHAR)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE T_UTENTI
(
  MID          NUMBER(10),
  USER_ID      VARCHAR2(20 CHAR),
  GRP          NUMBER(10),
  PROFILE      NUMBER(10),
  DISABLE_FLG  NUMBER(1),
  ANA_ID       NUMBER(10),
  CARRIERA_ID  NUMBER(10),
  CARRIERA     VARCHAR2(255 CHAR),
  NOME         VARCHAR2(255 CHAR),
  COGNOME      VARCHAR2(255 CHAR),
  MATRICOLA    VARCHAR2(20 CHAR),
  DESCRIZIONE  VARCHAR2(4000 CHAR),
  NOTE         VARCHAR2(4000 CHAR),
  DATA_INIZIO  DATE,
  DATA_FINE    DATE,
  URL_PHOTO    VARCHAR2(255 CHAR),
  FOTO_ID      NUMBER(10)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE X_GOL_STEP1
(
  MID_LIV_2  NUMBER,
  DES        VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE X_GOL_STEP2
(
  MID_LIV_1      NUMBER,
  MID_LIV_2      NUMBER,
  MID_LIV_2_DES  VARCHAR2(4000 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE TABLE X_GOL_STEP3
(
  MID                   NUMBER(10),
  CODE                  VARCHAR2(20 CHAR),
  NAME                  VARCHAR2(255 CHAR),
  DESCRIPTION           VARCHAR2(4000 CHAR),
  MID_LIV_PADRE         NUMBER(10),
  MID_DETT              NUMBER(10),
  AA_ID                 NUMBER(10)              NOT NULL,
  AD_ID                 NUMBER(10)              NOT NULL,
  TSN_TRAG_DESC_MODULO  VARCHAR2(255 CHAR),
  DES_TIPI_DID          VARCHAR2(255 CHAR),
  DES_LUNGUA_DID        VARCHAR2(40 CHAR),
  MODULO                VARCHAR2(255 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX AGE_AZIONI_PK ON AGE_AZIONI
(AGE_AZN_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_AZIONI_TIPI_PK ON AGE_AZIONI_TIPI
(AGE_AVT_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_BOX_EMAIL_PK ON AGE_BOX_EMAIL
(AGE_BEM_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_BOX_GESTORI_PK ON AGE_BOX_GESTORI
(AGE_BGE_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_BOX_ISCRITTI_PK ON AGE_BOX_ISCRITTI
(AGE_BIS_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_BOX_LISTE_PK ON AGE_BOX_LISTE
(AGE_BLI_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_CAL_ESAMI_PK ON AGE_CAL_ESAMI
(AGE_CAES_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_CAL_EVENTI_PK ON AGE_CAL_EVENTI
(AGE_CAEV_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_CAL_LEZIONI_PK ON AGE_CAL_LEZIONI
(AGE_CALE_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_IMPOSTA_T_PK ON AGE_IMPOSTA_T
(AGE_TIMP_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_LINK_PK ON AGE_LINK
(AGE_LINK_ID)
LOGGING;

CREATE UNIQUE INDEX AGE_SCAD_AMM_PK ON AGE_SCAD_AMM
(AGE_SCAD_ID)
LOGGING;

CREATE UNIQUE INDEX CHA_CHANNEL_PK ON TAB_CHA_CHANNEL
(MID)
LOGGING;

CREATE UNIQUE INDEX FEE_FEED_PK ON TAB_FEE_FEED
(MID)
LOGGING;

CREATE UNIQUE INDEX FRW_ACCESSI_PK ON FRW_ACCESSI
(MID)
NOLOGGING;

CREATE UNIQUE INDEX FRW_CONFIG_PK ON FRW_CONFIG
(MID)
LOGGING;

CREATE UNIQUE INDEX FRW_CONFIG_URL_PK ON FRW_CONFIG_URL
(MID)
LOGGING;

CREATE UNIQUE INDEX FRW_ESECUZIONE_COMANDI_PK ON FRW_ESECUZIONE_COMANDI
(MID)
LOGGING;

CREATE UNIQUE INDEX FRW_MODULI_PK ON FRW_MODULI
(MID)
LOGGING;

CREATE UNIQUE INDEX FRW_UTENTI_01 ON FRW_UTENTI
(CDA_USER)
NOLOGGING;

CREATE UNIQUE INDEX FRW_UTENTI_PK ON FRW_UTENTI
(MID)
NOLOGGING;

CREATE UNIQUE INDEX FRW_UTENTI_TOKEN_PK ON FRW_UTENTI_TOKEN
(MID)
LOGGING;

CREATE INDEX GOL_AD_AAOFFID ON GOL_AD
(AA_OFF_ID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_CERCA_PK ON GOL_CERCA
(MID)
NOLOGGING;

CREATE UNIQUE INDEX GOL_AD_CERCA_SEL_PK ON GOL_CERCA_SEL
(MID)
NOLOGGING;

CREATE UNIQUE INDEX GOL_AD_CERCA_VAL_PK ON GOL_CERCA_VAL
(MID)
NOLOGGING;

CREATE UNIQUE INDEX GOL_AD_CLA_DOC_LN_PK ON GOL_AD_CLA_DOC_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_CLA_DOC_PK ON GOL_AD_CLA_DOC
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_CLA_LN_PK ON GOL_AD_CLA_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_CLA_PK ON GOL_AD_CLA
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_DOC_LN_PK ON GOL_AD_DOC_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_DOC_PK ON GOL_AD_DOC
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_LN_PK ON GOL_AD_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_MOD_DOC_LN_PK ON GOL_AD_MOD_DOC_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_MOD_DOC_PK ON GOL_AD_MOD_DOC
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_MOD_LN_PK ON GOL_AD_MOD_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_MOD_PK ON GOL_AD_MOD
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_AD_PK ON GOL_AD
(MID)
LOGGING;

CREATE UNIQUE INDEX GOL_LIV_LN_PK ON GOL_LIV_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX GOL_LIV_PK ON GOL_LIV
(MID)
LOGGING;

CREATE UNIQUE INDEX IDX_CHA_CHANNEL_COD ON TAB_CHA_CHANNEL
(COD)
LOGGING;

CREATE INDEX IDX_DSH_AD_TORTA_01 ON DSH_AD_TORTA
(STU_ID)
LOGGING;

CREATE INDEX IDX_DSH_AD_VOTI_01 ON DSH_AD_VOTI
(STU_ID)
LOGGING;

CREATE INDEX IDX_ELMAH$ERROR_APP_TIME_SEQ ON ELMAH$ERROR
(APPLICATION, "TIMEUTC" DESC, "SEQUENCENUMBER" DESC)
LOGGING;

CREATE UNIQUE INDEX IDX_ELMAH$ERROR_PK ON ELMAH$ERROR
(ERRORID)
LOGGING;

CREATE UNIQUE INDEX IDX_FRW_MODULI_COD ON FRW_MODULI
(COD)
LOGGING;

CREATE UNIQUE INDEX IDX_FRW_UTENTI_TOKEN_01 ON FRW_UTENTI_TOKEN
(USER_ID)
LOGGING;

CREATE INDEX IDX_GOL_AD_DESCRIZIONI_01 ON T_GOL_AD_DESCRIZIONI
(MID)
LOGGING;

CREATE INDEX IDX_GOL_AD_DESCRIZIONI_02 ON T_GOL_AD_DESCRIZIONI
(AA_OFF_ID)
LOGGING;

CREATE INDEX IDX_GOL_AD_DESCRIZ_TUTTE_01 ON T_GOL_AD_DESCRIZIONI_TUTTE
(MID)
LOGGING;

CREATE INDEX IDX_LIB_STUDENTE_01 ON LIB_STUDENTE
(STU_ID)
LOGGING;

CREATE INDEX IDX_LIB_STUDENTE_CRUSC_01 ON LIB_STUDENTE_CRUSC
(STU_ID)
LOGGING;

CREATE INDEX IDX_MSG_MESSAGE_01 ON MSG_MESSAGE
(USER_ID)
LOGGING;

CREATE UNIQUE INDEX IDX_PHO_PHOTO_COD ON PHO_PHOTO
(COD)
LOGGING;

CREATE INDEX IDX_TAX_SIT_ANNI_001 ON TAX_SIT_ANNI
(STU_ID, AA_ISCR_ID)
LOGGING;

CREATE INDEX IDX_TAX_SIT_DETT_01 ON TAX_SIT_DETT
(STU_ID, AA_ISCR_ID)
LOGGING;

CREATE INDEX IDX_T_URL_STUDENTI ON T_URL_STUDENTI
(USER_ID, ANA_ID, STU_ID)
LOGGING;

CREATE INDEX IDX_X_GOL_STEP1 ON X_GOL_STEP1
(MID_LIV_2)
LOGGING;

CREATE BITMAP INDEX LANG_IDX ON TAB_EV_EVENTS
(LANG)
LOGGING;

CREATE UNIQUE INDEX LIB_DSH_AD_TORTA_PK ON DSH_AD_TORTA
(MID)
LOGGING;

CREATE UNIQUE INDEX LIB_DSH_AD_VOTI_PK ON DSH_AD_VOTI
(MID)
LOGGING;

CREATE UNIQUE INDEX LIB_STUDENTE_CRUSC_PK ON LIB_STUDENTE_CRUSC
(MID)
LOGGING;

CREATE UNIQUE INDEX LIB_STUDENTE_LN_PK ON LIB_STUDENTE_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX LIB_STUDENTE_PK ON LIB_STUDENTE
(MID)
LOGGING;

CREATE UNIQUE INDEX LNK_LINK_PK ON TAB_LNK_LINK
(MID)
LOGGING;

CREATE INDEX MID_DET_IDX ON TAB_EV_DETAIL
(MID, LANG)
LOGGING;

CREATE INDEX MID_IDX ON TAB_EV_EVENTS
(MID)
LOGGING;

CREATE UNIQUE INDEX MSG_MESSAGE_LN_PK ON MSG_MESSAGE_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX MSG_MESSAGE_PK ON MSG_MESSAGE
(MID)
LOGGING;

CREATE UNIQUE INDEX ORI_ESAMI_LN_PK ON ORI_ESAMI_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX ORI_ESAMI_PK ON ORI_ESAMI
(MID)
LOGGING;

CREATE UNIQUE INDEX ORI_ESAMI_USER_PK ON ORI_ESAMI_USER
(MID)
LOGGING;

CREATE UNIQUE INDEX ORI_LEZIONI_LN_PK ON ORI_LEZIONI_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX ORI_LEZIONI_PK ON ORI_LEZIONI
(MID)
LOGGING;

CREATE UNIQUE INDEX ORI_LEZIONI_USER_PK ON ORI_LEZIONI_USER
(MID)
LOGGING;

CREATE UNIQUE INDEX PHO_PHOTO_PK ON PHO_PHOTO
(MID)
LOGGING;

CREATE INDEX "schema_version_ir_idx" ON "schema_version"
("installed_rank")
LOGGING;

CREATE UNIQUE INDEX "schema_version_pk" ON "schema_version"
("version")
LOGGING;

CREATE INDEX "schema_version_s_idx" ON "schema_version"
("success")
LOGGING;

CREATE INDEX "schema_version_vr_idx" ON "schema_version"
("version_rank")
LOGGING;

CREATE UNIQUE INDEX SRV_SERVICES_LN_PK ON SRV_SERVICES_LN
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX SRV_SERVICES_PK ON SRV_SERVICES
(MID)
LOGGING;

CREATE UNIQUE INDEX T_AA_PK ON T_AA
(MID)
LOGGING;

CREATE UNIQUE INDEX T_AGE_AZIONI_PK ON T_AGE_AZIONI
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX TAX_SIT_ANNI_LN_PK ON TAX_SIT_ANNI_LN
(MID, LN_CODE)
NOLOGGING;

CREATE UNIQUE INDEX TAX_SIT_ANNI_PK ON TAX_SIT_ANNI
(MID)
NOLOGGING;

CREATE UNIQUE INDEX TAX_SIT_DETT_LN_PK ON TAX_SIT_DETT_LN
(MID, LN_CODE)
NOLOGGING;

CREATE UNIQUE INDEX TAX_SIT_DETT_PK ON TAX_SIT_DETT
(MID)
NOLOGGING;

CREATE UNIQUE INDEX T_DOCENTI_PK ON T_DOCENTI
(MID)
LOGGING;

CREATE UNIQUE INDEX T_LANGUAGE_PK ON T_LANGUAGE
(LN_CODE)
LOGGING;

CREATE UNIQUE INDEX T_LOCATION_PK ON T_LOCATION
(MID)
LOGGING;

CREATE UNIQUE INDEX T_MESSAGE_PK ON T_MESSAGE
(MID, LN_CODE)
LOGGING;

CREATE UNIQUE INDEX T_PROFILE_PK ON T_PROFILE
(MID)
LOGGING;

CREATE UNIQUE INDEX T_UTENTI_PK ON T_UTENTI
(MID)
LOGGING;

CREATE INDEX USER_ID_IDX ON TAB_EV_EVENTS
(USER_ID)
LOGGING;

CREATE UNIQUE INDEX XAK_LOCALGRANTS_UNIQUE ON LOCAL_GRANTS
(PROD_GRANTEE, WHAT, GRANT_PRIVS)
LOGGING;

CREATE UNIQUE INDEX XPK_KESITOFIX ON K_ESITO_FIX
(MODULO, VERSIONE, DATA_APPL, FNAME)
LOGGING;

CREATE UNIQUE INDEX XPK_LOCAL_GRANTS ON LOCAL_GRANTS
(ID)
LOGGING;

CREATE UNIQUE INDEX XPKLOCAL_PROD_LINK_STATUS ON LOCAL_PROD_LINK_STATUS
(PROD, LINKED_PROD)
LOGGING;

ALTER TABLE AGE_AZIONI ADD (
  CONSTRAINT AGE_AZIONI_PK
  PRIMARY KEY
  (AGE_AZN_ID)
  USING INDEX AGE_AZIONI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_AZIONI_TIPI ADD (
  CONSTRAINT AGE_AZIONI_TIPI_PK
  PRIMARY KEY
  (AGE_AVT_ID)
  USING INDEX AGE_AZIONI_TIPI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_BOX_EMAIL ADD (
  CONSTRAINT AGE_BOX_EMAIL_PK
  PRIMARY KEY
  (AGE_BEM_ID)
  USING INDEX AGE_BOX_EMAIL_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_BOX_GESTORI ADD (
  CONSTRAINT AGE_BOX_GESTORI_PK
  PRIMARY KEY
  (AGE_BGE_ID)
  USING INDEX AGE_BOX_GESTORI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_BOX_ISCRITTI ADD (
  CONSTRAINT AGE_BOX_ISCRITTI_PK
  PRIMARY KEY
  (AGE_BIS_ID)
  USING INDEX AGE_BOX_ISCRITTI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_BOX_LISTE ADD (
  CONSTRAINT AGE_BOX_LISTE_PK
  PRIMARY KEY
  (AGE_BLI_ID)
  USING INDEX AGE_BOX_LISTE_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_CAL_ESAMI ADD (
  CONSTRAINT AGE_CAL_ESAMI_PK
  PRIMARY KEY
  (AGE_CAES_ID)
  USING INDEX AGE_CAL_ESAMI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_CAL_EVENTI ADD (
  CONSTRAINT AGE_CAL_EVENTI_PK
  PRIMARY KEY
  (AGE_CAEV_ID)
  USING INDEX AGE_CAL_EVENTI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_CAL_LEZIONI ADD (
  CONSTRAINT AGE_CAL_LEZIONI_PK
  PRIMARY KEY
  (AGE_CALE_ID)
  USING INDEX AGE_CAL_LEZIONI_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_IMPOSTA_T ADD (
  CONSTRAINT AGE_IMPOSTA_T_PK
  PRIMARY KEY
  (AGE_TIMP_ID)
  USING INDEX AGE_IMPOSTA_T_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_LINK ADD (
  CONSTRAINT AGE_LINK_PK
  PRIMARY KEY
  (AGE_LINK_ID)
  USING INDEX AGE_LINK_PK
  ENABLE VALIDATE);

ALTER TABLE AGE_SCAD_AMM ADD (
  CONSTRAINT AGE_SCAD_AMM_PK
  PRIMARY KEY
  (AGE_SCAD_ID)
  USING INDEX AGE_SCAD_AMM_PK
  ENABLE VALIDATE);

ALTER TABLE DSH_AD_TORTA ADD (
  CONSTRAINT DSH_AD_TORTA_PK
  PRIMARY KEY
  (MID)
  USING INDEX LIB_DSH_AD_TORTA_PK
  ENABLE VALIDATE);

ALTER TABLE DSH_AD_VOTI ADD (
  CONSTRAINT DSH_AD_VOTI_PK
  PRIMARY KEY
  (MID)
  USING INDEX LIB_DSH_AD_VOTI_PK
  ENABLE VALIDATE);

ALTER TABLE ELMAH$ERROR ADD (
  CONSTRAINT IDX_ELMAH$ERROR_PK
  PRIMARY KEY
  (ERRORID)
  USING INDEX IDX_ELMAH$ERROR_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_ACCESSI ADD (
  CONSTRAINT FRW_ACCESSI_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_ACCESSI_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_CONFIG ADD (
  CONSTRAINT FRW_CONFIG_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_CONFIG_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_CONFIG_URL ADD (
  CONSTRAINT FRW_CONFIG_URL_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_CONFIG_URL_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_ESECUZIONE_COMANDI ADD (
  CONSTRAINT FRW_ESECUZIONE_COMANDI_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_ESECUZIONE_COMANDI_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_MODULI ADD (
  CONSTRAINT FRW_MODULI_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_MODULI_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_UTENTI ADD (
  CONSTRAINT FRWUTENTIFLGATTIVO
  CHECK (FLG_ATTIVO IN ('S', 'N'))
  ENABLE VALIDATE,
  CONSTRAINT FRWUTENTIINDSESSO
  CHECK (IND_SESSO IN ('M', 'F') OR IND_SESSO IS NULL)
  ENABLE VALIDATE,
  CONSTRAINT FRW_UTENTI_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_UTENTI_PK
  ENABLE VALIDATE);

ALTER TABLE FRW_UTENTI_TOKEN ADD (
  CONSTRAINT FRW_UTENTI_TOKEN_PK
  PRIMARY KEY
  (MID)
  USING INDEX FRW_UTENTI_TOKEN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD ADD (
  CONSTRAINT GOL_AD_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_CLA ADD (
  CONSTRAINT GOL_AD_CLA_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_CLA_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_CLA_DOC ADD (
  CONSTRAINT GOL_AD_CLA_DOC_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_CLA_DOC_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_CLA_DOC_LN ADD (
  CONSTRAINT GOL_AD_CLA_DOC_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_CLA_DOC_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_CLA_LN ADD (
  CONSTRAINT GOL_AD_CLA_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_CLA_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_DOC ADD (
  CONSTRAINT GOL_AD_DOC_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_DOC_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_DOC_LN ADD (
  CONSTRAINT GOL_AD_DOC_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_DOC_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_LN ADD (
  CONSTRAINT GOL_AD_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_MOD ADD (
  CONSTRAINT GOL_AD_MOD_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_MOD_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_MOD_DOC ADD (
  CONSTRAINT GOL_AD_MOD_DOC_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_MOD_DOC_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_MOD_DOC_LN ADD (
  CONSTRAINT GOL_AD_MOD_DOC_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_MOD_DOC_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_AD_MOD_LN ADD (
  CONSTRAINT GOL_AD_MOD_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_AD_MOD_LN_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_CERCA ADD (
  CONSTRAINT GOL_AD_CERCA_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_CERCA_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_CERCA_SEL ADD (
  CONSTRAINT GOL_AD_CERCA_SEL_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_CERCA_SEL_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_CERCA_VAL ADD (
  CONSTRAINT GOL_AD_CERCA_SEL_VAL
  PRIMARY KEY
  (MID)
  USING INDEX GOL_AD_CERCA_VAL_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_LIV ADD (
  CONSTRAINT GOL_LIV_PK
  PRIMARY KEY
  (MID)
  USING INDEX GOL_LIV_PK
  ENABLE VALIDATE);

ALTER TABLE GOL_LIV_LN ADD (
  CONSTRAINT GOL_LIV_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX GOL_LIV_LN_PK
  ENABLE VALIDATE);

ALTER TABLE K_ESITO_FIX ADD (
  CONSTRAINT XPK_KESITOFIX
  PRIMARY KEY
  (MODULO, VERSIONE, DATA_APPL, FNAME)
  USING INDEX XPK_KESITOFIX
  ENABLE VALIDATE);

ALTER TABLE LIB_STUDENTE ADD (
  CONSTRAINT LIB_STUDENTE_PK
  PRIMARY KEY
  (MID)
  USING INDEX LIB_STUDENTE_PK
  ENABLE VALIDATE);

ALTER TABLE LIB_STUDENTE_CRUSC ADD (
  CONSTRAINT LIB_STUDENTE_CRUSC_PK
  PRIMARY KEY
  (MID)
  USING INDEX LIB_STUDENTE_CRUSC_PK
  ENABLE VALIDATE);

ALTER TABLE LIB_STUDENTE_LN ADD (
  CONSTRAINT LIB_STUDENTE_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX LIB_STUDENTE_LN_PK
  ENABLE VALIDATE);

ALTER TABLE LOCAL_GRANTS ADD (
  CONSTRAINT XPK_LOCAL_GRANTS
  PRIMARY KEY
  (ID)
  USING INDEX XPK_LOCAL_GRANTS
  ENABLE VALIDATE,
  CONSTRAINT XAK_LOCALGRANTS_UNIQUE
  UNIQUE (PROD_GRANTEE, WHAT, GRANT_PRIVS)
  USING INDEX XAK_LOCALGRANTS_UNIQUE
  ENABLE VALIDATE);

ALTER TABLE LOCAL_PROD_LINK_STATUS ADD (
  CONSTRAINT XPKLOCAL_PROD_LINK_STATUS
  PRIMARY KEY
  (PROD, LINKED_PROD)
  USING INDEX XPKLOCAL_PROD_LINK_STATUS
  ENABLE VALIDATE);

ALTER TABLE MSG_MESSAGE ADD (
  CONSTRAINT MSG_MESSAGE_PK
  PRIMARY KEY
  (MID)
  USING INDEX MSG_MESSAGE_PK
  ENABLE VALIDATE);

ALTER TABLE MSG_MESSAGE_LN ADD (
  CONSTRAINT MSG_MESSAGE_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX MSG_MESSAGE_LN_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_ESAMI ADD (
  CONSTRAINT ORI_ESAMI_PK
  PRIMARY KEY
  (MID)
  USING INDEX ORI_ESAMI_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_ESAMI_LN ADD (
  CONSTRAINT ORI_ESAMI_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX ORI_ESAMI_LN_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_ESAMI_USER ADD (
  CONSTRAINT ORI_ESAMI_USER_PK
  PRIMARY KEY
  (MID)
  USING INDEX ORI_ESAMI_USER_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_LEZIONI ADD (
  CONSTRAINT ORI_LEZIONI_PK
  PRIMARY KEY
  (MID)
  USING INDEX ORI_LEZIONI_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_LEZIONI_LN ADD (
  CONSTRAINT ORI_LEZIONI_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX ORI_LEZIONI_LN_PK
  ENABLE VALIDATE);

ALTER TABLE ORI_LEZIONI_USER ADD (
  CONSTRAINT ORI_LEZIONI_USER_PK
  PRIMARY KEY
  (MID)
  USING INDEX ORI_LEZIONI_USER_PK
  ENABLE VALIDATE);

ALTER TABLE PHO_PHOTO ADD (
  CONSTRAINT PHO_PHOTO_PK
  PRIMARY KEY
  (MID)
  USING INDEX PHO_PHOTO_PK
  ENABLE VALIDATE);

ALTER TABLE "schema_version" ADD (
  CONSTRAINT "schema_version_pk"
  PRIMARY KEY
  ("version")
  USING INDEX "schema_version_pk"
  ENABLE VALIDATE);

ALTER TABLE SRV_SERVICES ADD (
  CONSTRAINT SRV_SERVICES_PK
  PRIMARY KEY
  (MID)
  USING INDEX SRV_SERVICES_PK
  ENABLE VALIDATE);

ALTER TABLE SRV_SERVICES_LN ADD (
  CONSTRAINT SRV_SERVICES_LN_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX SRV_SERVICES_LN_PK
  ENABLE VALIDATE);

ALTER TABLE T_AA ADD (
  CONSTRAINT T_AA_PK
  PRIMARY KEY
  (MID)
  USING INDEX T_AA_PK
  ENABLE VALIDATE);

ALTER TABLE TAB_CHA_CHANNEL ADD (
  CONSTRAINT CHA_CHANNEL_PK
  PRIMARY KEY
  (MID)
  USING INDEX CHA_CHANNEL_PK
  ENABLE VALIDATE);

ALTER TABLE TAB_FEE_FEED ADD (
  CONSTRAINT FEE_FEED_PK
  PRIMARY KEY
  (MID)
  USING INDEX FEE_FEED_PK
  ENABLE VALIDATE);

ALTER TABLE TAB_LNK_LINK ADD (
  CONSTRAINT LNK_LINK_PK
  PRIMARY KEY
  (MID)
  USING INDEX LNK_LINK_PK
  ENABLE VALIDATE);

ALTER TABLE T_AGE_AZIONI ADD (
  CONSTRAINT T_AGE_AZIONI_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX T_AGE_AZIONI_PK
  ENABLE VALIDATE);

ALTER TABLE TAX_SIT_ANNI ADD (
  CONSTRAINT TAX_SIT_ANNI
  PRIMARY KEY
  (MID)
  USING INDEX TAX_SIT_ANNI_PK
  ENABLE VALIDATE);

ALTER TABLE TAX_SIT_ANNI_LN ADD (
  CONSTRAINT TAX_SIT_ANNI_LN
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX TAX_SIT_ANNI_LN_PK
  ENABLE VALIDATE);

ALTER TABLE TAX_SIT_DETT ADD (
  CONSTRAINT TAX_SIT_DETT
  PRIMARY KEY
  (MID)
  USING INDEX TAX_SIT_DETT_PK
  ENABLE VALIDATE);

ALTER TABLE TAX_SIT_DETT_LN ADD (
  CONSTRAINT TAX_SIT_DETT_LN
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX TAX_SIT_DETT_LN_PK
  ENABLE VALIDATE);

ALTER TABLE T_DOCENTI ADD (
  CONSTRAINT T_DOCENTI_PK
  PRIMARY KEY
  (MID)
  USING INDEX T_DOCENTI_PK
  ENABLE VALIDATE);

ALTER TABLE T_LANGUAGE ADD (
  CONSTRAINT T_LANGUAGE_PK
  PRIMARY KEY
  (LN_CODE)
  USING INDEX T_LANGUAGE_PK
  ENABLE VALIDATE);

ALTER TABLE T_LOCATION ADD (
  CONSTRAINT T_LOCATION_PK
  PRIMARY KEY
  (MID)
  USING INDEX T_LOCATION_PK
  ENABLE VALIDATE);

ALTER TABLE T_MESSAGE ADD (
  CONSTRAINT T_MESSAGE_PK
  PRIMARY KEY
  (MID, LN_CODE)
  USING INDEX T_MESSAGE_PK
  ENABLE VALIDATE);

ALTER TABLE T_PROFILE ADD (
  CONSTRAINT T_PROFILE_PK
  PRIMARY KEY
  (MID)
  USING INDEX T_PROFILE_PK
  ENABLE VALIDATE);

ALTER TABLE T_UTENTI ADD (
  CONSTRAINT T_UTENTI_PK
  PRIMARY KEY
  (MID)
  USING INDEX T_UTENTI_PK
  ENABLE VALIDATE);
