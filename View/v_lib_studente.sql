/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_LIB_STUDENTE
(
   MID,
   STU_ID,
   COD_AD,
   DES_AD,
   ANNO_CORSO,
   DES_ANNO,
   PESO,
   DES_PESO,
   COD_TIPO_INS,
   DES_TIPO_INS,
   COD_STATO,
   DES_STATO,
   VOTO,
   LODE_FLG,
   TIPO_GIUD_COD,
   DES_VOTO,
   DATA_SUP,
   AA_SUP_ID
)
AS
   SELECT ADSCE_ID AS MID,
          A.STU_ID,
          A.COD AS COD_AD,
          FU_DES_UP_LOW (A.DES) AS DES_AD,
          A.ANNO_CORSO,
          NVL (E.DES2, 'nd') AS DES_ANNO,
          A.PESO,
             A.PESO
          || DECODE (f.um_peso_cod,
                     'A', ' Annualità',
                     'C', ' Cfu',
                     f.um_peso_cod)
             AS des_peso,
          NVL (A.TIPO_INS_COD, 'nd') AS COD_TIPO_INS,
          NVL (D.DES, 'Non Definito') AS DES_TIPO_INS,
          A.STA_SCE_COD AS COD_STATO,
          DECODE (A.STA_SCE_COD,
                  'P', 'In piano',
                  'F', 'Frequentata',
                  'S', 'Superata')
             AS DES_STATO,
          A.VOTO,
          A.LODE_FLG,
          A.TIPO_GIUD_COD,
          DECODE (
             A.VOTO,
             NULL, C.DES,
             TO_CHAR (A.VOTO) || DECODE (A.LODE_FLG,  0, '',  1, ' e lode'))
             AS DES_VOTO,
          TRUNC (A.DATA_SUP) AS DATA_SUP,
          A.AA_SUP_ID
     FROM P11_AD_SCE A
          JOIN P04_MAT B ON B.MAT_ID = A.MAT_ID AND B.STA_MAT_COD = 'A'
          LEFT JOIN TIPI_GIUDIZIO C ON A.TIPO_GIUD_COD = C.TIPO_GIUD_COD
          LEFT JOIN TIPI_INS D ON A.TIPO_INS_COD = D.TIPO_INS_COD
          LEFT JOIN TIPI_ANNO E ON TO_CHAR (A.ANNO_CORSO) = E.ANNO_COD
          JOIN P06_CDS F ON F.CDS_ID = A.CDS_ID;
