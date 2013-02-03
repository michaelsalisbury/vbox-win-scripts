@echo off
call :main > "%~1"
goto :EOF
:main
        for /F "usebackq tokens=*" %%a in (`"%ProgramW6432%\Oracle\VirtualBox\VBoxManage.exe" list runningvms`) do call :parse %%a
        ::call :parse "Beta-4" {352998e0-35db-40b1-a99c-cf6e32e02853}
        goto :EOF
:parse
        set runningVMsearch=%~2
        call :vms
        goto :EOF
:vms
        set /a lineCount=0
        for /F "usebackq tokens=*" %%a in (`"%ProgramW6432%\Oracle\VirtualBox\VBoxManage.exe" list vms`) do call :vmsBlock %%a
        goto :EOF
:vmsBlock
        set /a lineCount+=1
        echo %lineCount% %* | find "%runningVMsearch%"
        goto :EOF