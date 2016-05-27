CREATE OR REPLACE PROCEDURE                  UNIXX_DESCRIPTION_LIV (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      select * from GOL_LIV
      WHERE MID_DETT IS NOT NULL
      and aa_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

       UPDATE GOL_LIV
       SET DESCRIPTION = '['||CODE||'] '||UNIXX_GOL_LIV_DESCRIZIONE(MID_DETT)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/
