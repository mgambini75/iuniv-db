CREATE OR REPLACE PROCEDURE                  P_AGG_CERCA_SEL
AS
BEGIN

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento dei dati
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM GOL_CERCA; 

    INSERT INTO GOL_CERCA
    SELECT ROWNUM,
           MID_AD,
           AA_OFF_ID,
           --- ricerca insegnamenti per codice
           COD_AD,
           --- ricerca insegnamenti per nome
           DES_AD,
           TIPO_CORSO_COD,
           DES_LUNGUA_DID,
           SETT_COD,
           ACR,
           DES_PART,
           TIPO_INS_COD, 
           --- ricerca insegnamenti per docente
           TITOLARE
    FROM (  
            SELECT DISTINCT 
                   MID_AD,
                   AA_OFF_ID,
                   --- ricerca insegnamenti per codice
                   a.COD_ad,
                   --- ricerca insegnamenti per nome
                   DES_AD,
                   TIPO_CORSO_COD,
                   DES_LUNGUA_DID,
                   a.SETT_COD,
                   COD_CDS ACR,
                   NVL(DES_PART, 'Non Definito') as DES_PART,
                   NVL(TIPO_INS_COD, 'ND') as TIPO_INS_COD, 
                   --- ricerca insegnamenti per docente
                   CASE WHEN COGNOME IS  NULL AND NOME IS NULL
                            THEN  'Non Definito'
                            ELSE  COGNOME||' '||NOME
                   END TITOLARE
            FROM GOL_IUNI A
                 LEFT JOIN DOCENTI B ON A.DOCENTE_ID = B.DOCENTE_ID
            where aa_off_id in (2010, 2011, 2012)
         );

    --- eliminazione dati valori
    DELETE GOL_CERCA_VAL;
    
    --- caricamento dati valori in italiano
    INSERT INTO GOL_CERCA_VAL
    select rownum as mid,
           LN_CODE as LN_CODE,
           MID_CAMPO,
           AA_OFF_ID,
           substr(TITOLO, 1, 40),
           VAL,
           VAL_PADRE
    from (
    --- tipologia del corso
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
             X.TIPO_CORSO_COD||' - '||TIPO_CORSO_DES AS TITOLO, 
           X.TIPO_CORSO_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 4
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
         JOIN TIPI_CORSO C ON X.TIPO_CORSO_COD = C.TIPO_CORSO_COD
    union
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
             X.TIPO_CORSO_COD||' - '||TIPO_CORSO_DES AS TITOLO, 
           X.TIPO_CORSO_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 4
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
         JOIN TIPI_CORSO C ON X.TIPO_CORSO_COD = C.TIPO_CORSO_COD
    UNION     
    --- codice del corso
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, ACR AS TITOLO, ACR AS VAL, TIPO_CORSO_COD AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 5
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    union    
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, ACR AS TITOLO, ACR AS VAL, TIPO_CORSO_COD AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 5
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- lingua
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           DES_LUNGUA_DID AS TITOLO, DES_LUNGUA_DID AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 6
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           decode ( DES_LUNGUA_DID, 'francese', 'french', 
                                    'inglese', 'english',
                                    'italiano', 'italian',
                                    'portoghese', 'portuguese',
                                    'spagnolo', 'spanish',
                                    'tedesco', 'german',
                                    DES_LUNGUA_DID ) AS TITOLO, 
           DES_LUNGUA_DID AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 6
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- settore
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, SETT_COD AS TITOLO, SETT_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 7
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, SETT_COD AS TITOLO, SETT_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 7
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- periodo    
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES_PART AS TITOLO, DES_PART AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 8
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION     
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES_PART AS TITOLO, DES_PART AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA
         JOIN GOL_CERCA_SEL A ON A.MID = 8
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    --- tipo insegnamento
    SELECT DISTINCT 'it' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, DES AS TITOLO, B.TIPO_INS_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 9
         LEFT JOIN TIPI_INS B ON B.TIPO_INS_COD = X.TIPO_INS_COD
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    UNION
    SELECT DISTINCT 'en' as LN_CODE, A.MID AS MID_CAMPO, AA_OFF_ID, 
           decode (DES, 'Altro Insegnamento','Other teaching',
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
                        des ) AS TITOLO, B.TIPO_INS_COD AS VAL, NULL AS VAL_PADRE
    FROM GOL_CERCA X
         JOIN GOL_CERCA_SEL A ON A.MID = 9
         LEFT JOIN TIPI_INS B ON B.TIPO_INS_COD = X.TIPO_INS_COD
         LEFT JOIN GOL_CERCA_SEL B ON B.MID = A.MID_PADRE
    );


END;
/


CREATE OR REPLACE procedure                  p_agg_dsh_ad_torta (p_stu_id number) is

v_mid number(10);

begin

    delete from dsh_ad_torta where stu_id = p_stu_id;
    
    select nvl(max(mid), 0 ) into v_mid from dsh_ad_torta;

    insert into dsh_ad_torta
    select rownum + v_mid, stu_id, tipo_corso_cod, sta_stu_cod, mot_stastu_cod, des_peso, val_totale, peso_sup, peso_fre, peso_pia, sysdate
    from (
            select a.stu_id, 
                   c.tipo_corso_cod,
                   e.sta_stu_cod,
                   e.mot_stastu_cod,
                   decode( c.um_peso_cod, 'A', 'Annualità',
                                          'C', 'Cfu',
                                          c.um_peso_cod) as des_peso,
                   decode( e.mot_stastu_cod, 'TIT', sum(decode( sta_sce_cod, 'S', peso, 0)),
                                             valore_min) as val_totale,
                   sum(decode( sta_sce_cod, 'S', peso, 0)) as peso_sup, 
                   sum(decode( sta_sce_cod, 'F', peso, 0)) as peso_fre, 
                   sum(decode( sta_sce_cod, 'P', peso, 0)) as peso_pia
            from p11_ad_sce a
                 join p04_mat b on b.mat_id = a.mat_id and b.sta_mat_cod = 'A'
                 join p06_cds c on c.cds_id = a.cds_id
                 join tipi_corso d on d.tipo_corso_cod = c.tipo_corso_cod
                 join p01_stu e on e.stu_id = a.stu_id
            where a.stu_id = p_stu_id
            group by a.stu_id, e.sta_stu_cod, e.mot_stastu_cod, c.um_peso_cod, c.tipo_corso_cod, valore_min
         );


end;
/


CREATE OR REPLACE procedure p_agg_dsh_ad_voti  (p_stu_id number) is

---------------------------------------------------------------------------------
--- Titolo :
--- Note :
---------------------------------------------------------------------------------
---
---
---
---------------------------------------------------------------------------------


cursor c1 is
                    select rowid, stu_id, trunc(data) as data, peso, nvl(voto,0) as voto, mod_val_cod, no_media_flg
                    from   dsh_ad_voti
                    where stu_id = p_stu_id
                    order by stu_id, trunc(data);


v_stu_id number(10);
v_mid number(10);
v_progr number(10);
v_peso number(5,2);
v_voto_prog_art number(15,2);
v_voto_prog_pon number(15,2);
v_voto_media_art number(15,2);
v_voto_media_pon number(15,2);
v_conta_esami_media number(5);
v_conta_peso_media number(5);

