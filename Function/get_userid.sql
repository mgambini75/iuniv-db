CREATE OR REPLACE FUNCTION                  GET_USERID(USER_ID T_UTENTI.USER_ID%TYPE) return T_UTENTI.USER_ID%TYPE
as
v_IS_CASE_SENSITIVE  FRW_CONFIG.VALUE_STRING%TYPE; 
v_SRETVAL           FRW_CONFIG.VALUE_STRING%TYPE; 

-- 'UsernameCaseSensitive'

begin 
     
     v_IS_CASE_SENSITIVE := GET_FRW_CONFIG('UsernameCaseSensitive');


    if v_IS_CASE_SENSITIVE = 'True' then
       v_SRETVAL := USER_ID;
    else
       v_SRETVAL := UPPER(USER_ID);
    end if;
    
 
    return v_SRETVAL;

end;
/
