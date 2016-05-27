CREATE OR REPLACE procedure                  P_AGG_MOD_TAX_DATA (v_data date) 
as

   --- CURSORE
   CURSOR C_0
   IS
        select distinct stu_id  
        from p05_tax_stu 
        where (   data_ins > v_data -  1/24 
                  or data_mod > v_data - 1/24
                 );


v_time_insert date;
v_time_start date;
v_time_end  date;
v_aggiorno varchar2(100);
v_step varchar2(100);
v_mid number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);


begin

    FOR R_0 IN C_0
    LOOP
    
        v_time_start := sysdate;

        p_agg_mod_tax (r_0.stu_id);

        v_time_end := sysdate;

        Insert Into TABELLA_LOG
          (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
        Values
          (TABELLA_LOG_ID.Nextval,   'Aggiornamento Tasse STU:'||r_0.stu_id,v_time_start, v_time_end,null,null,null,null, null);      
        
    end loop;       

    commit;  

end;
/
