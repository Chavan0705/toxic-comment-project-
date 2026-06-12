@echo off
REM Learning Dashboard - Build Script (Batch)
REM Compiles Java source files to WebContent/WEB-INF/classes

setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ===========================================
echo Learning Dashboard - Compiling Project
echo ===========================================
echo.

set TOMCAT_LIB=C:\Users\adity\.gemini\antigravity\scratch\BillSplitProject\tomcat\lib\servlet-api.jar
set CLASSES_DIR=WebContent\WEB-INF\classes
set LIB_DIR=WebContent\WEB-INF\lib

if not exist "%CLASSES_DIR%" (
    mkdir "%CLASSES_DIR%"
    echo Created classes directory.
)

echo Locating Java files...
dir /s /b src\*.java > sources.txt

if %errorlevel% neq 0 (
    echo [ERROR] No Java files found.
    del sources.txt 2>nul
    pause
    exit /b 1
)

echo Compiling Java source files...
javac -d "%CLASSES_DIR%" -cp "%TOMCAT_LIB%;%LIB_DIR%\*" @sources.txt

set COMPILE_STATUS=%errorlevel%
del sources.txt 2>nul

if %COMPILE_STATUS% equ 0 (
    echo.
    echo ✅ Compilation successful!
    echo ===========================================
) else (
    echo.
    echo ❌ Compilation failed with exit code %COMPILE_STATUS%
    echo ===========================================
    pause
    exit /b %COMPILE_STATUS%
)
