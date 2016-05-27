CREATE OR REPLACE PROCEDURE                  p_agg_tasse (p_aa_id number)
as

   --- CURSORE
   CURSOR C_1
   IS
        select rownum mid,
               stu_id,
               aa_iscr_id,
               b.des||' ['||tipo_corso_cod||']' as titolo,
               'Iscr. '||anno_corso||' Anno ['||c.des||decode(a.tipo_iscr_cod, 'IC', ']',' al '||anni_fc||'° anno]') as descrizione,
               pkg05.f_semaforo_tasse ( stu_id, sysdate, aa_iscr_id, null, null ) as semaforo,
               cast( null as varchar2(4000)) as note
        from p04_iscr_ann a
             join p06_cds b on a.cds_id = b.cds_id
             join tipi_iscr_ann c on a.tipo_iscr_cod = c.tipo_iscr_cod
        where sta_iscr_cod <> 'X'
        and aa_iscr_id = p_aa_id;


   --- CURSORE
   CURSOR C_2
   IS
        select rownum mid, stu_id, aa_id as aa_iscr_id, a.fatt_id,
               'Doc. '||nvl(fatt_cod, decode(a.fatt_id, 0, 'ND', to_char(a.fatt_id)))  as des_gruppo,
                b.des as des_tassa,
                c.des as des_voce,
                d.des as des_rata,
                importo_voce as importo,
                e.data_scadenza as dat_scad,
                f.data_pagamento as dat_pag
        from p05_tax_stu a
             join p05_tax b on a.tassa_id = b.tassa_id
             join p05_voci c on a.voce_id = c.voce_id
             join p05_rate d on a.rata_id = d.rata_id
             join p05_fatt e on a.fatt_id = e.fatt_id
             left join p05_pag f on a.fatt_id = f.fatt_id
        where annullata_flg = 0
        and aa_id = p_aa_id;


v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);


begin


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- procedura per il caricamento dei dati delle tasse TAX_SIT_ANNI
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --execute Immediate 'alter session set optimizer_mode = RULE';


    v_time_start := sysdate;

        delete from tax_sit_anni_ln
        where mid in (select mid from tax_sit_anni where aa_iscr_id = p_aa_id);

        commit;

        delete from tax_sit_anni where aa_iscr_id = p_aa_id;

        commit;

    v_time_end := sysdate;

    v_step := 'TAX step 1 - '||p_aa_id;

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. Tasse '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    select max(mid) into v_mid from    tax_sit_anni;

       FOR R_1 IN C_1
       LOOP

            v_mid := v_mid + 1;

            insert into tax_sit_anni  (mid, stu_id, aa_iscr_id, titolo, descrizione, semaforo, note)
            values    (v_mid, r_1.stu_id, r_1.aa_iscr_id, r_1.titolo, r_1.descrizione, r_1.semaforo, r_1.note);

            insert into tax_sit_anni_ln (mid, ln_code, titolo, descrizione, note)
            values (v_mid, 'it', r_1.titolo, r_1.descrizione, r_1.note);

            insert into tax_sit_anni_ln (mid, ln_code, titolo, descrizione, note)
            values (v_mid, 'en', r_1.titolo, r_1.descrizione, r_1.note);

        dbms_application_info.set_client_info ('Righe trattate '||v_mid);

        if v_count_par_commit = 100

           then

            commit;

            v_count_par_commit := 0;

        end if;

        commit;




       END LOOP;

        commit;

    v_time_end := sysdate;

    v_step := 'TAX step 2 - '||p_aa_id;

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Ins. Tasse '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- procedura per il caricamento dei dati delle tasse TAX_SIT_DETT
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    v_time_start := sysdate;

        delete from tax_sit_dett_ln
        where mid in (select mid from tax_sit_dett
                             where aa_iscr_id = p_aa_id);

        commit;

        delete from tax_sit_dett
        where aa_iscr_id = p_aa_id;

        commit;

    v_time_end := sysdate;

    v_step := 'TAX step 3 - '||p_aa_id;

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. Tasse Dett. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    select max(mid) into v_mid from tax_sit_dett;

       FOR R_2 IN C_2
       LOOP

            v_mid := v_mid + 1;

            insert into tax_sit_dett  (mid, stu_id, aa_iscr_id, fatt_id, des_gruppo, des_tassa, des_voce, des_rata, importo, dat_scad, dat_pag)
            values    (v_mid, r_2.stu_id, r_2.aa_iscr_id, r_2.fatt_id, r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata, r_2.importo, r_2.dat_scad, r_2.dat_pag );

            insert into tax_sit_dett_ln (mid, ln_code, des_gruppo, des_tassa, des_voce, des_rata)
            values (v_mid, 'it', r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata);

            insert into tax_sit_dett_ln (mid, ln_code, des_gruppo, des_tassa, des_voce, des_rata)
            values (v_mid, 'en', r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata);

        dbms_application_info.set_client_info ('Righe trattate '||v_mid);

        if v_count_par_commit = 100

           then

            commit;

            v_count_par_commit := 0;

        end if;

        commit;

       END LOOP;

        commit;

        v_time_end := sysdate;

        v_step := 'TAX step 4 - '||p_aa_id;

        insert into tabella_log
          (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
        values
          (tabella_log_id.nextval,   'Ins. Tasse Dett. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

        commit;

end;
/
