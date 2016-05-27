CREATE OR REPLACE PROCEDURE p_agg_libretto_stu (p_stu_id number)
as

   --- CURSORE
   cursor c_0
   is
        select adsce_id as mid,
                   a.stu_id,
                   a.cod as cod_ad,
                   fu_des_up_low(a.des) as des_ad_ita,
                   fu_des_up_low(nvl(g.DS_AD_DES, a.des)) as des_ad_eng,
                   a.anno_corso,
                   nvl(e.des2, 'nd') as des_anno,
                   a.peso,
                   a.peso||decode(f.um_peso_cod, 'A', ' Annualità',
                                                 'C', ' Cfu',
                                                 f.um_peso_cod ) as des_peso,
                   a.tipo_ins_cod as cod_tipo_ins,
                   d.des as des_tipo_ins,
                   a.sta_sce_cod as cod_stato,
                   decode( a.sta_sce_cod, 'P', 'In piano',
                                          'F', 'Frequentata',
                                          'S', 'Superata') as des_stato,
                   a.voto,
                   a.lode_flg,
                   a.tipo_giud_cod,
                   decode ( a.voto, null,c.des, to_char(a.voto)|| decode(a.lode_flg, 0, '', 1, ' e lode')) as des_voto,
                   trunc(a.data_sup) as data_sup,
                   a.aa_sup_id
            from p11_ad_sce a
                 join p04_mat b on b.mat_id = a.mat_id and b.sta_mat_cod = 'A'
                 left join tipi_giudizio c on a.tipo_giud_cod = c.tipo_giud_cod
                 left join tipi_ins d on a.tipo_ins_cod = d.tipo_ins_cod
                 left join tipi_anno e on to_char(a.anno_corso) = e.anno_cod
                 join p06_cds f on f.cds_id = a.cds_id
                 left join p09_ad_des_lin g on g.ad_id = a.ad_id and g.lingua_id = 1
           where a.stu_id = p_stu_id;

   cursor c_1
   is
        select * from v_epi_replica_stu_dat_carr
        where stu_id = p_stu_id;

v_mid number(9);
v_data_controllo date;

begin

    select nvl(max(data_ins), sysdate - 2) into v_data_controllo
    from lib_studente_crusc  where stu_id = p_stu_id;


    if  v_data_controllo < sysdate - 1

        then

            --- eliminazione dati
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
            delete from lib_studente_ln where mid in (select mid from lib_studente where stu_id = p_stu_id);

            delete from lib_studente where stu_id = p_stu_id;

            delete from lib_studente_crusc where stu_id = p_stu_id;

            --- inserimento dati
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
            for r_0 in c_0
            loop

                v_mid := v_mid + 1;

                insert into lib_studente  (mid, stu_id, cod_ad, des_ad, anno_corso, des_anno, peso, des_peso, cod_tipo_ins, des_tipo_ins, cod_stato, des_stato, voto, lode_flg, tipo_giud_cod, des_voto, data_sup, aa_sup_id)
                values    (r_0.mid, r_0.stu_id, r_0.cod_ad, r_0.des_ad_ita, r_0.anno_corso, r_0.des_anno, r_0.peso, r_0.des_peso, r_0.cod_tipo_ins, r_0.des_tipo_ins, r_0.cod_stato, r_0.des_stato, r_0.voto, r_0.lode_flg, r_0.tipo_giud_cod, r_0.des_voto,r_0.data_sup, r_0.aa_sup_id);

                insert into lib_studente_ln (mid, ln_code, des_ad, des_anno, des_peso, des_tipo_ins,des_stato,des_voto )
                select r_0.mid, 'it' as ln_code, r_0.des_ad_ita, r_0.des_anno,
                       decode( r_0.des_peso, '1 Annualità', 'Una Annualità',
                                         ',5 Annualità', 'Mezza Annualità',
                                         '0 Annualità', 'Nessuna Annualità',
                                         ' Annualità', 'Nessuna Annualità',
                                         r_0.des_peso ) as des_peso,
                       r_0.des_tipo_ins, r_0.des_stato, r_0.des_voto
                from dual;


                insert into lib_studente_ln (mid, ln_code, des_ad, des_anno, des_peso, des_tipo_ins,des_stato,des_voto )
                select r_0.mid, 'en' as ln_code,
                       r_0.des_ad_eng,
                       decode(r_0.des_anno, 'Primo','First',
                                                        'Secondo','Second',
                                                        'Terzo','Third',
                                                        r_0.des_anno) as des_anno,
                       decode( r_0.des_peso, '1 Annualità', 'One Annuity',
                                                         ',5 Annualità', 'Half Annuity',
                                                         '0 Annualità', 'No Annuity',
                                                         ' Annualità', 'No Annuity',
                                                         r_0.des_peso ) as des_peso,
                       decode( r_0.des_tipo_ins, 'Altro Insegnamento','Other teaching',
                                                             'Caratteriz. corso di laurea','Characterizing couse',
                                                             'Caratteriz. opzionale','Characterizing elective course',
                                                             'Fondamentale','Fundamental',
                                                             'Obblig. a scelta','Compulsory course chosen',
                                                             'Obblig. base comune','Compulsory course',
                                                             'Obblig. di curriculum','Curriculum compulsory course',
                                                             'Obblig. di curriculum a scelta','Curriculum compulsory course chosen',
                                                             'Obbligatorio','Compulsory',
                                                             'Opzionale','Elective course',
                                                             'Precorso','Pre-course',
                                                             'Rosa Ristretta','Shortlist',
                                                             'obbligatorio d''indirizzo', 'Curriculum compulsory',
                                                             'Obbligatorio di indirizzo', 'Curriculum compulsory',
                                                             'Altra attività formativa', 'Other teaching',
                                                             'Debito Formativo', 'Educational debt',
                                                             'Fittizio', 'Dummy',
                                                              r_0.des_tipo_ins
                                                             ) as des_tipo_ins,
                       decode(r_0.des_stato, 'Superata','Exceeded',
                                                         'Frequentata','Attended',
                                                         'In piano','Flat',
                                                         r_0.des_anno) as des_stato,
                       decode(r_0.des_voto, 'IDONEO', 'Suitable',
                                                        '30 e lode', '30 laude',
                                                        'Approvato',  'Approved',
                                                        'Buono', 'Good',
                                                        'Ottimo', 'Excellent',
                                                        'Distinto', 'Discrete',
                                                        'Sufficiente','Sufficient',
                                                        r_0.des_voto) as des_voto
                from dual;

            end loop;

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            for r_1 in c_1
            loop

                insert into lib_studente_crusc (mid, stu_id, pers_id, matricola, tipo_media_cod, num_esami, media_accademica, cfu_maturati, num_ad_pianif, cfu_ad_pianif, num_esa_sup, num_esa_no_sup, cfu_piano, data_ins)
                select r_1.stu_id, r_1.stu_id, r_1.pers_id, r_1.matricola, r_1.tipo_media_cod, r_1.num_esami, r_1.media_accademica, r_1.cfu_maturati, r_1.num_ad_pianif, r_1.cfu_ad_pianif, r_1.num_esa_sup, r_1.num_esa_no_sup, r_1.cfu_piano, sysdate
                from dual;

            end loop;

    end if;

end;

/