begin

    delete from dsh_ad_voti where stu_id = p_stu_id;

    select nvl(max(mid), 0 ) into v_mid from dsh_ad_voti;    

    insert into dsh_ad_voti
    select  rownum + v_mid as mid,
            a.stu_id as stu_id,
            null as prog,
            a.des as descrizione,
            trunc(data_sup) as data,
            mod_val_cod as mod_val_cod,
            voto as voto,
            lode_flg as lode_flg,
            c.tipo_giud_cod as tipo_giud_cod,
            no_media_flg as no_media_flg,
            decode ( a.voto, null,c.des, to_char(a.voto)|| decode(a.lode_flg, 0, '', 1, ' e lode')) as voto_des,
            peso as peso,
            voto as voto_elab,
            null as media_art_prog,
            null as media_pon_prog,
            null as peso_elab,
            sysdate
    from p11_ad_sce a
         join p04_mat b on b.mat_id = a.mat_id and b.sta_mat_cod = 'A'
         left join tipi_giudizio c on a.tipo_giud_cod = c.tipo_giud_cod
    where a.sta_sce_cod = 'S'
    and a.mod_val_cod = 'V'
    and a.no_media_flg = 0
    and a.stu_id = p_stu_id;


    v_progr := 0;
    v_peso := 0;
    v_voto_prog_art :=0;
    v_voto_prog_pon :=0;
    v_voto_media_art :=0;
    v_voto_media_pon :=0;
    v_conta_esami_media :=0;

    for f1 in c1 loop

        if v_stu_id <> f1.stu_id

            then

                if f1.mod_val_cod = 'V' and f1.no_media_flg = 0

                    then

                        v_conta_esami_media := 1;

                        v_conta_peso_media := f1.peso;

                        v_voto_prog_art := f1.voto;

                        v_voto_prog_pon := f1.voto * f1.peso;

                        v_voto_media_art := v_voto_prog_art / v_conta_esami_media;   --- attenzione a /zero (

                        v_voto_media_pon := case when v_conta_peso_media = 0 then v_voto_prog_pon else v_voto_prog_pon / v_conta_peso_media end; --- attenzione a /zero

                    else

                        v_conta_esami_media := 0;
                        v_voto_prog_art := 0;
                        v_voto_media_art := 0;
                        v_conta_peso_media  := 0;
                        v_voto_prog_pon := 0;
                        v_voto_media_pon  := 0;


                end if;

                v_progr := 1;
                v_peso := f1.peso;

                update  dsh_ad_voti
                set prog = v_progr,
                    peso_elab = v_peso,
                    media_art_prog = v_voto_media_art,
                    media_pon_prog = v_voto_media_pon
                where rowid = f1.rowid;

                v_stu_id := f1.stu_id;

            else

                if f1.mod_val_cod = 'V' and f1.no_media_flg = 0

                    then

                        v_conta_esami_media := v_conta_esami_media + 1;

                        v_conta_peso_media := v_conta_peso_media + f1.peso;

                        v_voto_prog_art := v_voto_prog_art + f1.voto;

                        v_voto_prog_pon := v_voto_prog_pon + (f1.voto * f1.peso);

                        v_voto_media_art := v_voto_prog_art / v_conta_esami_media; --- attenzione a /zero

                        v_voto_media_pon := case when v_conta_peso_media = 0 then v_voto_prog_pon else v_voto_prog_pon / v_conta_peso_media end; --- attenzione a /zero


                end if;

                v_progr := v_progr + 1;
                v_peso := v_peso + f1.peso;


                update  dsh_ad_voti
                set prog = v_progr,
                    peso_elab = v_peso,
                    media_art_prog = v_voto_media_art,
                    media_pon_prog = v_voto_media_pon
                where rowid = f1.rowid;

        end if;

    end loop;


end;
/


CREATE OR REPLACE PROCEDURE P_AGG_ELIMINA_MSG(p_id_msg NUMBER, p_data_eli DATE  ) AS 

BEGIN

   DECLARE com_id_msg number(10);
   
   BEGIN
   
     SELECT COM_ID into com_id_msg from MSG_MESSAGE WHERE MID = p_id_msg;
     
     --- Elimino le localizzazioni del msg dalla cache---
     delete from MSG_MESSAGE_LN where MID = p_id_msg;
  
     --- Elimino il msg dalla cache
     delete from MSG_MESSAGE where MID = p_id_msg;
  
     -- Setto la data eliminazione e lo stato "cancellato" sulla struttura messaggi Esse3
     UPDATE P16_COM_EST
     SET STATO_COM = 5,
         DATA_MOD = p_data_eli
     WHERE ( COM_ID = com_id_msg );
     
  END;
  
END P_AGG_ELIMINA_MSG;
/


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


CREATE OR REPLACE PROCEDURE                  p_agg_gen_notifiche
AS
   v_com_id   NUMBER (9);
   v_com_id2  NUMBER (9);
   v_testo    VARCHAR2 (4000);

BEGIN
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Spedisci notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    /*
    Controllo se esistono notifiche da inviare
    */
    SELECT NVL (MAX (age_avt_id), -1)
    INTO v_com_id
    FROM t_notifiche;

    /*
    Se non ci sono dati, significa che e' la prima volta che eseguo la procedura,
    quindi metto un record iniziale con il progressivo massimo.
    La prossima volta parto da quello
    */
    if v_com_id = -1 then
        -- Quale e' il progressivo piu' alto ?
        SELECT NVL (MAX (com_id), 0)
        INTO v_com_id2
        FROM p16_com_est;

        -- Inserisco un record dummy
        INSERT INTO T_NOTIFICHE
        (
            MATRICOLA,
            TESTO,
            TESTO_ITA,
            TESTO_ENG,
            DATA_INS,
            TIPO,
            FLG_SPED,
            DATA_SPED,
            NOTA,
            STU_ID,
            CDS_ID,
            AD_ID,
            APP_ID,
            AGE_AVT_ID
        )
        VALUES
        (
            'X',
            'Prima elaborazione',
            'X',
            'X',
            sysdate,
            'X',
            1,
            null,
            null,
            null,
            null,
            null,
            null,
            v_com_id2
        );

        return;
    end if;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- recupero notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   FOR f1
      IN (SELECT d.user_id AS user_id,
         e.des AS des_categoria,
         e.cod AS cod_categoria,
         a.titolo AS titolo,
         a.oggetto AS oggetto,
         a.com_id AS com_id
            FROM p16_com_est a
                 JOIN p16_com_est_dest b ON b.com_id = a.com_id
                 JOIN p16_destinatari c
                    ON c.dest_id = b.dest_id AND origine_dato = 'EXTERNAL'
                 JOIN p18_user d
                    ON     d.id = c.id_user
                       AND disable_flg = 0
                 JOIN p16_tipo_com_est e
                    ON a.tipo_com_est_id = e.tipo_com_est_id
           WHERE  a.notif_push_flg = 1
                 AND a.com_id > v_com_id)
   LOOP
      v_testo := f1.des_categoria||' - '||f1.titolo;

      --- sistemazione caratteri speciali
      v_testo := replace(v_testo, 'è', 'e''');
      v_testo := replace(v_testo, 'à', 'a''');
      v_testo := replace(v_testo, 'ò', 'o''');
      v_testo := replace(v_testo, 'ì', 'i''');

      INSERT INTO T_NOTIFICHE (MATRICOLA,
                               TESTO,
                               TESTO_ITA,
                               TESTO_ENG,
                               DATA_INS,
                               TIPO,
                               FLG_SPED,
                               DATA_SPED,
                               NOTA,
                               STU_ID,
                               CDS_ID,
                               AD_ID,
                               APP_ID,
                               AGE_AVT_ID)
           VALUES (f1.user_id,
                   v_testo,
                   v_testo,
                   v_testo,
                   sysdate,
                   f1.cod_categoria,
                   0,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   f1.com_id);
   END LOOP;

END;
/


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


CREATE OR REPLACE PROCEDURE P_AGG_LIBRETTO
AS
BEGIN

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento libretto
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    DELETE FROM LIB_STUDENTE;

    INSERT INTO LIB_STUDENTE ( MID, STU_ID, COD_AD, DES_AD, ANNO_CORSO, DES_ANNO, PESO, des_peso, COD_TIPO_INS, DES_TIPO_INS, COD_STATO, DES_STATO, VOTO,  LODE_FLG, TIPO_GIUD_COD, DES_VOTO, DATA_SUP, AA_SUP_ID)
    SELECT ADSCE_ID AS MID,
           A.STU_ID,
           A.COD AS COD_AD,
           FU_DES_UP_LOW(A.DES) AS DES_AD,
           A.ANNO_CORSO as ANNO_CORSO,
           nvl(E.DES2, 'nd') AS DES_ANNO,
           A.PESO as PESO,
           A.PESO||decode(f.um_peso_cod, 'A', ' Annualità',
                                         'C', ' Cfu',
                                         f.um_peso_cod ) as des_peso,
           A.TIPO_INS_COD AS COD_TIPO_INS, 
           D.DES AS DES_TIPO_INS,
           A.STA_SCE_COD AS COD_STATO,
           DECODE( A.STA_SCE_COD, 'P', 'In piano',
                                  'F', 'Frequentata',
                                  'S', 'Superata') AS DES_STATO,
           A.VOTO as VOTO,
           A.LODE_FLG as LODE_FLG,
           A.TIPO_GIUD_COD as TIPO_GIUD_COD,
           DECODE ( A.VOTO, NULL,C.DES, TO_CHAR(A.VOTO)|| DECODE(A.LODE_FLG, 0, '', 1, ' e lode')) AS DES_VOTO,
           TRUNC(A.DATA_SUP) AS DATA_SUP,
           A.AA_SUP_ID as AA_SUP_ID
    FROM P11_AD_SCE A
         JOIN P04_MAT B ON B.MAT_ID = A.MAT_ID AND B.STA_MAT_COD = 'A'
         LEFT JOIN TIPI_GIUDIZIO C ON A.TIPO_GIUD_COD = C.TIPO_GIUD_COD
         LEFT JOIN TIPI_INS D ON A.TIPO_INS_COD = D.TIPO_INS_COD
         LEFT JOIN TIPI_ANNO E ON TO_CHAR(A.ANNO_CORSO) = E.ANNO_COD
         JOIN P06_CDS F ON F.CDS_ID = A.CDS_ID;


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- caricamento libretto in lingua
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    DELETE FROM LIB_STUDENTE_LN;


    INSERT INTO LIB_STUDENTE_LN (MID,LN_CODE, DES_AD, DES_ANNO, DES_PESO,  DES_TIPO_INS, DES_STATO, DES_VOTO)
    SELECT MID, 'it' as LN_CODE, DES_AD, DES_ANNO, 
           decode( DES_PESO, '1 Annualità', 'Una Annualità',
                             ',5 Annualità', 'Mezza Annualità',
                             '0 Annualità', 'Nessuna Annualità',
                             ' Annualità', 'Nessuna Annualità',
                             DES_PESO ) as des_peso, 
           DES_TIPO_INS, DES_STATO, DES_VOTO
    FROM LIB_STUDENTE;

    INSERT INTO LIB_STUDENTE_LN (MID,LN_CODE, DES_AD,DES_ANNO , DES_PESO, DES_TIPO_INS, DES_STATO, DES_VOTO)
    SELECT MID, 'en' as LN_CODE, 
           DES_AD, 
           decode(DES_ANNO, 'Primo','First',
                            'Secondo','Second',
                            'Terzo','Third',
                            DES_ANNO) AS DES_ANNO,
           decode( DES_PESO, '1 Annualità', 'One Annuity',
                             ',5 Annualità', 'Half Annuity',
                             '0 Annualità', 'No Annuity',
                             ' Annualità', 'No Annuity',
                             DES_PESO ) AS DES_PESO,                  
           decode( DES_TIPO_INS, 'Altro Insegnamento','Other teaching',
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
                                 'Fittizio', 'Dummy'
                                 ) AS DES_TIPO_INS, 
           decode(DES_STATO, 'Superata','Exceeded',
                             'Frequentata','Attended',
                             'In piano','Flat',
                             DES_ANNO) AS DES_STATO, 
           decode(DES_VOTO, 'IDONEO', 'Suitable',
                            '30 e lode', '30 laude', 
                            'Approvato',  'Approved',
                            'Buono', 'Good',
                            'Ottimo', 'Excellent',
                            'Distinto', 'Discrete',
                            'Sufficiente','Sufficient',
                            DES_VOTO) AS DES_VOTO
    FROM LIB_STUDENTE;

END;
/


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


CREATE OR REPLACE PROCEDURE p_agg_messaggi
AS
   --- CURSORE
   CURSOR c_1 (
      p_com_id    NUMBER)
   IS
      SELECT com_dest_id AS age_avt_id,
             DECODE (a.stato_com, 5, 'Y', 'N') AS age_avt_deleted,
             a.data_ins AS age_avt_data_ins,
             a.data_mod AS age_avt_data_mod,
             DECODE (a.stato_com, 5, a.data_mod, NULL) AS age_avt_data_eli,
             NVL (data_ini_val, data_att) AS age_avt_data_da,
             data_ini_val AS age_avt_data_a,
             NULL AS age_avt_data_pr,
             NULL AS age_avt_data_ul,
             1 AS age_avt_visibilita,
             0 AS age_avt_letture,
             user_id AS age_avt_username,
             pers_id AS age_avt_pers_id,
             NULL AS age_avt_stu_id,
             a.com_id AS age_avt_com_id,
             NULL AS age_avt_rag_id,
             NULL AS age_avt_imp_id,
             SUBSTR (mittente, 1, 20) AS age_avt_fonte,
             'n' AS age_avt_primo,
             'n' AS age_avt_preferiti,
             'n' AS age_avt_aperto,
             'n' AS age_avt_email,
             'n' AS age_avt_sms,
             'n' AS age_avt_push,
             NULL AS age_avt_codice,
             NULL AS age_avt_dtprova,                                  -- null
             NULL AS age_avt_aula,                                     -- null
             NULL AS age_avt_gestore,                                  -- null
             a.TIPO_COM_EST_ID AS age_avt_cat_id,                      -- null
             DES AS age_avt_cat_ita,                                   -- null
             NULL AS age_avt_cat_eng,                                  -- null
             a.titolo AS age_avt_titolo_ita,
             a.titolo AS age_avt_titolo_eng,
             NULL AS age_avt_sms_ita,                                  -- null
             NULL AS age_avt_sms_eng,                                  -- null
             NULL AS age_avt_push_ita,                                 -- null
             NULL AS age_avt_push_eng,                                 -- null
             a.oggetto AS age_avt_testo_ita,
             a.oggetto AS age_avt_testo_eng,
             1 age_avt_user_read
        FROM p16_com_est a
             JOIN p16_com_est_dest b ON b.com_id = a.com_id
             JOIN p16_destinatari c
                ON c.dest_id = b.dest_id AND origine_dato = 'PERSONE'
             JOIN p18_user d
                ON     d.ana_id = c.pers_id
                   AND grp_id IN (4,
                                  2,
                                  9,
                                  8,
                                  6)
                   AND disable_flg = 0
             JOIN p16_tipo_com_est e ON a.TIPO_COM_EST_ID = e.TIPO_COM_EST_ID
       WHERE     a.stato_com IN (2,
                                 3,
                                 4,
                                 5)
             AND a.com_id > p_com_id;



   v_time_start         DATE;
   v_time_end           DATE;
   v_step               VARCHAR2 (100);
   v_mid                NUMBER (10);
   v_count_tot          NUMBER (10);
   v_count_par          NUMBER (10);
   v_count_par_sta      NUMBER (10);
   v_count_par_commit   NUMBER (10);

   p_com_id             NUMBER (10);

   prima_volta          NUMBER (2);
   v_com_id2            NUMBER (38);
BEGIN
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- procedura per il caricamento dei dati dei messaggi AGE_AVVISI_T
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --execute Immediate 'alter session set optimizer_mode = RULE';

   -- Controllo se è la prima volta che eseguo questa procedura
   SELECT COUNT (*)
     INTO prima_volta
     FROM msg_message
    WHERE ROWNUM = 1;

   -- Se è la prima volta...
   IF prima_volta = 0
   THEN
        execute immediate ('truncate table msg_message_ln');

        -- Prendo il max com_id dei messaggi spediti nei 5 giorni a ritroso
        -- ... almeno metto qualcosa nei messaggi per la prima installazione
          SELECT NVL (MAX (a.com_id), 0)
          into v_com_id2
          from p16_com_est a
                    join p16_com_est_dest b on b.com_id = a.com_id
                    join p16_destinatari c on c.dest_id = b.dest_id and  c.origine_dato = 'PERSONE'
                    join p18_user d on d.ana_id = c.pers_id and  d.grp_id in (4, 2, 9, 8, 6) and d.disable_flg = 0
                    join p16_tipo_com_est  e on a.TIPO_COM_EST_ID = e.TIPO_COM_EST_ID
        where a.stato_com in (2, 3, 4, 5)
        and trunc(a.data_ins) <
            (
            select trunc(max(aa.data_ins)) - 5
                from p16_com_est aa
                    join p16_com_est_dest bb on bb.com_id = aa.com_id
                    join p16_destinatari cc on cc.dest_id = bb.dest_id and  cc.origine_dato = 'PERSONE'
                    join p18_user dd on dd.ana_id = cc.pers_id and  dd.grp_id in (4, 2, 9, 8, 6) and dd.disable_flg = 0
                    join p16_tipo_com_est  ee on aa.TIPO_COM_EST_ID = ee.TIPO_COM_EST_ID
                 where aa.stato_com in (2, 3, 4, 5)
            );

        p_com_id := v_com_id2;
    end if;


    v_count_par_commit := 0;

    v_time_start := sysdate;


       for r_1 in c_1 ( p_com_id )
       loop

            v_count_par_commit := v_count_par_commit + 1;

            insert into msg_message (mid, flg_canc, data_ins, data_mod, data_eli, data_da, data_a, data_pr_let, data_ul_let, num_visibilita, num_letture, user_id, pers_id, stu_id, com_id, rag_id, imp_id, des_fonte, flg_primo, flg_preferiti, flg_aperto, flg_email, flg_sms, flg_push, codice, data_prova, des_aula, des_gestore, cat_id, flg_read)
            values (r_1.age_avt_id, r_1.age_avt_deleted,
                       r_1.age_avt_data_ins, r_1.age_avt_data_mod, r_1.age_avt_data_eli, r_1.age_avt_data_da,r_1.age_avt_data_a, r_1.age_avt_data_pr, r_1.age_avt_data_ul,
                       r_1.age_avt_visibilita, r_1.age_avt_letture,
                       r_1.age_avt_username, r_1.age_avt_pers_id, r_1.age_avt_stu_id, r_1.age_avt_com_id, r_1.age_avt_rag_id, r_1.age_avt_imp_id, r_1.age_avt_fonte,
                       r_1.age_avt_primo, r_1.age_avt_preferiti, r_1.age_avt_aperto, r_1.age_avt_email, r_1.age_avt_sms, r_1.age_avt_push,
                       r_1.age_avt_codice, r_1.age_avt_dtprova, r_1.age_avt_aula, r_1.age_avt_gestore, r_1.age_avt_cat_id, r_1.age_avt_user_read);

            insert into msg_message_ln (mid, ln_code, des_categoria, des_titolo, des_sms, des_push, des_testo)
            values (r_1.age_avt_id, 'it', r_1.age_avt_cat_ita, r_1.age_avt_titolo_ita, r_1.age_avt_sms_ita, r_1.age_avt_push_ita, r_1.age_avt_testo_ita);

            insert into msg_message_ln (mid, ln_code, des_categoria, des_titolo, des_sms, des_push, des_testo)
            values (r_1.age_avt_id, 'en', r_1.age_avt_cat_ita, r_1.age_avt_titolo_eng, r_1.age_avt_sms_eng, r_1.age_avt_push_eng, r_1.age_avt_testo_eng);

            --dbms_application_info.set_client_info ('Righe trattate '||v_mid);
        /*
        if v_count_par_commit = 1000
        then
            commit;
            v_count_par_commit := 0;
        end if;
        */
       end loop;
       
       commit;
end;
/


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


CREATE OR REPLACE procedure                  p_agg_mod_esami (p_stu_id number)
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
                    join p09_ad_gen c on a.p10_app_ad_id = c.ad_id
            where a.stu_id = p_stu_id;

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
    delete from ori_esami_user where stu_id = p_stu_id;


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


CREATE OR REPLACE procedure                  p_agg_mod_messaggi (p_user_id varchar2)
as
   --*******************************************************************************
   -- 03/12/2015 Pederzoli B.  Modificato il recupero dei messaggi puntanto a quelli con device 'APP' e aggiunto log
   --*******************************************************************************
   
   --- CURSORE
   cursor c_1 (v_com_id number, v_id_user number, v_user_id varchar2, v_ana_id number, v_tab_ana varchar2)
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
             v_user_id as age_avt_username, 
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
            join p16_destinatari c on c.dest_id = b.dest_id        
            join p16_tipo_com_est  e on a.TIPO_COM_EST_ID = e.TIPO_COM_EST_ID 
    where a.stato_com in (2, 3, 4) and a.device_cod = 'APP'
    and a.com_id > v_com_id
    and ( (decode( v_tab_ana, 'SOGG_EST', sogg_est_id,
                              'P01_ANAPER', pers_id,
                              'DOCENTI', docente_id) = v_ana_id)
             or 
              id_user =  v_id_user);      



v_id_user number(10);
v_user_id varchar2(20);
v_ana_id number(10);
v_tab_ana varchar2(40);


v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid number(10);
v_aggiorno number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);

v_com_id number(10);


