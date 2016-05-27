CREATE OR REPLACE PACKAGE PKG_AGG
AS
   PROCEDURE servizi;
   PROCEDURE utenti;
   PROCEDURE guide_online(v_anno_aa number default null);
   PROCEDURE messaggi;
   PROCEDURE notifiche_push;
   PROCEDURE esami;
   PROCEDURE libretto;
   PROCEDURE tasse(v_anno_aa number default null);
   PROCEDURE help;
   
   v_ora_inizio_t  date;
   v_proc_name varchar2(30);

END pkg_agg;
/

