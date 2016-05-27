CREATE OR REPLACE procedure                  p_agg_esami
as

   --- CURSORE
   cursor c_1
   is
            select  distinct
                      p10_app_cds_id||'-'||p10_app_ad_id||'-'||p10_app_app_id as cod_app,
                      c.cod as cod_ad,
                      b.cod as cod_cds,
                      fu_des_up_low(p10_app_des) as des_appello,
                      data_ora_app as data_esame,
                      p10_app_data_fine_iscr as data_fine_iscrizione,
                      tipo_iscr_cod as tipo_esame,
                      tipo_iscr_des as des_esame,
                      tipo_iscr_cod as tipo_prova,
                      tipo_iscr_des as des_prova,
                      tot_iscritti as numero_iscritti,
                      p10_app_cds_id||'-'||p10_app_ad_id||'-'||p10_app_app_id as ext_prg,
                      a.stu_id
            from v10_ws_app_lib_stu a
                    join p06_cds b on a.p10_app_cds_id = b.cds_id
                    join p09_ad_gen c on a.p10_app_ad_id = c.ad_id;

v_mid number(10);
v_max_mid number(10);
v_max_mid_user number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);


begin

    v_count_tot :=0;
    v_count_par :=0;
    v_count_par_sta :=0;
    v_count_par_commit :=0;

    --- Cancellazione User
    delete from ori_esami;
    delete from ori_esami_ln;
    delete from ori_esami_user;


    --- Caricamento 
    v_mid := 0;
    
    select nvl(max(mid),0) into v_max_mid from ori_esami;
    select nvl(max(mid),0) into v_max_mid_user from ori_esami_user;        

    for r_1 in c_1
    loop
           
        select nvl(max(mid), 0) into v_mid
        from ori_esami
        where cod_app = r_1.cod_app;

        if v_mid = 0
        
            then    --- appello se non presente
            
                v_max_mid := v_max_mid + 1;
            
                insert into ori_esami values
                (v_max_mid, r_1.cod_app, r_1.cod_ad, r_1.cod_cds, r_1.des_appello, r_1.data_esame, r_1.data_fine_iscrizione, r_1.tipo_esame, r_1.des_esame, r_1.tipo_prova, r_1.des_prova, r_1.numero_iscritti, r_1.ext_prg);
        
                insert into ori_esami_ln
                select v_max_mid, 'it' ln_code, r_1.des_appello, r_1.des_esame, r_1.des_prova from dual;

                insert into ori_esami_ln
                select v_max_mid, 'en' ln_code, r_1.des_appello, 
                         decode(r_1.des_prova, 'Scritto', 'Written',
                                                           'Orale', 'Oral',
                                                           'Intermedio', 'Partial',
                                                           'Scritto e orale', 'Written and Oral',
                                                           null) as des_esame, 
                         decode(r_1.des_prova, 'Scritto', 'Written',
                                                           'Orale', 'Oral',
                                                           'Intermedio', 'Partial',
                                                           'Scritto e orale', 'Written and Oral',
                                                           null) as des_prova
                  from dual;
        
        end if;

        --- inserisco associazione user
        v_max_mid_user := v_max_mid_user + 1;    

        if v_mid = 0

            then 
        
                insert into ori_esami_user values    (v_max_mid_user, v_max_mid, null, r_1.stu_id, sysdate);
        
            else 

                insert into ori_esami_user values    (v_max_mid_user, v_mid, null, r_1.stu_id, sysdate);
            
        end if;            

        
    end loop;        
        
    commit;

end;
/
