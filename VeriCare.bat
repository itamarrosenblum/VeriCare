:: v1.0 By Itamar Rosenblum
@echo off
title VeriCare
color A
mode con: cols=90 lines=30

:: ..:VeriCare:..
:veriCare
cls & echo (!)Note: Run the script as administrator.
echo. & echo ^> Welcome to VeriCare v1.0 & echo   Verifone Technical Support Repair Tool.
echo. & echo ^> Please select one of the options:
echo  1 = VeriClear
echo  2 = VeriService
echo  3 = VeriNetwork
echo  E = Exit & echo.
:: User input
set /p VALUE= ^> Please enter your option: 
:: User output
if /i "%VALUE%"=="" goto veriCare
if %VALUE%==1 goto veriClear
if %VALUE%==2 goto veriService
if %VALUE%==3 goto veriNetwork
if /i %VALUE%==e goto exit
if /i %VALUE%==%VALUE% goto veriCare

:: ..:VeriClear:..
:veriClear
cls & echo ^> You're now in "VeriClear".
echo. & echo ^> This script clears the following:
echo  - Temporary files.
echo  - Print spooler files.
echo  - Logs files (C: drive). *Separately*
echo  - COMM files (D: drive).
echo  - The recycle bin.
echo. & echo ^> Please select one of the options:
echo  - R = Run (w/o logs files)
echo  - C = Clear only logs files
echo  - B = Back
echo  - E = Exit & echo.
:: User input
set /p VALUE= ^> Please enter your option: 
:: User output
if /i %VALUE%==r goto runVeriClear
if /i %VALUE%==c goto clearLogsFiles
if /i %VALUE%==b goto veriCare
if /i %VALUE%==e goto exit
if /i %VALUE%==%VALUE% goto veriClear
:runVeriClear
:: Clear temporary files
@rmdir %temp% /s /q & @md %temp%
del C:\Windows\SoftwareDistribution\ /s /q
:: Clear print spooler files
net stop spooler /q
del %windir%\system32\spool\printers\*.* /q
net start spooler
:: COMM files (IN/OUT)
D: & cd VeriFone Retail360\Front-Office.IL\COMM & del IN /q & del OUT /q
:: Clear recycle bin
del %systemdrive%\$RECYCLE.BIN /s /q
:: Back to main menu
goto veriCare
:clearLogsFiles
:: Clear performance files
@rmdir C:\PerfLogs\Admin\VR360Collectors\ /s /q
del %AppData%\"Verifone Retail 360"\"FrontOffice.IL"\Logs\*.* /s /q
:: Clear recycle bin
del %systemdrive%\$RECYCLE.BIN /s /q
goto veriCare

:: ..:VeriService:..
:veriService
cls & echo ^> You're now in "VeriService".
echo. & echo ^> This script restarts the following services:
echo  - SQL Server (SQLEXPRESS).
echo  - VR360.JobAgent.
echo  - VR360.WebServer.
echo  - RAU Service.
echo. & echo ^> Please select one of the options:
echo  - R = Run
echo  - B = Back
echo  - E = Exit & echo.
:: User input
set /p VALUE= ^> Please enter your option: 
:: User output
if /i %VALUE%==r goto runVeriService
if /i %VALUE%==b goto veriCare
if /i %VALUE%==e goto exit
if /i %VALUE%==%VALUE% goto veriService
:runVeriService
:: Close the Front Office App
tasklist | find "Retail360.IL.FrontOffice." > nul & (tskill re*) || (echo.)
:: Restart SQL Server (SQLEXPRESS)
net stop MSSQL$SQLEXPRESS & net start MSSQL$SQLEXPRESS
:: Restart VR360.JobAgent
net stop VR360.JobAgent & net start VR360.JobAgent
:: Restart VR360.WebServer
net stop VR360.WebServer & net start VR360.WebServer
:: Restart RAU Service
net stop RAUClientService & net start RAUClientService
:: Run the Front Office App
start "" "D:\VeriFone Retail360\Front-Office.IL\Retail360.IL.FrontOffice.exe"
:: Back to VeriCare
goto veriCare

:: ..:VeriNetwork:..
:veriNetwork
cls & echo ^> You're now in "VeriNetwork".
echo. & echo ^> Current Network Configuration:
:: Display network configuration
ipconfig | findstr /i "IPv4"
ipconfig | findstr /i "Subnet Mask"
ipconfig | findstr /i "Default Gateway"
ipconfig /all | findstr /i "Servers"
echo. & echo ^> Please select one of the options:
echo  - Enter an IP address
echo  - B = Back
echo  - E = Exit & echo.
:: User input
set /p VALUE= ^> Please enter your option: 
:: User output
if /i %VALUE%==b goto veriCare
if /i %VALUE%==e goto exit
ping %VALUE% -t | find "Reply"
:: Back to main menu
goto veriCare

:: Pause VeriCare scripts
pause > nul
