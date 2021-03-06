@SETLOCAL EnableExtensions EnableDelayedExpansion
@echo off
pushd "%~dp0"
title ALAS run
:: -----------------------------------------------------------------------------
SET RENAME="python-3.7.6.amd64"
if exist %RENAME% (
  rename %RENAME% toolkit
)
SET ADB=%~dp0toolkit\Lib\site-packages\adbutils\binaries\adb.exe
SET PYTHON=%~dp0toolkit\python.exe
SET CMD=%SystemRoot%\system32\cmd.exe
SET LMESZINC=https://github.com/LmeSzinc/AzurLaneAutoScript.git
SET WHOAMIKYO=https://github.com/whoamikyo/AzurLaneAutoScript.git
SET ENV=https://github.com/whoamikyo/alas-env.git
SET GITEE_URL=https://gitee.com/lmeszinc/AzurLaneAutoScript.git
:: -----------------------------------------------------------------------------
goto check_Permissions
:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        echo Press any to continue...
        pause >nul
        goto continue
    ) else (
        echo Failure: Current permissions inadequate.
    )
    pause >nul
:: -----------------------------------------------------------------------------
:continue
call %ADB% kill-server > nul 2>&1

set SCREENSHOT_FOLDER=%~dp0screenshots
if not exist %SCREENSHOT_FOLDER% (
  mkdir %SCREENSHOT_FOLDER%
)

if not exist adb_port.ini (
  cd . > adb_port.ini
)
:: -----------------------------------------------------------------------------
REM if adb_port is empty, prompt HOST:PORT
set "adb_empty=*adb_port.ini"
for %%A in (%adb_empty%) do if %%~zA==0 (
    echo enter your HOST:PORT eg: 127.0.0.1:5555 for default bluestacks
	echo WARNING! DONT FORGET TO SETUP AGAIN IN, ALAS ON EMULATOR SETTINGS FUNCTION
    set /p adb_input=
)
:: -----------------------------------------------------------------------------
REM if adb_input = 0 load from adb_port.ini
if [%adb_input%]==[] (
    goto load
)

REM write adb_input on adb_port.ini
echo %adb_input% >> adb_port.ini

REM Load adb_port.ini
:load
REM 
set /p ADB_PORT=<adb_port.ini

echo connecting at %ADB_PORT%
call %ADB% connect %ADB_PORT%

echo initializing uiautomator2
call %PYTHON% -m uiautomator2 init
:: timout
goto alas
:: -----------------------------------------------------------------------------
:alas
	cls
	echo.
	echo  :: Alas run
	echo. 
	echo  Choose your option
    echo.
    echo	1. EN
	echo	2. CN
	echo	3. JP
	echo	4. UPDATER
	echo. 
	echo  :: Type a 'number' and press ENTER
	echo  :: Type 'exit' to quit
	echo.
	
	set /P menu=
		if %menu%==1 GOTO en
		if %menu%==2 GOTO cn
		if %menu%==3 GOTO jp
		if %menu%==4 GOTO updater_menu
		if %menu%==exit GOTO EOF
		
		else (
		cls
	echo.
	echo  :: Incorrect Input Entered
	echo.
	echo     Please type a 'number' or 'exit'
	echo     Press any key to retry to the menu...
	echo.
		pause > NUL
		goto alas
		)
:: -----------------------------------------------------------------------------
:en
	call %PYTHON% --version >nul
	if %errorlevel% == 0 (
	echo Python Found! Proceeding..
	echo Opening alas_en.pyw...
	call %PYTHON% alas_en.pyw
	goto alas
	) else (
		echo :: it was not possible to open alas_en.pyw, make sure you have a folder toolkit
		echo :: inside AzurLaneAutoScript folder.
		echo.
        pause > NUL
        goto alas
	)
:: -----------------------------------------------------------------------------
:cn
	call %PYTHON% --version >nul
	if %errorlevel% == 0 (
	echo Python Found! Proceeding..
	echo Opening alas_en.pyw...
	call %PYTHON% alas_cn.pyw
	goto alas
	) else (
		echo :: it was not possible to open alas_cn.pyw, make sure you have a folder toolkit
		echo :: inside AzurLaneAutoScript folder.
		echo.
        pause > NUL
        goto alas
	)
:: -----------------------------------------------------------------------------
:jp
	call %PYTHON% --version >nul
	if %errorlevel% == 0 (
	echo Python Found! Proceeding..
	echo Opening alas_en.pyw...
	call %PYTHON% alas_jp.pyw
	goto alas
	) else (
		echo :: it was not possible to open alas_jp.pyw, make sure you have a folder toolkit
		echo :: inside AzurLaneAutoScript folder.
		echo.
        pause > NUL
        goto alas
	)
