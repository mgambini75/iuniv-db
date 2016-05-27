CREATE OR REPLACE procedure                  p_agg_lezioni
as

cursor c1 is
select   prg_imp as mid, --rownum as mid,
           anno_acc as anno_acc,
           cda_ad as cda_ad,
           cda_classe as cda_classe,
           cda_gruppo as cda_gruppo,
           to_date(to_char(data_impegno, 'DD/MM/YYYY')||' '||ora_inizio, 'DD/MM/YYYY HH24:MI:SS') as data_inizio,
           to_date(to_char(data_impegno, 'DD/MM/YYYY')||' '||ora_fine, 'DD/MM/YYYY HH24:MI:SS') as data_fine,
           fu_des_up_low(des_ad) as des_ad,
           fu_des_up_low(des_ad_eng) as des_ad_eng,
           fu_des_up_low(des_evento_riga) as des_evento,
           a.des_note_imp as des_nota_imp,
           des_note_imp_eng as des_nota_imp_eng,
           a.des_note_ev as des_nota_eve,
           des_note_ev_eng as des_nota_eve_eng,
           b.cda_tipo_attiv as cod_tipo_att,
           b.des_tipo_attiv as des_tipo_att,
           a.des_condivisioni_logist as des_corsi,
           case when cda_classe = cda_gruppo
                then cda_classe
                else cda_classe||' - '||cda_gruppo
           end as des_patiz,
           initcap(doc_resp) as des_doc_resp,
           initcap(des_docenti) as des_docenti,
           des_aule as des_aule,
           lingua_classe as lingua_classe,
           lingua_insegn as lingua_insegn,
           prg_imp as ext_prg
    from vw_exp_orario a
         join ana_tipi_attivita b on cda_tipo_att = cda_tipo_attiv
    where data_impegno > sysdate - 60;
    
cursor studenti  (v_mid_lezione number) is
        --per ogni lezione recupero gli studneti che la devono vedere e popolo la ori_lezioni_user    
        
        select stu_id, id_user
        from ori_lezioni 
        join v_orario_lezioni_user on ori_lezioni.mid = v_orario_lezioni_user.prg_imp
        where ori_lezioni.mid = v_mid_lezione;
        
--        select stu_id, id_user
--        from v_orario_lezioni_user
--        where v_orario_lezioni_user.prg_imp = v_mid_lezione and stu_id = 1023425 ;    

v_mid_lezione number(10);
v_mid number(10);

begin

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    delete from ori_lezioni;

    delete from ori_lezioni_ln;
    
    delete from ori_lezioni_user;

    --- caricamento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for f1 in c1 loop    
    
        insert into ori_lezioni
        values (f1.mid, f1.anno_acc, f1.cda_ad, f1.cda_classe, f1.cda_gruppo, f1.data_inizio, f1.data_fine, f1.des_ad, f1.des_evento, f1.des_nota_imp, f1.des_nota_eve, f1.cod_tipo_att, f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, f1.des_aule, f1.lingua_classe, f1.lingua_insegn, f1.ext_prg);

        insert into ori_lezioni_ln
        values (f1.mid, 'it', f1.des_ad, f1.des_evento, f1.des_nota_imp, f1.des_nota_eve, f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, f1.des_aule, f1.lingua_classe, f1.lingua_insegn);

        insert into ori_lezioni_ln
        values (f1.mid, 'en', nvl(f1.des_ad_eng,f1.des_ad), f1.des_evento, nvl(f1.des_nota_imp_eng,f1.des_nota_imp), nvl(f1.des_nota_eve_eng, f1.des_nota_eve_eng), f1.des_tipo_att, f1.des_corsi, f1.des_patiz, f1.des_doc_resp, f1.des_docenti, replace (f1.DES_AULE, 'Aula', 'Room'), f1.lingua_classe, f1.lingua_insegn);
        
        
        
       --Pederzoli B. 16/12/2015
       --Per ogni lezione vado ad inserire il dettaglio degli studenti che la devono vedere
      
       v_mid_lezione := f1.mid;
       
      select max (mid) into v_mid from ori_lezioni_user;
      
      if v_mid is null then
      
         v_mid := 0;
      
      end if;
      
     
      for stu in studenti (v_mid_lezione) loop    
            
            v_mid := v_mid + 1;
    
            insert into ori_lezioni_user
            values (v_mid, v_mid_lezione, stu.id_user, stu.stu_id, sysdate); 

        end loop;
     

    end loop;
    
   
    
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- sistemazione aule
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    insert into t_aule
    select cda_ris_fissa, des_risorsa, des_edificio||' - piano '||des_piano as descrizione,
           des_edificio as des_indirizzo,
           null as lat, null as lon
    from ris_fisse a
         join ana_edifici b on a.prg_edificio = b.prg_edificio
         join ana_piani c on a.prg_piano = c.prg_piano
    where not exists (select 1 from t_aule x where a.cda_ris_fissa = x.cda_ris_fissa);


end;
/