begin


    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --- procedura per il caricamento dei dati dei messaggi AGE_AVVISI_T
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    --execute Immediate 'alter session set optimizer_mode = RULE';


    select nvl(max(com_id), 200000) into v_com_id 
    from msg_message
    where USER_ID = p_user_id;
    
    
    select id, user_id, ana_id, tab_ana into  v_id_user, v_user_id, v_ana_id, v_tab_ana
    from p18_user a 
         join p18_grp b on a.grp_id = b.grp_id 
    where user_id = p_user_id;
    
    

    v_aggiorno := 0;

    v_time_start := sysdate;            
    
    v_step:= 'Utente: ' ||p_user_id || ' Id user: ' ||  to_char(v_id_user) || ' Pers_id: ' ||  to_char(v_ana_id)  || ' Tabella ana: ' || v_tab_ana; -- Pederzoli B 04/12/2015

       for r_1 in c_1 ( v_com_id, v_id_user, v_user_id, v_ana_id, v_tab_ana ) 
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
                      (TABELLA_LOG_ID.Nextval,   'NO Agg. Messaggi',v_time_start, v_time_end,null,null,null,null, v_step);                        

            ELSE         

                    Insert Into TABELLA_LOG
                      (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                    Values
                      (TABELLA_LOG_ID.Nextval,   'Agg. Messaggi N:'||v_aggiorno ,v_time_start, v_time_end,null,null,null,null, v_step);        

        END IF;




end;
/


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


CREATE OR REPLACE procedure                  P_AGG_MOD_TAX_DATA (v_data date) 
as

   --- CURSORE
   CURSOR C_0
   IS
        select distinct stu_id  
        from p05_tax_stu 
        where (   data_ins > v_data -  1/24 
                  or data_mod > v_data - 1/24
                 );


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

    FOR R_0 IN C_0
    LOOP
    
        v_time_start := sysdate;

        p_agg_mod_tax (r_0.stu_id);

        v_time_end := sysdate;

        Insert Into TABELLA_LOG
          (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
        Values
          (TABELLA_LOG_ID.Nextval,   'Aggiornamento Tasse STU:'||r_0.stu_id,v_time_start, v_time_end,null,null,null,null, null);      
        
    end loop;       

    commit;  

end;
/


CREATE OR REPLACE procedure                  p_agg_mod_tax_tot 
as

   --- CURSORE
   CURSOR C_0
   IS
        select stu_id from p01_stu 
        where sta_stu_cod = 'A' 
        and aa_id in ( 2013, 2012, 2011)
        order by stu_id desc;


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

    FOR R_0 IN C_0
    LOOP

        p_agg_mod_tax (r_0.stu_id);
        
    end loop;       

    commit;  

end;
/


CREATE OR REPLACE PROCEDURE P_AGG_NOTIFICHE
AS
v_ora_inizio DATE;
v_ora_fine   DATE;
v_host_name  VARCHAR2(1000 CHAR);
v_db_name    VARCHAR2(1000 CHAR);
v_optimizer  VARCHAR2(512 CHAR);
v_authkey    varchar2(100);
v_appcode     varchar2(100);

LOG_TEST VARCHAR(2000);

cursor c1 is   
  select 
    rowid, 
    MATRICOLA, 
    TESTO, 
    NVL(TESTO_ENG, TESTO) as TESTO_ENG,
    STU_ID, 
    CDS_ID, 
    AD_ID, 
    APP_ID, 
    AGE_AVT_ID
from 
    T_NOTIFICHE
where 
    FLG_SPED = 0
order by DATA_INS;



BEGIN



   v_authkey := get_frw_config('PushAuthKey');
   v_appcode := get_frw_config('PushAppCode');

   if v_authkey is null then

       return ;
   end if;

    if v_appcode is null then

       return ;
   end if;
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Spedisci notifiche
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   for f1 in c1 loop

           BEGIN


              LOG_TEST:= NOTIFICATORE.SendNotificationLN(f1.testo, f1.testo_eng, f1.matricola, 0, v_authkey, v_appcode);
              
              EXCEPTION
              WHEN OTHERS THEN

                --- se da errore
                Insert Into TABELLA_LOG
                  (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                Values
                  (TABELLA_LOG_ID.Nextval,
                   'P_AGG_NOTIFICHE',
                   v_ora_inizio,
                   v_ora_fine,
                   (v_ora_fine - v_ora_inizio) * 24 * 60,
                   v_host_name,
                   v_db_name,
                   v_optimizer,
                   'errore.... ('||f1.STU_ID||' '||f1.CDS_ID||' '||f1.AD_ID||' '||f1.APP_ID||' '||f1.AGE_AVT_ID||')'
                  );

           END;

            update t_notifiche
            set flg_sped = 1, DATA_SPED = sysdate
            where rowid = f1.rowid;

   end loop;

END;

/


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


CREATE OR REPLACE PROCEDURE                  P_AGG_T_DOCENTI
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --

   BEGIN
      --Aggiorno i dati della T_DOCENTI
      UPDATE t_docenti a
         SET (sett_cod,
              matricola,
              cognome,
              nome,
              cellulare,
              e_mail,
              des_appellativo,
              des_gruppo,
              des_luogo,
              note_biografiche,
              note_pubblicazioni,
              note_curriculum,
              note_docente,
              giorno,
              ora_inizio,
              ora_fine,
              prg_persona) =
                (SELECT sett_cod AS sett_cod,
                        matricola AS matricola,
                        INITCAP (TRIM (cognome)) AS cognome,
                        INITCAP (TRIM (nome)) AS nome,
                        TRIM (cellulare) AS cellulare,
                        TRIM (LOWER (e_mail)) AS e_mail,
                        NVL (fu_des_up_low (b.appellativo),
                             DECODE (sesso, 'F', 'Prof.ssa', 'Prof.'))
                           AS des_appellativo,
                        DECODE (
                           d.des,
                           NULL, 'Dipartimento da assegnare (DA.ASSEGN)',
                           d.des || ' (' || d.cod || ')')
                           AS des_gruppo,
                        NULL AS des_luogo,
                        fu_des_up_low (note_biografiche) AS note_biografiche,
                        fu_des_up_low (note_pubblicazioni)
                           AS note_pubblicazioni,
                        fu_des_up_low (note_curriculum) AS note_curriculum,
                        fu_des_up_low (note_docente) AS note_docente,
                        NULL AS giorno,
                        NULL AS ora_inizio,
                        NULL AS ora_fine,
                        NULL AS prg_persona
                   FROM docenti b
                        LEFT JOIN docenti_note c
                           ON b.docente_id = c.docente_id
                        LEFT JOIN v06_dip d ON d.dip_id = b.dip_id
                  WHERE a.docente_id = b.docente_id)
       WHERE EXISTS
                (SELECT 1
                   FROM t_docenti x
                  WHERE x.docente_id = a.docente_id);

      -- inserisco i dati mancanti della T_DOCENTI
      INSERT INTO t_docenti
         SELECT ROWNUM + (SELECT NVL (MAX (mid), 0) FROM t_docenti) mid,
                sett_cod AS sett_cod,
                matricola AS matricola,
                INITCAP (TRIM (cognome)) AS cognome,
                INITCAP (TRIM (nome)) AS nome,
                TRIM (cellulare) AS cellulare,
                TRIM (LOWER (e_mail)) AS e_mail,
                NVL (fu_des_up_low (b.appellativo),
                     DECODE (sesso, 'F', 'Prof.ssa', 'Prof.'))
                   AS des_appellativo,
                DECODE (d.des,
                        NULL, 'Dipartimento da assegnare (DA.ASSEGN)',
                        d.des || ' (' || d.cod || ')')
                   AS des_gruppo,
                NULL AS des_luogo,
                fu_des_up_low (note_biografiche) AS note_biografiche,
                fu_des_up_low (note_pubblicazioni) AS note_pubblicazioni,
                fu_des_up_low (note_curriculum) AS note_curriculum,
                fu_des_up_low (note_docente) AS note_docente,
                NULL AS giorno,
                NULL AS ora_inizio,
                NULL AS ora_fine,
                NULL AS prg_persona,
                b.docente_id AS docente_id
           FROM docenti b
                LEFT JOIN docenti_note c ON b.docente_id = c.docente_id
                LEFT JOIN V06_dip d ON d.dip_id = b.dip_id
          WHERE     NOT EXISTS
                       (SELECT 1
                          FROM t_docenti x
                         WHERE x.docente_id = b.docente_id)
                AND UPPER (COGNOME) NOT LIKE '%XXX%'
                AND UPPER (COGNOME) NOT LIKE '%XX%';


      COMMIT;
   END;
END;
/


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


CREATE OR REPLACE procedure P_API_FRW_LANG (p_LANG_DEV CHAR, p_LANG_EFF OUT CHAR ) as
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
P_CONTR NUMBER(10);

    BEGIN  

     SELECT COUNT(*) INTO P_CONTR
     FROM T_LANGUAGE
     WHERE LN_CODE = p_LANG_DEV;
      
      IF P_CONTR =0
      
         THEN  SELECT VALUE_STRING INTO p_LANG_EFF
               FROM FRW_CONFIG 
               WHERE COD = 'DefaultLanguage';
         
         ELSE  p_LANG_EFF := p_LANG_DEV;
      
      END IF;
                 
      
    END;

END; 
/


CREATE OR REPLACE procedure p_api_frw_utenti_token (p_user char, p_token char, p_hash char, p_datsca date ) as
begin
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
p_contr number(10);
v_mid number(10);

    begin  

     select count(*) into p_contr
     from frw_utenti_token
     where user_id = p_user;
      
        if p_contr =0
              
            then  
                 
            select nvl(max(mid), 0) + 1 into v_mid from frw_utenti_token;
                             
            insert into frw_utenti_token (mid, user_id, des_token, des_hash, data_scad, data_ins, data_mod)
            values (v_mid, p_user, p_token, p_hash, p_datsca, sysdate, null);
                 
        else  
                 
            update  frw_utenti_token
            set  des_token = p_token,
                    des_hash = p_hash,
                    data_scad = p_datsca,
                    data_mod =  sysdate
            where user_id = p_user;
                           
              
        end if;
                 
      
    end;

end;
/


CREATE OR REPLACE PROCEDURE                  P_API_MSG_DELETE (P_ID         NUMBER,
                                              P_LANG       VARCHAR,
                                              P_MSG    OUT SYS_REFCURSOR)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   DECLARE
      P_CONTR   NUMBER (10);
   BEGIN
      P_CONTR := 0;

      --- MSG 1 (messaggio in primo piano non ancora letto)
      SELECT COUNT (*)
        INTO P_CONTR
        FROM MSG_MESSAGE
       WHERE     mid = P_ID
             AND UPPER (flg_PRIMO) = 'S'
             AND NUM_VISIBILITA > NUM_LETTURE;


      IF P_CONTR = 0
      THEN
         UPDATE MSG_MESSAGE
            SET FLG_CANC = 's'
          WHERE mid = P_ID;

         OPEN P_MSG FOR
            SELECT M.MID, M.TITOLO, M.DESCRIZIONE
              FROM API_FRW_MESSAGES M
             WHERE M.LANG = LANG AND M.MID = 0;
      ELSE
         OPEN P_MSG FOR
            SELECT M.MID, M.TITOLO, M.DESCRIZIONE
              FROM API_FRW_MESSAGES M
             WHERE M.LANG = LANG AND M.MID = 2010001;
             
      END IF;
   END;
END;
/


CREATE OR REPLACE procedure                  P_API_MSG_INPREFER (p_ID NUMBER, p_MSG OUT NUMBER ) as
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  

      --- MSG 2 (messaggio è già fra i preferiti)
      SELECT COUNT(*) INTO P_CONTR
      FROM MSG_MESSAGE
      WHERE mid = p_ID
      AND UPPER(FLG_PREFERITI) = 'S';

      
      IF P_CONTR =0
      
         THEN    UPDATE MSG_MESSAGE
                 SET FLG_PREFERITI = 's'
                 WHERE mid = p_ID;
                 
         ELSE    P_MSG := 2010002;   
      
                 
      END IF;
                 
      
    END;

END;
/


CREATE OR REPLACE PROCEDURE                  P_API_MSG_OUTPREFER (P_ID NUMBER, P_MSG OUT NUMBER ) AS
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
DECLARE
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  
      
      --- MSG 3 (messaggio non è fra i preferiti)
      SELECT COUNT(*) INTO P_CONTR
      FROM MSG_MESSAGE
      WHERE MID = P_ID
      AND UPPER(FLG_PREFERITI) = 'N';
      
      IF P_CONTR = 0
      
         THEN    UPDATE MSG_MESSAGE
                 SET FLG_PREFERITI = 'n'
                 WHERE MID = P_ID
                 AND UPPER(FLG_PREFERITI) = 'S';
                 
         ELSE    P_MSG := 2010003;   
      
      END IF;
                 
      
    END;

END;
/


CREATE OR REPLACE procedure                  P_API_MSG_READ (p_ID number, p_MSG OUT NUMBER ) as
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  
      
      IF P_CONTR =0
      
         THEN    UPDATE MSG_MESSAGE
                 SET DATA_PR_LET = SYSDATE
                 WHERE MID = p_ID
                 AND NVL(NUM_LETTURE, 0) = 0;
                 
                 UPDATE MSG_MESSAGE
                 SET NUM_LETTURE = NVL(NUM_LETTURE, 0) + 1,  
                     DATA_UL_LET = SYSDATE,
                     FLG_READ = 0 
                 WHERE MID = p_ID;
      
      END IF;
                 
      
    END;

END;
/


CREATE OR REPLACE procedure                  P_API_MSG_UNREAD (p_ID number, p_MSG OUT NUMBER ) as
BEGIN
  --
  -- Aggiorna A Body
  -- Corpo Procedura
  --
declare
P_CONTR NUMBER(10);

    BEGIN  
  
      P_MSG   := 0;
      P_CONTR := 0;  
      
      IF P_CONTR =0
      
         THEN    UPDATE MSG_MESSAGE
                 SET FLG_READ = 1 
                 WHERE mid = p_ID;
      
      END IF;
                 
      
    END;

END;
/


CREATE OR REPLACE PROCEDURE                  P_API_PRE_INSERT (
                                              P_STU         NUMBER,
                                              P_CDS         NUMBER,
                                              P_AD         NUMBER,
                                              P_APP         NUMBER,
                                              p_MSG OUT NUMBER)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   BEGIN

        INSERT INTO T_PRENOTAZIONI (STU_ID, CDS_ID, AD_ID, APP_ID, NOTA, DATA_INS)
        SELECT P_STU, P_CDS, P_AD, P_APP, NULL, SYSDATE
        FROM DUAL;

   END;
END;
/


CREATE OR REPLACE PROCEDURE P_API_STU_TO_MAT (P_STU_ID         NUMBER,
                                              P_MAT_ID    OUT SYS_REFCURSOR)
AS
BEGIN
   --
   -- Aggiorna A Body
   -- Corpo Procedura
   --
   DECLARE
   
   BEGIN

         OPEN P_MAT_ID FOR
            SELECT MAT_ID
              FROM P04_MAT
             WHERE STU_ID = P_STU_ID
               AND STA_MAT_COD = 'A';
      
   END;
END; 
/


CREATE OR REPLACE procedure p_copia_link (v_profilo_copy number, v_profilo_crea number)
as

   --- CURSORE padre
   cursor c_1
   is   select a.*
        from LNK_LINK a
        where a.Profile = v_profilo_copy
        and mid_padre is null;

   cursor c_f1 (v_padre number)
   is   select a.*
        from LNK_LINK a
        where a.Profile = v_profilo_copy
        and mid_padre = v_padre;



v_time_start date;
v_time_end  date;
v_step varchar2(100);
v_mid_new number(10);
v_mid_new1 number(10);
v_aggiorno number(10);
v_count_tot number(10);
v_count_par number(10);
v_count_par_sta number(10);
v_count_par_commit number(10);

p_com_id number(10);


begin

    for r_1 in c_1 
    loop
    
        v_mid_new := LNK_LINK_MID.nextval; 
    
        insert into lnk_link 
        values (v_mid_new, r_1.TITLE, r_1.DESCRIPTION, r_1.URL, r_1.NAME_PHOTO, r_1.URL_PHOTO, v_profilo_crea, r_1.LN_CODE, r_1.ORDINAMENTO, r_1.FLG_AUTH, r_1.MID_PADRE);

        for r_2 in c_f1 (r_1.mid)
        loop
        
            v_mid_new1 := LNK_LINK_MID.nextval;
        
            insert into lnk_link 
            values (v_mid_new1, r_2.TITLE, r_2.DESCRIPTION, r_2.URL, r_2.NAME_PHOTO, r_2.URL_PHOTO, v_profilo_crea, r_1.LN_CODE, r_1.ORDINAMENTO, r_1.FLG_AUTH, v_mid_new);

        end loop;  
               

    end loop;
        

end;
/


CREATE OR REPLACE PROCEDURE SP_ALLINEA_SEQUENCE AUTHID CURRENT_USER AS
  V_NOMETABLE VARCHAR2(80);
  v_NOMEPK VARCHAR2(80);
  v_MAXVAL NUMBER(9);
  v_COUNT_PK NUMBER(9);
 BEGIN

  DECLARE CURSOR CUR_SEQ IS
    SELECT SEQUENCE_NAME
     FROM USER_SEQUENCES
     where SEQUENCE_NAME = 'LNK_LINK_MID';

  BEGIN FOR SEQ IN CUR_SEQ LOOP
     v_NOMETABLE := SUBSTR(SEQ.SEQUENCE_NAME, 4);

  BEGIN
     SELECT COUNT(C.COLUMN_NAME)
     INTO v_COUNT_PK
     FROM USER_CONSTRAINTS T,
          USER_CONS_COLUMNS C,
          USER_TAB_COLUMNS A
     WHERE  T.TABLE_NAME = v_NOMETABLE
     AND T.CONSTRAINT_TYPE = 'P'
     AND T.OWNER = C.OWNER
     AND T.CONSTRAINT_NAME = C.CONSTRAINT_NAME
     AND C.TABLE_NAME = A.TABLE_NAME
     AND C.COLUMN_NAME = A.COLUMN_NAME
     AND A.DATA_TYPE = 'NUMBER';

    if (v_COUNT_PK = 1) THEN

                   SELECT C.COLUMN_NAME
                      INTO v_NOMEPK
                   FROM USER_CONSTRAINTS T,
                        USER_CONS_COLUMNS C,
                        USER_TAB_COLUMNS A
                   WHERE  T.TABLE_NAME = v_NOMETABLE
                   AND T.CONSTRAINT_TYPE = 'P'
                   AND T.OWNER = C.OWNER
                   AND T.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                   AND C.TABLE_NAME = A.TABLE_NAME
                   AND C.COLUMN_NAME = A.COLUMN_NAME
                   AND A.DATA_TYPE = 'NUMBER';

                    EXECUTE IMMEDIATE ' SELECT NVL(MAX("' || v_NOMEPK || '"), 0) FROM '|| v_NOMETABLE  INTO v_MAXVAL;

                    IF(v_MAXVAL > 0 AND v_MAXVAL IS NOT NULL) THEN
                      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || SEQ.SEQUENCE_NAME;
                      EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || SEQ.SEQUENCE_NAME || ' START WITH '|| TO_CHAR(v_MAXVAL + 1) ||' MAXVALUE 999999999999999999999999999  MINVALUE 1  NOCYCLE  NOCACHE  NOORDER';

                           ELSE
                      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || SEQ.SEQUENCE_NAME;
                      EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || SEQ.SEQUENCE_NAME || ' START WITH 1 MAXVALUE 999999999999999999999999999  MINVALUE 1  NOCYCLE  NOCACHE  NOORDER';

                    END IF;


    END IF;
    EXCEPTION
                             WHEN NO_DATA_FOUND THEN NULL;
                             WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('SEQ_' || v_NOMETABLE || ' non aggiornata');
 END;

  END LOOP; END;

 COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE                  UNIXX_DESCRIPTION_LIV (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      select * from GOL_LIV
      WHERE MID_DETT IS NOT NULL
      and aa_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

       UPDATE GOL_LIV
       SET DESCRIPTION = '['||CODE||'] '||UNIXX_GOL_LIV_DESCRIZIONE(MID_DETT)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/


CREATE OR REPLACE PROCEDURE                  UNIXX_DESCRIZIONE_AD (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      SELECT MID
      FROM GOL_AD
      where DESCRIZIONE is null
      and aa_off_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

        UPDATE GOL_AD
        SET DESCRIZIONE = UNIXX_GOL_AD_DESCRIZIONE(MID)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/


CREATE OR REPLACE PROCEDURE                  UNIXX_GOL_ID (p_aa_id number)
AS
---------------------------------------------------------------------------------
--- CALCOLO DEGLI ID
--- NOTE:
---------------------------------------------------------------------------------
---
---------------------------------------------------------------------------------

   --- CURSORE PRIMO LIVELLO
   CURSOR C_LIV_1
   IS
     SELECT  AA_OFF_ID, COD_FAC
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY AA_OFF_ID, COD_FAC
     ORDER BY AA_OFF_ID, COD_FAC;

   --- CURSORE SECONDO LIVELLO
   CURSOR C_LIV_2
   IS
     SELECT  MID_LIV_1, COD_CDS
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, COD_CDS
     ORDER BY MID_LIV_1, COD_CDS;

   --- CURSORE TERZO LIVELLO
   CURSOR C_LIV_3
   IS
     SELECT  MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS
     ORDER BY MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS;

   --- CURSORE QUARTO LIVELLO
   CURSOR C_LIV_4
   IS
     SELECT  MID_LIV_1, MID_LIV_2, NVL(MID_LIV_3, 99999) AS MID_LIV_3, COD_AD
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, MID_LIV_2, MID_LIV_3, COD_AD
     ORDER BY MID_LIV_1, MID_LIV_2, NVL(MID_LIV_3, 99999),  COD_AD;

   --- CURSORE AD
   CURSOR C_AD
   IS
      SELECT   DISTINCT MID_LIV_4
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_LIV_4;

   --- CURSORE AD_CLA
   CURSOR C_AD_CLA
   IS
      SELECT   DISTINCT MID_AD, FAT_PART_COD, DOM_PART_COD, SEDE_DES
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, FAT_PART_COD, DOM_PART_COD, SEDE_DES;

   --- CURSORE AD_MOD
   CURSOR C_AD_MOD
   IS
      SELECT   DISTINCT MID_AD, COD_MOD
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, COD_MOD;

   --- CURSORE AD_DOC
   CURSOR C_AD_DOC
   IS
      SELECT   DISTINCT MID_AD, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, DOCENTE_ID;

   --- CURSORE AD_MOD_DOC
   CURSOR C_AD_MOD_DOC
   IS
      SELECT   DISTINCT MID_AD_MOD, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD_MOD, DOCENTE_ID;

   --- CURSORE AD_CLA_DOC
   CURSOR C_AD_CLA_DOC
   IS
      SELECT   DISTINCT MID_AD_CLA, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD_CLA, DOCENTE_ID;


   V_ID                 GOL_IUNI.MID_AD%TYPE;
   V_OLD_AA_OFF_ID      GOL_IUNI.AA_OFF_ID%TYPE;
   V_OLD_COD_FAC        GOL_IUNI.COD_FAC%TYPE;
   V_OLD_COD_CDS         GOL_IUNI.COD_CDS%TYPE;
   V_OLD_AA_ORD_ID      GOL_IUNI.AA_ORD_ID%TYPE;
   V_OLD_COD_PDS         GOL_IUNI.COD_PDS%TYPE;
   V_OLD_COD_AD          GOL_IUNI.COD_AD%TYPE;

   V_OLD_MID_LIV_1      GOL_IUNI.MID_LIV_1%TYPE;
   V_OLD_MID_LIV_2      GOL_IUNI.MID_LIV_2%TYPE;
   V_OLD_MID_LIV_3      GOL_IUNI.MID_LIV_3%TYPE;
   V_OLD_MID_LIV_4      GOL_IUNI.MID_LIV_4%TYPE;

   V_OLD_MID_AD         GOL_IUNI.MID_AD%TYPE;
   V_OLD_MID_AD_MOD     GOL_IUNI.MID_AD_MOD%TYPE;
   V_OLD_MID_AD_CLA     GOL_IUNI.MID_AD_CLA%TYPE;
   V_OLD_MID_AD_DOC     GOL_IUNI.MID_AD_DOC%TYPE;

   V_OLD_FAT_PART_COD   GOL_IUNI.FAT_PART_COD%TYPE;
   V_OLD_DOM_PART_COD   GOL_IUNI.DOM_PART_COD%TYPE;
   V_OLD_SEDE_DES   GOL_IUNI.SEDE_DES%TYPE;
   V_OLD_COD_MOD          GOL_IUNI.COD_MOD%TYPE;

   V_OLD_DOCENTE_ID     GOL_IUNI.DOCENTE_ID%TYPE;



BEGIN

      V_OLD_COD_FAC         := '0';
      V_OLD_AA_OFF_ID      := 0;
      V_OLD_COD_CDS         := '0';
      V_OLD_AA_ORD_ID      := 0;
      V_OLD_COD_PDS         := '0';
      V_OLD_COD_AD          := '0';
      V_OLD_MID_LIV_1      := 0;
      V_OLD_MID_LIV_2      := 0;
      V_OLD_MID_LIV_3      := 0;

      V_OLD_MID_AD         := 0;
      V_OLD_MID_AD_CLA     := 0;
      V_OLD_MID_AD_DOC     := 0;
      V_OLD_MID_AD_MOD     := 0;

      V_OLD_FAT_PART_COD   := 'x';
      V_OLD_DOM_PART_COD   := 'x';
      V_OLD_SEDE_DES   := 'x';
      V_OLD_COD_MOD          := '0';
      V_OLD_DOCENTE_ID     := 0;

--   V_OLD_DOCENTE_ID_CLA := 0;

   V_ID := 10000;

   SELECT NVL(MAX(MID_LIV_1), 10000) INTO V_ID FROM GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_1 IN C_LIV_1
   LOOP
      IF V_OLD_COD_FAC = R_LIV_1.COD_FAC AND
         V_OLD_AA_OFF_ID = R_LIV_1.AA_OFF_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_1 = V_ID
       WHERE AA_OFF_ID = R_LIV_1.AA_OFF_ID
       AND COD_FAC =  R_LIV_1.COD_FAC;

      V_OLD_AA_OFF_ID :=  R_LIV_1.AA_OFF_ID;
      V_OLD_COD_FAC :=  R_LIV_1.COD_FAC;
   END LOOP;

   COMMIT;

   V_ID := 20000;

   select nvl(max(MID_LIV_2), 20000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_2 IN C_LIV_2
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_2.MID_LIV_1 AND
         V_OLD_COD_CDS = R_LIV_2.COD_CDS
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_2 = V_ID
       WHERE MID_LIV_1 = R_LIV_2.MID_LIV_1
       AND COD_CDS =  R_LIV_2.COD_CDS;

      V_OLD_MID_LIV_1 :=  R_LIV_2.MID_LIV_1;
      V_OLD_COD_CDS :=  R_LIV_2.COD_CDS;
   END LOOP;

   COMMIT;

   V_ID := 30000;



   select nvl(max(MID_LIV_3), 30000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_3 IN C_LIV_3
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_3.MID_LIV_1 AND
         V_OLD_MID_LIV_2 = R_LIV_3.MID_LIV_2 AND
         V_OLD_AA_ORD_ID = R_LIV_3.AA_ORD_ID AND 
         V_OLD_COD_PDS = R_LIV_3.COD_PDS
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_3 = V_ID
       WHERE MID_LIV_1 = R_LIV_3.MID_LIV_1
       AND MID_LIV_2 = R_LIV_3.MID_LIV_2
       AND AA_ORD_ID =  R_LIV_3.AA_ORD_ID
       AND COD_PDS =  R_LIV_3.COD_PDS;

      V_OLD_MID_LIV_1 :=  R_LIV_3.MID_LIV_1;
      V_OLD_MID_LIV_2 :=  R_LIV_3.MID_LIV_2;
      V_OLD_AA_ORD_ID :=  R_LIV_3.AA_ORD_ID;
      V_OLD_COD_PDS :=  R_LIV_3.COD_PDS;
      
   END LOOP;

   COMMIT;

    --- dove è presente un solo ordinamento e un solo percorso
    UPDATE GOL_IUNI
    SET MID_LIV_3 = NULL
    WHERE (MID_LIV_1, MID_LIV_2)
    IN (
        SELECT MID_LIV_1, MID_LIV_2
        FROM
        (
        SELECT DISTINCT MID_LIV_1, MID_LIV_2, MID_LIV_3
        FROM GOL_IUNI
        )
        GROUP BY MID_LIV_1, MID_LIV_2
        HAVING COUNT(*) = 1
       );

   COMMIT;

   V_ID := 40000;

   select nvl(max(MID_LIV_4), 40000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_4 IN C_LIV_4
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_4.MID_LIV_1 AND
         V_OLD_MID_LIV_2 = R_LIV_4.MID_LIV_2 AND
         V_OLD_MID_LIV_3 = R_LIV_4.MID_LIV_3 AND
         V_OLD_COD_AD = R_LIV_4.COD_AD
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_4 = V_ID
       WHERE MID_LIV_1 = R_LIV_4.MID_LIV_1
       AND MID_LIV_2 = R_LIV_4.MID_LIV_2
       AND NVL(MID_LIV_3, 99999) = R_LIV_4.MID_LIV_3
       AND COD_AD =  R_LIV_4.COD_AD;

      V_OLD_MID_LIV_1 :=  R_LIV_4.MID_LIV_1;
      V_OLD_MID_LIV_2 :=  R_LIV_4.MID_LIV_2;
      V_OLD_MID_LIV_3 :=  R_LIV_4.MID_LIV_3;
      V_OLD_COD_AD :=  R_LIV_4.COD_AD;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD IN C_AD
   LOOP
      IF V_OLD_MID_LIV_4 = R_AD.MID_LIV_4
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD = V_ID
       WHERE MID_LIV_4 = R_AD.MID_LIV_4;

      V_OLD_MID_LIV_4 :=  R_AD.MID_LIV_4;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_CLA), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_CLA IN C_AD_CLA
   LOOP
      IF V_OLD_MID_AD = R_AD_CLA.MID_AD AND
         V_OLD_FAT_PART_COD = R_AD_CLA.FAT_PART_COD AND
         V_OLD_DOM_PART_COD = R_AD_CLA.DOM_PART_COD AND
         V_OLD_SEDE_DES = R_AD_CLA.SEDE_DES
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_CLA = V_ID
       WHERE MID_AD = R_AD_CLA.MID_AD
       AND FAT_PART_COD = R_AD_CLA.FAT_PART_COD
       AND DOM_PART_COD = R_AD_CLA.DOM_PART_COD
       AND SEDE_DES = R_AD_CLA.SEDE_DES;

      V_OLD_MID_AD :=  R_AD_CLA.MID_AD;
      V_OLD_FAT_PART_COD :=  R_AD_CLA.FAT_PART_COD;
      V_OLD_DOM_PART_COD :=  R_AD_CLA.DOM_PART_COD;
      V_OLD_SEDE_DES :=  R_AD_CLA.SEDE_DES;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_MOD), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_MOD IN C_AD_MOD
   LOOP
      IF V_OLD_MID_AD = R_AD_MOD.MID_AD AND
         V_OLD_COD_MOD = R_AD_MOD.COD_MOD
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_MOD = V_ID
       WHERE MID_AD = R_AD_MOD.MID_AD
       AND COD_MOD = R_AD_MOD.COD_MOD;

      V_OLD_MID_AD :=  R_AD_MOD.MID_AD;
      V_OLD_COD_MOD :=  R_AD_MOD.COD_MOD;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_DOC IN C_AD_DOC
   LOOP
      IF V_OLD_MID_AD = R_AD_DOC.MID_AD AND
         V_OLD_DOCENTE_ID = R_AD_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_DOC = V_ID
       WHERE MID_AD = R_AD_DOC.MID_AD
       AND DOCENTE_ID = R_AD_DOC.DOCENTE_ID;

      V_OLD_MID_AD :=  R_AD_DOC.MID_AD;
      V_OLD_DOCENTE_ID :=  R_AD_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_MOD_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_MOD_DOC IN C_AD_MOD_DOC
   LOOP
      IF V_OLD_MID_AD_MOD = R_AD_MOD_DOC.MID_AD_MOD AND
         V_OLD_DOCENTE_ID = R_AD_MOD_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_MOD_DOC = V_ID
       WHERE MID_AD_MOD = R_AD_MOD_DOC.MID_AD_MOD
       AND DOCENTE_ID =  R_AD_MOD_DOC.DOCENTE_ID;

      V_OLD_MID_AD_MOD :=  R_AD_MOD_DOC.MID_AD_MOD;
      V_OLD_DOCENTE_ID := R_AD_MOD_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_CLA_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_CLA_DOC IN C_AD_CLA_DOC
   LOOP
      IF V_OLD_MID_AD_CLA = R_AD_CLA_DOC.MID_AD_CLA AND
         V_OLD_DOCENTE_ID = R_AD_CLA_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_CLA_DOC = V_ID
       WHERE MID_AD_CLA = R_AD_CLA_DOC.MID_AD_CLA
       AND DOCENTE_ID = R_AD_CLA_DOC.DOCENTE_ID;

      V_OLD_MID_AD_CLA :=  R_AD_CLA_DOC.MID_AD_CLA;
      V_OLD_DOCENTE_ID := R_AD_CLA_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

    UPDATE GOL_IUNI
    SET MID_AD = MID_AD + (p_aa_id - 2000) * 100000,
           MID_AD_CLA = MID_AD_CLA + (p_aa_id - 2000) * 100000, 
           MID_AD_DOC = MID_AD_DOC + (p_aa_id - 2000) * 100000,
           MID_AD_MOD = MID_AD_MOD + (p_aa_id - 2000) * 100000, 
           MID_AD_MOD_DOC = MID_AD_MOD_DOC + (p_aa_id - 2000) * 100000,
           MID_AD_CLA_DOC = MID_AD_CLA_DOC + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id;


    UPDATE GOL_IUNI
    SET MID_LIV_1 = MID_LIV_1 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_1 IS NOT NULL;

    UPDATE GOL_IUNI
    SET MID_LIV_2 = MID_LIV_2 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_2 IS NOT NULL;

    UPDATE GOL_IUNI
    SET MID_LIV_3 = MID_LIV_3 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_3 IS NOT NULL;
     
    UPDATE GOL_IUNI
    SET MID_LIV_4 = MID_LIV_4 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_4 IS NOT NULL;


    
    COMMIT;  


END;
/


CREATE OR REPLACE PROCEDURE                  UNIXX_GOL_PULIZIA (p_aa_id number)
AS
---------------------------------------------------------------------------------
--- CALCOLO DEGLI ID
--- NOTE:
---------------------------------------------------------------------------------
---
---------------------------------------------------------------------------------

v_time_start date;
v_time_end  date;
v_step varchar2(100);

BEGIN

        --- FACOLTA
        update GOL_IUNI
        set (fac_id, cod_fac, des_fac) = (select distinct d.fac_id, d.cod, d.des_cert
                                                   from p06_cds b 
                                                          join p06_fac_cds c on b.cds_id = c.cds_id and ann_flg = 0 and def_amm_flg = 1
                                                          join p06_fac d on d.fac_id = c.fac_id
                                                   where cod_cds = b.cod)
        where aa_off_id = p_aa_id;
                                                   
        update GOL_IUNI
        set cod_fac = 'NN', des_fac = 'NON DEFINITA'
        where cod_fac is null
        and aa_off_id = p_aa_id;       

        --- CORSO        
        update  GOL_IUNI
        set cds_id =      (select cds_id from p06_cds where cod = cod_cds)
        where  (select count(*) from p06_cds where cod = cod_cds) = 1
        and aa_off_id = p_aa_id;   


        --- PERCORSO
        update GOL_IUNI x
        set pds_id =    
                    (select pds_id 
                     from p06_cds A
                             join p06_pdsord b on b.cds_id = a.cds_id
                     where a.cod = cod_cds
                     and b.aa_ord_id = x.aa_ord_id
                     and b.cod = cod_pds )
        where     (select count(*) 
                     from p06_cds A
                             join p06_pdsord b on b.cds_id = a.cds_id
                     where a.cod = cod_cds
                     and b.aa_ord_id = x.aa_ord_id
                     and b.cod = cod_pds ) = 1
        and aa_off_id = p_aa_id;


        --- TIPO CORSO
        update GOL_IUNI
        set tipo_corso_cod = 'L2'
        where tipo_corso_cod in ('L', 'LT')
        and aa_off_id = p_aa_id;

        update GOL_IUNI
        set tipo_corso_cod = 'L1'
        where tipo_corso_cod in ('LV')
        and aa_off_id = p_aa_id;

        --- PARTIZIONAMENTI / SEDI
        update GOL_IUNI a
        set fat_part_cod = 'N0', dom_part_cod = 'N0' 
        where fat_part_cod is null
        and dom_part_cod is null
        and aa_off_id = p_aa_id;
        
        update GOL_IUNI a
        set sede_des = 'TORINO'
        where sede_des is null
        and aa_off_id = p_aa_id;

        --- DOCENTE
        update GOL_IUNI
        set docente_id = (select docente_id from docenti where matricola_titolare = matricola)
        where aa_off_id = p_aa_id; 

        update GOL_IUNI
        set docente_id = 999999999
        where docente_id is null
        and aa_off_id = p_aa_id;

        --- ATTIVITA DIDATTICA
        update GOL_IUNI x
        set ad_id =  (select ad_id
                           from p09_ad_gen
                           where cod = cod_ad)
        where   (select count(*) 
                     from p09_ad_gen
                     where cod = cod_ad) = 1
        and aa_off_id = p_aa_id;


END;
/


CREATE OR REPLACE PROCEDURE                  UNIXX_STRUTTURA_CFU_AD_MOD (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      SELECT MID
      FROM gol_ad_mod
      WHERE STRUTTURA_CFU IS NULL
      and aa_off_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

        UPDATE gol_ad_mod
        SET STRUTTURA_CFU = UNIXX_GOL_MOD_STRUTT_CFU(MID)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/


CREATE OR REPLACE PROCEDURE                  P_AGG_LANCIO_PUS
AS
v_ora_inizio DATE;
v_ora_fine   DATE;
v_host_name  VARCHAR2(1000 CHAR);
v_db_name    VARCHAR2(1000 CHAR);
v_optimizer  VARCHAR2(512 CHAR);
v_testo    VARCHAR2(1000 CHAR);

BEGIN
    SELECT SYS_CONTEXT('USERENV','SERVER_HOST') into v_host_name FROM dual;


    p_agg_gen_notifiche;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- Lancio notifiche PUSH
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   v_ora_inizio := SYSDATE;

    select COUNT(*) INTO V_TESTO
    from t_notifiche
    where flg_sped = 0;

    if V_TESTO > 0

        then

           BEGIN

              p_agg_notifiche;

              EXCEPTION
              WHEN OTHERS THEN

                v_ora_fine := SYSDATE;

                ROLLBACK;

                --- se da errore
                Insert Into TABELLA_LOG
                  (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
                Values
                  (TABELLA_LOG_ID.Nextval,
                   'P_AGG_NOTIFICHE',
                   v_ora_inizio,
                   v_ora_fine,
                   (v_ora_fine - v_ora_inizio) * 24 * 60,
                   v_host_name,
                   v_db_name,
                   v_optimizer,
                   'errore.... ('||v_testo||')'
                  );

           END;

           v_ora_fine := SYSDATE;

           --- se non da errore
           Insert Into TABELLA_LOG
             (ID, TESTO, ORA1, ORA2, DURATA, HOST_NAME, DB_NAME, OPTIMIZER, NOTE)
           Values
             (TABELLA_LOG_ID.Nextval,
              'P_AGG_NOTIFICHE',
              v_ora_inizio,
              v_ora_fine,
              (v_ora_fine - v_ora_inizio) * 24 * 60,
              v_host_name,
              v_db_name,
              v_optimizer,
              v_testo||' - numero spedizioni .'
             );

           commit;

    end if;

END;
/


CREATE OR REPLACE PROCEDURE P_AGG_MOD_GOL (p_aa_id NUMBER, v_liv1 VARCHAR default 'FACOLTA')
AS
   /*
   Se si vuole mettere il TIPO_CORSO come primo livello, passarlo alla procedura nel seguente modo:
   
   exec P_AGG_MOD_GOL (2014, v_liv1 => 'TIPO_CORSO');
   
   altrimenti viene messa la facolta

   */
   ---------------------------------------------------------------------------------
   --- CALCOLO DEGLI ID
   --- NOTE:   v_liv1  VARCHAR2(50) := 'FACOLTA';   -- FACOLTA oppure TIPO_CORSO
   ---------------------------------------------------------------------------------
   ---
   ---------------------------------------------------------------------------------

   --- CURSORE PRIMO LIVELLO
   -- Facolta
   CURSOR c_liv_1_fac
   IS
        SELECT aa_off_id, fac_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY aa_off_id, fac_id
      ORDER BY aa_off_id, fac_id;

   -- Tipo corso
   CURSOR c_liv_1_tipo_corso
   IS
        SELECT aa_off_id, TIPO_CORSO_COD
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY aa_off_id, TIPO_CORSO_COD
      ORDER BY aa_off_id, TIPO_CORSO_COD;
      
      
   --- CURSORE SECONDO LIVELLO
   CURSOR c_liv_2
   IS
        SELECT mid_liv_1, cds_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1, cds_id
      ORDER BY mid_liv_1, cds_id;

   --- CURSORE TERZO LIVELLO
   CURSOR c_liv_3
   IS
        SELECT mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id
      ORDER BY mid_liv_1,
               mid_liv_2,
               aa_ord_id,
               pds_id;

   --- CURSORE QUARTO LIVELLO
   CURSOR c_liv_4
   IS
        SELECT mid_liv_1,
               mid_liv_2,
               NVL (mid_liv_3, 99999) AS mid_liv_3,
               ad_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_liv_1,
               mid_liv_2,
               mid_liv_3,
               ad_id
      ORDER BY mid_liv_1,
               mid_liv_2,
               NVL (mid_liv_3, 99999),
               ad_id;

   --- CURSORE AD
   CURSOR c_ad
   IS
        SELECT DISTINCT mid_liv_4
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_liv_4;

   --- CURSORE AD_CLA
   CURSOR c_ad_cla
   IS
        SELECT DISTINCT mid_ad, fat_part_cod, dom_part_cod
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, fat_part_cod, dom_part_cod;

   --- CURSORE AD_MOD
   CURSOR c_ad_mod
   IS
        SELECT DISTINCT mid_ad, ud_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, ud_id;

   --- CURSORE AD_DOC
   CURSOR c_ad_doc
   IS
        SELECT DISTINCT mid_ad, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad, docente_id;

   --- CURSORE AD_MOD_DOC
   CURSOR c_ad_mod_doc
   IS
        SELECT DISTINCT mid_ad_mod, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad_mod, docente_id;

   --- CURSORE AD_CLA_DOC
   CURSOR c_ad_cla_doc
   IS
        SELECT DISTINCT mid_ad_cla, docente_id
          FROM GOL_IUNI
         WHERE aa_off_id = p_aa_id
      ORDER BY mid_ad_cla, docente_id;

   v_id                 GOL_IUNI.mid_ad%TYPE;
   v_old_aa_off_id      GOL_IUNI.aa_off_id%TYPE;
   v_old_fac_id         GOL_IUNI.fac_id%TYPE;
   v_old_cds_id         GOL_IUNI.cds_id%TYPE;
   v_old_aa_ord_id      GOL_IUNI.aa_ord_id%TYPE;
   v_old_pds_id         GOL_IUNI.pds_id%TYPE;
   v_old_ad_id          GOL_IUNI.ad_id%TYPE;
   v_old_tipo_corso_cod GOL_IUNI.TIPO_CORSO_COD%TYPE;

   v_old_mid_liv_1      GOL_IUNI.mid_liv_1%TYPE;
   v_old_mid_liv_2      GOL_IUNI.mid_liv_2%TYPE;
   v_old_mid_liv_3      GOL_IUNI.mid_liv_3%TYPE;
   v_old_mid_liv_4      GOL_IUNI.mid_liv_4%TYPE;

   v_old_mid_ad         GOL_IUNI.mid_ad%TYPE;
   v_old_mid_ad_mod     GOL_IUNI.mid_ad_mod%TYPE;
   v_old_mid_ad_cla     GOL_IUNI.mid_ad_cla%TYPE;
   v_old_mid_ad_doc     GOL_IUNI.mid_ad_doc%TYPE;

   v_old_fat_part_cod   GOL_IUNI.fat_part_cod%TYPE;
   v_old_dom_part_cod   GOL_IUNI.dom_part_cod%TYPE;
   v_old_ud_id          GOL_IUNI.ud_id%TYPE;

   v_old_docente_id     GOL_IUNI.docente_id%TYPE;


   v_time_start         DATE;
   v_time_end           DATE;
   v_step               VARCHAR2 (100);
   
   -- Default
  

BEGIN
   v_old_fac_id := 0;
   v_old_aa_off_id := 0;
   v_old_cds_id := 0;
   v_old_aa_ord_id := 0;
   v_old_pds_id := 0;
   v_old_ad_id := 0;
   v_old_mid_liv_1 := 0;
   v_old_mid_liv_2 := 0;
   v_old_mid_liv_3 := 0;

   v_old_mid_ad := 0;
   v_old_mid_ad_cla := 0;
   v_old_mid_ad_doc := 0;
   v_old_mid_ad_mod := 0;

   v_old_fat_part_cod := 'x';
   v_old_dom_part_cod := 'x';
   v_old_ud_id := 0;
   v_old_docente_id := 0;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- ELIMINAZIONE TABELLA DI APPOGGIO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE GOL_IUNI
    WHERE aa_off_id = p_aa_id;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- CARICAMENTO TABELLA DI APPOGGIO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO GOL_IUNI (mid_pk,
                         mid_liv_1,
                         mid_liv_2,
                         mid_liv_3,
                         mid_liv_4,
                         mid_ad,
                         mid_ad_cla,
                         mid_ad_doc,
                         mid_ad_mod,
                         mid_ad_mod_doc,
                         mid_ad_cla_doc,
                         AA_OFF_ID,
                         FAC_ID,
                         CDS_ID,
                         AD_ID,
                         AA_ORD_ID,
                         PDS_ID,
                         UD_ID,
                         SEG_ID,
                         TIPO_CORSO_COD,
                         COD_FAC,
                         DES_FAC,
                         COD_CDS,
                         DES_CDS,
                         COD_AD,
                         DES_AD,
                         COD_MOD,
                         DES_MOD,
                         TIPO_INS_COD,
                         DUR_UNI_VAL,
                         DUR_STU_IND,
                         PESO_TOT,
                         PESO_DET,
                         TIPO_AF_COD,
                         DES_TAF,
                         AMB_ID,
                         DES_AMB,
                         SETT_COD,
                         DOCENTE_ID,
                         TIPO_COPERTURA_COD,
                         FAT_PART_COD,
                         DOM_PART_COD,
                         TITOLARE_FLG,
                         PART_COD,
                         DES_PART,
                         TIPO_DID_COD,
                         DES_TIPI_DID,
                         LINGUA_DID_ID,
                         DES_LUNGUA_DID)
      --CREATE TABLE GOL_IUNI AS
      SELECT ROWNUM AS mid_pk,
             CAST (NULL AS NUMBER) AS mid_liv_1,                   --- facoltà
             CAST (NULL AS NUMBER) AS mid_liv_2,                     --- corso
             CAST (NULL AS NUMBER) AS mid_liv_3,    --- ordinamento / persorso
             CAST (NULL AS NUMBER) AS mid_liv_4,                  --- attività
             CAST (NULL AS NUMBER) AS mid_ad,
             CAST (NULL AS NUMBER) AS mid_ad_cla,
             CAST (NULL AS NUMBER) AS mid_ad_doc,
             CAST (NULL AS NUMBER) AS mid_ad_mod,
             CAST (NULL AS NUMBER) AS mid_ad_mod_doc,
             CAST (NULL AS NUMBER) AS mid_ad_cla_doc,
             AA_OFF_ID,
             FAC_ID,
             CDS_ID,
             AD_ID,
             AA_ORD_ID,
             PDS_ID,
             UD_ID,
             SEG_ID,
             TIPO_CORSO_COD,
             COD_FAC,
             DES_FAC,
             COD_CDS,
             DES_CDS,
             COD_AD,
             DES_AD,
             COD_MOD,
             DES_MOD,
             TIPO_INS_COD,
             DUR_UNI_VAL,
             DUR_STU_IND,
             PESO_TOT,
             PESO_DET,
             TIPO_AF_COD,
             DES_TAF,
             AMB_ID,
             DES_AMB,
             SETT_COD,
             DOCENTE_ID,
             TIPO_COPERTURA_COD,
             FAT_PART_COD,
             DOM_PART_COD,
             TITOLARE_FLG,
             PART_COD,
             DES_PART,
             TIPO_DID_COD,
             DES_TIPI_DID,
             LINGUA_DID_ID,
             DES_LUNGUA_DID
        FROM v_gol_offerta_esse3 a
       WHERE aa_off_id = p_aa_id;


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- DEFINIZIONE PROGRESSIVI
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- Livello 1
   -- ---------
   SELECT NVL (MAX (mid_liv_1), 10000) INTO v_id FROM GOL_IUNI;

   if v_liv1 = 'FACOLTA' then
       FOR r_liv_1 IN c_liv_1_fac
       LOOP
          IF     v_old_fac_id = r_liv_1.fac_id
             AND v_old_aa_off_id = r_liv_1.aa_off_id
          THEN
             v_id := v_id;
          ELSE
             v_id := v_id + 1;
          END IF;

          UPDATE GOL_IUNI
             SET mid_liv_1 = v_id
           WHERE aa_off_id = r_liv_1.aa_off_id AND fac_id = r_liv_1.fac_id;

          v_old_aa_off_id := r_liv_1.aa_off_id;
          v_old_fac_id := r_liv_1.fac_id;
       END LOOP;
    end if;
    
   if v_liv1 = 'TIPO_CORSO' then
       FOR r_liv_1 IN c_liv_1_tipo_corso
       LOOP
          IF     v_old_tipo_corso_cod = r_liv_1.tipo_corso_cod
             AND v_old_aa_off_id = r_liv_1.aa_off_id
          THEN
             v_id := v_id;
          ELSE
             v_id := v_id + 1;
          END IF;

          UPDATE GOL_IUNI
             SET mid_liv_1 = v_id
           WHERE aa_off_id = r_liv_1.aa_off_id AND tipo_corso_cod = r_liv_1.tipo_corso_cod;

          v_old_aa_off_id := r_liv_1.aa_off_id;
          v_old_tipo_corso_cod := r_liv_1.tipo_corso_cod;
       END LOOP;
   end if;
    
   -- Livello 2
   -- ---------
   SELECT NVL (MAX (mid_liv_2), 20000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_2 IN c_liv_2
   LOOP
      IF     v_old_mid_liv_1 = r_liv_2.mid_liv_1
         AND v_old_cds_id = r_liv_2.cds_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_2 = v_id
       WHERE mid_liv_1 = r_liv_2.mid_liv_1 AND cds_id = r_liv_2.cds_id;

      v_old_mid_liv_1 := r_liv_2.mid_liv_1;
      v_old_cds_id := r_liv_2.cds_id;
   END LOOP;

   SELECT NVL (MAX (mid_liv_3), 30000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_3 IN c_liv_3
   LOOP
      IF     v_old_mid_liv_1 = r_liv_3.mid_liv_1
         AND v_old_mid_liv_2 = r_liv_3.mid_liv_2
         AND v_old_aa_ord_id = r_liv_3.aa_ord_id
         AND v_old_pds_id = r_liv_3.pds_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_3 = v_id
       WHERE     mid_liv_1 = r_liv_3.mid_liv_1
             AND mid_liv_2 = r_liv_3.mid_liv_2
             AND aa_ord_id = r_liv_3.aa_ord_id
             AND pds_id = r_liv_3.pds_id;

      v_old_mid_liv_1 := r_liv_3.mid_liv_1;
      v_old_mid_liv_2 := r_liv_3.mid_liv_2;
      v_old_aa_ord_id := r_liv_3.aa_ord_id;
      v_old_pds_id := r_liv_3.pds_id;
   END LOOP;

   --- doce è presente un solo ordinamento e un solo percorso
   UPDATE GOL_IUNI
      SET mid_liv_3 = NULL
    WHERE (mid_liv_1, mid_liv_2) IN (  SELECT mid_liv_1, mid_liv_2
                                         FROM (SELECT DISTINCT
                                                      mid_liv_1,
                                                      mid_liv_2,
                                                      mid_liv_3
                                                 FROM GOL_IUNI)
                                     GROUP BY mid_liv_1, mid_liv_2
                                       HAVING COUNT (*) = 1);

   SELECT NVL (MAX (mid_liv_4), 40000) INTO v_id FROM GOL_IUNI;

   FOR r_liv_4 IN c_liv_4
   LOOP
      IF     v_old_mid_liv_1 = r_liv_4.mid_liv_1
         AND v_old_mid_liv_2 = r_liv_4.mid_liv_2
         AND v_old_mid_liv_3 = r_liv_4.mid_liv_3
         AND v_old_ad_id = r_liv_4.ad_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_liv_4 = v_id
       WHERE     mid_liv_1 = r_liv_4.mid_liv_1
             AND mid_liv_2 = r_liv_4.mid_liv_2
             AND NVL (mid_liv_3, 99999) = r_liv_4.mid_liv_3
             AND ad_id = r_liv_4.ad_id;

      v_old_mid_liv_1 := r_liv_4.mid_liv_1;
      v_old_mid_liv_2 := r_liv_4.mid_liv_2;
      v_old_mid_liv_3 := r_liv_4.mid_liv_3;
      v_old_ad_id := r_liv_4.ad_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad IN c_ad
   LOOP
      IF v_old_mid_liv_4 = r_ad.mid_liv_4
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad = v_id
       WHERE mid_liv_4 = r_ad.mid_liv_4;

      v_old_mid_liv_4 := r_ad.mid_liv_4;
   END LOOP;

   SELECT NVL (MAX (mid_ad_cla), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_cla IN c_ad_cla
   LOOP
      IF     v_old_mid_ad = r_ad_cla.mid_ad
         AND v_old_fat_part_cod = r_ad_cla.fat_part_cod
         AND v_old_dom_part_cod = r_ad_cla.dom_part_cod
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_cla = v_id
       WHERE     mid_ad = r_ad_cla.mid_ad
             AND fat_part_cod = r_ad_cla.fat_part_cod
             AND dom_part_cod = r_ad_cla.dom_part_cod;

      v_old_mid_ad := r_ad_cla.mid_ad;
      v_old_fat_part_cod := r_ad_cla.fat_part_cod;
      v_old_dom_part_cod := r_ad_cla.dom_part_cod;
   END LOOP;

   SELECT NVL (MAX (mid_ad_mod), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_mod IN c_ad_mod
   LOOP
      IF v_old_mid_ad = r_ad_mod.mid_ad AND v_old_ud_id = r_ad_mod.ud_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_mod = v_id
       WHERE mid_ad = r_ad_mod.mid_ad AND ud_id = r_ad_mod.ud_id;

      v_old_mid_ad := r_ad_mod.mid_ad;
      v_old_ud_id := r_ad_mod.ud_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_doc IN c_ad_doc
   LOOP
      IF     v_old_mid_ad = r_ad_doc.mid_ad
         AND v_old_docente_id = r_ad_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_doc = v_id
       WHERE mid_ad = r_ad_doc.mid_ad AND docente_id = r_ad_doc.docente_id;

      v_old_mid_ad := r_ad_doc.mid_ad;
      v_old_docente_id := r_ad_doc.docente_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_mod_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_mod_doc IN c_ad_mod_doc
   LOOP
      IF     v_old_mid_ad_mod = r_ad_mod_doc.mid_ad_mod
         AND v_old_docente_id = r_ad_mod_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_mod_doc = v_id
       WHERE     mid_ad_mod = r_ad_mod_doc.mid_ad_mod
             AND docente_id = r_ad_mod_doc.docente_id;

      v_old_mid_ad_mod := r_ad_mod_doc.mid_ad_mod;
      v_old_docente_id := r_ad_mod_doc.docente_id;
   END LOOP;

   SELECT NVL (MAX (mid_ad_cla_doc), 0) INTO v_id FROM GOL_IUNI;

   FOR r_ad_cla_doc IN c_ad_cla_doc
   LOOP
      IF     v_old_mid_ad_cla = r_ad_cla_doc.mid_ad_cla
         AND v_old_docente_id = r_ad_cla_doc.docente_id
      THEN
         v_id := v_id;
      ELSE
         v_id := v_id + 1;
      END IF;

      UPDATE GOL_IUNI
         SET mid_ad_cla_doc = v_id
       WHERE     mid_ad_cla = r_ad_cla_doc.mid_ad_cla
             AND docente_id = r_ad_cla_doc.docente_id;

      v_old_mid_ad_cla := r_ad_cla_doc.mid_ad_cla;
      v_old_docente_id := r_ad_cla_doc.docente_id;
   END LOOP;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- CARICAMENTO DEI DATI NELLE TABELLE
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

   --- eliminazione dati lingua
   DELETE FROM gol_liv_ln
         WHERE mid IN (SELECT mid
                         FROM gol_liv
                        WHERE aa_id = p_aa_id);

   DELETE FROM gol_liv
         WHERE aa_id = p_aa_id;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- PRIMO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- Se primo livello = FACOLTA
   -- --------------------------
   if v_liv1 = 'FACOLTA' then
        INSERT INTO gol_liv (mid,
                    code,
                    name,
                    description,
                    mid_liv_padre,
                    mid_dett,
                    aa_id,
                    ordine)
        SELECT a.mid_liv_1 AS mid,
           cod AS code,
           nvl(decode(b.des_breve, b.cod, null, b.des_breve), b.des) as name,
           INITCAP (via || ', ' || citta) AS description,
           NULL AS mid_liv_padre,
           NULL AS mid_dett,
           aa_off_id AS aa_id,
           NULL AS ordine
        FROM GOL_IUNI a JOIN p06_fac b ON a.fac_id = b.fac_id
        WHERE aa_off_id = 2014
        GROUP BY a.mid_liv_1,
           a.aa_off_id,
           b.cod,
           NVL (b.des_breve, b.des),
           via || ', ' || citta
        ORDER BY a.mid_liv_1;

        --- inglese
        INSERT INTO gol_liv_ln (mid,
                       ln_code,
                       name,
                       description)
        SELECT a.mid_liv_1 AS mid,
           'en' AS ln_code,
           fu_des_up_low(nvl(c.des, nvl(b.des_breve, b.des))) as name,
           INITCAP (via || ', ' || citta) AS description
        FROM GOL_IUNI a
           JOIN p06_fac b ON a.fac_id = b.fac_id
           LEFT JOIN p06_fac_des_lin c
              ON c.fac_id = b.fac_id AND lingua_id = 1
        WHERE aa_off_id = p_aa_id
        GROUP BY a.mid_liv_1,
           a.aa_off_id,
           b.cod,
           NVL (c.des, NVL (b.des_breve, b.des)),
           via || ', ' || citta
        ORDER BY a.mid_liv_1;
    end if;
    
     -- Se primo livello = TIPO_CORSO
   -- --------------------------
    if v_liv1 = 'TIPO_CORSO' then
        INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_1 AS mid,
               c.tipo_corso_cod AS code,
               fu_des_up_low (c.tipo_corso_des) AS name,
               c.tipo_corso_cod AS description,
               NULL AS mid_liv_padre,
               NULL AS mid_dett,
               aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a 
               JOIN p06_cds b ON a.cds_id = b.cds_id
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
         WHERE aa_off_id = 2014
        GROUP BY a.mid_liv_1,
               a.aa_off_id,
               c.tipo_corso_cod,
               fu_des_up_low (c.tipo_corso_des),
               c.tipo_corso_cod
        ORDER BY a.mid_liv_1;
      
         --- inglese
        INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_1 AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (c.des, NVL (b.des_breve, b.des))) AS name,
               INITCAP (via || ', ' || citta) AS description
          FROM GOL_IUNI a
               JOIN p06_fac b ON a.fac_id = b.fac_id
               LEFT JOIN p06_fac_des_lin c
                  ON c.fac_id = b.fac_id AND lingua_id = 1
         WHERE aa_off_id = p_aa_id
        GROUP BY a.mid_liv_1,
               a.aa_off_id,
               b.cod,
               NVL (c.des, NVL (b.des_breve, b.des)),
               via || ', ' || citta
        ORDER BY a.mid_liv_1;
    end if;
    
    
   v_time_end := SYSDATE;

   v_step := 'step 1';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- SECONDO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_2 AS mid,
               cod AS code,
               fu_des_up_low (b.des) AS name,
                  '['
               || cod
               || '] '
               || c.tipo_corso_cod
               || ' - '
               || fu_des_up_low (c.tipo_corso_des)
                  AS description,
               a.mid_liv_1 AS mid_liv_padre,
               NULL AS mid_dett,
               aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a
               JOIN p06_cds b ON a.cds_id = b.cds_id
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.aa_off_id,
               a.mid_liv_2,
               b.cod,
               b.des,
               c.tipo_corso_cod,
               c.tipo_corso_des
      ORDER BY a.mid_liv_2;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_2 AS mid,
               'en' AS ln_cod,
               fu_des_up_low (b1.des) AS name,
                  '['
               || cod
               || '] '
               || c.tipo_corso_cod
               || ' - '
               || fu_des_up_low (NVL (c1.ds_tipo_corso_des, c.tipo_corso_des))
                  AS description
          FROM GOL_IUNI a
               JOIN p06_cds b ON a.cds_id = b.cds_id
               LEFT JOIN p06_cds_des_lin b1
                  ON a.cds_id = b1.cds_id AND b1.lingua_id = 1
               JOIN tipi_corso c ON b.tipo_corso_cod = c.tipo_corso_cod
               LEFT JOIN tipi_corso_des_lin c1
                  ON b.tipo_corso_cod = c1.tipo_corso_cod AND c1.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.aa_off_id,
               a.mid_liv_2,
               b.cod,
               b1.des,
               c.tipo_corso_cod,
               NVL (c1.ds_tipo_corso_des, c.tipo_corso_des)
      ORDER BY a.mid_liv_2;

   v_time_end := SYSDATE;

   v_step := 'step 2';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- TERZO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_3 AS mid,
               b.aa_ord_id || '/' || c.cod AS code,
               b.aa_ord_id || ' - ' || c.cod AS name,
               'Ind: ' || fu_des_up_low (c.des) AS description,
               a.mid_liv_2 AS mid_liv_padre,
               NULL AS mid_dett,
               a.aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a
               JOIN p06_cdsord b
                  ON a.cds_id = b.cds_id AND a.aa_ord_id = b.aa_ord_id
               JOIN p06_pdsord c
                  ON     a.cds_id = c.cds_id
                     AND a.aa_ord_id = c.aa_ord_id
                     AND a.pds_id = c.pds_id
         WHERE mid_liv_3 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               b.aa_ord_id,
               c.cod,
               a.aa_off_id,
               c.des,
               a.cds_id
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.aa_ord_id || '/' || c.cod;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_3 AS mid,
               'en' AS ln_code,
               b.aa_ord_id || ' - ' || c.cod AS name,
               'Ind: ' || fu_des_up_low (NVL (c1.des, c.des)) AS description
          FROM GOL_IUNI a
               JOIN p06_cdsord b
                  ON a.cds_id = b.cds_id AND a.aa_ord_id = b.aa_ord_id
               JOIN p06_pdsord c
                  ON     a.cds_id = c.cds_id
                     AND a.aa_ord_id = c.aa_ord_id
                     AND a.pds_id = c.pds_id
               LEFT JOIN p06_pdsord_des_lin c1
                  ON     a.cds_id = c1.cds_id
                     AND a.aa_ord_id = c1.aa_ord_id
                     AND a.pds_id = c1.pds_id
                     AND c1.lingua_id = 1
         WHERE mid_liv_3 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               b.aa_ord_id,
               c.cod,
               a.aa_off_id,
               NVL (c1.des, c.des),
               a.cds_id
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.aa_ord_id || '/' || c.cod;

   v_time_end := SYSDATE;

   v_step := 'step 3';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   -- ULTIMO LIVELLO
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   INSERT INTO gol_liv (mid,
                        code,
                        name,
                        description,
                        mid_liv_padre,
                        mid_dett,
                        aa_id,
                        ordine)
        SELECT a.mid_liv_4 AS mid,
               b.cod AS code,
               fu_des_up_low (b.des) AS name,
               'lista docenti...' AS description,
               NVL (a.mid_liv_3, a.mid_liv_2) AS mid_liv_padre,
               mid_ad AS mid_dett,
               a.aa_off_id AS aa_id,
               NULL AS ordine
          FROM GOL_IUNI a JOIN p09_ad_gen b ON a.ad_id = b.ad_id
         WHERE mid_liv_4 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.aa_off_id,
               a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               a.mid_liv_4,
               b.des,
               b.cod,
               mid_ad
      ORDER BY a.mid_liv_1, a.mid_liv_2, b.des;

   --- inglese
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
        SELECT a.mid_liv_4 AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (b1.ds_ad_des, b.des)) AS name,
               'lista docenti...' AS description
          FROM GOL_IUNI a
               JOIN p09_ad_gen b ON a.ad_id = b.ad_id
               LEFT JOIN p09_ad_des_lin b1
                  ON a.ad_id = b1.ad_id AND b1.lingua_id = 1
         WHERE mid_liv_4 IS NOT NULL AND aa_off_id = p_aa_id
      GROUP BY a.aa_off_id,
               a.mid_liv_1,
               a.mid_liv_2,
               a.mid_liv_3,
               a.mid_liv_4,
               NVL (b1.ds_ad_des, b.des),
               b.cod,
               mid_ad
      ORDER BY a.mid_liv_1, a.mid_liv_2, NVL (b1.ds_ad_des, b.des);


   v_time_end := SYSDATE;

   v_step := 'step 4';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- caricamento totale ITALIANO
   INSERT INTO gol_liv_ln (mid,
                           ln_code,
                           name,
                           description)
      SELECT mid,
             'it' ln_code,
             name,
             description
        FROM gol_liv
       WHERE aa_id = p_aa_id;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad (mid,
                       percorso,
                       attivita,
                       descrizione,
                       metodi_did_des,
                       obiett_form_des,
                       prerequisiti_des,
                       contenuti_des,
                       testi_rif_des,
                       mod_ver_appr_des,
                       altre_info_des,
                       peso,
                       struttura_cfu,
                       cds_id,
                       ad_id,
                       aa_off_id,
                       aa_ord_id,
                       pds_id,
                       ext_id)
      SELECT DISTINCT a.mid_ad AS mid,
                      a.des_cds AS percorso,
                      a.des_ad AS attivita,
                      NULL AS descrizione,
                      NULL AS metodi_did_des,
                      NULL AS obiett_form_des,
                      NULL AS prerequisiti_des,
                      NULL AS contenuti_des,
                      NULL AS testi_rif_des,
                      NULL AS mod_ver_appr_des,
                      NULL AS altre_info_des,
                      a.peso_tot AS peso,
                      'Convenzionale in italiano' AS struttura_cfu,
                      a.cds_id AS cds_id,
                      a.ad_id AS ad_id,
                      a.aa_off_id AS aa_off_id,
                      a.aa_ord_id AS aa_ord_id,
                      a.pds_id AS pds_id,
                      NULL AS ext_id
        FROM GOL_IUNI a
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_ln (mid,
                          ln_code,
                          percorso,
                          attivita,
                          descrizione,
                          metodi_did_des,
                          obiett_form_des,
                          prerequisiti_des,
                          contenuti_des,
                          testi_rif_des,
                          mod_ver_appr_des,
                          altre_info_des,
                          struttura_cfu)
      SELECT DISTINCT
             a.mid_ad AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (b.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (b1.ds_ad_des, a.des_ad)) AS attivita,
             NULL AS descrizione,
             NULL AS metodi_did_des,
             NULL AS obiett_form_des,
             NULL AS prerequisiti_des,
             NULL AS contenuti_des,
             NULL AS testi_rif_des,
             NULL AS mod_ver_appr_des,
             NULL AS altre_info_des,
             'Conventional in Italian' AS struttura_cfu
        FROM GOL_IUNI a
             LEFT JOIN p06_cds_des_lin b
                ON a.cds_id = b.cds_id AND lingua_id = 1
             LEFT JOIN p09_ad_des_lin b1
                ON a.ad_id = b1.ad_id AND b1.lingua_id = 1
       WHERE aa_off_id = p_aa_id;


   v_time_end := SYSDATE;

   v_step := 'step 5';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiornamento descrizione in italiano e in lingua
   unixx_descrizione_ad (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 6';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- AGGIORNO I TESTI
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM T_GOL_AD_DESCRIZIONI_TUTTE;

   INSERT INTO T_GOL_AD_DESCRIZIONI_TUTTE
      SELECT DISTINCT a.mid,
                      c.cds_id,
                      c.ad_id,
                      c.aa_off_id,
                      c.aa_ord_id,
                      c.pds_id,
                      c.fat_part_cod,
                      c.dom_part_cod,
                      c.part_cod,
                      ad_log_id,
                      c.metodi_did_des,
                      c.obiett_form_des,
                      c.prerequisiti_des,
                      c.contenuti_des,
                      c.testi_rif_des,
                      c.mod_ver_appr_des,
                      c.altre_info_des,
                      'it'
        FROM gol_ad a
             JOIN GOL_IUNI b ON a.mid = b.mid_ad
             JOIN p09_ad_log_pds c
                ON     b.cds_id = c.cds_id
                   AND b.ad_id = c.ad_id
                   AND b.aa_off_id = c.aa_off_id
                   AND b.aa_ord_id = c.aa_ord_id
                   AND b.pds_id = c.pds_id
       WHERE     (   c.metodi_did_des IS NOT NULL
                  OR c.obiett_form_des IS NOT NULL
                  OR c.prerequisiti_des IS NOT NULL
                  OR c.contenuti_des IS NOT NULL
                  OR c.testi_rif_des IS NOT NULL
                  OR c.mod_ver_appr_des IS NOT NULL
                  OR c.altre_info_des IS NOT NULL)
             AND a.aa_off_id = p_aa_id;

   INSERT INTO T_GOL_AD_DESCRIZIONI_TUTTE
      SELECT DISTINCT a.mid,
                      c.cds_id,
                      c.ad_id,
                      c.aa_off_id,
                      c.aa_ord_id,
                      c.pds_id,
                      c.fat_part_cod,
                      c.dom_part_cod,
                      c.part_cod,
                      ad_log_id,
                      c.metodi_did_des,
                      c.obiett_form_des,
                      c.prerequisiti_des,
                      c.contenuti_des,
                      c.testi_rif_des,
                      c.mod_ver_appr_des,
                      c.altre_info_des,
                      'en'
        FROM gol_ad a
             JOIN GOL_IUNI b ON a.mid = b.mid_ad
             JOIN p09_ad_log_pds_des_lin c
                ON     b.cds_id = c.cds_id
                   AND b.ad_id = c.ad_id
                   AND b.aa_off_id = c.aa_off_id
                   AND b.aa_ord_id = c.aa_ord_id
                   AND b.pds_id = c.pds_id
                   AND c.lingua_id = 1
       WHERE     (   c.metodi_did_des IS NOT NULL
                  OR c.obiett_form_des IS NOT NULL
                  OR c.prerequisiti_des IS NOT NULL
                  OR c.contenuti_des IS NOT NULL
                  OR c.testi_rif_des IS NOT NULL
                  OR c.mod_ver_appr_des IS NOT NULL
                  OR c.altre_info_des IS NOT NULL)
             AND a.aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 6.1';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   DELETE FROM T_GOL_AD_DESCRIZIONI;

   INSERT INTO T_GOL_AD_DESCRIZIONI (MID,
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
                                     ALTRE_INFO_DES,
                                     LN_CODE)
      SELECT MID,
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
             ALTRE_INFO_DES,
             LN_CODE
        FROM T_GOL_AD_DESCRIZIONI_TUTTE
       WHERE (mid, ln_code) NOT IN (  SELECT mid, ln_code
                                        FROM T_GOL_AD_DESCRIZIONI_TUTTE
                                    GROUP BY mid, ln_code
                                      HAVING COUNT (*) > 1);

   v_time_end := SYSDATE;

   v_step := 'step 6.2';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- METODI_DID_DES = '<strong>Metodi didattici ???</strong><br/>'
   UPDATE gol_ad a
      SET metodi_did_des =
             (SELECT    '<strong>Metodi didattici </strong><br/>
    '
                     || b.metodi_did_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     metodi_did_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET metodi_did_des =
             (SELECT    '<strong>Teaching Methods </strong><br/>
    '
                     || b.metodi_did_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     metodi_did_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 7';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---     OBIETT_FORM_DES = '<strong>Obiettivi ???</strong><br/>'
   UPDATE gol_ad a
      SET obiett_form_des =
             (SELECT DISTINCT
                        '<strong>Obiettivi </strong><br/>
    '
                     || b.obiett_form_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     obiett_form_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET obiett_form_des =
             (SELECT DISTINCT
                        '<strong>Objective </strong><br/>
    '
                     || b.obiett_form_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     obiett_form_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 8';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---     PREREQUISITI_DES = '<strong>Prerequisiti ???</strong><br/>'
   UPDATE gol_ad a
      SET prerequisiti_des =
             (SELECT DISTINCT
                        '<strong>Prerequisiti </strong><br/>
    '
                     || b.prerequisiti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     prerequisiti_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET prerequisiti_des =
             (SELECT DISTINCT
                        '<strong>Prerequisites </strong><br/>
    '
                     || b.prerequisiti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     prerequisiti_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 9';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    CONTENUTI_DES = '<strong>Contenuti ???</strong><br/>'
   UPDATE gol_ad a
      SET contenuti_des =
             (SELECT DISTINCT
                        '<strong>Contenuti </strong><br/>
    '
                     || contenuti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     contenuti_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET contenuti_des =
             (SELECT DISTINCT
                        '<strong>Contents </strong><br/>
    '
                     || contenuti_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     contenuti_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 10';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;


   v_time_start := SYSDATE;

   ---    TESTI_RIF_DES = '<strong>testi di riferimento ???</strong><br/>'
   UPDATE gol_ad a
      SET testi_rif_des =
             (SELECT DISTINCT
                        '<strong>Testi di riferimento </strong><br/>
    '
                     || b.testi_rif_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     testi_rif_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET testi_rif_des =
             (SELECT DISTINCT
                        '<strong>Reference Books </strong><br/>
    '
                     || b.testi_rif_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     testi_rif_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 11';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    MOD_VER_APPR_DES = '<strong>Modalita di apprendimento ???</strong><br/>'
   UPDATE gol_ad a
      SET mod_ver_appr_des =
             (SELECT DISTINCT
                        '<strong>Modalita di apprendimento </strong><br/>
    '
                     || b.mod_ver_appr_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     mod_ver_appr_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET mod_ver_appr_des =
             (SELECT DISTINCT
                        '<strong>Learning Model </strong><br/>
    '
                     || b.mod_ver_appr_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     mod_ver_appr_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 12';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   ---    ALTRE_INFO_DES = '<strong>Altre info ???</strong><br/>'
   UPDATE gol_ad a
      SET altre_info_des =
             (SELECT DISTINCT
                        '<strong>Altre info </strong><br/>
    '
                     || b.altre_info_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'it')
    WHERE mid IN (SELECT mid
                    FROM T_GOL_AD_DESCRIZIONI
                   WHERE     altre_info_des IS NOT NULL
                         AND aa_off_id = p_aa_id
                         AND ln_code = 'it');

   UPDATE gol_ad_ln a
      SET altre_info_des =
             (SELECT DISTINCT
                        '<strong>More info </strong><br/>
    '
                     || b.altre_info_des
                     || '<br/><br/>'
                FROM T_GOL_AD_DESCRIZIONI b
               WHERE a.mid = b.mid AND b.ln_code = 'en')
    WHERE     mid IN (SELECT mid
                        FROM T_GOL_AD_DESCRIZIONI
                       WHERE     altre_info_des IS NOT NULL
                             AND aa_off_id = p_aa_id
                             AND ln_code = 'en')
          AND a.ln_code = 'en';

   v_time_end := SYSDATE;

   v_step := 'step 13';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;



   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_CLA
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

   DELETE FROM gol_ad_cla_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_cla
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_cla
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla (mid,
                           mid_ad,
                           percorso,
                           attivita,
                           classe,
                           descrizione,
                           info_sem_classe,
                           info_aule_edifici,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           dom_part_cod,
                           cod_corso,
                           cod_percorso,
                           cod_ad,
                           fat_part_cod)
      SELECT DISTINCT a.mid_ad_cla AS mid,
                      a.mid_ad AS mid_ad,
                      a.des_cds AS percorso,
                      a.des_ad AS attivita,
                      b.des AS classe,
                      ' ' AS descrizione,
                      NULL AS info_sem_classe,
                      NULL AS info_aule_edifici,
                      a.cds_id AS cds_id,
                      a.ad_id AS ad_id,
                      a.aa_off_id AS aa_off_id,
                      a.aa_ord_id AS aa_ord_id,
                      a.pds_id AS pds_id,
                      a.dom_part_cod AS dom_part_cod,
                      a.cod_cds AS cod_corso,
                      NULL AS cod_percorso,
                      a.cod_ad AS cod_ad,
                      a.fat_part_cod AS fat_part_cod
        FROM GOL_IUNI a
             JOIN dom_part b
                ON     a.fat_part_cod = b.fat_part_cod
                   AND a.dom_part_cod = b.dom_part_cod
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 14';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   UPDATE gol_ad_cla a
      SET info_sem_classe =
             (SELECT DISTINCT des_part
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_cla AND des_part IS NOT NULL)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 15';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_cla a
      SET info_sem_classe = 'Annuale'
    WHERE info_sem_classe IS NULL AND aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 16';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- inglese
   INSERT INTO gol_ad_cla_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              classe,
                              descrizione,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT DISTINCT
             a.mid_ad_cla AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
             b.des AS classe,
             ' ' AS descrizione,
             info_sem_classe AS info_sem_classe,
             info_aule_edifici AS info_aule_edifici
        FROM GOL_IUNI a
             JOIN gol_ad_cla a1 ON a1.MID = a.mid_ad_cla
             JOIN dom_part b
                ON     a.fat_part_cod = b.fat_part_cod
                   AND a.dom_part_cod = b.dom_part_cod
             LEFT JOIN p06_cds_des_lin c1
                ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
             LEFT JOIN p09_ad_des_lin c2
                ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
       WHERE a.aa_off_id = p_aa_id;

   --- update CLASSE
   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Iniziale cognome', 'Initial surname')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Iniziali cognome', 'Initial surname')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Nessun partizionamento', 'No partition')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Matricole dispari', 'Matricola unequal')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET classe = REPLACE (classe, 'Matricole pari', 'Matricola equal')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   --- update INFO_SEM_CLASSE
   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Unico', 'Unique')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Ciclo', 'Cycle')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Annuale', 'Annual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Semestrale', 'Semiannual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Bimestrale', 'Bimestrial')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Primo', 'First')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Secondo', 'Second')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Terzo', 'Third')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_cla_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Quarto', 'Fourth')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_cla
                       WHERE aa_off_id = p_aa_id);


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_MOD
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_mod_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_mod
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_mod
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod (mid,
                           mid_ad,
                           percorso,
                           attivita,
                           modulo,
                           descrizione,
                           metodi_did_des,
                           obiett_form_des,
                           prerequisiti_des,
                           contenuti_des,
                           testi_rif_des,
                           mod_ver_appr_des,
                           altre_info_des,
                           peso,
                           struttura_cfu,
                           info_sem_classe,
                           info_aule_edifici,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           ud_id,
                           cod_corso,
                           cod_percorso,
                           cod_ad,
                           cod_mod)
      SELECT DISTINCT
             a.mid_ad_mod AS mid,
             a.mid_ad AS mid_ad,
             a.des_cds AS percorso,
             a.des_ad AS attivita,
             a.des_mod AS modulo,
             NULL AS descrizione,
             '<strong>Metodi didattici ???</strong><br/>' AS metodi_did_des,
             '<strong>Obiettivi ???</strong><br/>' AS obiett_form_des,
             '<strong>Prerequisiti ???</strong><br/>' AS prerequisiti_des,
             '<strong>Contenuti ???</strong><br/>' AS contenuti_des,
             '<strong>Testi di riferimento ???</strong><br/>'
                AS testi_rif_des,
             '<strong>Modalita di apprendimento ???</strong><br/>'
                AS mod_ver_appr_des,
             '<strong>Altre info ???</strong><br/>' AS altre_info_des,
             NULL AS peso,
             NULL AS struttura_cfu,
             NULL AS info_sem_classe,
             'Info aule ???' AS info_aule_edifici,
             a.cds_id AS cds_id,
             a.ad_id AS ad_id,
             a.aa_off_id AS aa_off_id,
             a.aa_ord_id AS aa_ord_id,
             a.pds_id AS pds_id,
             a.ud_id AS ud_id,
             a.cod_cds AS cod_corso,
             NULL AS cod_percorso,
             a.cod_ad AS cod_ad,
             a.cod_mod AS cod_mod
        FROM GOL_IUNI a
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 17';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_sem_classe =
             (SELECT DISTINCT des_part
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_mod)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 18';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_sem_classe = 'Annuale'
    WHERE info_sem_classe IS NULL AND aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 19';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   UPDATE gol_ad_mod a
      SET info_aule_edifici =
             (SELECT 'Ore ' || SUM (dur_uni_val)
                FROM GOL_IUNI b
               WHERE a.mid = b.mid_ad_mod)
    WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 20';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   unixx_struttura_cfu_ad_mod (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 21';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   --- inglese
   INSERT INTO gol_ad_mod_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              modulo,
                              descrizione,
                              metodi_did_des,
                              obiett_form_des,
                              prerequisiti_des,
                              contenuti_des,
                              testi_rif_des,
                              mod_ver_appr_des,
                              altre_info_des,
                              struttura_cfu,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT DISTINCT
             a.mid_ad_mod AS mid,
             'en' AS ln_code,
             fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
             fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
             a.des_mod AS modulo,
             a1.descrizione AS descrizione,
             '<strong>Metodi didattici ???</strong><br/>' AS metodi_did_des,
             '<strong>Obiettivi ???</strong><br/>' AS obiett_form_des,
             '<strong>Prerequisiti ???</strong><br/>' AS prerequisiti_des,
             '<strong>Contenuti ???</strong><br/>' AS contenuti_des,
             '<strong>Testi di riferimento ???</strong><br/>'
                AS testi_rif_des,
             '<strong>Modalita di apprendimento ???</strong><br/>'
                AS mod_ver_appr_des,
             '<strong>Altre info ???</strong><br/>' AS altre_info_des,
             a1.struttura_cfu,
             a1.info_sem_classe,
             a1.info_aule_edifici
        FROM GOL_IUNI a
             JOIN gol_ad_mod a1 ON a.mid_ad_mod = a1.mid
             LEFT JOIN p06_cds_des_lin c1
                ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
             LEFT JOIN p09_ad_des_lin c2
                ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
       WHERE a.aa_off_id = p_aa_id;

   -- update INFO_SEM_CLASSE
   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Unico', 'Unique')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Ciclo', 'Cycle')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Annuale', 'Annual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Semestrale', 'Semiannual')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe =
             REPLACE (info_sem_classe, 'Bimestrale', 'Bimestrial')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Primo', 'First')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Secondo', 'Second')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Terzo', 'Third')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);

   UPDATE gol_ad_mod_ln
      SET info_sem_classe = REPLACE (info_sem_classe, 'Quarto', 'Fourth')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);


   -- update INFO_AULE_EDIFICI
   UPDATE gol_ad_mod_ln
      SET info_aule_edifici = REPLACE (info_aule_edifici, 'Ore', 'Hours')
    WHERE     ln_code = 'en'
          AND mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE aa_off_id = p_aa_id);


   UPDATE gol_ad_mod_ln
      SET modulo = attivita
    WHERE     mid IN (SELECT mid
                        FROM gol_ad_mod
                       WHERE attivita = modulo AND aa_off_id = p_aa_id)
          AND ln_code = 'en';


   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_DOC
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_doc (mid,
                           mid_doc,
                           mid_ad,
                           percorso,
                           attivita,
                           docente,
                           cod_matr_doc,
                           titolare,
                           nominativo_docente,
                           cds_id,
                           ad_id,
                           aa_off_id,
                           aa_ord_id,
                           pds_id,
                           docente_id)
        SELECT DISTINCT
               a.mid_ad_doc AS mid,
               b.mid AS mid_doc,
               mid_ad AS mid_ad,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome                                                 --||
                  --DECODE(DES, NULL, '',' ('||DES||')')
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               a.docente_id AS docente_id
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN tipi_copertura c
                  ON a.tipo_copertura_cod = c.tipo_copertura_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_ad_doc,
               b.mid,
               mid_ad,
               a.des_cds,
               a.des_ad,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;


   --- inglese
   INSERT INTO gol_ad_doc_ln (MID,
                              LN_CODE,
                              percorso,
                              attivita,
                              docente)
        SELECT DISTINCT
               a.mid_ad_doc AS mid,
               'en' AS ln_codE,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN tipi_copertura c
                  ON a.tipo_copertura_cod = c.tipo_copertura_cod
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY a.mid_ad_doc,
               b.mid,
               mid_ad,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;



   v_time_end := SYSDATE;

   v_step := 'step 22';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_CLA_DOC
   DELETE FROM gol_ad_cla_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_cla_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_cla_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_doc (mid,
                               mid_ad_cla,
                               mid_doc,
                               percorso,
                               attivita,
                               classe,
                               docente,
                               cod_matr_doc,
                               titolare,
                               nominativo_docente,
                               cds_id,
                               ad_id,
                               aa_off_id,
                               aa_ord_id,
                               pds_id,
                               dom_part_cod,
                               docente_id)
        SELECT DISTINCT
               mid_ad_cla_doc AS mid,
               mid_ad_cla AS mid_ad_cla,
               b.mid AS mid_doc,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
               c.des AS classe,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome                                                 --||
                  --DECODE(DES, NULL, '',' ('||D.DES||')')
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               NULL AS dom_part_cod,
               a.docente_id AS docente_id
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               JOIN dom_part c
                  ON     a.fat_part_cod = c.fat_part_cod
                     AND a.dom_part_cod = c.dom_part_cod
               LEFT JOIN tipi_copertura d
                  ON a.tipo_copertura_cod = d.tipo_copertura_cod
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_cla_doc,
               mid_ad_cla,
               b.mid,
               a.des_cds,
               a.des_ad,
               c.des,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.docente_id;


   INSERT INTO gol_ad_cla_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  attivita,
                                  classe,
                                  docente,
                                  nominativo_docente)
        SELECT DISTINCT
               mid_ad_cla_doc AS mid,
               'en' AS ln_code,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)) AS attivita,
               c.des AS classe,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               JOIN dom_part c
                  ON     a.fat_part_cod = c.fat_part_cod
                     AND a.dom_part_cod = c.dom_part_cod
               LEFT JOIN tipi_copertura d
                  ON a.tipo_copertura_cod = d.tipo_copertura_cod
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_cla_doc,
               a.des_cds,
               a.des_ad,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
               c.des,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome;


   v_time_end := SYSDATE;

   v_step := 'step 23';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   --- INSERIMENTO GOL_AD_MOD_DOC
   --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
   DELETE FROM gol_ad_mod_doc_ln
         WHERE mid IN (SELECT mid
                         FROM gol_ad_mod_doc
                        WHERE aa_off_id = p_aa_id);

   DELETE FROM gol_ad_mod_doc
         WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_doc
        SELECT DISTINCT
               mid_ad_mod_doc AS mid,
               mid_ad_mod AS mid_ad_mod,
               b.mid AS mid_doc,
               a.des_cds AS percorso,
               a.des_ad AS attivita,
               a.des_mod AS modulo,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
               matricola AS cod_matr_doc,
               MAX (titolare_flg) AS titolare,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente,
               a.cds_id AS cds_id,
               a.ad_id AS ad_id,
               a.aa_off_id AS aa_off_id,
               a.aa_ord_id AS aa_ord_id,
               a.pds_id AS pds_id,
               a.ud_id AS ud_id,
               a.docente_id AS docente_id
          FROM GOL_IUNI a JOIN t_docenti b ON a.docente_id = b.docente_id
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_mod_doc,
               mid_ad_mod,
               b.mid,
               a.des_cds,
               a.des_ad,
               a.des_mod,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               matricola,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome,
               a.cds_id,
               a.ad_id,
               a.aa_off_id,
               a.aa_ord_id,
               a.pds_id,
               a.ud_id,
               a.docente_id;


   INSERT INTO gol_ad_mod_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  modulo,
                                  docente,
                                  nominativo_docente)
        SELECT DISTINCT
               mid_ad_mod_doc AS mid,
               'en' AS ln_cod,
               fu_des_up_low (NVL (c1.des, a.des_cds)) AS percorso,
               a.des_mod AS modulo,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS docente,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome
                  AS nominativo_docente
          --  fu_des_up_low(nvl(c2.ds_ad_des, a.des_ad)) as attivita
          FROM GOL_IUNI a
               JOIN t_docenti b ON a.docente_id = b.docente_id
               LEFT JOIN p06_cds_des_lin c1
                  ON a.cds_id = c1.cds_id AND c1.lingua_id = 1
               LEFT JOIN p09_ad_des_lin c2
                  ON a.ad_id = c2.ad_id AND c2.lingua_id = 1
         WHERE aa_off_id = p_aa_id
      GROUP BY mid_ad_mod_doc,
               mid_ad_mod,
               b.mid,
               fu_des_up_low (NVL (c1.des, a.des_cds)),
               fu_des_up_low (NVL (c2.ds_ad_des, a.des_ad)),
               a.des_mod,
                  DECODE (des_appellativo, NULL, '', des_appellativo || ' ')
               || nome
               || ' '
               || cognome;

   v_time_end := SYSDATE;

   v_step := 'step 24';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiorno la descrizione del livello AD
   unixx_description_liv (p_aa_id);

   v_time_end := SYSDATE;

   v_step := 'step 25';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;

   --- aggiorno la tabella delle lingue relative al livetto
   UPDATE gol_liv_ln a
      SET a.DESCRIPTION =
             (SELECT DESCRIPTION
                FROM gol_liv b
               WHERE a.mid = b.mid)
    WHERE a.mid IN (SELECT mid
                      FROM gol_liv
                     WHERE aa_id = p_aa_id AND mid_dett IS NOT NULL);

   v_time_end := SYSDATE;

   v_step := 'step 26';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;


   ---- creo la struttur ain lingua italiana
   INSERT INTO gol_ad_ln (mid,
                          ln_code,
                          percorso,
                          attivita,
                          descrizione,
                          metodi_did_des,
                          obiett_form_des,
                          prerequisiti_des,
                          contenuti_des,
                          testi_rif_des,
                          mod_ver_appr_des,
                          altre_info_des,
                          struttura_cfu)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             descrizione,
             metodi_did_des,
             obiett_form_des,
             prerequisiti_des,
             contenuti_des,
             testi_rif_des,
             mod_ver_appr_des,
             altre_info_des,
             struttura_cfu
        FROM gol_ad
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              classe,
                              descrizione,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             classe,
             descrizione,
             info_sem_classe,
             info_aule_edifici
        FROM gol_ad_cla
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_doc_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             docente
        FROM gol_ad_doc
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_ln (mid,
                              ln_code,
                              percorso,
                              attivita,
                              modulo,
                              descrizione,
                              metodi_did_des,
                              obiett_form_des,
                              prerequisiti_des,
                              contenuti_des,
                              testi_rif_des,
                              mod_ver_appr_des,
                              altre_info_des,
                              struttura_cfu,
                              info_sem_classe,
                              info_aule_edifici)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             modulo,
             descrizione,
             metodi_did_des,
             obiett_form_des,
             prerequisiti_des,
             contenuti_des,
             testi_rif_des,
             mod_ver_appr_des,
             altre_info_des,
             struttura_cfu,
             info_sem_classe,
             info_aule_edifici
        FROM gol_ad_mod
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_cla_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  attivita,
                                  classe,
                                  docente,
                                  nominativo_docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             attivita,
             classe,
             docente,
             nominativo_docente
        FROM gol_ad_cla_doc
       WHERE aa_off_id = p_aa_id;

   INSERT INTO gol_ad_mod_doc_ln (mid,
                                  ln_code,
                                  percorso,
                                  modulo,
                                  docente,
                                  nominativo_docente)
      SELECT mid,
             'it' ln_code,
             percorso,
             modulo,
             docente,
             nominativo_docente
        FROM gol_ad_mod_doc
       WHERE aa_off_id = p_aa_id;

   v_time_end := SYSDATE;

   v_step := 'step 27';

   INSERT INTO tabella_log (id,
                            testo,
                            ora1,
                            ora2,
                            durata,
                            host_name,
                            db_name,
                            optimizer,
                            note)
        VALUES (tabella_log_id.NEXTVAL,
                'Caric. ' || p_aa_id,
                v_time_start,
                v_time_end,
                NULL,
                NULL,
                NULL,
                NULL,
                v_step);

   COMMIT;

   v_time_start := SYSDATE;
END;

/


CREATE OR REPLACE PROCEDURE                  P_AGG_SERVICES
AS
prima_volta number(10);
BEGIN

    /* Nel caso avessi righe che non hanno valorizzato il type_source (ad: esempio migrazione) cancello tutta la tabella */
    select count(*) into prima_volta from srv_services where type_source is null;
    if prima_volta <> 0 then
       DELETE FROM SRV_SERVICES;
    end if;
    select count(*) into prima_volta from srv_services_ln where type_source is null;
    if prima_volta <> 0 then
       DELETE FROM SRV_SERVICES_LN;
    end if;
    
    /* Aggiorno la tabella dei docenti (in modo incrementale) */
    P_AGG_T_DOCENTI;  

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- popolamento della SRV_SERVICES per rubrica docenti PUBBLICA
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM SRV_SERVICES where type_source = 1;

    INSERT INTO SRV_SERVICES (MID, ATTRIBUTE,FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS,EMAIL, TEL, FAX, CELL, URL, HOURS,NOTE1, NOTE2, NOTE3, TAG_SRV,TYPE_SRV,  PROFILE, ANA_ID,TYPE, LAT,LON, TYPE_SOURCE)
    SELECT ROWNUM MID,
           A.DES_APPELLATIVO AS ATTRIBUTE,
           A.COGNOME AS FIRSTNAME,
           A.NOME AS LASTNAME,
           A.DES_APPELLATIVO||' ' ||A.NOME||' '||A.COGNOME AS DESCRIPTION,
           C.VIA||DECODE(C.CAP, NULL, '', ' - '||C.CAP)||' '||C.CITTA||DECODE(C.PROV, NULL, '',' ('||C.PROV||')') AS ADDRESS, -- INDIRIZZO DIPARTIMENTO
           A.E_MAIL AS EMAIL,
           C.TEL AS TEL, -- TEL DIPARTIMENTO
           C.FAX AS FAX, -- FAX DIPARTIMENTO
           NULL AS CELL, --A.CELLULARE
           NULL AS URL,
           NULL AS HOURS,
           A.DES_GRUPPO AS NOTE1,
           NULL AS NOTE2,
           NULL AS NOTE3,
           'Docente' AS TAG_SRV,
           1 AS TYPE_SRV,
           0 AS PROFILE,
           MID AS ANA_ID,
           'MID_DOC' AS TYPE,
           null as LAT,
           null as LON,
           1
    FROM T_DOCENTI A
         JOIN DOCENTI B ON B.DOCENTE_ID = A.DOCENTE_ID
         left JOIN P06_DIP C ON C.DIP_ID = B.DIP_ID;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- popolamento della SRV_SERVICES_LN
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE FROM SRV_SERVICES_LN where type_source = 1;

    INSERT INTO SRV_SERVICES_LN (MID,LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS,NOTE1,NOTE2, NOTE3,TAG_SRV, TYPE_SOURCE ) 
    SELECT A.MID,
           'en' AS LN_CODE,
           DECODE(ATTRIBUTE, 'Dott.', 'Dr.',
                             'Dott.ssa', 'Dr.',
                             'Prof.', 'Prof.',
                             ATTRIBUTE) AS ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NVL(D.DES, DECODE(C.DES, NULL, 'Dipartimento da assegnare', C.DES))||' ('||NVL(C.COD,'DA.ASSEGN') ||')' AS NOTE1,
           NOTE2,
           NOTE3,
           DECODE( TAG_SRV, 'Docente', 'Teacher',  TAG_SRV) AS  TAG_SRV,
           1
    FROM SRV_SERVICES A
         JOIN T_DOCENTI A1 ON A1.MID = ANA_ID
         JOIN DOCENTI B ON B.DOCENTE_ID = A1.DOCENTE_ID
         LEFT JOIN P06_DIP C ON C.DIP_ID = B.DIP_ID
         LEFT JOIN P06_DIP_DES_LIN D ON (D.DIP_ID = C.DIP_ID AND D.LINGUA_ID = 1)
    WHERE TYPE_SOURCE = 1;

    INSERT INTO SRV_SERVICES_LN (MID,LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS,NOTE1,NOTE2, NOTE3,TAG_SRV, TYPE_SOURCE ) 
    SELECT MID,
           'it' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           1
    FROM SRV_SERVICES A
    WHERE TYPE_SOURCE = 1;

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- STRUTTURE
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    DELETE from SRV_SERVICES WHERE TYPE_SOURCE = 2;

    insert into SRV_SERVICES (MID,  ATTRIBUTE, FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS, EMAIL, TEL, FAX, CELL, URL, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SRV, PROFILE, ANA_ID, TYPE, LAT, LON, TYPE_SOURCE )
    select (
    select max(mid) from SRV_SERVICES) + rownum MID,
    ATTRIBUTE, FIRSTNAME, LASTNAME, DESCRIPTION, ADDRESS, EMAIL, TEL, FAX, CELL, URL, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SRV, PROFILE, ANA_ID, TYPE, LAT, LON, TYPE_SOURCE
    from
    (
    SELECT null as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des as DESCRIPTION,
           via as ADDRESS,
           null as EMAIL,
           null as TEL,
           null as FAX,
           null as CELL,
           url_sito_web as URL,
           null as HOURS,
           null as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Facolta' as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           FAC_ID ANA_ID,
           'ID_FAC' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2 as TYPE_SOURCE
    FROM P06_FAC
    where fac_id <> 9999
    union
    SELECT DES_BREVE as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des as DESCRIPTION,
           via as ADDRESS,
           null as EMAIL,
           tel as TEL,
           fax as FAX,
           null as CELL,
           null as URL,
           null as HOURS,
           presdir as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Dipartimento' as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           DIP_ID ANA_ID,
           'ID_DIP' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2
    FROM P06_DIP
    union
    select acronimo as ATTRIBUTE,
           null as FIRSTNAME,
           null as LASTNAME,
           des||' ['||COD||']' as DESCRIPTION,
           null as ADDRESS,
           null as EMAIL,
           null as TEL,
           null as FAX,
           null as CELL,
           url_sito_web as URL,
           null as HOURS,
           null as NOTE1,
           null as NOTE2,
           null as NOTE3,
           'Corsi '||tipo_corso_cod as TAG_SRV,
           2 as TYPE_SRV,
           1 AS PROFILE,
           cds_ID ANA_ID,
           'ID_CDS' AS TYPE,
           NULL AS LAT,
           NULL AS LON,
           2
    from P06_CDS
    );


    DELETE FROM SRV_SERVICES_LN WHERE TYPE_SOURCE = 2;

    INSERT INTO SRV_SERVICES_LN (MID, LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SOURCE)
    SELECT MID,
           'it' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           2
    FROM SRV_SERVICES A
    where TYPE_SOURCE = 2;

    INSERT INTO SRV_SERVICES_LN  (MID, LN_CODE, ATTRIBUTE, DESCRIPTION, HOURS, NOTE1, NOTE2, NOTE3, TAG_SRV, TYPE_SOURCE)
    SELECT MID,
           'en' AS LN_CODE,
           ATTRIBUTE,
           DESCRIPTION,
           HOURS,
           NOTE1,
           NOTE2,
           NOTE3,
           TAG_SRV,
           2
    FROM SRV_SERVICES A
    where TYPE_SOURCE = 2;


END;
/


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

