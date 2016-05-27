CREATE OR REPLACE PROCEDURE P_AGG_ELIMINA_MSG(p_id_msg NUMBER, p_data_eli DATE  ) AS 

BEGIN

   DECLARE com_id_msg number(10);
   
   BEGIN
   
     SELECT COM_ID into com_id_msg from MSG_MESSAGE WHERE MID = p_id_msg;
     
     --- Elimino le localizzazioni del msg dalla cache---
     delete from MSG_MESSAGE_LN where MID = p_id_msg;
  
     --- Elimino il msg dalla cache
     delete from MSG_MESSAGE where MID = p_id_msg;
  
     -- Setto la data eliminazione e lo stato "cancellato" sulla struttura messaggi Esse3
     UPDATE P16_COM_EST
     SET STATO_COM = 5,
         DATA_MOD = p_data_eli
     WHERE ( COM_ID = com_id_msg );
     
  END;
  
END P_AGG_ELIMINA_MSG;
/
