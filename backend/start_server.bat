@echo off
echo Starting Flower Backend...
echo.
echo IMPORTANT: For phone access, run allow_firewall.ps1 as Administrator first!
echo.
cd /d "%~dp0"
call venv\Scripts\activate.bat
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
