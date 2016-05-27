CREATE OR REPLACE PROCEDURE                  UNIXX_DESCRIZIONE_AD (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      SELECT MID
      FROM GOL_AD
      where DESCRIZIONE is null
      and aa_off_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

        UPDATE GOL_AD
        SET DESCRIZIONE = UNIXX_GOL_AD_DESCRIZIONE(MID)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/
