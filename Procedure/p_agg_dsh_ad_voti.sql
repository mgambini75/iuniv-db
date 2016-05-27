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
