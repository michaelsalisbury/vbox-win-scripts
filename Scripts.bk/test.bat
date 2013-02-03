@echo off

set AUTO_DEVX_EXEC=C:\Program Files\Oracle\Scripts\autodevxexec2.bat
set AUTO_DEVX_EXEC=C:\Program Files\Oracle\Scripts\autodevxexec2.exe

"%AUTO_DEVX_EXEC%" one two three "four five six" seven "eight nine" ten "[Q]this sucks[Q] in a big way [Q]for sure[Q] crap"
::  "%AUTO_DEVX_EXEC%" one two three "four five six" seven "eight nine" ten """"this sucks""" in a big way """for sure""" crap"


goto :EOF

set      DEVX_EXEC=C:\Program Files\Oracle\devxexec.exe
set   VBOX_SCRIPTS=C:\Program Files\Oracle\Scripts
set AUTO_DEVX_EXEC=C:\Program Files\Oracle\Scripts\autodevxexec.bat

set PASSWORD=Xitsanmyg76

set SERVICE_DEVX_LOG=%USERPROFILE%\Service_devxexec.log
set SERVICE_DEVX_OPT=/mute /sessionid:1 /user:%USERNAME% /domain:%COMPUTERNAME% /password:%PASSWORD% /logpath:%SERVICE_DEVX_LOG%
set SERVICE_DEVX_OPT=/mute /sessionid:1 /user:%USERNAME% /domain:%COMPUTERNAME% /logpath:%SERVICE_DEVX_LOG%


"%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% """"%VBOX_SCRIPTS%\Environment_Log.exe""" -o test"
:: Works :: "%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% """"%VBOX_SCRIPTS%\Environment_Log.exe""" -o test"
::"%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% "%VBOX_SCRIPTS%\Environment_Log.bat"
