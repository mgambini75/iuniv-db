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
