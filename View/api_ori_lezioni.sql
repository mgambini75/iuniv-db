/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_ORI_LEZIONI
(
   MID,
   LN_CODE,
   TIPO,
   DATA_INIZIO,
   DATA_FINE,
   SUPERTITOLO,
   TITOLO,
   DESCRIZIONE,
   DES_AD,
   DES_EVENTO,
   DES_NOTA_IMP,
   DES_NOTA_EVE,
   DES_TIPO_ATT,
   DES_CORSI,
   DES_PATIZ,
   DES_DOC_RESP,
   DES_DOCENTI,
   DES_AULE,
   LINGUA_CLASSE,
   LINGUA_INSEGN,
   COD_AD,
   COD_CLASSE,
   COD_GRUPPO,
   TITOLO_MAP,
   LAT,
   LON
)
AS
   SELECT a.mid,
          ln_code,
          1 AS tipo,
          data_inizio,
          data_fine,
          fu_des_up_low (b.des_ad) || ' [' || cda_ad || ']' AS supertitolo,
          UPPER (b.des_aule) AS titolo,
          b.des_corsi || ' - ' || b.des_docenti AS descrizione,
          fu_des_up_low (b.des_ad),
          fu_des_up_low (b.des_evento),
          b.des_nota_imp,
          b.des_nota_eve,
          b.des_tipo_att,
          b.des_corsi,
          b.des_patiz,
          b.des_doc_resp,
          b.des_docenti,
          b.des_aule AS des_aule,
          b.lingua_classe,
          b.lingua_insegn,
          cda_ad AS cod_ad,
          CASE
             WHEN INSTR (REPLACE (b.DES_PATIZ, 'Classe: ', ''), ' ') = 0
             THEN
                REPLACE (b.DES_PATIZ, 'Classe: ', '')
             ELSE
                SUBSTR (REPLACE (b.DES_PATIZ, 'Classe: ', ''),
                        1,
                        INSTR (REPLACE (b.DES_PATIZ, 'Classe: ', ''), ' '))
          END
             AS cod_classe,
          CASE
             WHEN INSTR (b.DES_PATIZ, 'Gruppo: ') = 0
             THEN
                NULL
             ELSE
                SUBSTR (b.DES_PATIZ,
                        INSTR (b.DES_PATIZ, 'Gruppo: ') + 8,
                        100)
          END
             AS cod_gruppo,
          DESCRIZIONE AS titolo_map,
          lat AS lat,
          lon AS lon
     FROM ori_lezioni a
          JOIN ori_lezioni_ln b ON a.mid = b.mid
          LEFT JOIN t_aule c ON a.des_aule = DES_RISORSA;
