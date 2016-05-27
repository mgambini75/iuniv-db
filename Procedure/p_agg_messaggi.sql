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
