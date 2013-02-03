@echo off

set PROG=%~1
set OPTS=%*
set OPTS=%OPTS:* =%
set SYSP=%WINDIR%\system32\config\systemprofile\
set LOG=C:\users\%USERNAME%\Environment_Log.exe.log


call :getCMD_CD startPath
cd %USERPROFILE%
call :getCMD_CD curPath

call :sleep 10

call :main %* > %LOG%
goto :EOF

:main
	echo.
	echo _______________________________________________________________________________
	echo ..................%DATE%...................%TIME%.................
	echo.
	echo Start Path ::: %startPath%
	echo Workn Path ::: %curPath%
	echo.
	echo _______________________________________________________________________________
	set
	echo _______________________________________________________________________________
	echo.
	call :listENV %*
	echo.
	echo _______________________________________________________________________________
	echo.
	@echo on
	::cd %SYSP%
	::@dir
	::@cd .VirtualBox
	::del /F /Q VirtualBox.xml
	::@dir
	::copy /Y /V %VBOX_USER_HOME%\VirtualBox.xml
	::@dir
	::"%WINDIR%\system32\taskkill.exe" /F /FI "USERNAME eq %USERNAME%" /IM VBoxSVC.exe
	::start /B /D "%USERPROFILE%" "%VBOX_INSTALL_PATH%\vboxSVC.exe"
	"%VBOX_INSTALL_PATH%\vboxmanage.exe" list vms
	@echo "%VBOX_INSTALL_PATH%\%PROG%" %OPTS%
	@echo off
	echo.
	echo _______________________________________________________________________________
	echo Done
	call :sleep 10
	goto :EOF


:listENV
	echo .CMD.LINE.INPUT = %*
	echo ...............................................................................
	echo ALLUSERSPROFILE = %ALLUSERSPROFILE%
	echo ........APPDATA = %APPDATA%
	echo .............CD = %CD%
	echo .....CMDCMDLINE = %CMDCMDLINE%
	echo ..CMDEXTVERSION = %CMDEXTVERSION%
	echo ...COMPUTERNAME = %COMPUTERNAME% 
	echo ........COMSPEC = %COMSPEC% 
	echo ...........DATE = %DATE% 
	echo .....ERRORLEVEL = %ERRORLEVEL% 
	echo ......HOMEDRIVE = %HOMEDRIVE% 
	echo .......HOMEPATH = %HOMEPATH% 
	echo ......HOMESHARE = %HOMESHARE% 
	echo .....LOGONSEVER = %LOGONSEVER% 
	echo .............OS = %OS% 
	echo ........PATHEXT = %PATHEXT%
	echo ..NUMBER_OF_PROCESSORS = %NUMBER_OF_PROCESSORS% 
	echo PROCESSOR_ARCHITECTURE = %PROCESSOR_ARCHITECTURE% 
	echo ..PROCESSOR_IDENTIFIER = %PROCESSOR_IDENTIFIER%
	echo .......PROCESSOR_LEVEL = %PROCESSOR_LEVEL% 
	echo ....PROCESSOR_REVISION = %PROCESSOR_REVISION%
	echo .........PROMPT = %PROMPT%
	echo .........RANDOM = %RANDOM%
	echo ....SYSTEMDRIVE = %SYSTEMDRIVE%
	echo .....SYSTEMROOT = %SYSTEMROOT% 
	echo ...........TEMP = %TEMP%
	echo ............TMP = %TMP%
	echo ...........TIME = %TIME%
	echo .....USERDOMAIN = %USERDOMAIN%
	echo .......USERNAME = %USERNAME%
	echo ....USERPROFILE = %USERPROFILE%
	echo .........WINDIR = %WINDIR%
	::echo ...........PATH = %PATH%
	echo ...............................................................................
	echo ...........PATH = .............................................................
	call :listPATH
	goto :EOF

:listPATH
	set PATHS=%PATH%
	set PATHS=%PATHS: =._.%
	set PATHS=%PATHS:)=.(.%
	set PATHS=%PATHS:;= %
	for %%a in (%PATHS%) do call :echoPATH %%a
	goto :EOF

:echoPATH
	set line=%*
	set line=%line:._.= %
	set line=%line:.(.=)%
	echo %line%
	goto :EOF

:getCMD_CD
	for /f "tokens=*" %%a in ('cd') do set %1=%%a
	goto:EOF

:sleep
        for /l %%a in (0,1,%1) do echo %%a && ping -n 1 -w 1000 10.10.10.10 | find "nothing"
        goto :EOF



:EOF


