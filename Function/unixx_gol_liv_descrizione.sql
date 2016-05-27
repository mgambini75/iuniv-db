CREATE OR REPLACE FUNCTION                  "UNIXX_GOL_LIV_DESCRIZIONE" (
   v_MID   NUMBER
   )
   RETURN VARCHAR2
AS


   CURSOR C_CUR
   IS 
   
      SELECT DISTINCT DOCENTE
      FROM gol_ad_doc
      WHERE MID_AD = v_MID
      ORDER BY DOCENTE;


   v_RITORNO  VARCHAR2 (4000);
   v_TESTO  VARCHAR2 (4000);
   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --
   v_TESTO := '';
   
   FOR R_CUR IN C_CUR
   LOOP
      
    v_TESTO := v_TESTO||', '||R_CUR.DOCENTE;
   
   END LOOP;   
   
   v_RITORNO := SUBSTR(v_TESTO, 3, 4000);

   RETURN v_RITORNO;
END;
/
