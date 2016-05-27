/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_DSH_AD_VOTI
(
   MID,
   LANG,
   STU_ID,
   ITEM_NUM,
   DESCRIPTION,
   REG_DATE,
   GRADE_DESC,
   GRADE_REAL,
   AVG_MATH
)
AS
     SELECT mid,
            'it',
            stu_id,
            prog,
            CASE
               WHEN LENGTH (descrizione) > 30
               THEN
                  SUBSTR (descrizione, 1, 27) || '...'
               ELSE
                  descrizione
            END
               descrizione,
            data,
            voto_des,
            voto_elab,
            media_art_prog
       FROM dsh_ad_voti
      WHERE voto_des IS NOT NULL AND voto_elab IS NOT NULL
   ORDER BY prog;
