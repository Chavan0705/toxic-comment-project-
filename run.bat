@echo off
REM Learning Dashboard - Run Script (Batch)
REM Compiles the project, deploys to local Tomcat, and starts Tomcat if not running

setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ===========================================
echo Learning Dashboard - Deployment and Launch
echo ===========================================
echo.

REM 1. Compile
call build.bat
if %errorlevel% neq 0 (
    echo [ERROR] Build failed. Aborting execution.
    pause
    exit /b %errorlevel%
)

REM 2. Deploy
echo.
echo Deploying to Tomcat...
set TOMCAT_PATH=C:\Users\adity\.gemini\antigravity\scratch\BillSplitProject\tomcat
set DEPLOY_PATH=%TOMCAT_PATH%\webapps\LearningDashboard

if exist "%DEPLOY_PATH%" (
    rmdir /s /q "%DEPLOY_PATH%"
    echo Removed old deployment.
)

xcopy "WebContent" "%DEPLOY_PATH%" /E /I /Y >nul
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy files to Tomcat directory.
    pause
    exit /b 1
)
echo ✅ Project deployed successfully.

REM 3. Check port 8080 and start Tomcat
echo.
echo Checking if Tomcat is running...
netstat -ano | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ✅ Tomcat is already running. Redeploy complete.
) else (
    echo Tomcat is not running. Starting Tomcat...
    start "" /D "%TOMCAT_PATH%\bin" "%TOMCAT_PATH%\bin\startup.bat"
    echo ✅ Tomcat started in a separate window.
)

echo.
echo ==========================================================
echo Learning Dashboard is ready!
echo Open http://localhost:8080/LearningDashboard/ in your browser
echo ==========================================================
echo.
pause
