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
    )
    IS
    BEGIN
        INSERT INTO elmah$error
            (
                errorid,
                application,
                host,
                type,
                source,
                message,
                username,
                allxml,
                statuscode,
                timeutc
            )
        VALUES
            (
                UPPER(v_ErrorId),
                v_Application,
                v_Host,
                v_Type,
                v_Source,
                v_Message,
                v_User,
                v_AllXml,
                v_StatusCode,
                v_TimeUtc
            );

    END LogError;   

