CREATE OR REPLACE PACKAGE PKG_ELMAH$GET_ERROR
IS
    -- NB this is for backwards compatibility with Oracle 8i
    TYPE t_cursor IS REF CURSOR;
    
    PROCEDURE GetErrorXml
    (
        v_Application IN elmah$error.application%TYPE,
        v_ErrorId IN elmah$error.errorid%TYPE,
        v_AllXml OUT elmah$error.allxml%TYPE
    );

    PROCEDURE GetErrorsXml
    (
        v_Application IN elmah$error.application%TYPE,
        v_PageIndex IN NUMBER DEFAULT 0,
        v_PageSize IN NUMBER DEFAULT 15,
        v_TotalCount OUT NUMBER,
        v_Results OUT t_cursor
    );
    
END pkg_elmah$get_error;
/


