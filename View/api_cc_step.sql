/* Formatted on 14/03/2016 11:45:34 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_CC_STEP
(
   MID,
   PARENT_ID,
   DETAIL_ID,
   ACYEAR_ID,
   TITLE,
   DESCRIPTION,
   LANG,
   ORDINE
)
AS
     SELECT A.MID,
            B.MID_LIV_PADRE AS PARENT_ID,
            B.MID_DETT AS DETAIL_ID,
            B.AA_ID AS ACYEAR_ID,
            A.NAME AS TITLE,
            A.DESCRIPTION AS DESCRIPTION,
            A.LN_CODE AS LANG,
            B.ORDINE AS ORDINE
       FROM GOL_LIV_LN A JOIN GOL_LIV B ON A.MID = B.MID
   ORDER BY A.NAME || ' [' || CODE || ']';
