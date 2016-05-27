CREATE OR REPLACE PROCEDURE                  P_AGG_MOD_TAX (P_STU_ID NUMBER)
as

   --- CURSORE
   CURSOR C_0
   IS
        select a.stu_id, a.aa_iscr_id, nvl(b.data_ins, to_date('01/01/1900','dd/mm/yyyy')) as data_ins
        from p04_iscr_ann a
                left join tax_sit_anni b on a.stu_id = b.stu_id
                                                 and a.aa_iscr_id = B.AA_ISCR_ID
        where a.stu_id = p_stu_id
        and sta_iscr_cod <> 'X'
        order by aa_iscr_id;



   --- CURSORE
   CURSOR C_1 (v_stu_id number, v_aa_iscr_id number)
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
        where stu_id = v_stu_id
        and aa_iscr_id = v_aa_iscr_id
        and sta_iscr_cod <> 'X';


   --- CURSORE
   CURSOR C_2 (v_stu_id number, v_aa_iscr_id number)
   IS
        select rownum mid, stu_id, aa_id as aa_iscr_id, a.fatt_id,
               'Doc. '||nvl(fatt_cod, decode(a.fatt_id, 0, 'ND', to_char(a.fatt_id)))  as des_gruppo,
                b.des as des_tassa,
                c.des as des_voce,
                d.des as des_rata,
                importo_voce as importo,
                a.data_scadenza as dat_scad,
                f.data_pagamento as dat_pag
        from p05_tax_stu a
             join p05_tax b on a.tassa_id = b.tassa_id
             join p05_voci c on a.voce_id = c.voce_id
             join p05_rate d on a.rata_id = d.rata_id
             join p05_fatt e on a.fatt_id = e.fatt_id
             left join p05_pag f on a.fatt_id = f.fatt_id
        where stu_id = v_stu_id
        and aa_id = v_aa_iscr_id
        and annullata_flg = 0
        and a.fatt_id <> 0;

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


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- procedura per il caricamento dei dati delle tasse TAX_SIT_ANNI
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    v_aggiorno :=0;

    v_time_start := sysdate;

    v_step := to_char(p_stu_id);

            FOR R_0 IN C_0
            LOOP

                IF r_0.AA_ISCR_ID < TO_CHAR(SYSDATE, 'yyyy') - 3 and r_0.data_ins < sysdate - 30

                    then  v_aggiorno :=1;

                    else

                        if  r_0.AA_ISCR_ID >= TO_CHAR(SYSDATE, 'yyyy') - 3 and r_0.data_ins < sysdate - 1

                            then  v_aggiorno :=1;

                            else  v_aggiorno :=0;

                        end if;

                end if;


                if v_aggiorno = 1

                    then

                        --- eliminazione dati presenti
                        delete from tax_sit_anni_ln
                        where mid in (select mid from tax_sit_anni where stu_id = r_0.stu_id and aa_iscr_id = r_0.aa_iscr_id);

                        delete from tax_sit_anni where stu_id = r_0.stu_id and aa_iscr_id = r_0.aa_iscr_id;

                        delete from tax_sit_dett_ln
                        where mid in (select mid from tax_sit_dett where stu_id = r_0.stu_id and aa_iscr_id = r_0.aa_iscr_id);

                        delete from tax_sit_dett  where stu_id = r_0.stu_id and aa_iscr_id = r_0.aa_iscr_id;

                        --- caricamento dati presenti TAX_SIT_ANNI
                        select nvl(max(mid),0) into v_mid from    tax_sit_anni;

                        FOR R_1 IN C_1 (r_0.stu_id, r_0.aa_iscr_id)
                        LOOP

                            v_mid := v_mid + 1;

                            insert into tax_sit_anni  (mid, stu_id, aa_iscr_id, titolo, descrizione, semaforo, note, data_ins)
                            values    (v_mid, r_1.stu_id, r_1.aa_iscr_id, r_1.titolo, r_1.descrizione, r_1.semaforo, r_1.note, sysdate);

                            insert into tax_sit_anni_ln (mid, ln_code, titolo, descrizione, note)
                            values (v_mid, 'it', r_1.titolo, r_1.descrizione, r_1.note);

                            insert into tax_sit_anni_ln (mid, ln_code, titolo, descrizione, note)
                            values (v_mid, 'en', r_1.titolo, r_1.descrizione, r_1.note);

                        END LOOP;

                        --- caricamento dati presenti TAX_SIT_DETT
                        select nvl(max(mid),0) into v_mid from tax_sit_dett;

                        FOR R_2 IN C_2 (r_0.stu_id, r_0.aa_iscr_id)
                        LOOP

                            v_mid := v_mid + 1;

                            insert into tax_sit_dett  (mid, stu_id, aa_iscr_id, fatt_id, des_gruppo, des_tassa, des_voce, des_rata, importo, dat_scad, dat_pag, data_ins)
                            values    (v_mid, r_2.stu_id, r_2.aa_iscr_id, r_2.fatt_id, r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata, r_2.importo, r_2.dat_scad, r_2.dat_pag, sysdate );

                            insert into tax_sit_dett_ln (mid, ln_code, des_gruppo, des_tassa, des_voce, des_rata)
                            values (v_mid, 'it', r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata);

                            insert into tax_sit_dett_ln (mid, ln_code, des_gruppo, des_tassa, des_voce, des_rata)
                            values (v_mid, 'en', r_2.des_gruppo, r_2.des_tassa, r_2.des_voce, r_2.des_rata);

                        END LOOP;


                end if;

            END LOOP;

            v_time_end := sysdate;

           IF v_aggiorno = 1

                THEN

                        Insert Into TABELLA_LOG
                          (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                        Values
                          (TABELLA_LOG_ID.Nextval,   'Aggiornamento Tasse',v_time_start, v_time_end,null,null,null,null, v_step);

                ELSE

                        Insert Into TABELLA_LOG
                          (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                        Values
                          (TABELLA_LOG_ID.Nextval,   'NO Aggiornamento Tasse',v_time_start, v_time_end,null,null,null,null, v_step);

            END IF;

    commit;

end;
/
