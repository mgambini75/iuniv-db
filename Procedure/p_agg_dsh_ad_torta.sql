CREATE OR REPLACE procedure                  p_agg_dsh_ad_torta (p_stu_id number) is

v_mid number(10);

begin

    delete from dsh_ad_torta where stu_id = p_stu_id;
    
    select nvl(max(mid), 0 ) into v_mid from dsh_ad_torta;

    insert into dsh_ad_torta
    select rownum + v_mid, stu_id, tipo_corso_cod, sta_stu_cod, mot_stastu_cod, des_peso, val_totale, peso_sup, peso_fre, peso_pia, sysdate
    from (
            select a.stu_id, 
                   c.tipo_corso_cod,
                   e.sta_stu_cod,
                   e.mot_stastu_cod,
                   decode( c.um_peso_cod, 'A', 'Annualità',
                                          'C', 'Cfu',
                                          c.um_peso_cod) as des_peso,
                   decode( e.mot_stastu_cod, 'TIT', sum(decode( sta_sce_cod, 'S', peso, 0)),
                                             valore_min) as val_totale,
                   sum(decode( sta_sce_cod, 'S', peso, 0)) as peso_sup, 
                   sum(decode( sta_sce_cod, 'F', peso, 0)) as peso_fre, 
                   sum(decode( sta_sce_cod, 'P', peso, 0)) as peso_pia
            from p11_ad_sce a
                 join p04_mat b on b.mat_id = a.mat_id and b.sta_mat_cod = 'A'
                 join p06_cds c on c.cds_id = a.cds_id
                 join tipi_corso d on d.tipo_corso_cod = c.tipo_corso_cod
                 join p01_stu e on e.stu_id = a.stu_id
            where a.stu_id = p_stu_id
            group by a.stu_id, e.sta_stu_cod, e.mot_stastu_cod, c.um_peso_cod, c.tipo_corso_cod, valore_min
         );


end;
/
