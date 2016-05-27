CREATE OR REPLACE PROCEDURE                  UNIXX_GOL_INSERT (p_aa_id number)
as
---------------------------------------------------------------------------------
--- CALCOLO DEGLI ID
--- NOTE:
---------------------------------------------------------------------------------
---
---------------------------------------------------------------------------------

   --- CURSORE
   cursor c_1
   is   select mid from gol_liv a
        where ordine is null
        order by mid_liv_padre, name;

   cursor c_2
   is   select mid from gol_liv a
        where ordine is null
        order by mid_liv_padre, name;

   cursor c_3
   is   select mid from gol_liv a
        where ordine is null
        order by mid_liv_padre, code desc;

   cursor c_4
   is   select mid from gol_liv a
        where ordine is null
        order by mid_liv_padre, name;

v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_conta number(9);

begin

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- pulizia relativa all'anno che sto trasferendo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    v_time_start := sysdate;

        delete gol_liv_ln where mid in (select mid from gol_liv where aa_id = p_aa_id);

        delete gol_liv where aa_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 1';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_ln where mid in (select mid from gol_ad where aa_off_id = p_aa_id);

        delete gol_ad where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 2';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_mod_ln where mid in (select mid from gol_ad_mod where aa_off_id = p_aa_id);

        delete gol_ad_mod where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 3';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_mod_doc_ln where mid in (select mid from gol_ad_mod_doc where aa_off_id = p_aa_id);

        delete gol_ad_mod_doc where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 4';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_cla_ln  where mid in (select mid from gol_ad_cla where aa_off_id = p_aa_id);

        delete gol_ad_cla where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 5';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_cla_doc_ln where mid in (select mid from gol_ad_cla_doc where aa_off_id = p_aa_id);

        delete gol_ad_cla_doc where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 6';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

        delete gol_ad_doc_ln where mid in (select mid from gol_ad_doc where aa_off_id = p_aa_id);

        delete gol_ad_doc where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 7';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Can. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;


     v_time_start := sysdate;
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- PRIMO LIVELLO -- 35 RIGHE
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    insert into gol_liv
    select a.mid_liv_1 as mid,
           cod as code,
           fu_des_up_low(b.des) as name,
           initcap(decode(via, null, '', via||', ')||citta) as description,
           null as mid_liv_padre,
           null as mid_dett,
           aa_off_id as aa_id,
           null as ordine
    from GOL_IUNI a
         join p06_fac b on a.fac_id = b.fac_id
    where aa_off_id = p_aa_id
    group by a.mid_liv_1, a.aa_off_id, b.cod, b.des, initcap(decode(via, null, '', via||', ')||citta)
    order by a.mid_liv_1;

    --- gestione dell'ordinamento per descrizione
    v_conta := 0;

    for r_1 in c_1
    loop

        v_conta := v_conta + 1;

        update gol_liv
        set ordine = v_conta
        where mid = r_1.mid;


    end loop;

    v_time_end := sysdate;

    v_step := 'step 1';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    -- SECONDO LIVELLO -- 317 RIGHE
    insert into gol_liv
    select a.mid_liv_2 as mid,
           cod as code,
           fu_des_up_low(b.des) as name,
           '['||cod||'] - '||fu_des_up_low(c.tipo_corso_des)||' - Sede: '||upper(b2.des) as description,
           a.mid_liv_1 as mid_liv_padre,
           null as mid_dett,
           aa_off_id as aa_id,
           null
    from GOL_IUNI a
         join p06_cds b on a.cds_id = b.cds_id
         left join p06_sedi_cds b1 on b.cds_id = b1.cds_id and b1.def_did_flg = 1
         left join p06_sedi b2 on b1.sede_id = b2.sede_id
         join tipi_corso c on b.tipo_corso_cod = c.tipo_corso_cod
    where aa_off_id = p_aa_id
    group by a.mid_liv_1, a.aa_off_id, a.mid_liv_2, b.cod, b.des, c.tipo_corso_cod, c.tipo_corso_des, b2.des
    order by a.mid_liv_2;

    --- gestione dell'ordinamento per descrizione
    v_conta := 0;

    for r_2 in c_2
    loop

        v_conta := v_conta + 1;

        update gol_liv
        set ordine = v_conta
        where mid = r_2.mid;

    end loop;

    v_time_end := sysdate;

    v_step := 'step 2';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    -- TERZO LIVELLO -- 355 RIGHE
    insert into gol_liv
    select a.mid_liv_3 as mid,
           b.aa_ord_id||'/'||c.pds_id||'/'||c.cod as code,
           'Ind: '||fu_des_up_low(c.des)  as name,
           'Ordinamento: '||b.aa_ord_id||' - '||c.cod  as description,
           a.mid_liv_2 as mid_liv_padre,
           null as mid_dett,
           a.aa_off_id as aa_id,
           null
    from GOL_IUNI a
         join p06_cdsord b on a.cds_id = b.cds_id
                           and  a.aa_ord_id = b.aa_ord_id
         join p06_pdsord c on a.cds_id = c.cds_id
                           and  a.aa_ord_id = c.aa_ord_id
                           and  a.pds_id = c.pds_id
    where mid_liv_3 is not null
    and aa_off_id = p_aa_id
    group by a.mid_liv_1, a.mid_liv_2, a.mid_liv_3, b.aa_ord_id, c.cod, a.aa_off_id, c.des,
             a.cds_id, c.pds_id
    order by a.mid_liv_1, a.mid_liv_2, b.aa_ord_id desc, c.pds_id;

    --- gestione dell'ordinamento per descrizione
    v_conta := 0;

    for r_3 in c_3
    loop

        v_conta := v_conta + 1;

        update gol_liv
        set ordine = v_conta
        where mid = r_3.mid;

    end loop;

    v_time_end := sysdate;

    v_step := 'step 3';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    -- ULTIMO LIVELLO
    insert into gol_liv
    select a.mid_liv_4 as mid,
           b.cod as code,
           fu_des_up_low(b.des) as name,
           'lista docenti...' as description,
           nvl(a.mid_liv_3, a.mid_liv_2) as mid_liv_padre,
           mid_ad as mid_dett,
           a.aa_off_id as aa_id,
           null
    from GOL_IUNI a
         join p09_ad_gen b on a.ad_id = b.ad_id
    where mid_liv_4 is not null
    and aa_off_id = p_aa_id
    group by a.aa_off_id, a.mid_liv_1, a.mid_liv_2, a.mid_liv_3, a.mid_liv_4, b.des, b.cod, mid_ad
    order by a.mid_liv_1, a.mid_liv_2,  b.des;

    --- gestione dell'ordinamento per descrizione
    v_conta := 0;

    for r_4 in c_4
    loop

        v_conta := v_conta + 1;

        update gol_liv
        set ordine = v_conta
        where mid = r_4.mid;

    end loop;

    v_time_end := sysdate;

    v_step := 'step 4';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- GESTIONE DELL'ORDINAMENTO
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---






    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    insert into gol_ad
    select distinct
           a.mid_ad as mid,
           a.des_cds as percorso,
           a.des_ad as attivita,
           null as descrizione,
           null as metodi_did_des,
           null as obiett_form_des,
           null as prerequisiti_des,
           null as contenuti_des,
           null as testi_rif_des,
           null as mod_ver_appr_des,
           null as altre_info_des,
           sum(a.peso_tot) as peso,
           'Convenzionale in italiano' as struttura_cfu,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           null as ext_id
    from GOL_IUNI a
    where aa_off_id = p_aa_id
    group by a.mid_ad,
           a.des_cds,
           a.des_ad,
           a.cds_id,
           a.ad_id,
           a.aa_off_id,
           a.aa_ord_id,
           a.pds_id ;

    v_time_end := sysdate;

    v_step := 'step 5';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    UNIXX_descrizione_ad(p_aa_id);

    v_time_end := sysdate;

    v_step := 'step 6';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    delete from t_gol_ad_descrizioni_tutte;

    insert into t_gol_ad_descrizioni_tutte
    (
       MID,
       CDS_ID,
       AD_ID,
       AA_OFF_ID,
       AA_ORD_ID,
       PDS_ID,
       FAT_PART_COD,
       DOM_PART_COD,
       PART_COD,
       AD_LOG_ID,
       METODI_DID_DES,
       OBIETT_FORM_DES,
       PREREQUISITI_DES,
       CONTENUTI_DES,
       TESTI_RIF_DES,
       MOD_VER_APPR_DES,
       ALTRE_INFO_DES
)
    select
       MID,
       CDS_ID,
       AD_ID,
       AA_OFF_ID,
       AA_ORD_ID,
       PDS_ID,
       FAT_PART_COD,
       DOM_PART_COD,
       PART_COD,
       AD_LOG_ID,
       METODI_DID_DES,
       OBIETT_FORM_DES,
       PREREQUISITI_DES,
       CONTENUTI_DES,
       TESTI_RIF_DES,
       MOD_VER_APPR_DES,
       ALTRE_INFO_DES
     from v_gol_ad_descrizioni_tutte;


    delete from t_gol_ad_descrizioni;

    insert into t_gol_ad_descrizioni
    select *
    from t_gol_ad_descrizioni_tutte
    where mid not in (  select mid
                          from t_gol_ad_descrizioni_tutte
                      group by mid
                        having count (*) > 1);


    --- PULIZIA
    update t_gol_ad_descrizioni
    set obiett_form_des = substr(obiett_form_des, 1, 3700)
    where length(obiett_form_des) > 3000;

    update t_gol_ad_descrizioni
    set contenuti_des = substr(contenuti_des, 1, 3700)
    where length(contenuti_des) > 3000;


    --- METODI_DID_DES = '<strong>Metodi didattici ???</strong><br/>'
    update gol_ad a
    set metodi_did_des = (select '<strong>Metodi didattici </strong><br/>
    '||b.metodi_did_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  metodi_did_des is not null)
    and aa_off_id = p_aa_id     ;

    v_time_end := sysdate;

    v_step := 'step 7';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---     OBIETT_FORM_DES = '<strong>Obiettivi ???</strong><br/>'
    update gol_ad a
    set obiett_form_des = (select distinct '<strong>Obiettivi </strong><br/>
    '||b.obiett_form_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  obiett_form_des is not null)
    and aa_off_id = p_aa_id     ;

    v_time_end := sysdate;

    v_step := 'step 8';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---     PREREQUISITI_DES = '<strong>Prerequisiti ???</strong><br/>'
    update gol_ad a
    set prerequisiti_des = (select distinct '<strong>Prerequisiti </strong><br/>
    '||b.prerequisiti_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  prerequisiti_des is not null)
    and aa_off_id = p_aa_id     ;

    v_time_end := sysdate;

    v_step := 'step 9';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---    CONTENUTI_DES = '<strong>Contenuti ???</strong><br/>'
    update gol_ad a
    set contenuti_des = (select distinct '<strong>Contenuti </strong><br/>
    '||replace(b.contenuti_des, '  ', ' ')||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni  where  contenuti_des is not null )
    and aa_off_id = p_aa_id     ;

    v_time_end := sysdate;

    v_step := 'step 10';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---    TESTI_RIF_DES = '<strong>testi di riferimento ???</strong><br/>'
    update gol_ad a
    set testi_rif_des = (select distinct '<strong>Testi di riferimento </strong><br/>
    '||b.testi_rif_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  testi_rif_des is not null);

    v_time_end := sysdate;

    v_step := 'step 11';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---    MOD_VER_APPR_DES = '<strong>Modalita di apprendimento ???</strong><br/>'
    update gol_ad a
    set mod_ver_appr_des = (select distinct '<strong>Modalita di apprendimento </strong><br/>
    '||b.mod_ver_appr_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  mod_ver_appr_des is not null
    and aa_off_id = p_aa_id     );

    v_time_end := sysdate;

    v_step := 'step 12';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---    ALTRE_INFO_DES = '<strong>Altre info ???</strong><br/>'
    update gol_ad a
    set altre_info_des = (select distinct '<strong>Altre info </strong><br/>
    '||b.altre_info_des||'<br/><br/>'
                          from t_gol_ad_descrizioni b
                          where a.mid = b.mid )
    where mid in (select mid from t_gol_ad_descrizioni where  altre_info_des is not null)
    and aa_off_id = p_aa_id     ;

    v_time_end := sysdate;

    v_step := 'step 13';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD_CLA
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    insert into gol_ad_cla
    select distinct
           a.mid_ad_cla as mid,
           a.mid_ad as mid_ad,
           a.des_cds as percorso,
           a.des_ad as attivita,
           decode(a.fat_part_cod, 'N0', 'Nessun Partiz..',b.des)||'  ['||initcap(sede_des)||']' as classe,
           ' ' as descrizione,
           null as info_sem_classe,
           null as info_aule_edifici,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           a.dom_part_cod as dom_part_cod,
           a.cod_cds as cod_corso,
           null as cod_percorso,
           a.cod_ad as cod_ad,
           a.fat_part_cod as fat_part_cod
    from GOL_IUNI a
         join dom_part b on a.fat_part_cod = b.fat_part_cod
                         and a.dom_part_cod = b.dom_part_cod
    where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 14';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    update gol_ad_cla a
    set info_sem_classe = (select  min(des_part) from GOL_IUNI b where a.mid = b.mid_ad_cla)
    where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 15';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    update  gol_ad_cla a
    set  info_sem_classe = 'Annuale'
    where info_sem_classe is null
    and aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 16';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD_MOD
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    insert into gol_ad_mod
    select distinct
           a.mid_ad_mod as mid,
           a.mid_ad as mid_ad,
           a.des_cds as percorso,
           a.des_ad as attivita,
           a.des_mod as modulo,
           null as descrizione,
            '<strong>Metodi didattici ???</strong><br/>' as metodi_did_des,
            '<strong>Obiettivi ???</strong><br/>' as obiett_form_des,
             '<strong>Prerequisiti ???</strong><br/>' as prerequisiti_des,
            '<strong>Contenuti ???</strong><br/>' as contenuti_des,
            '<strong>Testi di riferimento ???</strong><br/>' as testi_rif_des,
           '<strong>Modalita di apprendimento ???</strong><br/>' as mod_ver_appr_des,
            '<strong>Altre info ???</strong><br/>' as altre_info_des,
           null as peso,
           null as struttura_cfu,
           null as info_sem_classe,
           'Info aule ???' as info_aule_edifici,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           a.ud_id as ud_id,
           a.cod_cds as cod_corso,
           null as cod_percorso,
           a.cod_ad as cod_ad,
           a.cod_mod as cod_mod
    from GOL_IUNI a
    where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 17';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    update gol_ad_mod a
    set info_sem_classe = (select min(des_part) from GOL_IUNI b where a.mid = b.mid_ad_mod)
    where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 18';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    update gol_ad_mod a
    set info_sem_classe = 'Annuale'
    where info_sem_classe is null
    and aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 19';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    update gol_ad_mod a
    set info_aule_edifici = (select 'Ore '||sum(dur_uni_val) from GOL_IUNI b where a.mid = b.mid_ad_mod)
    where aa_off_id = p_aa_id;

    v_time_end := sysdate;

    v_step := 'step 20';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    UNIXX_struttura_cfu_ad_mod(p_aa_id);

    v_time_end := sysdate;

    v_step := 'step 21';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD_DOC

    insert into gol_ad_doc
    select distinct
           a.mid_ad_doc as mid,
           b.mid as mid_doc,
           mid_ad as mid_ad,
           a.des_cds as percorso,
           a.des_ad as attivita,
           decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome as docente,
           matricola as cod_matr_doc,
           max(titolare_flg) as titolare,
           decode(des_appellativo, null, '',des_appellativo||' ')||
           nome||' '||
           cognome--||
           --DECODE(DES, NULL, '',' ('||DES||')')
           as nominativo_docente,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           a.docente_id as docente_id
    from GOL_IUNI a
         join t_docenti b on a.docente_id = b.docente_id
         left join tipi_copertura c on a.tipo_copertura_cod = c.tipo_copertura_cod
    where aa_off_id = p_aa_id
    group by a.mid_ad_doc, b.mid, mid_ad, a.des_cds, a.des_ad,
             decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome,
             matricola,
             a.cds_id,
             a.ad_id,
             a.aa_off_id,
             a.aa_ord_id,
             a.pds_id,
             a.docente_id;

    v_time_end := sysdate;

    v_step := 'step 22';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD_CLA_DOC

    insert into gol_ad_cla_doc
    select distinct
           mid_ad_cla_doc as mid,
           mid_ad_cla as mid_ad_cla,
           b.mid as mid_doc,
           a.des_cds as percorso,
           a.des_ad as attivita,
           c.des as classe,
           decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome as docente,
           matricola as cod_matr_doc,
           max(titolare_flg) as titolare,
           decode(des_appellativo, null, '',des_appellativo||' ')||
            nome||' '||
            cognome--||
            --DECODE(DES, NULL, '',' ('||D.DES||')')
            as nominativo_docente,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           null as dom_part_cod,
           a.docente_id as docente_id
    from GOL_IUNI a
         join t_docenti b on a.docente_id = b.docente_id
         join dom_part c on a.fat_part_cod = c.fat_part_cod
                         and a.dom_part_cod = c.dom_part_cod
         left join tipi_copertura d on a.tipo_copertura_cod = d.tipo_copertura_cod
    where aa_off_id = p_aa_id
    group by  mid_ad_cla_doc,
              mid_ad_cla,
              b.mid,
              a.des_cds,
              a.des_ad,
              c.des,
              decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome,
              matricola,
              a.cds_id,
              a.ad_id,
              a.aa_off_id,
              a.aa_ord_id,
              a.pds_id,
              a.docente_id;

    v_time_end := sysdate;

    v_step := 'step 23';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- INSERIMENTO GOL_AD_MOD_DOC
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    delete from gol_ad_mod_doc;

    insert into gol_ad_mod_doc
    select distinct
           mid_ad_mod_doc as mid,
           mid_ad_mod as mid_ad_mod,
           b.mid as mid_doc,
           a.des_cds as percorso,
           a.des_ad as attivita,
           a.des_mod as modulo,
           decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome as docente,
           matricola as cod_matr_doc,
           max(titolare_flg) as titolare,
           decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome as nominativo_docente,
           a.cds_id as cds_id,
           a.ad_id as ad_id,
           a.aa_off_id as aa_off_id,
           a.aa_ord_id as aa_ord_id,
           a.pds_id as pds_id,
           a.ud_id as ud_id,
           a.docente_id as docente_id
    from GOL_IUNI a
         join t_docenti b on a.docente_id = b.docente_id
    where aa_off_id = p_aa_id
    group by mid_ad_mod_doc,
             mid_ad_mod,
             b.mid,
             a.des_cds,
             a.des_ad,
             a.des_mod,
             decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome,
             matricola,
             decode(des_appellativo, null, '',des_appellativo||' ')||nome||' '||cognome,
             a.cds_id,
             a.ad_id,
             a.aa_off_id,
             a.aa_ord_id,
             a.pds_id,
             a.ud_id,
             a.docente_id;

    v_time_end := sysdate;

    v_step := 'step 24';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    ---
    UNIXX_description_liv (p_aa_id);

    v_time_end := sysdate;

    v_step := 'step 25';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- ALL
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    delete from gol_liv_ln;

    delete from gol_ad_ln;

    delete from gol_ad_mod_ln;

    delete from gol_ad_cla_ln;

    delete from gol_ad_doc_ln;

    delete from gol_ad_mod_doc_ln;

    delete from gol_ad_cla_doc_ln;

    v_time_end := sysdate;

    v_step := 'step 26';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    insert into gol_liv_ln
    select mid, 'it' ln_code, name, description
    from gol_liv;

    insert into gol_ad_ln
    select mid, 'it' ln_code, percorso, attivita, descrizione, metodi_did_des, obiett_form_des, prerequisiti_des, contenuti_des, testi_rif_des, mod_ver_appr_des, altre_info_des, struttura_cfu
    from gol_ad;

    insert into gol_ad_cla_ln
    select mid, 'it' ln_code, percorso, attivita, classe, descrizione, info_sem_classe, info_aule_edifici
    from gol_ad_cla;

    insert into gol_ad_doc_ln
    select mid, 'it' ln_code, percorso, attivita, docente
    from gol_ad_doc;

    insert into gol_ad_mod_ln
    select mid, 'it' ln_code, percorso, attivita, modulo, descrizione, metodi_did_des, obiett_form_des, prerequisiti_des, contenuti_des, testi_rif_des, mod_ver_appr_des, altre_info_des, struttura_cfu, info_sem_classe, info_aule_edifici
    from gol_ad_mod;

    insert into gol_ad_cla_doc_ln
    select mid, 'it' ln_code, percorso, attivita, classe, docente, nominativo_docente
    from gol_ad_cla_doc;

    insert into gol_ad_mod_doc_ln
    select  mid, 'it' ln_code, percorso, modulo, docente, nominativo_docente
    from gol_ad_mod_doc;

    v_time_end := sysdate;

    v_step := 'step 27';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


    insert into gol_liv_ln
    select mid, 'en' ln_code, name, description
    from gol_liv;

    insert into gol_ad_ln
    select mid, 'en' ln_code, percorso, attivita, descrizione, metodi_did_des, obiett_form_des, prerequisiti_des, contenuti_des, testi_rif_des, mod_ver_appr_des, altre_info_des, struttura_cfu
    from gol_ad;

    insert into gol_ad_cla_ln
    select mid, 'en' ln_code, percorso, attivita, classe, descrizione, info_sem_classe, info_aule_edifici
    from gol_ad_cla;

    insert into gol_ad_doc_ln
    select mid, 'en' ln_code, percorso, attivita, docente
    from gol_ad_doc;

    insert into gol_ad_mod_ln
    select mid, 'en' ln_code, percorso, attivita, modulo, descrizione, metodi_did_des, obiett_form_des, prerequisiti_des, contenuti_des, testi_rif_des, mod_ver_appr_des, altre_info_des, struttura_cfu, info_sem_classe, info_aule_edifici
    from gol_ad_mod;

    insert into gol_ad_cla_doc_ln
    select mid, 'en' ln_code, percorso, attivita, classe, docente, nominativo_docente
    from gol_ad_cla_doc;

    insert into gol_ad_mod_doc_ln
    select  mid, 'en' ln_code, percorso, modulo, docente, nominativo_docente
    from gol_ad_mod_doc;

    v_time_end := sysdate;

    v_step := 'step 28';

    insert into tabella_log
      (id, testo, ora1, ora2, durata, host_name, db_name, optimizer, note)
    values
      (tabella_log_id.nextval,   'Caric. '||p_aa_id,v_time_start, v_time_end,null,null,null,null, v_step);

    commit;

    v_time_start := sysdate;


end;
/
