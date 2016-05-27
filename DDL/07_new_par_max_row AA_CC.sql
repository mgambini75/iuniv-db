
-- delete frw_config where cod = 'MaxRowsACYEAR';

BEGIN
	
   -- select sysdate from dual;
   P_UPSERT_CONFIG ('MaxRowsACYEAR', '3', 'Max rows returned by view API_CC_ACYEAR', 0, 0, 0, 0);

END;
/