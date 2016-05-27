CREATE OR REPLACE PACKAGE PKG_ELMAH$LOG_ERROR
IS
    PROCEDURE LogError
    (
        v_ErrorId IN elmah$error.errorid%TYPE,
        v_Application IN elmah$error.application%TYPE,
        v_Host IN elmah$error.host%TYPE,
        v_Type IN elmah$error.type%TYPE,
        v_Source IN elmah$error.source%TYPE,
        v_Message IN elmah$error.message%TYPE,
        v_User IN elmah$error.username%TYPE,
        v_AllXml IN elmah$error.allxml%TYPE,
        v_StatusCode IN elmah$error.statuscode%TYPE,
        v_TimeUtc IN elmah$error.timeutc%TYPE
    );
END pkg_elmah$log_error;
/

