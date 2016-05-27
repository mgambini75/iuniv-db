
delete frw_config where cod = 'PushAuthKey';

BEGIN
	
   -- select sysdate from dual;
   P_UPSERT_CONFIG ('PushAuthKey', '123-123-123-123', 'AuthKey for push notification access', 0, 0, 0, 0);

END;
/


delete frw_config where cod = 'PushAppCode';

BEGIN
	
   -- select sysdate from dual;
   P_UPSERT_CONFIG ('PushAppCode', 'UNIXX', 'Appcode for push notification access', 0, 0, 0, 0);

END;
/

