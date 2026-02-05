@ECHO OFF
REM *************************************************************************
REM * Use -k on cUrl to bypass SSL certificate verification                 *
REM * Use -v for call debugging                                             *
REM *************************************************************************
ECHO Starting VC4 API - Modify Program Library Entry CH5Z

REM Load variables from settings.txt
IF EXIST VC4_API\settings.txt (
    FOR /F "tokens=1,2 delims==" %%A IN (settings.txt) DO (
        SET %%A=%%B
    )
) ELSE (
    ECHO Error: settings.txt not found!
    PAUSE
    EXIT /B
)

REM Get Authorizations groups
REM curl -k -X GET "https://%IP%/VirtualControl/config/api/Authentication" -H "accept: application/json" -H "Authorization: %Token%"
REM Reads all programs to get their ProgramID useful for oprogram operations
curl -k -X GET "https://%IP%/VirtualControl/config/api/ProgramLibrary" -H "accept: application/json" -H "Authorization: %Token%"

ECHO.
ECHO.

ECHO Modify Program Library Entry for ProgramID %ProgramID% with FriendlyName %FriendlyName% with new CH5Z
REM Modify existing CH5
REM Nota: Usiamo -F (form) invece di -d (data) per gestire correttamente il file e i campi multipart
curl -k -X PUT "https://%IP%/VirtualControl/config/api/ProgramLibrary" ^
     -H "accept: application/json" ^
     -H "Authorization: %Token%" ^
     -H "Content-Type: multipart/form-data" ^
     -F "ProgramId=%ProgramID%" ^
     -F "FriendlyName=%FriendlyName%" ^
     -F "Notes=%Notes%" ^
     -F "WebxPanelFile=@%WebxPanelFile%"

ECHO.
ECHO.
ECHO Restarting
curl -k -X GET "https://%IP%/VirtualControl/config/api/ProgramInstance"  ^
 -H "accept: application/json"  ^
 -H "Authorization: %Token%" 

ECHO.
ECHO.

REM Restart Program to apply changes
curl -k -X PUT "https://%IP%/VirtualControl/config/api/ProgramInstance" ^
         -H "accept: application/json" -H "Authorization: %Token%" ^
         -H "Content-Type: multipart/form-data" ^
         -F "ProgramInstanceId=%ProgramInstanceId%" ^
         -F "Name=%FriendlyName%" ^
         -F "Restart=true"