:: -----------------------------------------------------------------------------
rem :updater
rem SET GIT_ALAS=%~dp0toolkit\Git\cmd\git.exe
rem SET GLP=%GIT_ALAS%
rem SET ALAS_PY=alas.py
rem 	if exist %ALAS_PY% (
rem 			goto updater_menu
rem 		) else (
rem 		cd AzurLaneAutoScript
rem 		echo.
rem 		goto updater_menu
rem 	)
rem :: -----------------------------------------------------------------------------
:updater_menu
SET GIT_ALAS=%~dp0toolkit\Git\cmd\git.exe
SET GLP=%GIT_ALAS%
	cls
	echo.
	echo	:: This update only will work if you downloaded ALAS on
	echo	:: Release tab and installed with Easy_Install-v2.bat
	echo.
	echo	::DISCLAIMER::
	echo.
	echo	JUST RUN UPDATER INSIDE AzurLaneAutoScript FOLDER
	echo.
	echo	1. https://github.com/LmeSzinc/AzurLaneAutoScript (Main Repo, When in doubt, use it)
	echo	2. https://github.com/whoamikyo/AzurLaneAutoScript (Mirrored Fork)
	echo	3. https://github.com/whoamikyo/AzurLaneAutoScript (nightly build, dont use)
	echo	4. https://gitee.com/lmeszinc/AzurLaneAutoScript.git (Recommended for CN users)
	echo	5. Back to main menu
	echo.
	echo	:: Type a 'number' and press ENTER
	echo	:: Type 'exit' to quit
	echo.

	set /P choice=
		if %choice%==1 GOTO LmeSzinc
		if %choice%==2 GOTO whoamikyo
		if %choice%==3 GOTO nightly
		if %choice%==4 GOTO gitee
		if %choice%==5 GOTO alas
		if %choice%==exit GOTO EOF
		
		else (
		cls
	echo.
	echo  :: Incorrect Input Entered
	echo.
	echo     Please type a 'number' or 'exit'
	echo     Press any key to return to the menu...
	echo.
		pause > NUL
		goto updater_menu
		)
:: -----------------------------------------------------------------------------
:LmeSzinc
	call %GLP% --version >nul
	if %errorlevel% == 0 (
	echo GIT Found! Proceeding..
	echo Updating from LmeSzinc repository..
	call %GLP% fetch origin master
	call %GLP% reset --hard origin/master
	call %GLP% pull --ff-only origin master
	echo DONE!
	echo Press any key to proceed
	pause > NUL
	goto updater_menu
	) else (
		echo  :: Git not detected, maybe there was an installation issue
		echo check if you have this directory:
		echo AzurLaneAutoScript\toolkit\Git\cmd
		echo.
        pause > NUL
        goto updater_menu
	)
:: -----------------------------------------------------------------------------
:whoamikyo
	call %GLP% --version >nul
	if %errorlevel% == 0 (
	echo GIT Found! Proceeding..
	echo Updating from whoamikyo repository..
	call %GLP% fetch whoamikyo master
	call %GLP% reset --hard whoamikyo/master
	call %GLP% pull --ff-only whoamikyo master
	echo DONE!
	echo Press any key to proceed
	pause > NUL
	goto updater_menu
	) else (
		echo  :: Git not detected, maybe there was an installation issue
		echo check if you have this directory:
		echo AzurLaneAutoScript\toolkit\Git\cmd
        pause > NUL
        goto updater_menu
	)
:: -----------------------------------------------------------------------------
:nightly
	call %GLP% --version >nul
	if %errorlevel% == 0 (
	echo GIT Found! Proceeding..
	echo Updating from whoamikyo nightly repository..
	call %GLP% fetch whoamikyo nightly
	call %GLP% reset --hard whoamikyo/nightly
	call %GLP% pull --ff-only whoamikyo nightly
	echo Press any key to proceed
	pause > NUL
	goto updater_menu
	) else (
		echo  :: Git not detected, maybe there was an installation issue
		echo check if you have this directory:
		echo AzurLaneAutoScript\toolkit\Git\cmd
		echo.
        pause > NUL
        goto updater_menu
	)
:: -----------------------------------------------------------------------------
rem :check_connection
rem cls
rem 	echo.
rem 	echo  :: Checking For Internet Connection to Github...
rem 	echo.
rem 	timeout /t 2 /nobreak > NUL

rem 	ping -n 1 google.com -w 20000 >nul

rem 	if %errorlevel% == 0 (
rem 	echo You have a good connection with Github! Proceeding...
rem 	echo press any to proceed
rem 	pause > NUL
rem 	goto updater_menu
rem 	) else (
rem 		echo  :: You don't have a good connection out of China
rem 		echo  :: It might be better to update using Gitee
rem 		echo  :: Redirecting...
rem 		echo.
rem         echo     Press any key to continue...
rem         pause > NUL
rem         goto start_gitee
rem 	)
:: -----------------------------------------------------------------------------
:gitee
	call %GLP% --version >nul
	if %errorlevel% == 0 (
	echo GIT Found! Proceeding..
	echo Updating from LmeSzinc repository..
	call %GLP% fetch lmeszincgitee master
	call %GLP% reset --hard lmeszincgitee/master
	call %GLP% pull --ff-only lmeszincgitee master
	echo DONE!
	echo Press any key to proceed
	pause > NUL
	goto updater_menu
	) else (
		echo  :: Git not detected, maybe there was an installation issue
		echo check if you have this directory:
		echo AzurLaneAutoScript\toolkit\Git\cmd
        pause > NUL
        goto updater_menu
	)
:: -----------------------------------------------------------------------------
:toolkit
	call %GLP% --version >nul
	if %errorlevel% == 0 (
	echo GIT Found! Proceeding..
	echo Updating toolkit..
	call cd toolkit
	echo ## initializing toolkit..
	call %GIT% init
	call %GIT% config --global core.autocrlf false
	echo ## Adding files
	call %GIT% add -A
	echo ## adding origin..
	call %GIT% remote add origin %ENV%
	echo Fething...
	call %GIT% fetch origin master
	call %GIT% reset --hard origin/master
	echo Pulling...
	call %GIT% pull --ff-only origin master
	call cd ..
	echo DONE!
	echo Press any key to proceed
	pause > NUL
	goto updater_menu
	) else (
		echo  :: Git not detected, maybe there was an installation issue
		echo check if you have this directory:
		echo AzurLaneAutoScript\toolkit\Git\cmd
        pause > NUL
        goto updater_menu
	)
:: -----------------------------------------------------------------------------
:EOF
exit


