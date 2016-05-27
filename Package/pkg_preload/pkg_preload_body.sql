  -- Scope declaration
   PROCEDURE init_frw_moduli (P_MID                NUMBER,
                              P_COD                NVARCHAR2,
                              P_DESCRIPTION        NVARCHAR2,
                              P_FLG_ATT_IOS        NUMBER DEFAULT 1,
                              p_FLG_ATT_ANDROID    NUMBER DEFAULT 1,
                              p_FLG_ATT_WS         NUMBER DEFAULT 1,
                              p_FLG_ATT_WP         NUMBER DEFAULT 1);

   PROCEDURE init_frw_config (P_KEY        CHAR,
                              P_VALUE      CHAR,
                              P_DESC       CHAR,
                              P_IOS        NUMBER,
                              P_ANDROID    NUMBER,
                              P_WP         NUMBER,
                              P_WS         NUMBER);

   -- Aggiorna tutte le tabelle
   PROCEDURE init_all
   AS
   BEGIN
      DBMS_OUTPUT.put_line ('loading: frw_config');
      frw_config;
      DBMS_OUTPUT.put_line ('loading: frw_moduli');
      frw_moduli;
      DBMS_OUTPUT.put_line ('loading: frw_utenti');
      frw_utenti;
      DBMS_OUTPUT.put_line ('loading: t_language');
      t_language;
      DBMS_OUTPUT.put_line ('loading: frw_esecuzione_comandi');
      frw_esecuzione_comandi;
      DBMS_OUTPUT.put_line ('loading: t_profile');
      t_profile;
   END init_all;

   PROCEDURE clear
   AS
   BEGIN
      DBMS_OUTPUT.put_line ('deleting: frw_config');

      DELETE frw_config;

      DBMS_OUTPUT.put_line ('deleting: frw_moduli');

      DELETE frw_moduli;

      DBMS_OUTPUT.put_line ('deleting: frw_utenti');

      DELETE frw_utenti
       WHERE cda_user = 'apex';

      DBMS_OUTPUT.put_line ('deleting: t_language');

      DELETE t_language
       WHERE ln_code IN ('it', 'en');

      DBMS_OUTPUT.put_line ('deleting: frw_esecuzione_comandi');

      DELETE frw_esecuzione_comandi
       WHERE mid = 1;

      DBMS_OUTPUT.put_line ('deleting: t_profile');

      DELETE t_profile
       WHERE mid < 4;
 
   END clear;

   PROCEDURE t_profile
   AS
      v_count   NUMBER (10);
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM t_profile
       WHERE mid < 4;

      IF v_count = 0
      THEN
         INSERT INTO T_PROFILE (MID, DES)
              VALUES (0, 'Pubblico');

         INSERT INTO T_PROFILE (MID, DES)
              VALUES (1, 'Studente');

         INSERT INTO T_PROFILE (MID, DES)
              VALUES (2, 'Docente');

         INSERT INTO T_PROFILE (MID, DES)
              VALUES (3, 'Pta');
      END IF;
   END t_profile;

   PROCEDURE frw_utenti
   AS
      v_count   NUMBER (10);
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM frw_utenti
       WHERE cda_user = 'apex';

      IF v_count = 0
      THEN
         INSERT INTO FRW_UTENTI (MID,
                                 CDA_USER,
                                 CDA_PASSW,
                                 CDA_REENTER_PASSW,
                                 IND_RUOLO,
                                 FLG_ATTIVO)
              VALUES (1,
                      'apex',
                      'admin',
                      'admin',
                      1,
                      'S');
      END IF;
   END frw_utenti;

   PROCEDURE frw_esecuzione_comandi
   AS
      v_count   NUMBER (10);
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM frw_esecuzione_comandi
       WHERE mid = 1;

      IF v_count = 0
      THEN
         INSERT INTO FRW_ESECUZIONE_COMANDI (MID,
                                             DES_COMANDO,
                                             FLG_CONFIG,
                                             FLG_MODULI)
              VALUES (1,
                      'empty',
                      0,
                      0);
      END IF;
   END frw_esecuzione_comandi;

   -- preload t_language
   PROCEDURE t_language
   AS
      v_count   NUMBER (10);
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM t_language
       WHERE ln_code IN ('it', 'en');

      IF v_count = 0
      THEN
         INSERT INTO T_LANGUAGE (LN_CODE, DESCRIPTION)
              VALUES ('it', 'Italiano');

         INSERT INTO T_LANGUAGE (LN_CODE, DESCRIPTION)
              VALUES ('en', 'English');
      END IF;
   END t_language;

   ----------------
   -- frw_config
   ----------------
   PROCEDURE frw_config
   AS
   BEGIN
      -- Nel menu info la prima riga
      init_frw_config (
         'AboutBannerURL',
         'http://www.kion.it',
         'URL to navigate when tapped on banner in about section',
         1,
         1,
         0,
         0);
      -- Credits (Sempre cineca)
      init_frw_config (
         'AboutCreditsURL',
         'http://www.cineca.com/en',
         'URL to navigate when tapped on credits in about section',
         1,
         1,
         0,
         0);
      -- Pulsante i nella schermata di about
      init_frw_config (
         'AboutInfo',
         '<!DOCTYPE HTML>
<html>
  <head>
  <title>{title}</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=no" />
  <link href="http://fonts.googleapis.com/css?family=Cabin:400,400italic,500,500italic,600,600italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <link href="http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <style>
    strong
    {
      font-family: ''Cabin'', serif;
      font-size: 18px;
      font-style: normal;
      font-weight: 700;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
    body
    {
      font-family: ''PT Sans'', serif;
      font-size: 16px;
      font-style: normal;
      font-weight: 400;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
  </style>
  </head>
  <body>
    <p><strong>Welcome to MyEsse3</strong><br /></p>
  </body>
</html>
',
         'When tapped on ''i'' button in about section this info will be rendered as a web content in about section',
         1,
         1,
         0,
         0);
      -- non si sa
      init_frw_config ('AnonymousProfileId',
                       '0',
                       'unknow',
                       0,
                       0,
                       0,
                       0);
      -- Chiave secret per chiamata API (da configurare in base all'ateneo)
      init_frw_config (
         'APIAuthSecretKey',
         'myesse3s3cr3t',
         'Secret key that the app uses to authenticate with the service',
         0,
         0,
         0,
         0);
      -- Tempo oltre il quale viene rinfrescato il session id di esse3
      init_frw_config (
         'APIAuthSessionTimespan',
         '15',
         'Number representing the timespan of the user session (in MINUTES)',
         0,
         0,
         0,
         0);
      -- Chiave secret usata da University manager. Fa un restart della cache
      init_frw_config ('APISecret',
                       'myesse3s3cr3t',
                       'Secret key to Refresh cache data',
                       0,
                       0,
                       0,
                       0);
      -- da eliminare
      -- delete AuthorizationScheme
      init_frw_config (
         'CourseDetailTemplate',
         '<!DOCTYPE HTML>
<html>
  <head>
  <title>{title}</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=no" />
  <link href="http://fonts.googleapis.com/css?family=Cabin:400,400italic,500,500italic,600,600italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <link href="http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <style>
    strong
    {
      font-family: ''Cabin'', serif;
      font-size: 18px;
      font-style: normal;
      font-weight: 700;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
    body
    {
      font-family: ''PT Sans'', serif;
      font-size: 16px;
      font-style: normal;
      font-weight: 400;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
  </style>
  </head>
  <body>
    {description}
    {educational_objectives}
    {content}
    {learning_modes}
    {methods_of_teaching}
    {other_info}
    {prerequisites}
    {references}
  </body>
</html>
',
         'Web content template used in course catalog section',
         1,
         1,
         0,
         0);

      -- Linguaggio di default (da verificare se effettivamente va usato per ios e android (forse solo per api)
      init_frw_config (
         'DefaultLanguage',
         'it',
         'Default lang code for results (e.g., ''en'', ''it'')',
         1,
         1,
         0,
         0);
      -- Mostra la possibilita' di entrare con un utente demo (da varificare)
      init_frw_config (
         'DemoAccountsEnabled',
         NULL,
         '(optional) Enabled demo users as comma separated values, if empty no demo accounts will be enabled',
         1,
         1,
         0,
         0);
      init_frw_config (
         'DemoAccountSessionId',
         'demo_session_id',
         'Session id placeholder when a demo user account logged in',
         0,
         0,
         0,
         0);
      -- Usata per recuperare le foto da esse3
      init_frw_config (
         'EncryptKey',
         NULL,
         'Encrypt key for url parameters (es: eW6Zms2ye02Ben0Vc11rHIOp0QtPmTGP)',
         0,
         0,
         0,
         0);
      -- Configurazione per l'autenticazione (http o https)
      init_frw_config ('Esse3WsClientBasicHttpSecurityMode',
                       'None',
                       '"None" or "Transport"',
                       0,
                       0,
                       0,
                       0);
      -- Url Web Services esse3
      init_frw_config (
         'Esse3WsClientEndpointAddressURI',
         NULL,
         '(optional) URI for Esse3 webservices (es: http://webesse3.kion.it/unina2-beta/services/ESSE3WS)',
         0,
         0,
         0,
         0);
      -- Se esse3 è giu' e questo parametro è true, viene mostrata una schermata di lavori in corso)
      init_frw_config ('Esse3WsConnectionTest',
                       'False',
                       'Flag for check if esse3Ws is in mainteneance',
                       0,
                       0,
                       0,
                       0);
      -- Usato per generare la pagina di dettaglio degli eventi
      init_frw_config (
         'EventTemplate',
         '<!DOCTYPE HTML>
<html>
  <head>
  <title>{title}</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=no" />
  <link href="http://fonts.googleapis.com/css?family=Cabin:400,400italic,500,500italic,600,600italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <link href="http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <style>
    h1.event-header
    {
      font-family: ''Cabin'', serif;
      font-size: 18px;
      font-style: normal;
      font-weight: 700;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
    .event-content
    {
      font-family: ''PT Sans'', serif;
      font-size: 16px;
      font-style: normal;
      font-weight: 400;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;

    }

  </style>
  <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
  <script type="text/javascript">
    $(document).ready(function(){
      $("img").load(function(){
        var maxWidth = 200;     // Max width for the image
        var maxHeight = 350;    // Max height for the image
        var ratio = 0;          // Used for aspect ratio
        var width = $(this).width();    // Current image width
        var height = $(this).height();  // Current image height
        
        // Check if the current width is larger than the max
        if(width > maxWidth){
          ratio = maxWidth / width;                 // get ratio for scaling image
          $(this).css("width", maxWidth);           // Set new width
          $(this).css("height", height * ratio);    // Scale height based on ratio
          height = height * ratio;                  // Reset height to match scaled image
          width = width * ratio;                    // Reset width to match scaled image
        }
        
        // Check if current height is larger than max
        if(height > maxHeight){
          ratio = maxHeight / height;               // get ratio for scaling image
          $(this).css("height", maxHeight);         // Set new height
          $(this).css("width", width * ratio);      // Scale width based on ratio
          width = width * ratio;                    // Reset width to match scaled image
        }
        $(this).css("float", "left");
        $(this).css("border-style", "none");

        $(this).css("margin-right", "10px");

      }) <!-- Closes ''each'' -->
  }) <!-- Closes ''ready'' -->
  </script>
  </head>
  <body>
    <img src="{thumbnail}" />

    <h1 class="event-header">{title}</h1>

    <!-- Content begins -->

    <div class="event-content" style="display: block;">

      <span style="color: gray;">{date}</span><br />

      <strong>{location}</strong>

      {speaker}<br />

      {payment}<br />

      {content}<br />
    </div>
    <!-- Content ends -->
  </body>
</html>
',
         'Web content template used in events section',
         1,
         1,
         0,
         0);

      -- Link al profilo facebook
      init_frw_config (
         'FacebookPageURL',
         'https://www.facebook.com/pages/Kion-SpA/118352161557068?ref=ts'||chr(38)||'fref=ts',
         '(optional) URL to navigate in facebook section (to make this work corresponding section must be enabled)',
         1,
         1,
         0,
         0);

      -- Template per pagina feed
      init_frw_config (
         'FeedEntryTemplate',
         '<!DOCTYPE HTML>
<html>
  <head>
  <title>{title}</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; user-scalable=no" />
  <link href="http://fonts.googleapis.com/css?family=Cabin:400,400italic,500,500italic,600,600italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <link href="http://fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css" />
  <style>
    h1.feed-header
    {
      font-family: ''Cabin'', serif;
      font-size: 18px;
      font-style: normal;
      font-weight: 700;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
    .feed-content
    {
      font-family: ''PT Sans'', serif;
      font-size: 16px;
      font-style: normal;
      font-weight: 400;
      text-shadow: none;
      text-decoration: none;
      text-transform: none;
      letter-spacing: 0em;
      word-spacing: 0em;
      line-height: 1.2;
    }
  </style>
  <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
  <script type="text/javascript">
    $(document).ready(function(){
      $("img").load(function(){
        var maxWidth = 200;     // Max width for the image
        var maxHeight = 350;    // Max height for the image
        var ratio = 0;          // Used for aspect ratio
        var width = $(this).width();    // Current image width
        var height = $(this).height();  // Current image height
        
        // Check if the current width is larger than the max
        if(width > maxWidth){
          ratio = maxWidth / width;                 // get ratio for scaling image
          $(this).css("width", maxWidth);           // Set new width
          $(this).css("height", height * ratio);    // Scale height based on ratio
          height = height * ratio;                  // Reset height to match scaled image
          width = width * ratio;                    // Reset width to match scaled image
        }
        
        // Check if current height is larger than max
        if(height > maxHeight){
          ratio = maxHeight / height;               // get ratio for scaling image
          $(this).css("height", maxHeight);         // Set new height
          $(this).css("width", width * ratio);      // Scale width based on ratio
          width = width * ratio;                    // Reset width to match scaled image
        }
        $(this).css("float", "left")
        $(this).css("border-style", "none")
      }) <!-- Closes ''each'' -->
  }) <!-- Closes ''ready'' -->
  </script>
  </head>
  <body>
    <h1 class="feed-header">{title}</h1>
    <!-- Content begins -->
    <div class="feed-content">
    {content}
    <!-- Content ends -->
    </div>
  </body>
</html>
',
         'Web content template used in feeds section',
         1,
         1,
         0,
         0);

      -- Chiave di Flickr
      init_frw_config (
         'FlickrAPIKey',
         NULL,
         '(optional) API Key for Flickr Service (to make this work photo section with at least one Flickr account must be enabled)',
         1,
         1,
         0,
         0);
      -- Se true vengono mostrati anche gli eventi pubblici
      init_frw_config (
         'IncludePublicEventsForLoggedInUsers',
         'False',
         'If set to ''true'', fetched events for logged in users will include also public events',
         1,
         1,
         0,
         0);

      init_frw_config (
         'LatestAppRelease',
         '7.2',
         'iOS release number checked during app launch forcing user to update to the latest version',
         1,
         0,
         0,
         0);
      init_frw_config (
         'LatestAppRelease',
         '4.0',
         'Android release number checked during app launch forcing user to update to the latest version',
         0,
         1,
         0,
         0);
      init_frw_config (
         'LatestAppRelease',
         '0.0',
         'Windows phone release number checked during app launch forcing user to update to the latest version',
         0,
         0,
         1,
         0);
      init_frw_config (
         'LatestAppRelease',
         '0.0',
         'Windows store release number checked during app launch forcing user to update to the latest version',
         0,
         0,
         0,
         1);

      -- delete LatestAppRelease_WS

      -- Banner mostrato in pie' pagina nella home (solo Android) - Lingua principale
      init_frw_config ('LauncherPhotoGalleryURI_Android',
                       NULL,
                       '(optional) URI for Android launcher photo gallery',
                       0,
                       1,
                       0,
                       0);

      -- Banner mostrato in pie' pagina nella home (solo Android) - Seconda lingua
      init_frw_config (
         'LauncherPhotoGalleryAlternativeURI_Android',
         NULL,
         '(optional) Alternative URI for Android launcher photo gallery',
         0,
         1,
         0,
         0);

      -- Script di autenticazione sui link
      init_frw_config (
         'LinkAuthScript',
         NULL,
         'JavaScript executed in links section for iOS client-side authentication',
         1,
         0,
         0,
         0);
      init_frw_config (
         'LinkAuthScript',
         NULL,
         'JavaScript executed in links section for Android client-side authentication',
         0,
         1,
         0,
         0);
      init_frw_config (
         'LinkAuthScript',
         NULL,
         'JavaScript executed in links section for Windows store client-side authentication',
         0,
         0,
         0,
         1);

      -- Numero massimo di anni da mostrare nelle guide on-line
      init_frw_config ('MaxRowsACYEAR',
                       '3',
                       'Max rows returned by view API_CC_ACYEAR',
                       0,
                       0,
                       0,
                       0);

      -- Servizio per rendere mobile siti che non lo sono
      init_frw_config ('MobilizerURL',
                       'http://www.instapaper.com/m?u={url}',
                       NULL,
                       1,
                       1,
                       0,
                       0);

      -- delete NoAuthSecret
      -- delete NoAuthSessionId

      -- Url applicativo ESSE3 foto per il recupero delle fotografie studente di esse3
      init_frw_config ('ProfilePhotoURI',
                       NULL,
                       'Esse3Photo url',
                       0,
                       0,
                       0,
                       0);

      -- Codice identificativo dell'università usato dal package di invio delle notifiche push
      init_frw_config ('PushAppCode',
                       NULL,
                       'push notification app code',
                       0,
                       0,
                       0,
                       0);

      -- Chiave di sicurezza utilizzata per l'invio delle notifiche push
      init_frw_config ('PushAuthKey',
                       NULL,
                       'push notification authorization key',
                       0,
                       0,
                       0,
                       0);
      /*
      delete
  RandomURLAuthScript
  RandomURLAuthScript
  RandomURL_0
  RandomURL_1
  RandomURL_2
  RandomURL_3
  RandomURL_4
  */
      -- Url per l'accesso ai documenti di sharepoint (solo se l'integrazione è attiva. vedi modulo)
      init_frw_config ('SharepointAddressURI',
                       NULL,
                       'URL to access to sharepoint shared document',
                       0,
                       0,
                       0,
                       0);
      -- Usato nell'invio della mail in "contattaci"
      init_frw_config (
         'SPAMSecret',
         NULL,
         'Secret that will be appended to subject of messages sent, if empty subject will not include this secret at all',
         1,
         1,
         0,
         0);
      -- Email per la richiesta di supporto
      init_frw_config ('SupportToRecipients',
                       'info@kion.it',
                       'Support e-mail addresses as comma separated values',
                       1,
                       1,
                       0,
                       0);
      -- Pagina di twitter
      init_frw_config (
         'TwitterPageURL',
         NULL,
         'URL to navigate in twitter section (to make this work corresponding section must be enabled)',
         1,
         1,
         0,
         0);
      -- Indica se il login di esse3 è case sensitive
      init_frw_config (
         'UsernameCaseSensitive',
         'True',
         'Whether usernames are case sensitive or not (e.g. ''foobar'' and ''FooBar'')',
         0,
         0,
         0,
         0);
      -- Tenmplate usato per il dettaglio pagina dei video
      init_frw_config (
         'VideoDetailTemplate',
         '<!DOCTYPE HTML>
<html>
  <head>
    <title>{title}</title>
    <style type="text/css">
    body {
      background-color: transparent;
      color: white;
    }
    </style>
  </head>
  <body style="margin:0">
    <object type="application/x-shockwave-flash" style="height: {height}px; width: {width}px">
      <param name="movie" value="{sourceURI}">
      <param name="allowFullScreen" value="true">
      <param name="allowScriptAccess" value="always">
      <embed src="{sourceURI}"
           type="application/x-shockwave-flash"
           allowfullscreen="true"
           allowScriptAccess="always"
           width="{width}"
           height="{height}">
    </object>
  </body>
</html>
',
         'Web content template used in videos section',
         0,
         1,
         0,
         0);

      /*
      WebAuthRequestURL
      WebAuthScript
      WebAuthScript

      */

      -- Tempo di timeout delle applicazioni
      init_frw_config ('WebAuthTimeout',
                       '20',
                       'Timeout for client-side authentication',
                       1,
                       1,
                       0,
                       0);

      /*
      WebmailAuthScript
     WebmailAuthScript
     WebmailRequestURL

      */

      COMMIT;
   END frw_config;

   --------------------------------------------------------------------------------
   -- PROCEDURE frw_moduli
   --------------------------------------------------------------------------------
   PROCEDURE frw_moduli
   AS
   BEGIN
      init_frw_moduli (100, 'GOL', 'Guida online');
      
      init_frw_moduli (102, 'GOS', 'Guida Online Cerca',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (121, 'CHA', 'Video');
      init_frw_moduli (132, 'FEE', 'Feed');
      init_frw_moduli (133, 'LNK', 'Collegamenti');
      init_frw_moduli (130, 'NEW', 'News',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
                       
      init_frw_moduli (201, 'MSG', 'Messaggi');
      init_frw_moduli (202, 'AGE', 'Agenda');
      init_frw_moduli (206, 'AZI',
                       'Azioni',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (208, 'WML',
                       'Webmail',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (207, 'DOC',
                       'Documenti',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (204, 'DSH', 'Cruscotto');
      init_frw_moduli (205, 'ESA', 'Esami');
      init_frw_moduli (131, 'EVE', 'Eventi',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
                       
      init_frw_moduli (310, 'FB', 'Facebook');
      init_frw_moduli (120, 'FOT', 'Foto');
      init_frw_moduli (0,   'FRW', 'Impostazioni');
      init_frw_moduli (203, 'LIB', 'Libretto');
      init_frw_moduli (101, 'ORI',
                       'Orari',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (210, 'QUE',
                       'Questionari',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (111, 'RUB', 'Rubrica');
      init_frw_moduli (110, 'SVR', 'Servizi');
      init_frw_moduli (209, 'TAX', 'Pagamenti');
      init_frw_moduli (311, 'TW', 'Twitter');
      init_frw_moduli (300, 'URL_0',
                       'Random URL 0',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (301, 'URL_1',
                       'Random URL 1',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (302, 'URL_2',
                       'Random URL 2',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (303, 'URL_3',
                       'Random URL 3',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (304, 'URL_4',
                       'Random URL 4',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (305, 'URL_5',
                       'Random URL 5',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (306, 'URL_6',
                       'Random URL 6',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (307, 'URL_7',
                       'Random URL 7',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (308, 'URL_8',
                       'Random URL 8',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);
      init_frw_moduli (309, 'URL_9',
                       'Random URL 9',
                       P_FLG_ATT_WS        => 0,
                       P_FLG_ATT_WP        => 0,
                       P_FLG_ATT_IOS       => 0,
                       P_FLG_ATT_ANDROID   => 0);

      init_frw_moduli (200, 'UTE', 'Profilo utente');
      init_frw_moduli (9,   'ABT', 'About');
      COMMIT;
   END FRW_MODULI;

   --------------------------------------------------------------------------------
   -- PROCEDURE help
   --------------------------------------------------------------------------------
   PROCEDURE HELP
   AS
   BEGIN
      DBMS_OUTPUT.enable (1000000);
      DBMS_OUTPUT.put_line (CHR (0));
      DBMS_OUTPUT.put_line ('Package Name : pkg_preload');
      DBMS_OUTPUT.put_line ('==========================');
      DBMS_OUTPUT.put_line ('Package di precaricamento dati MyEsse3');
      DBMS_OUTPUT.put_line ('rel.1.0 Aprile 2015, S. Teodorani - Creata');
      DBMS_OUTPUT.put_line (CHR (0));
      DBMS_OUTPUT.put_line ('Metodi            Descrizione');
      DBMS_OUTPUT.put_line (
         '----------------  ------------------------------');
      DBMS_OUTPUT.put_line ('help              Questa schermata');

      RETURN;
   END HELP;

   --------------------------------------------------------------------------------
   -- PROCEDURE db_check
   --------------------------------------------------------------------------------
   PROCEDURE init_frw_moduli (P_MID                NUMBER,
                              P_COD                NVARCHAR2,
                              P_DESCRIPTION        NVARCHAR2,
                              P_FLG_ATT_IOS        NUMBER DEFAULT 1,
                              p_FLG_ATT_ANDROID    NUMBER DEFAULT 1,
                              p_FLG_ATT_WS         NUMBER DEFAULT 1,
                              p_FLG_ATT_WP         NUMBER DEFAULT 1)
   AS
      V_COUNT   NUMBER (10);
      V_ORDIN   NUMBER (10);
   BEGIN
      V_COUNT := 0;

      SELECT COUNT (*)
        INTO V_COUNT
        FROM FRW_MODULI
       WHERE 1 = 1 AND COD = P_COD;

      IF V_COUNT = 0
      THEN
         SELECT NVL (MAX (CDN_ORDIN), 0) + 10
           INTO V_ORDIN
           FROM FRW_MODULI;

         INSERT INTO FRW_MODULI (MID,
                                 FLG_STU,
                                 FLG_PUB,
                                 FLG_PTA,
                                 FLG_DOC,
                                 FLG_ATT_WS,
                                 FLG_ATT_WP,
                                 FLG_ATT_TABLET,
                                 FLG_ATT_PHONE,
                                 FLG_ATT_IOS,
                                 FLG_ATT_ANDROID,
                                 FLG_ACC_UTE_BLOC,
                                 DESCRIPTION,
                                 COD,
                                 CDN_ORDIN)
              VALUES (P_MID,
                      1,
                      1,
                      1,
                      1,
                      P_FLG_ATT_WS,
                      P_FLG_ATT_WP,
                      1,
                      1,
                      P_FLG_ATT_IOS,
                      P_FLG_ATT_ANDROID,
                      0,
                      P_DESCRIPTION,
                      P_COD,
                      V_ORDIN);
      END IF;
   END init_frw_moduli;


   PROCEDURE init_frw_config (P_KEY        CHAR,
                              P_VALUE      CHAR,
                              P_DESC       CHAR,
                              P_IOS        NUMBER,
                              P_ANDROID    NUMBER,
                              P_WP         NUMBER,
                              P_WS         NUMBER)
   AS
      V_COUNT   NUMBER (10);
   BEGIN
      V_COUNT := 0;

      SELECT COUNT (*)
        INTO V_COUNT
        FROM FRW_CONFIG
       WHERE     1 = 1
             AND COD = P_KEY
             AND APP_VISIBLE_IOS = P_IOS
             AND APP_VISIBLE_ANDROID = P_ANDROID
             AND APP_VISIBLE_WP = P_WP
             AND APP_VISIBLE_WS = P_WS;

      IF V_COUNT = 0
      THEN
         INSERT INTO FRW_CONFIG (MID,
                                 COD,
                                 VALUE_STRING,
                                 DESCRIPTION,
                                 APP_VISIBLE_IOS,
                                 APP_VISIBLE_ANDROID,
                                 APP_VISIBLE_WP,
                                 APP_VISIBLE_WS)
              VALUES (FRW_CONFIG_MID.NEXTVAL,
                      P_KEY,
                      P_VALUE,
                      P_DESC,
                      P_IOS,
                      P_ANDROID,
                      P_WP,
                      P_WS);
      ELSE
         UPDATE FRW_CONFIG
            SET DESCRIPTION = P_DESC
          WHERE     1 = 1
                AND COD = P_KEY
                AND APP_VISIBLE_IOS = P_IOS
                AND APP_VISIBLE_ANDROID = P_ANDROID
                AND APP_VISIBLE_WP = P_WP
                AND APP_VISIBLE_WS = P_WS;
      END IF;
   END init_frw_config;
