@echo off
REM Final step when building component, called by build method.
REM Do not execute this script manually, it is called by the component.

REM Argument list:
REM 1 - 4D application process ID  
REM 2 - Component name

REM Check for Argument; if not passed script was probably called manually.
IF "%1" EQU "" (GOTO BLD_USAGE) ELSE (GOTO BLD_START)

:BLD_USAGE
echo Do not execute this script manually, it is called by the component.
GOTO BLD_ERROR


:BLD_START
set NumPIDApp=%1
set /A numTries=1

REM Wait for 4D to quit.
:BLD_DelayForQuit4D
	cls
	
	REM Let the user know what's happening, and how many times.
	echo Waiting for 4D to quit...%numTries%
	
	REM Delay for 1 second
	PING 127.0.0.1 -n 2 >NUL
	
	REM Check to see if 4D is running.
	tasklist /FI "PID eq %NumPIDApp%" | findstr "%NumPIDApp%" >NUL
	
	REM Above code returns 1 if found.
	set /A is4DRunning=%ERRORLEVEL%
	
	set /A numTries=%numTries% +1
	
	REM If 4D is still running, loop again.
IF %is4DRunning% NEQ 1 (GOTO BLD_DelayForQuit4D)

echo 4D has quit!

GOTO BLD_CopyFiles


:BLD_CopyFiles
set componentName=%2
set componentFolder=%3
set component_dir=.\%componentFolder%\%componentName%.4dbase
set source_dir=.\matrix\%componentName%.4dbase

REM Files we need:
REM   -4DB
REM   -4DINDY

echo Copying structure file...
copy "%source_dir%\%componentName%.4DB" "%component_dir%\%componentName%.4DB"

echo Copying structure index file...
copy "%source_dir%\%componentName%.4DIndy" "%component_dir%\%componentName%.4DIndy"

echo Build complete!
pause
exit

:BLD_ERROR
