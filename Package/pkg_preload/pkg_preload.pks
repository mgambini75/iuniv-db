CREATE OR REPLACE PACKAGE PKG_PRELOAD
AS
   PROCEDURE frw_moduli;

   PROCEDURE frw_config;

   PROCEDURE frw_utenti;

   PROCEDURE t_language;

   PROCEDURE t_profile;

   PROCEDURE frw_esecuzione_comandi;

   PROCEDURE init_all;

   PROCEDURE clear;

   PROCEDURE HELP;
END pkg_preload;
/

