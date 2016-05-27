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
