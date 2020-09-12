@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

echo pinging all connected devices...
echo ================================
echo SEARCH RESULTS:
echo.

arp -d
set ip_address_string_en="IPv4 Address"
set ip_address_string_ja="IPv4 アドレス"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string_en% /c:%ip_address_string_ja%`) do (
    for /F "tokens=1-3 delims=. " %%a in ("%%f") do (
        for /L %%d in (1,1,254) do (
            start /b ping %%a.%%b.%%c.%%d -w 100 -n 2 >nul
        )
    )
)

for /f "tokens=1,2" %%a in (device_mac.txt) do (
    echo %%a
    arp -a | find "%%b"
    echo.
)

popd
pause
