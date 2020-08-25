@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

echo pinging all connected devices...

arp -d
set ip[0]=0
set ip[1]=0
set ip[2]=0
set ip_mine=0
set ip_address_string_en="IPv4 Address"
set ip_address_string_ja="IPv4 アドレス"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string_en% /c:%ip_address_string_ja%`) do (
    set ip_mine=%%f
    goto :next_block
)

:next_block
for /F "tokens=1-3 delims=. " %%a in ("%ip_mine%") do (
    set ip[0]=%%a
    set ip[1]=%%b
    set ip[2]=%%c
)

for /L %%a in (1,1,254) do (
    start /b ping %ip[0]%.%ip[1]%.%ip[2]%.%%a -w 100 -n 2 >nul
)

echo ================================
echo SEARCH RESULTS:

for /f "tokens=1,2" %%a in (device_mac.txt) do (
    echo %%a
    arp -a | find "%%b"
    echo.
)

popd
pause
