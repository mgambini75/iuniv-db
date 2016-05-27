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
