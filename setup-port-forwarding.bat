@echo off
echo Setting up ADB port forwarding for Android emulator...
"C:\Users\tauqu\AppData\Local\Android\Sdk\platform-tools\adb.exe" reverse tcp:8000 tcp:8000
if %errorlevel% == 0 (
    echo ✅ Port forwarding set up successfully!
    echo Emulator can now access localhost:8000
) else (
    echo ❌ Failed to set up port forwarding
    echo Make sure Android emulator is running
)
pause

