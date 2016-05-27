CREATE OR REPLACE FUNCTION FU_DES_UP_LOW (v_text_in VARCHAR2)
   RETURN VARCHAR2
AS
   v_text_out   VARCHAR2 (4000);
BEGIN
   v_text_out :=
      UPPER (SUBSTR (v_text_in, 1, 1))
      || TRIM (LOWER (SUBSTR (v_text_in, 2)));
      
     v_text_out:=REPLACE(v_text_out, '(i ', '(I ');     
     v_text_out:=REPLACE(v_text_out, ' i ', ' I ');
     v_text_out:=REPLACE(v_text_out, ' i)', ' I)');
     v_text_out:=REPLACE(v_text_out, ' i:', ' I:');
     v_text_out:=REPLACE(v_text_out, 'iii', 'III');
     v_text_out:=REPLACE(v_text_out, 'ii', 'II');
     v_text_out:=REPLACE(v_text_out, '(iv', '(IV'); 
     v_text_out:=REPLACE(v_text_out, 'iv)', 'IV)');
     v_text_out:=REPLACE(v_text_out, ' iv)', ' IV)');
     v_text_out:=REPLACE(v_text_out, '(v', '(V'); 
     v_text_out:=REPLACE(v_text_out, 'v)', 'V)');
     
     v_text_out:=REPLACE(v_text_out, 'x)', 'X)');
     v_text_out:=REPLACE(v_text_out, '(x', '(X');

     v_text_out:=REPLACE(v_text_out, 'xxii', 'XXII');
     v_text_out:=REPLACE(v_text_out, 'xxi', 'XXI');
     v_text_out:=REPLACE(v_text_out, 'xx', 'XX');     
     v_text_out:=REPLACE(v_text_out, 'xiii', 'XIII');     
     v_text_out:=REPLACE(v_text_out, 'ix', 'IX');
     v_text_out:=REPLACE(v_text_out, 'xi', 'XI');
     v_text_out:=REPLACE(v_text_out, 'x:', 'X:');
          
   RETURN v_text_out;
END; 
/
