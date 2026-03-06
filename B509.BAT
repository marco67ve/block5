@echo off
echo.
echo Seleziona la dimensione della griglia:
echo.
echo 1 = 11x11
echo 2 = 12x12
echo 3 = 13x13
echo 4 = 14x14
echo 5 = 15x15
echo 6 = 16x16
echo 7 = 17x17
echo.

choice /c:1234567 /n

if errorlevel 1 set lato=11
if errorlevel 2 set lato=12
if errorlevel 3 set lato=13
if errorlevel 4 set lato=14
if errorlevel 5 set lato=15
if errorlevel 6 set lato=16
if errorlevel 7 set lato=17

echo.
echo Avvio BLOCK 5 con griglia %lato%x%lato%...
echo.
B509 %lato%

