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
