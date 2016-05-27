CREATE OR REPLACE PROCEDURE                  UNIXX_GOL_ID (p_aa_id number)
AS
---------------------------------------------------------------------------------
--- CALCOLO DEGLI ID
--- NOTE:
---------------------------------------------------------------------------------
---
---------------------------------------------------------------------------------

   --- CURSORE PRIMO LIVELLO
   CURSOR C_LIV_1
   IS
     SELECT  AA_OFF_ID, COD_FAC
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY AA_OFF_ID, COD_FAC
     ORDER BY AA_OFF_ID, COD_FAC;

   --- CURSORE SECONDO LIVELLO
   CURSOR C_LIV_2
   IS
     SELECT  MID_LIV_1, COD_CDS
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, COD_CDS
     ORDER BY MID_LIV_1, COD_CDS;

   --- CURSORE TERZO LIVELLO
   CURSOR C_LIV_3
   IS
     SELECT  MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS
     ORDER BY MID_LIV_1, MID_LIV_2, AA_ORD_ID, COD_PDS;

   --- CURSORE QUARTO LIVELLO
   CURSOR C_LIV_4
   IS
     SELECT  MID_LIV_1, MID_LIV_2, NVL(MID_LIV_3, 99999) AS MID_LIV_3, COD_AD
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
     GROUP BY MID_LIV_1, MID_LIV_2, MID_LIV_3, COD_AD
     ORDER BY MID_LIV_1, MID_LIV_2, NVL(MID_LIV_3, 99999),  COD_AD;

   --- CURSORE AD
   CURSOR C_AD
   IS
      SELECT   DISTINCT MID_LIV_4
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_LIV_4;

   --- CURSORE AD_CLA
   CURSOR C_AD_CLA
   IS
      SELECT   DISTINCT MID_AD, FAT_PART_COD, DOM_PART_COD, SEDE_DES
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, FAT_PART_COD, DOM_PART_COD, SEDE_DES;

   --- CURSORE AD_MOD
   CURSOR C_AD_MOD
   IS
      SELECT   DISTINCT MID_AD, COD_MOD
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, COD_MOD;

   --- CURSORE AD_DOC
   CURSOR C_AD_DOC
   IS
      SELECT   DISTINCT MID_AD, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD, DOCENTE_ID;

   --- CURSORE AD_MOD_DOC
   CURSOR C_AD_MOD_DOC
   IS
      SELECT   DISTINCT MID_AD_MOD, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD_MOD, DOCENTE_ID;

   --- CURSORE AD_CLA_DOC
   CURSOR C_AD_CLA_DOC
   IS
      SELECT   DISTINCT MID_AD_CLA, DOCENTE_ID
          FROM GOL_IUNI
     where aa_off_id = p_aa_id
      ORDER BY MID_AD_CLA, DOCENTE_ID;


   V_ID                 GOL_IUNI.MID_AD%TYPE;
   V_OLD_AA_OFF_ID      GOL_IUNI.AA_OFF_ID%TYPE;
   V_OLD_COD_FAC        GOL_IUNI.COD_FAC%TYPE;
   V_OLD_COD_CDS         GOL_IUNI.COD_CDS%TYPE;
   V_OLD_AA_ORD_ID      GOL_IUNI.AA_ORD_ID%TYPE;
   V_OLD_COD_PDS         GOL_IUNI.COD_PDS%TYPE;
   V_OLD_COD_AD          GOL_IUNI.COD_AD%TYPE;

   V_OLD_MID_LIV_1      GOL_IUNI.MID_LIV_1%TYPE;
   V_OLD_MID_LIV_2      GOL_IUNI.MID_LIV_2%TYPE;
   V_OLD_MID_LIV_3      GOL_IUNI.MID_LIV_3%TYPE;
   V_OLD_MID_LIV_4      GOL_IUNI.MID_LIV_4%TYPE;

   V_OLD_MID_AD         GOL_IUNI.MID_AD%TYPE;
   V_OLD_MID_AD_MOD     GOL_IUNI.MID_AD_MOD%TYPE;
   V_OLD_MID_AD_CLA     GOL_IUNI.MID_AD_CLA%TYPE;
   V_OLD_MID_AD_DOC     GOL_IUNI.MID_AD_DOC%TYPE;

   V_OLD_FAT_PART_COD   GOL_IUNI.FAT_PART_COD%TYPE;
   V_OLD_DOM_PART_COD   GOL_IUNI.DOM_PART_COD%TYPE;
   V_OLD_SEDE_DES   GOL_IUNI.SEDE_DES%TYPE;
   V_OLD_COD_MOD          GOL_IUNI.COD_MOD%TYPE;

   V_OLD_DOCENTE_ID     GOL_IUNI.DOCENTE_ID%TYPE;



