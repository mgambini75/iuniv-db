CREATE OR REPLACE procedure                  p_agg_mod_messaggi_old (p_user_id varchar2)
as

   --- CURSORE
   cursor c_1 (p_com_id number)
   is
    select com_dest_id as age_avt_id, 
             decode(a.stato_com, 5, 'Y', 'N')  as age_avt_deleted,
             a.data_ins as age_avt_data_ins, 
             a.data_mod as age_avt_data_mod, 
             decode(a.stato_com, 5, a.data_mod, null) as age_avt_data_eli, 
             nvl(data_ini_val, data_att)  as age_avt_data_da, 
             data_ini_val as age_avt_data_a, 
             null as age_avt_data_pr, 
             null as age_avt_data_ul, 
             1 as age_avt_visibilita, 
             0 as age_avt_letture, 
             user_id as age_avt_username, 
             pers_id as age_avt_pers_id, 
             null as age_avt_stu_id, 
             a.com_id as age_avt_com_id, 
             null as age_avt_rag_id, 
             null as age_avt_imp_id, 
             substr(mittente, 1, 20) as age_avt_fonte, 
             'n' as age_avt_primo, 
             'n' as age_avt_preferiti, 
             'n' as age_avt_aperto, 
             'n' as age_avt_email, 
             'n' as age_avt_sms, 
             'n' as age_avt_push, 
             null as age_avt_codice, 
             null as age_avt_dtprova,   -- null
             null as age_avt_aula,   -- null
             null as age_avt_gestore,  -- null 
             a.tipo_com_est_id as age_avt_cat_id,  -- null 
             e.des as age_avt_cat_ita,  -- null 
             null as age_avt_cat_eng,  -- null  
             a.titolo as age_avt_titolo_ita, 
             a.titolo as age_avt_titolo_eng,  
             null as age_avt_sms_ita,  -- null
             null as age_avt_sms_eng,  -- null  
             null as age_avt_push_ita,  -- null  
             null as age_avt_push_eng,  -- null  
             a.oggetto as age_avt_testo_ita, 
             null as age_avt_testo_ita2,  -- null   
             null as age_avt_testo_ita3,  -- null 
             a.oggetto as age_avt_testo_eng, 
             null as age_avt_testo_eng2,  -- null 
             null as age_avt_testo_eng3,  -- null
             1 age_avt_user_read
    from p16_com_est a
            join p16_com_est_dest b on b.com_id = a.com_id
            join p16_destinatari c on c.dest_id = b.dest_id and  origine_dato = 'PERSONE'        
            join p18_user d on d.ana_id = c.pers_id and  grp_id in (4, 2, 9, 8, 6) and disable_flg = 0
            join p16_tipo_com_est  e on a.TIPO_COM_EST_ID = e.TIPO_COM_EST_ID 
    where a.stato_com in (2, 3, 4, 5)         
    --and a.data_ins > (sysdate - 210)
    and a.com_id > p_com_id
    and user_id = p_user_id;   



v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid number(10);
v_aggiorno number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);

p_com_id number(10);


begin


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- procedura per il caricamento dei dati dei messaggi AGE_AVVISI_T
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --execute Immediate 'alter session set optimizer_mode = RULE';


    select nvl(max(com_id), 200000) into p_com_id 
    from msg_message
    where USER_ID = p_user_id;

    v_aggiorno := 0;

    v_time_start := sysdate;            
    
    v_step:=p_user_id; 

       for r_1 in c_1 ( p_com_id )
       loop

            v_aggiorno := v_aggiorno + 1;

            insert into msg_message (mid, flg_canc, data_ins, data_mod, data_eli, data_da, data_a, data_pr_let, data_ul_let, num_visibilita, num_letture, user_id, pers_id, stu_id, com_id, rag_id, imp_id, des_fonte, flg_primo, flg_preferiti, flg_aperto, flg_email, flg_sms, flg_push, codice, data_prova, des_aula, des_gestore, cat_id, flg_read)
            values (r_1.age_avt_id, r_1.age_avt_deleted, 
                       r_1.age_avt_data_ins, r_1.age_avt_data_mod, r_1.age_avt_data_eli, r_1.age_avt_data_da,r_1.age_avt_data_a, r_1.age_avt_data_pr, r_1.age_avt_data_ul, 
                       r_1.age_avt_visibilita, r_1.age_avt_letture, 
                       r_1.age_avt_username, r_1.age_avt_pers_id, r_1.age_avt_stu_id, r_1.age_avt_com_id, r_1.age_avt_rag_id, r_1.age_avt_imp_id, r_1.age_avt_fonte, 
                       r_1.age_avt_primo, r_1.age_avt_preferiti, r_1.age_avt_aperto, r_1.age_avt_email, r_1.age_avt_sms, r_1.age_avt_push, 
                       r_1.age_avt_codice, r_1.age_avt_dtprova, r_1.age_avt_aula, r_1.age_avt_gestore, r_1.age_avt_cat_id, r_1.age_avt_user_read);

            insert into msg_message_ln (mid, ln_code, des_categoria, des_titolo, des_sms, des_push, des_testo)
            values (r_1.age_avt_id, 'it', r_1.age_avt_cat_ita, r_1.age_avt_titolo_ita, r_1.age_avt_sms_ita, r_1.age_avt_push_ita, r_1.age_avt_testo_ita );

            insert into msg_message_ln (mid, ln_code, des_categoria, des_titolo, des_sms, des_push, des_testo)
            values (r_1.age_avt_id, 'en', r_1.age_avt_cat_ita, r_1.age_avt_titolo_eng, r_1.age_avt_sms_eng, r_1.age_avt_push_eng, r_1.age_avt_testo_eng );


       end loop;
        
        commit;


       IF v_aggiorno = 0
           
            THEN 

                    Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'NO Aggiornamento Messaggi',v_time_start, v_time_end,null,null,null,null, v_step);                        

            ELSE         

                    Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'Aggiornamento Messaggi N:'||v_aggiorno,v_time_start, v_time_end,null,null,null,null, v_step);        

        END IF;




end;
/
