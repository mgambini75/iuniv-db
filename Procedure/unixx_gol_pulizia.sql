CREATE OR REPLACE PROCEDURE                  UNIXX_GOL_PULIZIA (p_aa_id number)
AS
---------------------------------------------------------------------------------
--- CALCOLO DEGLI ID
--- NOTE:
---------------------------------------------------------------------------------
---
---------------------------------------------------------------------------------

v_time_start date;
v_time_end  date;
v_step varchar2(100);

BEGIN

        --- FACOLTA
        update GOL_IUNI
        set (fac_id, cod_fac, des_fac) = (select distinct d.fac_id, d.cod, d.des_cert
                                                   from p06_cds b 
                                                          join p06_fac_cds c on b.cds_id = c.cds_id and ann_flg = 0 and def_amm_flg = 1
                                                          join p06_fac d on d.fac_id = c.fac_id
                                                   where cod_cds = b.cod)
        where aa_off_id = p_aa_id;
                                                   
        update GOL_IUNI
        set cod_fac = 'NN', des_fac = 'NON DEFINITA'
        where cod_fac is null
        and aa_off_id = p_aa_id;       

        --- CORSO        
        update  GOL_IUNI
        set cds_id =      (select cds_id from p06_cds where cod = cod_cds)
        where  (select count(*) from p06_cds where cod = cod_cds) = 1
        and aa_off_id = p_aa_id;   


        --- PERCORSO
        update GOL_IUNI x
        set pds_id =    
                    (select pds_id 
                     from p06_cds A
                             join p06_pdsord b on b.cds_id = a.cds_id
                     where a.cod = cod_cds
                     and b.aa_ord_id = x.aa_ord_id
                     and b.cod = cod_pds )
        where     (select count(*) 
                     from p06_cds A
                             join p06_pdsord b on b.cds_id = a.cds_id
                     where a.cod = cod_cds
                     and b.aa_ord_id = x.aa_ord_id
                     and b.cod = cod_pds ) = 1
        and aa_off_id = p_aa_id;


        --- TIPO CORSO
        update GOL_IUNI
        set tipo_corso_cod = 'L2'
        where tipo_corso_cod in ('L', 'LT')
        and aa_off_id = p_aa_id;

        update GOL_IUNI
        set tipo_corso_cod = 'L1'
        where tipo_corso_cod in ('LV')
        and aa_off_id = p_aa_id;

        --- PARTIZIONAMENTI / SEDI
        update GOL_IUNI a
        set fat_part_cod = 'N0', dom_part_cod = 'N0' 
        where fat_part_cod is null
        and dom_part_cod is null
        and aa_off_id = p_aa_id;
        
        update GOL_IUNI a
        set sede_des = 'TORINO'
        where sede_des is null
        and aa_off_id = p_aa_id;

        --- DOCENTE
        update GOL_IUNI
        set docente_id = (select docente_id from docenti where matricola_titolare = matricola)
        where aa_off_id = p_aa_id; 

        update GOL_IUNI
        set docente_id = 999999999
        where docente_id is null
        and aa_off_id = p_aa_id;

        --- ATTIVITA DIDATTICA
        update GOL_IUNI x
        set ad_id =  (select ad_id
                           from p09_ad_gen
                           where cod = cod_ad)
        where   (select count(*) 
                     from p09_ad_gen
                     where cod = cod_ad) = 1
        and aa_off_id = p_aa_id;


END;
/
