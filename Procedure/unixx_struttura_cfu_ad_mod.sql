CREATE OR REPLACE PROCEDURE                  UNIXX_STRUTTURA_CFU_AD_MOD (p_aa_id number)
AS


   CURSOR C_CUR
   IS
      SELECT MID
      FROM gol_ad_mod
      WHERE STRUTTURA_CFU IS NULL
      and aa_off_id = p_aa_id;


   v_count    NUMBER := 0;
BEGIN
   --
   -- Apex Decode Body
   -- Procedure Body
   --

   FOR R_CUR IN C_CUR
   LOOP

        UPDATE gol_ad_mod
        SET STRUTTURA_CFU = UNIXX_GOL_MOD_STRUTT_CFU(MID)
        where mid = R_CUR.MID;

        V_COUNT := V_COUNT + 1;

        IF V_COUNT = 100

            THEN COMMIT;

                 V_COUNT := 0;

        END IF;

    END LOOP;


END;
/
