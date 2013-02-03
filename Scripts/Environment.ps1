function write_environment() {
    ""
    Date
	"..............................................................................."
	"ALLUSERSPROFILE = " + $env:ALLUSERSPROFILE
	"........APPDATA = " + $env:APPDATA
	".............CD = " + $env:CD
	".....CMDCMDLINE = " + $env:CMDCMDLINE
	"..CMDEXTVERSION = " + $env:CMDEXTVERSION
	"...COMPUTERNAME = " + $env:COMPUTERNAME
	"........COMSPEC = " + $env:COMSPEC
	"...........DATE = " + $env:DATE
	".....ERRORLEVEL = " + $env:ERRORLEVEL
	"......HOMEDRIVE = " + $env:HOMEDRIVE
	".......HOMEPATH = " + $env:HOMEPATH
	"......HOMESHARE = " + $env:HOMESHARE
	".....LOGONSEVER = " + $env:LOGONSEVER
	".............OS = " + $env:OS
	"........PATHEXT = " + $env:PATHEXT
	"..NUMBER_OF_PROCESSORS = " + $env:NUMBER_OF_PROCESSORS
	"PROCESSOR_ARCHITECTURE = " + $env:PROCESSOR_ARCHITECTURE
	"..PROCESSOR_IDENTIFIER = " + $env:PROCESSOR_IDENTIFIE
	".......PROCESSOR_LEVEL = " + $env:PROCESSOR_LEVEL
	"....PROCESSOR_REVISION = " + $env:PROCESSOR_REVISION
	".........PROMPT = " + $env:PROMPT
	".........RANDOM = " + $env:RANDOM
	"....SYSTEMDRIVE = " + $env:SYSTEMDRIVE
	".....SYSTEMROOT = " + $env:SYSTEMROOT
	"...........TEMP = " + $env:TEMP
	"............TMP = " + $env:TMP
	"...........TIME = " + $env:TIME
	".....USERDOMAIN = " + $env:USERDOMAIN
	".......USERNAME = " + $env:USERNAME
	"....USERPROFILE = " + $env:USERPROFILE
	".........WINDIR = " + $env:WINDIR
	"..............................................................................."
	"...........PATH =.............................................................."
    ($env:PATH.split(";") | sort | ? {$_ -ne ""}) -replace "^", "                  "
}
write_environment >> ($env:USERPROFILE + "\Environment_Test_Script.log")
#write_environment
