CREATE OR REPLACE procedure                  p_agg_t_utenti as

v_time_start date;
v_time_end  date;
v_step varchar2(100);

begin
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --

    begin

        v_time_start := sysdate;

            ---Eliminazione
        delete from t_utenti;

        v_time_end := sysdate;

        v_step := 'step 1';

        insert into tabella_log
          (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
        values
          (tabella_log_id.nextval,   'Pulizia Utenti',v_time_start, v_time_end,null,null,null,null, v_step);

        commit;

        v_time_start := sysdate;

        ---Inserimento
        insert into t_utenti
         select rownum,
               user_id as user_id,
               a.grp_id as grp,
               decode( tab_ana, 'P01_ANAPER', 1,
                                'DOCENTI', 2,
                                'SOGG_EST', decode (tipo_sogg_est_cod, 'ATENEO', 3,
                                                                       'ATEWEB', 3,
                                                                       0 ),
                       3
                     ) as profile,
               disable_flg as disable_flg,
               nvl(nvl(s.pers_id, d.docente_id), e.sogg_est_id) as ana_id,
               c.stu_id as stu_id,
               decode( c.stu_id, null, b.grp_name,
                                  x1.des || ' in ' ||x.des
                                  )
                    as carriera,
               initcap(nvl(nvl(s.nome, d.nome), e.nome)) as nome,
               initcap(nvl(nvl(nvl(s.cognome, d.cognome), e.cognome), user_name)) as cognome,
               nvl(nvl(m.matricola, d.matricola), sogg_est_id) as matricola,
               decode( tab_ana, 'P01_ANAPER', decode(x1.des, null, '', x1.des||' per ')||
                                              x2.des||decode(m.sta_mat_cod, 'I',' ('||x7.des||')', ''),
                                'DOCENTI', decode(x4.des, null, '', x4.des)||
                                           decode(x3.sett_cod, null, '',decode(x4.des, null, fu_des_up_low(x3.des)||' ('||x3.sett_cod||')', ' - '||fu_des_up_low(x3.des)||' ('||x3.sett_cod||')')),
                                'SOGG_EST', fu_des_up_low(b.grp_name),
                                b.grp_name
                                ) as descrizione,
               decode( tab_ana, 'P01_ANAPER', decode(x5.tipo_corso_des, null, '', x5.tipo_corso_des||' - '||fu_des_up_low(x.des)),
                                'DOCENTI', '',
                                'SOGG_EST', 'Tipo: '||tipo_sogg_est_cod)  as note,
               nvl(decode( tab_ana, 'P01_ANAPER', c.data_ini,
                                'DOCENTI', nvl(d.data_ini_att, d.data_ins),
                                'SOGG_EST', nvl(e.data_ini_att, e.data_ins)), sysdate -1)  as data_inizio,
               decode( tab_ana, 'P01_ANAPER', c.data_chiusura,
                                'DOCENTI', d.data_fin_att,
                                'SOGG_EST', null)   as data_fine,
               null as url_foto,
               null as foto_id
        from p18_user a
             join p18_grp b on a.grp_id = b.grp_id
                            --and b.TAB_ANA is not null
             left join p01_anaper s on ana_id = pers_id
                                    and tab_ana = 'P01_ANAPER'
             left join docenti d on ana_id = docente_id
                                    and tab_ana = 'DOCENTI'
             left join sogg_est e on ana_id = sogg_est_id
                                    and tab_ana = 'SOGG_EST'
             left join p01_stu c on s.pers_id = c.pers_id
             left join p04_mat m on m.stu_id = c.stu_id
                                 and (sta_mat_cod = 'A' or sta_mat_cod = 'I')
             left join p06_cds x on x.cds_id = m.cds_id
             left join stati_stu x1 on x1.sta_stu_cod = c.sta_stu_cod
             left join mot_stastu x2 on x2.mot_stastu_cod = c.mot_stastu_cod
             left join p07_sett x3 on x3.sett_cod = d.sett_cod
             left join p06_dip x4 on x4.dip_id = d.dip_id
             left join tipi_corso x5 on x5.tipo_corso_cod = x.tipo_corso_cod
             left join stati_mat x6 on x6.sta_mat_cod = m.sta_mat_cod
             left join mot_stamat x7 on x7.mot_stamat_cod = m.mot_stamat_cod
        where disable_flg = 0
        order by nvl(nvl(s.cognome, d.cognome), e.cognome);

        --- aggiornamento caso particolare
        update t_utenti set profile = 3 where grp = 12;

        v_step := 'step 2';

        v_time_end := sysdate;

        insert into tabella_log
          (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
        values
          (tabella_log_id.nextval,   'Inserimento Utenti',v_time_start, v_time_end,null,null,null,null, v_step);

        commit;

    end;

end;
/
