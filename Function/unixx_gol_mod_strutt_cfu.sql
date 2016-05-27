CREATE OR REPLACE FUNCTION                  UNIXX_GOL_MOD_STRUTT_CFU (
   v_MID   NUMBER
   )
   RETURN VARCHAR2
AS


   CURSOR C_CUR
   IS 
      select mid_ad, mid_ad_mod, sum(peso_det) AS PESO, sett_cod, des_taf, des_amb
      from ( 
                  select distinct mid_ad, mid_ad_mod, cod_mod, des_mod, peso_det, sett_cod, des_taf, des_amb 
                  from GOL_IUNI
                  where  MID_AD_MOD = v_MID
                )
        group by   mid_ad, mid_ad_mod, sett_cod, des_taf, des_amb;
      

   v_RITORNO  VARCHAR2 (4000);
   v_TESTO    VARCHAR2 (4000);
   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --
   v_TESTO := '';
   
   FOR R_CUR IN C_CUR
   LOOP
      
      v_TESTO := v_TESTO||' cfu: '||R_CUR.PESO||' ('||R_CUR.SETT_COD||' - '||R_CUR.DES_TAF||' - '||R_CUR.DES_AMB||')
';
    
   END LOOP;   
   
   v_RITORNO := SUBSTR(v_TESTO, 1, 4000);

   RETURN v_RITORNO;
END;
/
