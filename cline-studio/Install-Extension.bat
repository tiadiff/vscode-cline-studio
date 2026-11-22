@echo off
setlocal
title Install Cline Agent Studio Extension

echo ========================================================
echo       INSTALL CLINE AGENT STUDIO VSIX IN VS CODE
echo ========================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "VSIX_FILE=%SCRIPT_DIR%cline-fullscreen.vsix"
set "DATA_DIR=%SCRIPT_DIR%data"
set "EXT_DIR=%SCRIPT_DIR%extensions"

if not exist "%VSIX_FILE%" (
    echo [ERROR] %VSIX_FILE% not found.
    pause
    exit /b 1
)

echo Installing into isolated Studio profile...
call code --user-data-dir "%DATA_DIR%" --extensions-dir "%EXT_DIR%" --install-extension "%VSIX_FILE%" --force

echo.
echo Do you also want to install the extension into your main VS Code?
set /p "CHOICE=(Y/N, default N): "
if /i "%CHOICE%"=="Y" (
    echo Installing into main VS Code...
    call code --install-extension "%VSIX_FILE%" --force
)

echo.
echo [DONE] Installation complete.
pause
