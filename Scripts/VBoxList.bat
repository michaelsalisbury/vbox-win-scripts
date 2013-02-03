@echo off

set          DEVX_EXEC=%ProgramW6432%\Oracle\devxexec.exe
set       VBOX_SCRIPTS=%ProgramW6432%\Oracle\Scripts
set     AUTO_DEVX_EXEC=%ProgramW6432%\Oracle\Scripts\autodevxexec.exe
set           VBOX_GUI=%ProgramW6432%\Oracle\VirtualBox\VirtualBox.exe
set           VBOX_MGR=%ProgramW6432%\Oracle\VirtualBox\vboxmanage.exe
set       VBOX_MGR_LST=%ProgramW6432%\Oracle\Scripts\VboxMGR_list-vms.bat
set       VBOX_MGR_RUN=%ProgramW6432%\Oracle\Scripts\VboxMGR_list-runningvms.bat
set           VBOX_LST=%HOMEDRIVE%\Users\%1\vboxVMList.txt
set           VBOX_RUN=%HOMEDRIVE%\Users\%1\vboxVMRUNL.txt
set   SERVICE_DEVX_LOG=%HOMEDRIVE%\Users\%1\Service_devxexec.log
set               HOME=%HOMEDRIVE%\Users\%1
set     VBOX_USER_HOME=%HOMEDRIVE%\Users\%1\.VirtualBox
::set SERVICE_DEVX_OPT=/mute /sessionid:1 /user:%1 /domain:%COMPUTERNAME% /logpath:%SERVICE_DEVX_LOG% /cpwl
  set SERVICE_DEVX_OPT=/mute /sessionid:1 /user:%1 /domain:%COMPUTERNAME% /logpath:%SERVICE_DEVX_LOG%

"%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% "[Q]%VBOX_MGR_LST%[Q] [Q]%VBOX_LST%[Q]"
"%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% "[Q]%VBOX_MGR_RUN%[Q] [Q]%VBOX_RUN%[Q]"

echo LIST
echo.
type "%VBOX_LST%"
echo.
echo RUNNING
echo.
type "%VBOX_RUN%"
echo.


call :parseServices

goto :EOF
:parse
set input=
set inputOK=
cls
echo Toggle the Headless VM Startup/Shutdown service entry ON or OFF.
echo Disables entries will have their system service entries removed.
echo.
call :parseVMS
echo.
echo Press (e) to discard changes and exit.
echo Press (w) to write changes and exit.
echo Press (r) to reset toggles to their current settings.
set /p input="Toggle VM by number or set all to (a)auto, (m)manual or (d)disabled. > "
if not defined input   goto :parse
if %input% GTR 0       if %input% LEQ %prcnt% set inputOK=00
if %input% EQU a                              set inputOK=aa
if %input% EQU m                              set inputOK=mm
if %input% EQU d                              set inputOK=dd
if %input% EQU e                              set inputOK=ee
if %input% EQU w                              set inputOK=ww
if %input% EQU r                              set inputOK=rr
if not defined inputOK goto :parse
if %input% EQU a       for /L %%a in (1,1,%parseVN#%) DO (set toggle%%a=Auto)
if %input% EQU d       for /L %%a in (1,1,%parseVM#%) DO (set toggle%%a=Disabled)
if %input% EQU m       for /L %%a in (1,1,%parseVM#%) DO (set toggle%%a=Manuel)
if %input% GTR 0       if %input% LEQ     %parseVM#%  call :toggle
if %input% EQU e       goto :EOF
if %input% EQU r       goto :EOF
if %input% EQU w       goto :EOF
goto :parse

        
goto :EOF


:toggleOLD
        call :getV toggleVal toggle%input%
        if %toggleVal% EQU ON  (set toggle%input%=OFF) && goto :EOF
        if %toggleVal% EQU OFF (set toggle%input%=ON)  && goto :EOF
        goto :EOF
:toggle
        call :getV toggleVal toggle%input%
        if %toggleVal% EQU Disabled (set toggle%input%=Manual)   && goto :EOF
        if %toggleVal% EQU Manual   (set toggle%input%=Auto)     && goto :EOF
        if %toggleVal% EQU Auto     (set toggle%input%=Disabled) && goto :EOF
        goto :EOF
        
:searchVMS
        ::set /a prcnt=0
        type "%VBOX_LST%"
        ::for /F "usebackq tokens=*" %%a in ("%VBOX_LST%") do call :searchVMSBlock "%*" %%a
        goto :EOF
:searchVMSBlock
        set /a prcnt+=1
        echo %*

        goto :EOF

:getVMID

        goto :EOF
:getVM#
        
        goto :EOF

:parseVMS
        for /F "usebackq tokens=*" %%a in ("%VBOX_LST%") do call :parseVMSBlock %%a
        goto :EOF

:parseVMSBlock
        set /a parseVM#=%~1
        call :getV toggleVal toggle%parseVM#%
        set toggleVal=     %toggleVal%
        set    dspcnt=     %parseVM#%
        echo %~3 %toggleVal:~-9% %dspcnt:~-3%. %~2
        goto :EOF

:parseServices
        set parseService0x2=auto
        set parseService0x3=manual
        set parseService0x4=disabled
        for /F "usebackq tokens=*" %%a in (`sc query state^= all ^| find "SERVICE_NAME"`) do call :parseService %%a
        goto :EOF
:parseService
        set parseService_Name=%~2
        if %parseService_Name% EQU %parseService_Name:VBoxHeadless=% goto :EOF
        set parseService_REGQ=HKLM\system\currentcontrolset\services\%parseService_Name%
        
        for /F "usebackq tokens=2,*" %%a in (`sc GetDisplayName %parseService_Name% ^| find "="`)             do set parseService_Full=%%b
        for /F "usebackq tokens=4"   %%a in (`reg QUERY %parseService_REGQ% /c /z /e /f Start ^| find "REG"`) do set parseService_Start=%%a
        for /F "usebackq tokens=2"   %%a in (`echo %parseService_Full%`)                                      do set parseService_USER=%%a
        for /F "usebackq tokens=2,*" %%a in (`echo %parseService_Full%`)                                      do set parseService_SYS=%%b
        set parseService_USER=%parseService_USER:USER[=%
        set parseService_USER=%parseService_USER:~0,-1%
        set parseService_SYS=%parseService_SYS:SYSTEM[=%
        set parseService_SYS=%parseService_SYS:~0,-1%
        for /F "usebackq tokens=1"   %%a in (`type "%VBOX_LST%" ^| find "%parseService_SYS%"`)                do set parseService_VM#=%%a 
        
        call :getV parseService_StartDisc parseService%parseService_Start%        
        echo %parseService_Name% ::: %parseService_Full% ::: %parseService_Start% ::: %parseService_StartDisc% ::: %parseService_USER% ::: %parseService_SYS% ::: %parseService_VM#%
        
        goto :EOF








:getV
        call :getVHelper %~1 %%%~2%%
        goto :EOF
:getVHelper
        ::echo getVHelper ~1 = !!%~1!!
        ::echo getVHelper ~2 = !!%~2!!
        set %~1=%~2
        goto :EOF














:sleep
        for /l %%a in (0,1,%1) do echo %%a && ping -n 1 -w 1000 10.10.10.10 | find "nothing"
        goto :EOF