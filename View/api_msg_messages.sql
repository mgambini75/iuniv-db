/* Formatted on 14/03/2016 11:45:36 (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW API_MSG_MESSAGES
(
   MID,
   LANG,
   USER_ID,
   FLG_PP,
   FLG_ISNEW,
   FLG_PREFER,
   DAT_CREAZ,
   CATEGORIA,
   TITOLO,
   TESTO
)
AS
     SELECT a.mid AS mid,
            b.ln_code AS lang,
            user_id,
            DECODE (UPPER (flg_primo), 'S', 1, 0) AS flg_pp,
            CASE
               WHEN num_visibilita > num_letture THEN 1
               ELSE CASE WHEN flg_read = 1 THEN 1 ELSE 0 END
            END
               AS flg_isnew,
            DECODE (UPPER (flg_preferiti), 'S', 1, 0) AS flg_prefer,
            data_ins AS dat_creaz,
            NVL (des_categoria, 'Generico') AS categoria,
            des_titolo AS titolo,
            SUBSTR (des_testo, 1, 250) testo
       FROM msg_message a JOIN msg_message_ln b ON a.mid = b.mid
      WHERE UPPER (flg_canc) = 'N'
   ORDER BY data_ins DESC;
