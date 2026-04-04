@echo off
cd /d "%~dp0"
echo.
echo  Hashmi Studio portfolio - local web server
echo  -----------------------------------------
echo  In your browser open:  http://localhost:8080
echo  Press Ctrl+C here to stop the server.
echo.

where py >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    py -m http.server 8080
    goto done
)

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    python -m http.server 8080
    goto done
)

where npx >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    npx --yes serve . -l 8080
    goto done
)

echo  No Python or Node found on PATH.
echo  Install Python from https://www.python.org/downloads/
echo  or Node from https://nodejs.org/  OR use VS Code "Live Server" on index.html
echo.
pause
exit /b 1

:done
pause
