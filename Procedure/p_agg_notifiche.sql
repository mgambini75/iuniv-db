CREATE OR REPLACE PROCEDURE P_AGG_NOTIFICHE
AS
v_ora_inizio DATE;
v_ora_fine   DATE;
v_host_name  VARCHAR2(1000 CHAR);
v_db_name    VARCHAR2(1000 CHAR);
v_optimizer  VARCHAR2(512 CHAR);
v_authkey    varchar2(100);
v_appcode     varchar2(100);

LOG_TEST VARCHAR(2000);

cursor c1 is   
  select 
    rowid, 
    MATRICOLA, 
    TESTO, 
    NVL(TESTO_ENG, TESTO) as TESTO_ENG,
    STU_ID, 
    CDS_ID, 
    AD_ID, 
    APP_ID, 
    AGE_AVT_ID
from 
    T_NOTIFICHE
where 
    FLG_SPED = 0
order by DATA_INS;



BEGIN



   v_authkey := get_frw_config('PushAuthKey');
   v_appcode := get_frw_config('PushAppCode');

   if v_authkey is null then

       return ;
   end if;

    if v_appcode is null then

       return ;
   end if;
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Spedisci notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   for f1 in c1 loop

           BEGIN


              LOG_TEST:= NOTIFICATORE.SendNotificationLN(f1.testo, f1.testo_eng, f1.matricola, 0, v_authkey, v_appcode);
              
              EXCEPTION
              WHEN OTHERS THEN

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
                   'errore.... ('||f1.STU_ID||' '||f1.CDS_ID||' '||f1.AD_ID||' '||f1.APP_ID||' '||f1.AGE_AVT_ID||')'
                  );

           END;

            update t_notifiche
            set flg_sped = 1, DATA_SPED = sysdate
            where rowid = f1.rowid;

   end loop;

END;

/
