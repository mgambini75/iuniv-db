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
