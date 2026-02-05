@ECHO OFF
REM *************************************************************************
REM * Use -k on cUrl to bypass SSL certificate verification                 *
REM * Use -v for call debugging                                             *
REM *************************************************************************
ECHO Starting VC4 API - Modify Program Library Entry CH5Z

REM These variables must by changed referencing your system
SET IP="192.168.1.56"
SET Token="XXXX"
Set FriendlyName="Main"
Set ProgramID="11"
Set Notes=For Testing - Updated via API
Set AppFile="..\bin\Debug\net8.0\HyperionCore.cpz"
Set WebxPanelFile="..\..\Construct\Room\output\Room.ch5z"
Set ProgramInstanceId="MAIN"

REM Get Authorizations groups
REM curl -k -X GET "https://%IP%/VirtualControl/config/api/Authentication" -H "accept: application/json" -H "Authorization: %Token%"
REM Reads all programs to get their ProgramID useful for oprogram operations
curl -k -X GET "https://%IP%/VirtualControl/config/api/ProgramLibrary" -H "accept: application/json" -H "Authorization: %Token%"

ECHO.
ECHO.

ECHO Modify Program Library Entry for ProgramID %ProgramID% with FriendlyName %FriendlyName% with new CH5Z
REM Modify existing CH5
REM Note: We use -F (form) instead of -d (data) to correctly handle the file and multipart fields
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
