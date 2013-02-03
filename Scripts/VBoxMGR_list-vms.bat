@echo off
call :main > "%~1"
goto :EOF
:main
        set /a lineCount=0
        for /F "usebackq tokens=*" %%a in (`"%ProgramW6432%\Oracle\VirtualBox\VBoxManage.exe" list vms`) do call :parse %%a
        goto :EOF
:parse
        set /a lineCount+=1
        echo %lineCount% %*
        goto :EOF