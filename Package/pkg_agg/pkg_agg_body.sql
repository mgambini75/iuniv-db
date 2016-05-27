    PROCEDURE trace_start(v_procedure varchar2)
    AS
    BEGIN
        v_ora_inizio_t := SYSDATE;
        v_proc_name := v_procedure;
    END;

    PROCEDURE trace_commit
    AS
      
        v_ora_fine_t   DATE;
        v_host_name  VARCHAR2(1000 CHAR);
        v_db_name    VARCHAR2(1000 CHAR);
        v_optimizer  VARCHAR2(512 CHAR);
    BEGIN

        v_ora_fine_t := SYSDATE;

        SELECT SYS_CONTEXT('USERENV','SERVER_HOST') into v_host_name FROM dual;

        Insert Into TABELLA_LOG
          (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
        Values
          (TABELLA_LOG_ID.Nextval,
           v_proc_name,
           v_ora_inizio_t,
           v_ora_fine_t,
           (v_ora_fine_t - v_ora_inizio_t) * 24 * 60,
           v_host_name,
           v_db_name,
           v_optimizer,
           'PKG_AGG'
          );

    END;
    
    /* Aggiornamento servizi */
    PROCEDURE servizi
    AS
    BEGIN
         trace_start('P_AGG_SERVICES');

         P_AGG_SERVICES;     

         trace_commit;      
    END;

    /* Aggiornamento utenti */
    PROCEDURE utenti
    AS
    BEGIN
        trace_start('P_AGG_T_UTENTI');

        P_AGG_T_UTENTI;      

        trace_commit;
    END;
    
    /* Aggiornamento Guide On-Line */
    PROCEDURE guide_online(v_anno_aa number)
    AS
    v_anno number;
    BEGIN
        trace_start('P_AGG_MOD_GOL');

        if v_anno_aa is null then
            v_anno := get_acc_year();
        else
            v_anno := v_anno_aa;
        end if;

        P_AGG_MOD_GOL(v_anno);     

        trace_commit;
    END;

    /* Aggiornamento messaggi */
    PROCEDURE messaggi
    AS
    BEGIN
        trace_start('P_AGG_MESSAGGI');

        P_AGG_MESSAGGI;   

        trace_commit;
    END;
       
    /* Aggiornamento e invio notifiche push */
    PROCEDURE notifiche_push
    AS
    BEGIN
         trace_start('P_AGG_GEN_NOTIFICHE');
         P_AGG_GEN_NOTIFICHE;

         trace_start('P_AGG_LANCIO_PUS');
         P_AGG_LANCIO_PUS;    

         trace_commit;
    END;

    /* Aggiornamento esami */
    PROCEDURE esami
    AS
    BEGIN
        trace_start('P_AGG_ESAMI');
        P_AGG_ESAMI;   

        trace_commit;      
    END;

    /* Aggiornamento libretto studente */
    PROCEDURE libretto
    AS
    BEGIN
        trace_start('P_AGG_LIBRETTO');
        P_AGG_LIBRETTO;  
        
        trace_commit;       
    END;

    /* Aggiornamento tasse */
    PROCEDURE tasse(v_anno_aa number default null)
    AS
    v_anno number;
    BEGIN
        trace_start('P_AGG_TASSE');

        if v_anno_aa is null then
            v_anno := get_acc_year();
        else
            v_anno := v_anno_aa;
        end if;

        P_AGG_TASSE (v_anno);   

        trace_commit;
    END;

    /* Procedura di Help */
    PROCEDURE help
    AS
    BEGIN
       
         null;
               
    END help;




	