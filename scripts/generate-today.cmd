cmd
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 从系统时间变量直接获取日期，格式为 YYYY-MM-DD (例如 2026-06-25)
:: 这种方法比解析 date /t 更稳定
for /f "tokens=1-3 delims=/-. " %%a in ('echo %date%') do (
    set yy=%%a
    set mm=%%b
    set dd=%%c
)

:: 如果年份不是四位数字（例如只拿到两位年份），尝试用另一种方式
:: 简单判断：如果 yy 的长度小于 4，就尝试从另一个位置获取
set yy_len=0
setlocal enabledelayedexpansion
for %%i in (%yy%) do set yy_len=%%~zi
if %yy_len% LSS 4 (
    for /f "tokens=2-4 delims=/-. " %%a in ('echo %date%') do (
        set yy=%%c
        set mm=%%a
        set dd=%%b
    )
)

:: 如果月份或日期是单个数字，补零（但保持原样也OK，这里选择保留）
:: 为了文件名整洁，我们不做补零，保持原样

:: 如果没有日期变量（极罕见情况），用 PowerShell 获取
if "%yy%"=="" (
    for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd'"') do set DATE_STR=%%i
) else (
    set DATE_STR=%yy%-%mm%-%dd%
)

set FILE_PATH=journals\%DATE_STR%.md

if not exist journals mkdir journals

if not exist "%FILE_PATH%" (
    echo # 感恩日记 - %DATE_STR% > "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo ## 🌅 今天值得感恩的人 >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo 1.  >> "%FILE_PATH%"
    echo 2.  >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo ## 🌄 今天值得感恩的事 >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo 1.  >> "%FILE_PATH%"
    echo 2.  >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo ## 🌟 今天的小确幸 >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo ## 💭 今天的感受 >> "%FILE_PATH%"
    echo. >> "%FILE_PATH%"
    echo ✅ 已创建 %FILE_PATH%
) else (
    echo ⚠️ %FILE_PATH% 已存在
)

pause