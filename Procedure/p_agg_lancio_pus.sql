CREATE OR REPLACE PROCEDURE                  P_AGG_LANCIO_PUS
AS
v_ora_inizio DATE;
v_ora_fine   DATE;
v_host_name  VARCHAR2(1000 CHAR);
v_db_name    VARCHAR2(1000 CHAR);
v_optimizer  VARCHAR2(512 CHAR);
v_testo    VARCHAR2(1000 CHAR);

BEGIN
    SELECT SYS_CONTEXT('USERENV','SERVER_HOST') into v_host_name FROM dual;


    p_agg_gen_notifiche;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Lancio notifiche PUSH
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   v_ora_inizio := SYSDATE;

    select COUNT(*) INTO V_TESTO
    from t_notifiche
    where flg_sped = 0;

    if V_TESTO > 0

        then

           BEGIN

              p_agg_notifiche;

              EXCEPTION
              WHEN OTHERS THEN

                v_ora_fine := SYSDATE;

                ROLLBACK;

                --- se da errore
                Insert Into TABELLA_LOG
                  (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                Values
                  (TABELLA_LOG_ID.Nextval,
                   'P_AGG_NOTIFICHE',
                   v_ora_inizio,
                   v_ora_fine,
                   (v_ora_fine - v_ora_inizio) * 24 * 60,
                   v_host_name,
                   v_db_name,
                   v_optimizer,
                   'errore.... ('||v_testo||')'
                  );

           END;

           v_ora_fine := SYSDATE;

           --- se non da errore
           Insert Into TABELLA_LOG
             (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
           Values
             (TABELLA_LOG_ID.Nextval,
              'P_AGG_NOTIFICHE',
              v_ora_inizio,
              v_ora_fine,
              (v_ora_fine - v_ora_inizio) * 24 * 60,
              v_host_name,
              v_db_name,
              v_optimizer,
              v_testo||' - numero spedizioni .'
             );

           commit;

    end if;

END;
/
