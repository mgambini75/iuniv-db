CREATE OR REPLACE FUNCTION GET_FRW_CONFIG(PARAM varchar2) return FRW_CONFIG.VALUE_STRING%TYPE
as
cursor c1 is
select VALUE_STRING
from API_FRW_CONFIG 
where COD = PARAM;

v_SRETVAL FRW_CONFIG.VALUE_STRING%TYPE; 

-- 'UsernameCaseSensitive'

 begin 
 
    for cur in c1
    loop
      v_SRETVAL := cur.VALUE_STRING;
    end loop;

    return v_SRETVAL;

end;
/
