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
