
CREATE OR REPLACE FUNCTION FU_DES_UP_LOW (v_text_in VARCHAR2)
   RETURN VARCHAR2
AS
   v_text_out   VARCHAR2 (4000);
BEGIN
   v_text_out :=
      UPPER (SUBSTR (v_text_in, 1, 1))
      || TRIM (LOWER (SUBSTR (v_text_in, 2)));
      
     v_text_out:=REPLACE(v_text_out, '(i ', '(I ');     
     v_text_out:=REPLACE(v_text_out, ' i ', ' I ');
     v_text_out:=REPLACE(v_text_out, ' i)', ' I)');
     v_text_out:=REPLACE(v_text_out, ' i:', ' I:');
     v_text_out:=REPLACE(v_text_out, 'iii', 'III');
     v_text_out:=REPLACE(v_text_out, 'ii', 'II');
     v_text_out:=REPLACE(v_text_out, '(iv', '(IV'); 
     v_text_out:=REPLACE(v_text_out, 'iv)', 'IV)');
     v_text_out:=REPLACE(v_text_out, ' iv)', ' IV)');
     v_text_out:=REPLACE(v_text_out, '(v', '(V'); 
     v_text_out:=REPLACE(v_text_out, 'v)', 'V)');
     
     v_text_out:=REPLACE(v_text_out, 'x)', 'X)');
     v_text_out:=REPLACE(v_text_out, '(x', '(X');

     v_text_out:=REPLACE(v_text_out, 'xxii', 'XXII');
     v_text_out:=REPLACE(v_text_out, 'xxi', 'XXI');
     v_text_out:=REPLACE(v_text_out, 'xx', 'XX');     
     v_text_out:=REPLACE(v_text_out, 'xiii', 'XIII');     
     v_text_out:=REPLACE(v_text_out, 'ix', 'IX');
     v_text_out:=REPLACE(v_text_out, 'xi', 'XI');
     v_text_out:=REPLACE(v_text_out, 'x:', 'X:');
          
   RETURN v_text_out;
END; 
/


CREATE OR REPLACE FUNCTION                  GET_ACC_YEAR
   RETURN NUMBER
AS
   v_anno_accademico_in_corso   NUMBER(4);
BEGIN

    select aa_id into v_anno_accademico_in_corso
    from p06_aa
    where sysdate between data_inizio and data_fine;


    RETURN v_anno_accademico_in_corso;
END;
/


CREATE OR REPLACE FUNCTION GET_DATA_EVENTS (lang varchar2, v_data_da date, v_data_a date)
   RETURN VARCHAR2
AS
   v_data_out   VARCHAR2 (4000);
   v_data_001   VARCHAR2 (2000);
   v_data_002   VARCHAR2 (2000);

   gg_da varchar2(2);
   mm_da varchar2(2);
   yy_da varchar2(4);
   hh24_da varchar2(20);
   hh12_da varchar2(20);
   d_da varchar2(2);

   gg_a  varchar2(2);
   mm_a  varchar2(2);
   yy_a  varchar2(4);
   hh24_a varchar2(20);
   hh12_a varchar2(20);
   d_a  varchar2(2);

   v_giorno varchar2(40);
   v_mese   varchar2(40);
   v_ampm   varchar2(40);
   flg_data number(1);

BEGIN

    gg_da := to_char(v_data_da, 'dd');
    mm_da := to_char(v_data_da, 'mm');
    yy_da := to_char(v_data_da, 'yyyy');
    hh24_da := to_char(v_data_da, 'hh24:mi');
    hh12_da := to_char(v_data_da, 'hh12:mi am');
    d_da := to_char(v_data_da, 'd');

    gg_a := to_char(v_data_a, 'dd');
    mm_a := to_char(v_data_a, 'mm');
    yy_a := to_char(v_data_a, 'yyyy');
    hh24_a := to_char(v_data_a, 'hh24:mi');
    hh12_a := to_char(v_data_a, 'hh12:mi am');
    d_a := to_char(v_data_a, 'd');

    flg_data := 0;


    select decode(substr(gg_a,1,1), '0', substr(gg_a,2,1), gg_a) into gg_a
    from dual;

    select decode(substr(gg_da,1,1), '0', substr(gg_da,2,1), gg_da) into gg_da
    from dual;

    --gg_a := decode(substr(gg_a,1,1), '0', substr(gg_a,2,1), gg_a);
    --gg_da := decode(substr(gg_da,1,1), '0', substr(gg_da,2,1), gg_da);




    if gg_da = gg_a and
       mm_da = mm_a and
       yy_da = yy_a

       then  flg_data := 1;

    end if;



    if lang = 'it'

       then
            -- definizione inizio
            select decode( d_da, 1,'Lun',2,'Mar',3,'Mer',4,'Gio',
                                 5,'Ven',6,'Sab',7,'Dom',
                                 null) into v_giorno
            from dual;

