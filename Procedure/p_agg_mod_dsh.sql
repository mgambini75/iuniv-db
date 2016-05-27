CREATE OR REPLACE procedure p_agg_mod_dsh (p_stu_id number)
as

 

v_time_insert date;
v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);


begin

    v_step := to_char(p_stu_id);

    v_time_start := sysdate;    
    
    select nvl(max(data_ins), to_date('01/01/1900','dd/mm/yyyy')) into v_time_insert from dsh_ad_torta where stu_id = p_stu_id and rownum = 1;
    
    if v_time_insert < sysdate - 3
    
        then   
        
            --- aggiornamento del grafico a torta
            P_AGG_DSH_AD_TORTA (p_stu_id);
    
            commit;
            
            --- aggiornamento del grafico lineare con voti
            P_AGG_DSH_AD_VOTI (p_stu_id);    

            commit;  
            
            v_time_end := sysdate;   

            Insert Into TABELLA_LOG
              (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
            Values
              (TABELLA_LOG_ID.Nextval,   'Aggiornamento Grafici',v_time_start, v_time_end,null,null,null,null, v_step);          
        
        else
        
            v_time_end := sysdate;           

            Insert Into TABELLA_LOG
              (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
            Values
              (TABELLA_LOG_ID.Nextval,   'NO Aggiornamento Grafici',v_time_start, v_time_end,null,null,null,null, v_step);                  
                                  
                                      
    
    end if;            

end;
/
