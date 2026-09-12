@echo off
setlocal

title FILESHELL Installer

echo.
echo ==========================================================
echo                         FILESHELL
echo                         INSTALLER
echo ==========================================================
echo.
echo Installing FILESHELL...
echo.

rem Get the folder where this installer is located
set "INSTALL_DIR=%~dp0"
set "INSTALL_DIR=%INSTALL_DIR:~0,-1%"

rem Check that FILESHELL exists
if not exist "%INSTALL_DIR%\Fileshell.bat" (
    echo ERROR: Fileshell.bat was not found!
    echo.
    pause
    exit /b 1
)

echo FILESHELL found:
echo %INSTALL_DIR%
echo.

rem Get the current User PATH
for /f "tokens=2,*" %%A in (
    'reg query "HKCU\Environment" /v Path 2^>nul'
) do set "USER_PATH=%%B"

rem Check if the folder is already in PATH
echo %USER_PATH% | find /I "%INSTALL_DIR%" >nul

if not errorlevel 1 (
    echo FILESHELL is already in your PATH.
    goto success
)

echo Adding FILESHELL to your User PATH...
echo.

rem Add FILESHELL folder to User PATH
powershell -NoProfile -Command ^
    "$path = [Environment]::GetEnvironmentVariable('Path','User');" ^
    "$dir = '%INSTALL_DIR%';" ^
    "if ([string]::IsNullOrWhiteSpace($path)) {" ^
        "[Environment]::SetEnvironmentVariable('Path',$dir,'User')" ^
    "} elseif (($path -split ';') -notcontains $dir) {" ^
        "[Environment]::SetEnvironmentVariable('Path',($path.TrimEnd(';') + ';' + $dir),'User')" ^
    "}"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to add FILESHELL to PATH.
    pause
    exit /b 1
)

:success

echo.
echo ==========================================================
echo                    INSTALLATION COMPLETE
echo ==========================================================
echo.
echo FILESHELL has been installed!
echo.
echo Close this terminal and open a new one.
echo Then type:
echo.
echo     fsh
echo.
echo to launch FILESHELL.
echo.
pause