--            select decode( d_da, 1,'Lunedì',2,'Martedì',3,'Mercoledì',4,'Giovedì',
--                                 5,'Venerdì',6,'Sabato',7,'Domenica',
--                                 null) into v_giorno
--            from dual;

            select decode( mm_da, 1,'Gennaio',2,'Febbraio',3,'Marzo',4,'Aprile',
                                  5,'Maggio',6,'Giugno',7,'Luglio',8,'Agosto',
                                  9,'Settembre',10, 'Ottobre',11,'Novembre',12,'Dicembre',
                                  null) into v_mese
            from dual;

--            select decode( mm_da, 1,'Gennaio',2,'Febbraio',3,'Marzo',4,'Aprile',
--                                  5,'Maggio',6,'Giugno',7,'Luglio',8,'Agosto',
--                                  9,'Settembre',10, 'Ottobre',11,'Novembre',12,'Dicembre',
--                                  null) into v_mese
--            from dual;


            v_data_001 :=  v_giorno||' '||gg_da||' '||v_mese--||' '||yy_da
            ;

            if flg_data = 1

                then

                    v_data_out := v_data_001||' '||hh24_da||'-'||hh24_a;

                 else
                      select decode( d_a, 1,'Lun',2,'Mar',3,'Mer',4,'Gio',
                                          5,'Ven',6,'Sab',7,'Dom',
                                          null) into v_giorno
                      from dual;

--                      select decode( d_a, 1,'Lunedì',2,'Martedì',3,'Mercoledì',4,'Giovedì',
--                                          5,'Venerdì',6,'Sabato',7,'Domenica',
--                                          null) into v_giorno
--                      from dual;

                      select decode( mm_a, 1,'Gennaio',2,'Febbraio',3,'Marzo',4,'Aprile',
                                           5,'Maggio',6,'Giugno',7,'Luglio',8,'Agosto',
                                           9,'Settembre',10, 'Ottobre',11,'Novembre',12,'Dicembre',
                                           null) into v_mese
                      from dual;

--                      select decode( mm_a, 1,'Gennaio',2,'Febbraio',3,'Marzo',4,'Aprile',
--                                           5,'Maggio',6,'Giugno',7,'Luglio',8,'Agosto',
--                                           9,'Settembre',10, 'Ottobre',11,'Novembre',12,'Dicembre',
--                                           null) into v_mese
--                      from dual;

                      v_data_out := v_data_001||' - '||v_giorno||' '||gg_a||' '||v_mese||' '||yy_da
                      ;

              end if;

    end if;


    if lang = 'en'

        then

              -- definizione inizio
              select decode( d_da, 1,'Mon',2,'Tue',3,'Wed',4,'Thu',
                                   5,'Fri',6,'Sat',7,'Sun',
                                   null) into v_giorno
              from dual;

--              select decode( d_da, 1,'Monday',2,'Tuesday',3,'Wednesday',4,'Thursday',
--                                   5,'Friday',6,'Saturday',7,'Sunday',
--                                   null) into v_giorno
--              from dual;

              select decode( mm_da, 1,'January',2,'Febraury',3,'March',4,'April',
                                    5,'May',6,'June',7,'July',8,'August',
                                    9,'September',10,'October',11,'November',12,'December',
                                    null) into v_mese
              from dual;

--              select decode( mm_da, 1,'January',2,'Febraury',3,'March',4,'April',
--                                    5,'May',6,'June',7,'July',8,'August',
--                                    9,'September',10,'October',11,'November',12,'December',
--                                    null) into v_mese
--              from dual;


              select v_giorno||', '||
                     decode(gg_da, '1', gg_da||'st ',
                                   '2', gg_da||'nd ',
                                   '3', gg_da||'rd ',
                                   '21', gg_da||'st ',
                                   '22', gg_da||'nd ',
                                   '23', gg_da||'rd ',
                                   '31', gg_da||'st ',
                                   gg_da||'th ')||
                     v_mese||' '||
                     yy_da
              into v_data_001
              from dual;

--              v_data_001 :=  v_giorno||', '||
--                             decode(gg_da, '2', gg_da||'nd ',
--                                           '3', gg_da||'rd ',
--                                           gg_da||'th ')||
--                             v_mese||' '||
--                             yy_da
--              ;

            if flg_data = 1

                then

                    v_data_out := v_data_001||' from '||hh24_da||' to '||hh24_a;

                 else
                      select decode( d_a, 1,'Mon',2,'Tue',3,'Wed',4,'Thu',
                                          5,'Fri',6,'Sat',7,'Sun',
                                          null) into v_giorno
                      from dual;

