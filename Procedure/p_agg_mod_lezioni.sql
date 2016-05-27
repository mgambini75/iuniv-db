CREATE OR REPLACE PROCEDURE                  P_AGG_MOD_LEZIONI (P_STU_ID IN NUMBER ) AS 

 --*******************************************************************************
   -- 04/12/2015 Pederzoli B.  Procedura per allineamento lezioni
   --*******************************************************************************

--- CURSORE
-- cursor orari  (v_mid number, v_stu_id number) is
--select rownum as mid,
--           anno_acc as anno_acc,
--           cda_ad as cda_ad,
--           cda_classe as cda_classe,
--           cda_gruppo as cda_gruppo,
--           to_date(to_char(data_impegno, 'DD/MM/YYYY')||' '||ora_inizio, 'DD/MM/YYYY HH24:MI:SS') as data_inizio,
--           to_date(to_char(data_impegno, 'DD/MM/YYYY')||' '||ora_fine, 'DD/MM/YYYY HH24:MI:SS') as data_fine,
--           fu_des_up_low(des_ad) as des_ad,
--           fu_des_up_low(des_ad_eng) as des_ad_eng,
--           fu_des_up_low(des_evento_riga) as des_evento,
--           a.des_note_imp as des_nota_imp,
--           des_note_imp_eng as des_nota_imp_eng,
--           a.des_note_ev as des_nota_eve,
--           des_note_ev_eng as des_nota_eve_eng,
--           b.cda_tipo_attiv as cod_tipo_att,
--           b.des_tipo_attiv as des_tipo_att,
--           a.des_condivisioni_logist as des_corsi,
--           case when cda_classe = cda_gruppo
--                then cda_classe
--                else cda_classe||' - '||cda_gruppo
--           end as des_patiz,
--           initcap(doc_resp) as des_doc_resp,
--           initcap(des_docenti) as des_docenti,
--           des_aule as des_aule,
--           lingua_classe as lingua_classe,
--           lingua_insegn as lingua_insegn,
--           prg_imp as ext_prg
--    from vw_exp_orario a
--         join ana_tipi_attivita b on cda_tipo_att = cda_tipo_attiv
--         join p11_ad_sce on p11_ad_sce.cod = a.cda_ad
--         join p04_mat on p04_mat.mat_id = p11_ad_sce.mat_id 
--    where data_impegno > =  sysdate and p04_mat.stu_id = v_stu_id and p04_mat.sta_mat_cod = 'A' and a.prg_imp > v_mid;

 cursor orari  (v_mid number, v_stu_id number) is
select mid
    from ori_lezioni a
         join p11_ad_sce on p11_ad_sce.cod = a.cda_ad
         join p04_mat on p04_mat.mat_id = p11_ad_sce.mat_id 
    where p04_mat.stu_id = v_stu_id and p04_mat.sta_mat_cod = 'A' and a.mid > v_mid;
    

v_id_user number(10);
v_stu_id number (10);
v_user_id varchar2(20);
v_ana_id number(10);


v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid number(10);
v_aggiorno number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);


begin


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- procedura per il caricamento degli orari delle lezioni
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

    select nvl(max(ori_lezioni_user.mid_lezione), 0)  into v_mid
    from ori_lezioni_user
    where ori_lezioni_user.stu_id = p_stu_id;
    
    
    select id  into v_user_id
    from p18_user p
    join p01_stu on p.ana_id = p01_stu.pers_id 
    where p01_stu.stu_id = p_stu_id;
    
    
    v_aggiorno := 0;

    v_time_start := sysdate;       
    
     v_stu_id := p_stu_id;  
    
     v_step:= 'Utente: ' || to_char(p_stu_id) || 'User_id' || v_user_id ||  'Max mid ' || to_char(v_mid);  -- Pederzoli B 04/12/2015   
     
   
    
        Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'NO Agg. ORARI',v_time_start, v_time_end,null,null,null,null, v_step);           
    

       for f1 in orari ( v_mid, v_stu_id)
       loop
       
       

            v_aggiorno := v_aggiorno + 1;

--                 insert into ori_lezioni
--                 values (f1.mid, f1.anno_acc, f1.cda_ad, f1.cda_classe, f1.cda_gruppo, f1.data_inizio, f1.data_fine, f1.des_ad, f1.des_evento, f1.des_nota_imp, f1.des_nota_eve, f1.cod_tipo_att, f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, f1.des_aule, f1.lingua_classe, f1.lingua_insegn, f1.ext_prg);
--
--                 insert into ori_lezioni_ln
--                 values (f1.mid, 'it', f1.des_ad, f1.des_evento, f1.des_nota_imp, f1.des_nota_eve, f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, f1.des_aule, f1.lingua_classe, f1.lingua_insegn);
--
--                insert into ori_lezioni_ln
--                values (f1.mid, 'en', nvl(f1.des_ad_eng,f1.des_ad), f1.des_evento, nvl(f1.des_nota_imp_eng,f1.des_nota_imp), nvl(f1.des_nota_eve_eng, f1.des_nota_eve_eng), f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, replace (f1.DES_AULE, 'Aula', 'Room'), f1.lingua_classe, f1.lingua_insegn);
                
--                insert into ori_lezioni_user
--                values (f1.mid, 1, v_user_id, v_stu_id, sysdate);
--                 

       end loop;
        
        commit;

      IF v_aggiorno = 0
           
            THEN 

                    Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'NO Agg. ORARI',v_time_start, v_time_end,null,null,null,null, v_step);                        

            ELSE         

                    Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'Agg. ORARI N:'||v_aggiorno ,v_time_start, v_time_end,null,null,null,null, v_step);        

        END IF;
     
  
END P_AGG_MOD_LEZIONI;
/
