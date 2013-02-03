@echo off
set PROG_DIR=C:\Program Files\Oracle
set LOG=%PROG_DIR%\Scripts\VBox_Setup_Services.log
set SC=%WINDIR%\system32\sc.exe
set SRV_START=%PROG_DIR%\srvstart.exe
set INI=%PROG_DIR%\services.ini

::######################################################################################
call :main > "%LOG%"
goto :EOF

::######################################################################################
:main
	echo _______________________________________________________________________________
	echo ..................%DATE%...................%TIME%.................
	echo.
	call :setUserPass	msalisbury	Xitsanmyg76
	call :setUserPass	administrator	1qaz@WSX
	call :setUserPass	vbox		1qaz@WSX

	call :addEnvironmentLog Environment     vbox          "Hello World"
	call :addEnvironmentLog Environment     msalisbury    "Hello Sexy"
	call :addEnvironmentLog Environment     administrator "Hello POTUS"

	call :addVBoxWebSrv     VBoxWebSrv   administrator  18084
	call :addVBoxWebSrv     VBoxWebSrv   msalisbury     18085
	call :addVBoxWebSrv     VBoxWebSrv   vbox           18086

	::call :addVBoxHeadless   VBoxHeadless msalisbury     RHEL01 "RedHat Enterprise 6 Server [RHEL01]"

	goto :EOF

::######################################################################################

:addEnvironmentLog
	set NAME=%~1
	set USER=%~2
	set OPTS=%~3
	call :getUserPass %USER%

	set SRV_NAME=%NAME%%USER%
	set SRV_DISP=%NAME% LOG USER[%USER%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_OPT="%OPTS%" -c "%INI%"

	call :addService
	goto :EOF


:addVBoxHeadless
	set NAME=%~1
	set USER=%~2
	set SHRT=%~3
	set LONG=%~4
	call :getUserPass %USER%

	set SRV_NAME=%NAME%%USER%%SHRT%
	set SRV_DISP=%NAME% USER[%USER%] SYSTEM[%LONG%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_VBOX_CLIENT="%LONG%" -e PASSWORD=%USERPASS% -c "%INI%"
	
	call :addService
	goto :EOF

:addVBoxWebSrv
	set NAME=%~1
	set USER=%~2
	set PORT=%~3
	call :getUserPass %USER%

	set SRV_NAME=%NAME%%PORT%%USER%
	set SRV_DISP=%NAME% PORT[%PORT%] USER[%USER%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_PORT=%PORT% -e PASSWORD=%USERPASS% -c "%INI%"
	
	call :addService
	goto :EOF

:addService
	%SC% delete %SRV_NAME% > nul
	echo Adding Service "%SRV_DISP%"
	echo ...............................................................................
	%SC% create %SRV_NAME%     binPath= "%SRV_BIN:"="""%"
	%SC% config %SRV_NAME% DisplayName= "%SRV_DISP%"
	%SC% config %SRV_NAME%        type= own
	%SC% config %SRV_NAME%       start= demand
	%SC% config %SRV_NAME%       error= ignore
	%SC% config %SRV_NAME%         obj= .\%USER% 
	%SC% config %SRV_NAME%    password= %USERPASS%
	echo.
	goto :EOF

:getCMD_CD
	for /f "tokens=*" %%a in ('cd') do set %1=%%a
	goto:EOF

:setUserPass
	set USERPASS%1=%2
	goto :EOF

:getUserPass
	call :getUserPassHelper %%UserPass%1%%
	goto :EOF

:getUserPassHelper
	set UserPass=%1
	goto :EOF










	