BEGIN

      V_OLD_COD_FAC         := '0';
      V_OLD_AA_OFF_ID      := 0;
      V_OLD_COD_CDS         := '0';
      V_OLD_AA_ORD_ID      := 0;
      V_OLD_COD_PDS         := '0';
      V_OLD_COD_AD          := '0';
      V_OLD_MID_LIV_1      := 0;
      V_OLD_MID_LIV_2      := 0;
      V_OLD_MID_LIV_3      := 0;

      V_OLD_MID_AD         := 0;
      V_OLD_MID_AD_CLA     := 0;
      V_OLD_MID_AD_DOC     := 0;
      V_OLD_MID_AD_MOD     := 0;

      V_OLD_FAT_PART_COD   := 'x';
      V_OLD_DOM_PART_COD   := 'x';
      V_OLD_SEDE_DES   := 'x';
      V_OLD_COD_MOD          := '0';
      V_OLD_DOCENTE_ID     := 0;

--   V_OLD_DOCENTE_ID_CLA := 0;

   V_ID := 10000;

   SELECT NVL(MAX(MID_LIV_1), 10000) INTO V_ID FROM GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_1 IN C_LIV_1
   LOOP
      IF V_OLD_COD_FAC = R_LIV_1.COD_FAC AND
         V_OLD_AA_OFF_ID = R_LIV_1.AA_OFF_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_1 = V_ID
       WHERE AA_OFF_ID = R_LIV_1.AA_OFF_ID
       AND COD_FAC =  R_LIV_1.COD_FAC;

      V_OLD_AA_OFF_ID :=  R_LIV_1.AA_OFF_ID;
      V_OLD_COD_FAC :=  R_LIV_1.COD_FAC;
   END LOOP;

   COMMIT;

   V_ID := 20000;

   select nvl(max(MID_LIV_2), 20000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_2 IN C_LIV_2
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_2.MID_LIV_1 AND
         V_OLD_COD_CDS = R_LIV_2.COD_CDS
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_2 = V_ID
       WHERE MID_LIV_1 = R_LIV_2.MID_LIV_1
       AND COD_CDS =  R_LIV_2.COD_CDS;

      V_OLD_MID_LIV_1 :=  R_LIV_2.MID_LIV_1;
      V_OLD_COD_CDS :=  R_LIV_2.COD_CDS;
   END LOOP;

   COMMIT;

   V_ID := 30000;



   select nvl(max(MID_LIV_3), 30000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_3 IN C_LIV_3
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_3.MID_LIV_1 AND
         V_OLD_MID_LIV_2 = R_LIV_3.MID_LIV_2 AND
         V_OLD_AA_ORD_ID = R_LIV_3.AA_ORD_ID AND 
         V_OLD_COD_PDS = R_LIV_3.COD_PDS
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_3 = V_ID
       WHERE MID_LIV_1 = R_LIV_3.MID_LIV_1
       AND MID_LIV_2 = R_LIV_3.MID_LIV_2
       AND AA_ORD_ID =  R_LIV_3.AA_ORD_ID
       AND COD_PDS =  R_LIV_3.COD_PDS;

      V_OLD_MID_LIV_1 :=  R_LIV_3.MID_LIV_1;
      V_OLD_MID_LIV_2 :=  R_LIV_3.MID_LIV_2;
      V_OLD_AA_ORD_ID :=  R_LIV_3.AA_ORD_ID;
      V_OLD_COD_PDS :=  R_LIV_3.COD_PDS;
      
   END LOOP;

   COMMIT;

    --- dove è presente un solo ordinamento e un solo percorso
    UPDATE GOL_IUNI
    SET MID_LIV_3 = NULL
    WHERE (MID_LIV_1, MID_LIV_2)
    IN (
        SELECT MID_LIV_1, MID_LIV_2
        FROM
        (
        SELECT DISTINCT MID_LIV_1, MID_LIV_2, MID_LIV_3
        FROM GOL_IUNI
        )
        GROUP BY MID_LIV_1, MID_LIV_2
        HAVING COUNT(*) = 1
       );

   COMMIT;

   V_ID := 40000;

   select nvl(max(MID_LIV_4), 40000) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_LIV_4 IN C_LIV_4
   LOOP
      IF V_OLD_MID_LIV_1 = R_LIV_4.MID_LIV_1 AND
         V_OLD_MID_LIV_2 = R_LIV_4.MID_LIV_2 AND
         V_OLD_MID_LIV_3 = R_LIV_4.MID_LIV_3 AND
         V_OLD_COD_AD = R_LIV_4.COD_AD
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_LIV_4 = V_ID
       WHERE MID_LIV_1 = R_LIV_4.MID_LIV_1
       AND MID_LIV_2 = R_LIV_4.MID_LIV_2
       AND NVL(MID_LIV_3, 99999) = R_LIV_4.MID_LIV_3
       AND COD_AD =  R_LIV_4.COD_AD;

      V_OLD_MID_LIV_1 :=  R_LIV_4.MID_LIV_1;
      V_OLD_MID_LIV_2 :=  R_LIV_4.MID_LIV_2;
      V_OLD_MID_LIV_3 :=  R_LIV_4.MID_LIV_3;
      V_OLD_COD_AD :=  R_LIV_4.COD_AD;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD IN C_AD
   LOOP
      IF V_OLD_MID_LIV_4 = R_AD.MID_LIV_4
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD = V_ID
       WHERE MID_LIV_4 = R_AD.MID_LIV_4;

      V_OLD_MID_LIV_4 :=  R_AD.MID_LIV_4;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_CLA), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_CLA IN C_AD_CLA
   LOOP
      IF V_OLD_MID_AD = R_AD_CLA.MID_AD AND
         V_OLD_FAT_PART_COD = R_AD_CLA.FAT_PART_COD AND
         V_OLD_DOM_PART_COD = R_AD_CLA.DOM_PART_COD AND
         V_OLD_SEDE_DES = R_AD_CLA.SEDE_DES
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_CLA = V_ID
       WHERE MID_AD = R_AD_CLA.MID_AD
       AND FAT_PART_COD = R_AD_CLA.FAT_PART_COD
       AND DOM_PART_COD = R_AD_CLA.DOM_PART_COD
       AND SEDE_DES = R_AD_CLA.SEDE_DES;

      V_OLD_MID_AD :=  R_AD_CLA.MID_AD;
      V_OLD_FAT_PART_COD :=  R_AD_CLA.FAT_PART_COD;
      V_OLD_DOM_PART_COD :=  R_AD_CLA.DOM_PART_COD;
      V_OLD_SEDE_DES :=  R_AD_CLA.SEDE_DES;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_MOD), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_MOD IN C_AD_MOD
   LOOP
      IF V_OLD_MID_AD = R_AD_MOD.MID_AD AND
         V_OLD_COD_MOD = R_AD_MOD.COD_MOD
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_MOD = V_ID
       WHERE MID_AD = R_AD_MOD.MID_AD
       AND COD_MOD = R_AD_MOD.COD_MOD;

      V_OLD_MID_AD :=  R_AD_MOD.MID_AD;
      V_OLD_COD_MOD :=  R_AD_MOD.COD_MOD;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_DOC IN C_AD_DOC
   LOOP
      IF V_OLD_MID_AD = R_AD_DOC.MID_AD AND
         V_OLD_DOCENTE_ID = R_AD_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_DOC = V_ID
       WHERE MID_AD = R_AD_DOC.MID_AD
       AND DOCENTE_ID = R_AD_DOC.DOCENTE_ID;

      V_OLD_MID_AD :=  R_AD_DOC.MID_AD;
      V_OLD_DOCENTE_ID :=  R_AD_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_MOD_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_MOD_DOC IN C_AD_MOD_DOC
   LOOP
      IF V_OLD_MID_AD_MOD = R_AD_MOD_DOC.MID_AD_MOD AND
         V_OLD_DOCENTE_ID = R_AD_MOD_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_MOD_DOC = V_ID
       WHERE MID_AD_MOD = R_AD_MOD_DOC.MID_AD_MOD
       AND DOCENTE_ID =  R_AD_MOD_DOC.DOCENTE_ID;

      V_OLD_MID_AD_MOD :=  R_AD_MOD_DOC.MID_AD_MOD;
      V_OLD_DOCENTE_ID := R_AD_MOD_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

   V_ID := 0;

   select nvl(max(MID_AD_CLA_DOC), 0) into v_id from GOL_IUNI where aa_off_id = p_aa_id;

   FOR R_AD_CLA_DOC IN C_AD_CLA_DOC
   LOOP
      IF V_OLD_MID_AD_CLA = R_AD_CLA_DOC.MID_AD_CLA AND
         V_OLD_DOCENTE_ID = R_AD_CLA_DOC.DOCENTE_ID
      THEN
         V_ID := V_ID;
      ELSE
         V_ID := V_ID + 1;
      END IF;

      UPDATE GOL_IUNI
         SET MID_AD_CLA_DOC = V_ID
       WHERE MID_AD_CLA = R_AD_CLA_DOC.MID_AD_CLA
       AND DOCENTE_ID = R_AD_CLA_DOC.DOCENTE_ID;

      V_OLD_MID_AD_CLA :=  R_AD_CLA_DOC.MID_AD_CLA;
      V_OLD_DOCENTE_ID := R_AD_CLA_DOC.DOCENTE_ID;
   END LOOP;

   COMMIT;

    UPDATE GOL_IUNI
    SET MID_AD = MID_AD + (p_aa_id - 2000) * 100000,
           MID_AD_CLA = MID_AD_CLA + (p_aa_id - 2000) * 100000, 
           MID_AD_DOC = MID_AD_DOC + (p_aa_id - 2000) * 100000,
           MID_AD_MOD = MID_AD_MOD + (p_aa_id - 2000) * 100000, 
           MID_AD_MOD_DOC = MID_AD_MOD_DOC + (p_aa_id - 2000) * 100000,
           MID_AD_CLA_DOC = MID_AD_CLA_DOC + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id;


    UPDATE GOL_IUNI
    SET MID_LIV_1 = MID_LIV_1 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_1 IS NOT NULL;

    UPDATE GOL_IUNI
    SET MID_LIV_2 = MID_LIV_2 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_2 IS NOT NULL;

    UPDATE GOL_IUNI
    SET MID_LIV_3 = MID_LIV_3 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_3 IS NOT NULL;
     
    UPDATE GOL_IUNI
    SET MID_LIV_4 = MID_LIV_4 + (p_aa_id - 2000) * 100000
    WHERE AA_OFF_ID = p_aa_id
    AND  MID_LIV_4 IS NOT NULL;


    
    COMMIT;  


END;
/
