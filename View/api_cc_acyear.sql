/* Formatted on 14/03/2016 11:45:33 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_ACYEAR
(
   MID,
   TITLE
)
AS
   SELECT AA_ID AS MID,
          TO_CHAR (AA_ID) || '/' || SUBSTR (AA_ID + 1, 3, 2) AS TITLE
     FROM (  SELECT DISTINCT AA_ID
               FROM GOL_LIV
              WHERE     MID_LIV_PADRE IS NULL
                    AND AA_ID <= TO_CHAR (SYSDATE, 'YYYY')
           ORDER BY AA_ID DESC)
    WHERE ROWNUM <= get_frw_config ('MaxRowsACYEAR');
