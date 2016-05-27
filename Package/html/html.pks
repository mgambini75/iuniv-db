CREATE OR REPLACE PACKAGE HTML
     IS
         PROCEDURE convertToText ( html_in IN VARCHAR2, plain_text OUT VARCHAR2 )
         IS
            language java
            name 'html.convertToText( java.lang.String, java.lang.String[] )';

         FUNCTION to_text ( html_in IN VARCHAR2 )
         RETURN VARCHAR2
         IS
            language java
            name 'html.to_text( java.lang.String ) return java.lang.String';
			
		function f_dba_check return varchar2 ;

END html;
/


-- html was created from a Java Source and should be recreated the same way.
CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "html" as import javax.swing.text.BadLocationException;
     import javax.swing.text.Document;
     import javax.swing.text.html.HTMLEditorKit;
     import java.io.*;

     public class html extends Object
     {
        public static void convertToText( java.lang.String p_in,
                                          java.lang.String[] p_out )
        throws IOException, BadLocationException
        {
           // test for null inputs to avoid java.lang.NullPointerException when input is null
           if ( p_in != null )
           { HTMLEditorKit kit = new HTMLEditorKit();
             Document doc = kit.createDefaultDocument();
             kit.read(new StringReader(p_in), doc, 0);
             p_out[0] = doc.getText(0, doc.getLength());
           }
           else p_out[0] = null;
        }

        public static String to_text(String p_in)
        throws IOException, BadLocationException
        {
           // test for null inputs to avoid java.lang.NullPointerException when input is null
           if (p_in != null)
           { HTMLEditorKit kit = new HTMLEditorKit();
             Document doc = kit.createDefaultDocument();
             kit.read(new StringReader(p_in), doc, 0);
             return doc.getText(0, doc.getLength());
           }
           else return null;
        }
    }
/