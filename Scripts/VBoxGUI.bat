@echo off

set        DEVX_EXEC=C:\Program Files\Oracle\devxexec.exe
set     VBOX_SCRIPTS=C:\Program Files\Oracle\Scripts
set   AUTO_DEVX_EXEC=C:\Program Files\Oracle\Scripts\autodevxexec.exe
set         VBOX_GUI=C:\Program Files\Oracle\VirtualBox\VirtualBox.exe
set SERVICE_DEVX_LOG=C:\Users\%1\Service_devxexec.log
set SERVICE_DEVX_OPT=/cpwl /mute /sessionid:1 /user:%1 /domain:%COMPUTERNAME% /logpath:%SERVICE_DEVX_LOG%

"%AUTO_DEVX_EXEC%" %SERVICE_DEVX_OPT% "[Q]%VBOX_GUI%[Q]"