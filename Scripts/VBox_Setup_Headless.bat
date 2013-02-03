@echo off
set             PROG=%~f0
set         PROG_DIR=%~dp0
set              LOG=%PROG_DIR%\VBox_Setup_Services.log
set          SRV_INI=%PROG_DIR%\..\services.ini
set        SRV_START=%PROG_DIR%\..\srvstart.exe
set        DEVX_EXEC=%PROG_DIR%\..\devxexec.exe
set AutoDevxExec_bat=%PROG_DIR%\autodevxexec.bat
set AutoDevxExec_exe=%PROG_DIR%\autodevxexec.exe
set AutoDevxExec_tmp=%PROG_DIR%\autodevxexec.tpl
set  Bat_To_Exe_Conv=%PROG_DIR%\Bat_To_Exe_Converter.exe
set      VBOX_LS_VMS=%PROG_DIR%\vbox_list_vms.bat
set      VBOX_MANAGE=%PROG_DIR%\..\VirtualBox\vboxmanage.exe
set               SC=%WINDIR%\system32\sc.exe

::######################################################################################
::######################################################################################
::######################################################################################
::######################################################################################
call :main_Setup_Services > "%LOG%"
call :selectMachines    VBoxHeadless    vbox

goto :EOF
::######################################################################################

:main_Setup_Services
	echo _______________________________________________________________________________
	echo ..................%DATE%...................%TIME%.................
	echo.

        ::call :addVBoxHeadless   VBoxHeadless    msalisbury     RHEL01 "RedHat Enterprise 6 Server [RHEL01]"
        


goto :EOF
::######################################################################################
::Functions

:selectMachines
        call :sleep 3
        set NAME=%~1
        set USER=%~2
        call :retrieveDomain
        set AutoDevxExec_log=%HOMEDRIVE%\Users\%USER%\Service_devxexec.log
        set  VBOX_LS_VMS_LOG=%HOMEDRIVE%\Users\%USER%\vboxVMList.txt
        set   VBOX_USER_HOME=%HOMEDRIVE%\Users\%USER%\.VirtualBox
        set AutoDevxExec_opt=/mute /sessionid:1 /logpath:%AutoDevxExec_log% /user:%USER% /domain:%COMPUTERNAME%

        echo "Username::%USER% Domain::%Domain%"
        echo %AutoDevxExec_bat%
        echo %AutoDevxExec_opt%
        echo %VBOX_LS_VMS_LOG%
        ::echo "%AutoDevxExec_exe%" %AutoDevxExec_opt% "[Q]%VBOX_MANAGE%[Q] list vms > %VBOX_LS_VMS_LOG%"
             "%AutoDevxExec_exe%" %AutoDevxExec_opt% "[Q]%VBOX_MANAGE%[Q] list vms >> %VBOX_LS_VMS_LOG%"
             "%AutoDevxExec_exe%" %AutoDevxExec_opt% "[Q]%VBOX_LS_VMS%[Q]         [Q]%VBOX_LS_VMS_LOG%[Q]"
        
        echo start
        type %VBOX_LS_VMS_LOG%
        echo stop

        call :sleep 100
        goto :EOF

:sleep
        for /l %%a in (0,1,%1) do echo %%a && ping -n 1 -w 1000 10.10.10.10 | find "nothing"
        goto :EOF

:addVBoxHeadless
	set NAME=%~1
	set USER=%~2
	set SHRT=%~3
	set LONG=%~4
	call :retrieveDomain
	call :retrievePass

	set SRV_NAME=%NAME%%USER%%SHRT%
	set SRV_DISP=%NAME% USER[%USER%] SYSTEM[%LONG%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_VBOX_CLIENT="%LONG%" -c "%SRV_INI%"
	
	call :addService
	goto :EOF
	
:addVBoxWebSrv
	set NAME=%~1
	set USER=%~2
	set PORT=%~3
	call :retrieveDomain
	call :retrievePass
	
	set SRV_NAME=%NAME%%PORT%%USER%
	set SRV_DISP=%NAME% PORT[%PORT%] USER[%USER%@%DOMAIN%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_PORT=%PORT% -c "%SRV_INI%"
	
	call :addService
	goto :EOF

:addEnvironmentLog
	set NAME=%~1
	set USER=%~2
	set OPTS=%~3
	call :retrieveDomain
	call :retrievePass

	set SRV_NAME=%NAME%%USER%
	set SRV_DISP=%NAME% LOG USER[%USER%@%DOMAIN%]
	set SRV_BIN=%SRV_START% svc %NAME% -e SERVICE_NAME=%SRV_NAME% -e SERVICE_OPT="%OPTS%" -c "%SRV_INI%"

	call :addService
	goto :EOF

:setupAutoDevxExec
	echo @echo off                                                   > "%AutoDevxExec_bat%"
	type "%PROG%" | find /i"call :encodePass" | find /v "type*find" >> "%AutoDevxExec_bat%"
	type "%AutoDevxExec_tmp%"                                       >> "%AutoDevxExec_bat%"
	goto :EOF

:retrieveDomain
	Set Domain=
	if not defined Domain call :retrieveDomain_@ %User:@= %
	if not defined Domain call :retrieveDomain_\ %User:\= %
	if not defined User   (set User=%Domain%) && set Domain=.
	goto :EOF

:retrieveDomain_@
	set Domain=%2
	set   User=%1
	goto :EOF

:retrieveDomain_\
	set Domain=%1
	set   User=%2
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
	%SC% config %SRV_NAME%         obj= %DOMAIN%\%USER% 
	%SC% config %SRV_NAME%    password= %ENCODEDPASS%
	echo.
	goto :EOF

::######################################################################################
::######################################################################################
::######################################################################################
::######################################################################################

:encodePass
	set EncodedPass_%1=%2
	goto :EOF

:retrievePass
	set EncodedPass=
	if not defined User                        goto :EOF
	if     defined EncodedPass_%User%@%Domain% call :retrievePassHelper %%EncodedPass_%User%@%Domain%%%
	if     defined EncodedPass_%Domain%\%User% call :retrievePassHelper %%EncodedPass_%Domain%\%User%%%
	if     defined EncodedPass                 goto :EOF
	if     defined EncodedPass_%User%          call :retrievePassHelper %%EncodedPass_%User%%%
	                                           goto :EOF
:retrievePassHelper
	set EncodedPass=%1
	goto :EOF