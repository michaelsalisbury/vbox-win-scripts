::######################################################################################
::######################################################################################
::######################################################################################
::######################################################################################
:: This script expects that environment variable DEVX_EXEC is the path to devxexec.exe
::######################################################################################
set OPT=%*
if     defined OPT call :main_autodevxexec %*
if not defined OPT (
        echo Sorry no directives provided.  Exiting!
        call :sleep 5
)
goto :EOF


:main_autodevxexec
if not defined DEVX_EXEC (
	echo Sorry the environmental variable %%DEVX_EXEC%% has not been set.  Exiting!
	call :sleep 5
	goto :EOF
) ELSE (
if not exist "%DEVX_EXEC%" (
	echo Sorry the environmental variable %%DEVX_EXEC%% doesn't reference an existing file.  Exiting!
	call :sleep 5
	goto :EOF
))

call :parseSwitches %*
call :retrievePass

if     defined User        echo User     ::: %User%
if     defined Domain      echo Domain   ::: %Domain%
if     defined Password    echo Password ::: %Password%
if     defined EncodedPass echo Encoded  ::: %EncodedPass%

if     defined Password    ^
if     defined DEVX_EXEC   "%DEVX_EXEC%" %Switches%

if not defined Password    ^
if     defined EncodedPass ^
if     defined DEVX_EXEC   "%DEVX_EXEC%" /password:%EncodedPass% %Switches%

goto :EOF

::######################################################################################
::######################################################################################
::######################################################################################
::######################################################################################
::Functions

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

:parseSwitches
        set Switches=%*
        set Switches=%Switches:[Q]="""%
	set User=
	Set Domain=
	Set Password=
:parseSwitchesLoop
	set parseSwitches=%~1
	shift
	if not defined parseSwitches			 goto :EOF
	set parseSwitchesTest=%parseSwitches:"='%
	if /i "%parseSwitchesTest:~0,1%" NEQ "/"         goto :parseSwitchesLoop
	if /i "%parseSwitchesTest:~0,5%" EQU "/user"     set     User=%parseSwitches:~6%
	if /i "%parseSwitchesTest:~0,7%" EQU "/domain"   set   Domain=%parseSwitches:~8%
	if /i "%parseSwitchesTest:~0,9%" EQU "/password" set Password=%parseSwitches:~10%
	goto :parseSwitchesLoop

:sleep
        for /l %%a in (0,1,%1) do echo %%a && ping -n 1 -w 1000 10.10.10.10 | find "nothing"
        goto :EOF

::######################################################################################
::######################################################################################
::######################################################################################
::######################################################################################




