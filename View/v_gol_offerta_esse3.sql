/* Formatted on 14/03/2016 11:45:38 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW V_GOL_OFFERTA_ESSE3
(
   AA_OFF_ID,
   FAC_ID,
   CDS_ID,
   AD_ID,
   AA_ORD_ID,
   PDS_ID,
   UD_ID,
   SEG_ID,
   TIPO_CORSO_COD,
   COD_FAC,
   DES_FAC,
   COD_CDS,
   DES_CDS,
   COD_AD,
   DES_AD,
   COD_MOD,
   DES_MOD,
   TIPO_INS_COD,
   DUR_UNI_VAL,
   DUR_STU_IND,
   PESO_TOT,
   PESO_DET,
   TIPO_AF_COD,
   DES_TAF,
   AMB_ID,
   DES_AMB,
   SETT_COD,
   DOCENTE_ID,
   TIPO_COPERTURA_COD,
   FAT_PART_COD,
   DOM_PART_COD,
   TITOLARE_FLG,
   PART_COD,
   DES_PART,
   TIPO_DID_COD,
   DES_TIPI_DID,
   LINGUA_DID_ID,
   DES_LUNGUA_DID
)
AS
     SELECT OF1.AA_OFF_ID,
            I.FAC_ID,
            OF1.CDS_ID,
            OF1.AD_ID,
            OF4.AA_ORD_ID,
            OF4.PDS_ID,
            OF2.UD_ID,
            OF3.SEG_ID,
            G.TIPO_CORSO_COD,
            I.COD AS COD_FAC,
            FU_DES_UP_LOW (I.DES) AS DES_FAC,
            G.COD AS COD_CDS,
            FU_DES_UP_LOW (G.DES) AS DES_CDS,
            D.COD AS COD_AD,
            FU_DES_UP_LOW (D.DES) AS DES_AD,
            OF2.COD AS COD_MOD,
            FU_DES_UP_LOW (OF2.DES) AS DES_MOD,
            OF4.TIPO_INS_COD,
            OF3.DUR_UNI_VAL,
            OF3.DUR_STU_IND,
            OF4.PESO_AR AS PESO_TOT,
            OF6.PESO AS PESO_DET,
            OF6.TIPO_AF_COD,
            B.DES AS DES_TAF,
            OF6.AMB_ID,
            C.DES AS DES_AMB,
            OF3.SETT_COD,
            OF7.DOCENTE_ID,
            OF7.TIPO_COPERTURA_COD,
            OF8.FAT_PART_COD,
            OF8.DOM_PART_COD,
            TITOLARE_FLG,
            OF9.PART_COD,
            A.DES AS DES_PART,
            OF10.TIPO_DID_COD,
            LOWER (E.DES) AS DES_TIPI_DID,
            NVL (OF10.LINGUA_DID_ID, 5) AS LINGUA_DID_ID,
            LOWER (F.DES) AS DES_LUNGUA_DID
       FROM P09_AD_CDS OF1
            JOIN P09_UD_CDS OF2
               ON     OF1.CDS_ID = OF2.CDS_ID
                  AND OF1.AD_ID = OF2.AD_ID
                  AND OF1.AA_OFF_ID = OF2.AA_OFF_ID
            JOIN P09_SEG_CDS OF3
               ON     OF2.CDS_ID = OF3.CDS_ID
                  AND OF2.AD_ID = OF3.AD_ID
                  AND OF2.AA_OFF_ID = OF3.AA_OFF_ID
                  AND OF2.UD_ID = OF3.UD_ID
            JOIN P09_AD_PDSORD OF4
               ON     OF1.CDS_ID = OF4.CDS_ID
                  AND OF1.AD_ID = OF4.AD_ID
                  AND OF1.AA_OFF_ID = OF4.AA_OFF_ID
            JOIN P09_UD_PDSORD OF5
               ON     OF4.CDS_ID = OF5.CDS_ID
                  AND OF4.AD_ID = OF5.AD_ID
                  AND OF4.AA_OFF_ID = OF5.AA_OFF_ID
                  AND OF4.AA_ORD_ID = OF5.AA_ORD_ID
                  AND OF4.PDS_ID = OF5.PDS_ID
                  AND OF2.UD_ID = OF5.UD_ID
            JOIN P09_SEG_PDSORD OF6
               ON     OF5.CDS_ID = OF6.CDS_ID
                  AND OF5.AD_ID = OF6.AD_ID
                  AND OF5.AA_OFF_ID = OF6.AA_OFF_ID
                  AND OF5.AA_ORD_ID = OF6.AA_ORD_ID
                  AND OF5.PDS_ID = OF6.PDS_ID
                  AND OF5.UD_ID = OF6.UD_ID
                  AND OF3.SEG_ID = OF6.SEG_ID
            LEFT JOIN P09_UD_PDSORD_DOC OF7
               ON     OF6.CDS_ID = OF7.CDS_ID
                  AND OF6.AD_ID = OF7.AD_ID
                  AND OF6.AA_OFF_ID = OF7.AA_OFF_ID
                  AND OF6.AA_ORD_ID = OF7.AA_ORD_ID
                  AND OF6.PDS_ID = OF7.PDS_ID
                  AND OF6.UD_ID = OF7.UD_ID
            LEFT JOIN P09_UD_DOC_PART OF8
               ON     OF7.CDS_ID = OF8.CDS_ID
                  AND OF7.AD_ID = OF8.AD_ID
                  AND OF7.AA_OFF_ID = OF8.AA_OFF_ID
                  AND OF7.AA_ORD_ID = OF8.AA_ORD_ID
                  AND OF7.PDS_ID = OF8.PDS_ID
                  AND OF7.UD_ID = OF8.UD_ID
                  AND OF7.DOCENTE_ID = OF8.DOCENTE_ID
            LEFT JOIN P09_UD_LOG_PDS OF9
               ON     OF5.CDS_ID = OF9.CDS_ID
                  AND OF5.AD_ID = OF9.AD_ID
                  AND OF5.AA_OFF_ID = OF9.AA_OFF_ID
                  AND OF5.AA_ORD_ID = OF9.AA_ORD_ID
                  AND OF5.PDS_ID = OF9.PDS_ID
                  AND OF5.UD_ID = OF9.UD_ID
            LEFT JOIN P09_AD_LOG OF10
               ON     OF9.AA_OFF_ID = OF10.AA_OFF_ID
                  AND OF9.FAT_PART_COD = OF10.FAT_PART_COD
                  AND OF9.DOM_PART_COD = OF10.DOM_PART_COD
                  AND OF9.PART_COD = OF10.PART_COD
                  AND OF9.AD_LOG_ID = OF10.AD_LOG_ID
            LEFT JOIN P06_PART A ON OF9.PART_COD = A.PART_COD
            LEFT JOIN TIPI_AF B ON OF6.TIPO_AF_COD = B.TIPO_AF_COD
            LEFT JOIN P07_AMBITI C ON OF6.AMB_ID = C.AMB_ID
            JOIN P09_AD_GEN D ON OF1.AD_ID = D.AD_ID
            LEFT JOIN TIPI_DID E ON OF10.TIPO_DID_COD = E.TIPO_DID_COD
            JOIN LINGUE F ON NVL (OF10.LINGUA_DID_ID, 5) = F.LINGUA_ID
            JOIN P06_CDS G ON OF1.CDS_ID = G.CDS_ID
            JOIN P06_FAC_CDS h ON OF1.CDS_ID = H.CDS_ID
            JOIN P06_FAC I ON H.FAC_ID = I.FAC_ID AND i.sdr_tip = 'DIP'
      WHERE 1 = 1 AND OF1.AA_OFF_ID >= 2008
   ORDER BY 1,
            2,
            3,
            4,
            5,
            6,
            7;
