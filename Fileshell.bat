@echo off
setlocal EnableDelayedExpansion
title FILESHELL

:menu
cls

echo ==========================================================
echo                         FILESHELL
echo                      FILE EXPLORER
echo ==========================================================
echo.
echo Current folder:
echo %CD%
echo.
echo ----------------------------------------------------------
echo.

set /a count=0

rem ==========================================================
rem LIST FILES AND FOLDERS
rem ==========================================================

for /f "delims=" %%A in ('dir /b /a 2^>nul') do (
    set /a count+=1
    set "item[!count!]=%%A"

    if exist "%%A\*" (
        echo !count!.  %%A
    ) else (
        for %%F in ("%%A") do (
            set "fileSize=%%~zF"
            set "fileDate=%%~tF"
            set "fileExt=%%~xF"

            rem Convert bytes to KB
            set /a fileKB=fileSize/1024
            if !fileKB! LSS 1 set "fileKB=1"

            rem File type
            set "fileType=File"

            if /i "!fileExt!"==".txt" set "fileType=Text Document"
            if /i "!fileExt!"==".bat" set "fileType=Windows Batch File"
            if /i "!fileExt!"==".cmd" set "fileType=Windows Command Script"
            if /i "!fileExt!"==".exe" set "fileType=Application"
            if /i "!fileExt!"==".dll" set "fileType=Application Extension"
            if /i "!fileExt!"==".html" set "fileType=HTML Document"
            if /i "!fileExt!"==".htm" set "fileType=HTML Document"
            if /i "!fileExt!"==".css" set "fileType=Cascading Style Sheet"
            if /i "!fileExt!"==".js" set "fileType=JavaScript File"
            if /i "!fileExt!"==".json" set "fileType=JSON File"
            if /i "!fileExt!"==".py" set "fileType=Python File"
            if /i "!fileExt!"==".cpp" set "fileType=C++ Source File"
            if /i "!fileExt!"==".h" set "fileType=C/C++ Header File"
            if /i "!fileExt!"==".png" set "fileType=PNG Image"
            if /i "!fileExt!"==".jpg" set "fileType=JPEG Image"
            if /i "!fileExt!"==".jpeg" set "fileType=JPEG Image"
            if /i "!fileExt!"==".gif" set "fileType=GIF Image"
            if /i "!fileExt!"==".mp3" set "fileType=MP3 Audio"
            if /i "!fileExt!"==".wav" set "fileType=WAV Audio"
            if /i "!fileExt!"==".mp4" set "fileType=MP4 Video"
            if /i "!fileExt!"==".zip" set "fileType=ZIP Archive"
            if /i "!fileExt!"==".rar" set "fileType=RAR Archive"
            if /i "!fileExt!"==".7z" set "fileType=7-Zip Archive"
            if /i "!fileExt!"==".pdf" set "fileType=PDF Document"

            rem ==================================================
            rem PAD FILENAME TO FIXED WIDTH
            rem ==================================================

            set "displayName=%%A"
            set "displayName=!displayName:~0,35!"

            set "displayName=!displayName!                                   "
            set "displayName=!displayName:~0,35!"

            rem Pad file type to fixed width
            set "displayType=!fileType!                              "
            set "displayType=!displayType:~0,28!"

            rem Display aligned information
            echo !count!.  !displayName!   !fileDate!   !displayType!   !fileKB! KB
        )
    )
)

echo.
echo ----------------------------------------------------------
echo I. Create file
echo G. Go to path
echo B. Go back
echo X. Exit
echo ----------------------------------------------------------
echo.

set "choice="
set /p "choice=Select: "

rem ==========================================================
rem EXIT
rem ==========================================================

if /i "!choice!"=="X" exit /b

rem ==========================================================
rem CREATE FILE
rem ==========================================================

if /i "!choice!"=="I" goto createfile

rem ==========================================================
rem GO TO PATH
rem ==========================================================

if /i "!choice!"=="G" goto gotopath

rem ==========================================================
rem GO BACK
rem ==========================================================

if /i "!choice!"=="B" (
    cd ..
    goto menu
)

rem ==========================================================
rem GET SELECTED ITEM
rem ==========================================================

set "selected=!item[%choice%]!"

if not defined selected (
    goto menu
)

rem ==========================================================
rem CHECK FOR FOLDER
rem ==========================================================

if exist "!selected!\*" (
    cd /d "!selected!"
    goto menu
)

rem ==========================================================
rem CHECK FOR FILE
rem ==========================================================

if exist "!selected!" (
    for %%F in ("!selected!") do set "fullFilePath=%%~fF"

    rundll32.exe shell32.dll,ShellExec_RunDLL "!fullFilePath!"

    set "fullFilePath="
    goto menu
)

goto menu


:gotopath
cls

echo ==========================================================
echo                       GO TO PATH
echo ==========================================================
echo.
echo Enter the full folder path.
echo.
echo Example:
echo C:\Users\YourName\Downloads
echo.

set "targetPath="
set /p "targetPath=Path: "

if not defined targetPath goto menu

set "targetPath=!targetPath:"=!"

cd /d "!targetPath!" >nul 2>&1

if errorlevel 1 (
    echo.
    echo ==========================================================
    echo ERROR: Cannot open that folder!
    echo ==========================================================
    echo.
    echo Path:
    echo !targetPath!
    echo.
    pause
    goto menu
)

goto menu


:createfile
cls

echo ==========================================================
echo                      CREATE FILE
echo ==========================================================
echo.
echo Current folder:
echo %CD%
echo.

set "filename="
set /p "filename=Enter file name: "

if not defined filename goto menu

type nul > "!filename!" 2>nul

if errorlevel 1 (
    echo.
    echo Failed to create the file!
    timeout /t 2 >nul
    goto menu
)

echo.
echo File created successfully!
timeout /t 1 >nul

goto menu