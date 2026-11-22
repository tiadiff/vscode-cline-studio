@echo off
setlocal enabledelayedexpansion
title Cline Agent Studio

set "SCRIPT_DIR=%~dp0"
set "DATA_DIR=%SCRIPT_DIR%data"
set "USER_DIR=%DATA_DIR%\User"
set "EXT_DIR=%SCRIPT_DIR%extensions"
set "CONFIG_DIR=%SCRIPT_DIR%config"
set "VSIX_FILE=%SCRIPT_DIR%cline-fullscreen.vsix"
set "SRC_DIR=%SCRIPT_DIR%..\cline-fork\apps\vscode"

:: Locate VS Code executable
set "CODE_EXE="
set "CODE_CLI="
if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" (
    set "CODE_EXE=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
    set "CODE_CLI=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd"
) else if exist "C:\Program Files\Microsoft VS Code\Code.exe" (
    set "CODE_EXE=C:\Program Files\Microsoft VS Code\Code.exe"
    set "CODE_CLI=C:\Program Files\Microsoft VS Code\bin\code.cmd"
) else (
    for /f "delims=" %%I in ('where code.cmd 2^>nul') do (
        set "CODE_EXE=%%I"
        set "CODE_CLI=%%I"
    )
)

if "%CODE_EXE%"=="" (
    echo [ERROR] VS Code executable not found. Please install Visual Studio Code first.
    pause
    exit /b 1
)

:: Bootstrap clean isolated settings on first run
if not exist "%USER_DIR%" mkdir "%USER_DIR%"
if not exist "%USER_DIR%\settings.json" (
    if exist "%CONFIG_DIR%\settings.json" copy /y "%CONFIG_DIR%\settings.json" "%USER_DIR%\settings.json" >nul
)
if not exist "%USER_DIR%\keybindings.json" (
    if exist "%CONFIG_DIR%\keybindings.json" copy /y "%CONFIG_DIR%\keybindings.json" "%USER_DIR%\keybindings.json" >nul
)

:: Auto-install extension into isolated directory on first run if VSIX is present
if not exist "%EXT_DIR%\extensions.json" (
    if exist "%VSIX_FILE%" (
        call "%CODE_CLI%" --user-data-dir "%DATA_DIR%" --extensions-dir "%EXT_DIR%" --install-extension "%VSIX_FILE%" --force >nul 2>&1
    )
)

:: Ensure Desktop shortcut exists with custom Cline Agent Studio icon
if not exist "%USERPROFILE%\Desktop\Cline Agent Studio.lnk" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Create-Desktop-Shortcut.ps1" >nul 2>&1
)

set "DEV_MODE=0"
set "TARGET_DIR="

if "%~1"=="--dev" (
    set "DEV_MODE=1"
    set "TARGET_DIR=%~2"
) else (
    set "TARGET_DIR=%~1"
)

:: Open minimal dark Project Picker when no target folder is provided
if "%TARGET_DIR%"=="" (
    for /f "usebackq delims=" %%P in (`powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%SCRIPT_DIR%Select-Project.ps1"`) do (
        set "TARGET_DIR=%%P"
    )
)

:: Abort cleanly if user cancelled the picker
if "%TARGET_DIR%"=="" (
    exit /b 0
)

if "%DEV_MODE%"=="1" (
    start "" "%CODE_EXE%" --user-data-dir "%DATA_DIR%" --extensionDevelopmentPath="%SRC_DIR%" --new-window "%TARGET_DIR%"
    exit /b 0
)

start "" "%CODE_EXE%" --user-data-dir "%DATA_DIR%" --extensions-dir "%EXT_DIR%" --new-window "%TARGET_DIR%"
exit /b 0