--                      select decode( d_a, 1,'Monday',2,'Tuesday',3,'Wednesday',4,'Thursday',
--                                          5,'Friday',6,'Saturday',7,'Sunday',
--                                          null) into v_giorno
--                      from dual;

                      select decode( mm_a, 1,'January',2,'Febraury',3,'March',4,'April',
                                           5,'May',6,'June',7,'July',8,'August',
                                           9,'September',10,'October',11,'November',12,'December',
                                           null) into v_mese
                      from dual;

--                      select decode( mm_a, 1,'January',2,'Febraury',3,'March',4,'April',
--                                           5,'May',6,'June',7,'July',8,'August',
--                                           9,'September',10,'October',11,'November',12,'December',
--                                           null) into v_mese
--                      from dual;

              select v_giorno||', '||
                     decode(gg_a, '1', gg_a||'st ',
                                   '2', gg_a||'nd ',
                                   '3', gg_a||'rd ',
                                   '21', gg_a||'st ',
                                   '22', gg_a||'nd ',
                                   '23', gg_a||'rd ',
                                   '31', gg_a||'st ',
                                   gg_a||'th ')||
                     v_mese||' '||
                     yy_a
              into v_data_002
              from dual;




                      v_data_out := v_data_001||' - '||v_data_002
                      --v_data_out := v_data_001||' - '||v_giorno||', '||v_mese||' '||gg_a||'th '||yy_a
                      ;

              end if;

    end if;

    if v_data_out = 'Mer 22 Giugno 09:00-13:00'

        then v_data_out := 'Mer 22 Giugno 09:00-13:00';

        -- 'Mer 22 Giugno 2011 09:00 13:00'   'Mer 22 Giugno 2011 09:00' '13:00'
        -- 'Mer 22 Giugno 2011 09:00-13:00'   'Mer 22 Giugno 2011' '09:00-13:00'
        -- 'Mer 22 Giugno 2011 ore 09:00-13:00'

    end if;


    v_data_out := ltrim(rtrim(v_data_out));

    RETURN v_data_out;
END;
/


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


CREATE OR REPLACE FUNCTION                  UNIXX_GOL_AD_DESCRIZIONE (
   v_mid   number
   )
   return varchar2
as

   cursor c_cur_totale
   is
      select distinct
             mid_ad,
             peso_tot
      from gol_iuni
      where mid_ad = v_mid;

   cursor c_cur_sessioni
   is
      select distinct
             mid_ad,
             part_cod,
             decode(part_cod, 'S1', 'I Semestre',
                              'S2', 'II Semestre.',
                              'A1','Annuale',
                              'SD', 'Annuale',
                              'Q1', 'I Quadrimestre',
                              'Q2', 'II Quadrimestre',
                              'Q3', 'III Quadrimestre'
                              ) des_part,
             tipo_ins_cod
      from gol_iuni
      where mid_ad = v_mid
      and part_cod is not null
      order by part_cod;

   cursor c_cur_settori
   is
      select sum(peso_det) as peso,
             sett_cod
      FROM (
                  select distinct cod_mod,  peso_det, sett_cod
                  from gol_iuni
                  where mid_ad = v_mid
               )
      group by sett_cod;


   v_ritorno  varchar2 (4000);
   v_testo  varchar2 (4000);
   v_des_part varchar2 (4000) := '';
   v_tipo_ins_cod varchar2 (4000) := '';
   v_count    number := 0;
begin
   --
   -- Apex Decode Body
   -- Procedure Body
   --
   v_testo := '<strong>Crediti</strong><br/>';

   for r_cur in c_cur_totale
   loop

        v_testo := v_testo||r_cur.peso_tot||' CFU Totali '||'<br/>';

   end loop;

   v_testo := v_testo||'<br/><strong>Sessioni</strong><br/>';

   for r_cur in c_cur_sessioni
   loop

        v_testo := v_testo||r_cur.part_cod||' - '||r_cur.des_part||' - '||r_cur.tipo_ins_cod||'<br/>';

   end loop;

   v_testo := v_testo||'<br/><strong>Settori</strong><br/>';

   for r_cur in c_cur_settori
   loop

        v_testo := v_testo||'Cfu '||r_cur.peso||' - '||r_cur.sett_cod||'<br/>';

   end loop;


   v_ritorno := substr(v_testo||'</ul><br/>', 1, 4000);

   return v_ritorno;
end;
/


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
