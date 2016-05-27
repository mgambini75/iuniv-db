    PROCEDURE GetErrorXml
    (
        v_Application IN elmah$error.application%TYPE,
        v_ErrorId IN elmah$error.errorid%TYPE,
        v_AllXml OUT elmah$error.allxml%TYPE
    )
    IS
    BEGIN
        SELECT  allxml
        INTO    v_AllXml
        FROM    elmah$error
        WHERE   errorid = UPPER(v_ErrorId)
        AND     application = v_Application;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_AllXml := NULL;
    END GetErrorXml;

    PROCEDURE GetErrorsXml
    (
        v_Application IN elmah$error.application%TYPE,
        v_PageIndex IN NUMBER DEFAULT 0,
        v_PageSize IN NUMBER DEFAULT 15,
        v_TotalCount OUT NUMBER,
        v_Results OUT t_cursor
    )
    IS
        l_StartRowIndex NUMBER;
        l_EndRowIndex   NUMBER;
    BEGIN
        -- Get the ID of the first error for the requested page
        l_StartRowIndex := v_PageIndex * v_PageSize + 1;
        l_EndRowIndex := l_StartRowIndex + v_PageSize - 1;
        
        -- find out how many rows we've got in total
        SELECT  COUNT(*)
        INTO    v_TotalCount
        FROM    elmah$error
        WHERE   application = v_Application;

        OPEN v_Results FOR
            SELECT  *
            FROM
            (
                SELECT  e.*,
                        ROWNUM row_number
                FROM
                (
                    SELECT  /*+ INDEX(elmah$error, idx_elmah$error_app_time_seq) */
                            errorid,
                            application,
                            host,
                            type,
                            source,
                            message,
                            username,
                            statuscode,
                            timeutc
                    FROM    elmah$error
                    WHERE   application = v_Application
                    ORDER BY
                            timeutc DESC, 
                            sequencenumber DESC
                ) e
                WHERE ROWNUM <= l_EndRowIndex
            )
            WHERE   row_number >= l_StartRowIndex;
            
    END GetErrorsXml;

