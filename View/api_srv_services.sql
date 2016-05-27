/* Formatted on 14/03/2016 11:45:37 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_SRV_SERVICES
(
   MID,
   ANA_ID,
   TYPE,
   TYPE_SRV,
   LANG,
   PROFILE,
   TITOLO,
   DESCRIZIONE,
   TAG_SRV,
   ATTRIBUTE,
   LASTNAME,
   FIRSTNAME,
   ADDRESS,
   LAT,
   LON,
   EMAIL,
   TEL,
   FAX,
   CELL,
   URL,
   NOTE
)
AS
   SELECT A.MID,
          A.ANA_ID,
          TYPE,
          TYPE_SRV,
          LN_CODE AS LANG,
          PROFILE,
          B.DESCRIPTION AS TITOLO,
          B.NOTE1 AS DESCRIZIONE,
          B.TAG_SRV,
          B.ATTRIBUTE,
          FIRSTNAME,
          NVL (LASTNAME, B.DESCRIPTION),
          ADDRESS,
          LAT,
          LON,
          EMAIL,
          TEL,
          FAX,
          CELL,
          URL,
          B.HOURS || B.NOTE1 || B.NOTE2 || B.NOTE3
     FROM SRV_SERVICES A JOIN SRV_SERVICES_LN B ON A.MID = B.MID;
