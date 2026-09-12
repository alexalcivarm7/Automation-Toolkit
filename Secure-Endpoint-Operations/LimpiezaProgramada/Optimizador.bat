@echo off
setlocal

REM ====================================================
REM HERRAMIENTA DE OPTIMIZACION DE ESTACIONES DE TRABAJO
REM Autor    : Alex Alcivar Moya
REM Version  : 1.0
REM Fecha    : 11/09/2026
REM Objetivo :
REM   - Limpiar Windows Temp
REM   - Limpiar Temp de perfiles locales
REM   - Liberar memoria RAM (Working Sets y Standby List)
REM ====================================================

title Secure Endpoint Operations
color 0A

REM ====================================================
REM CONFIGURACION
REM ====================================================

set "RUTA_BASE=C:\LimpiezaProgramada"
set "LOG=%RUTA_BASE%\Historial.log"

if not exist "%RUTA_BASE%" mkdir "%RUTA_BASE%"

REM Eliminar logs con más de 30 días
forfiles /p "%RUTA_BASE%" /m Historial.log /d -30 /c "cmd /c del @path" >nul 2>&1

REM ====================================================
REM REGISTRO DE INICIO
REM ====================================================
echo =================================================== >> "%LOG%"
echo EQUIPO: %COMPUTERNAME% >> "%LOG%"
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).UserName"') do set UsuarioActivo=%%A
echo USUARIO CON SESION INICIADA: %UsuarioActivo% >> "%LOG%"
echo [%date% %time%] INICIO DE EJECUCION >> "%LOG%"

echo.
echo ==========================================
echo         LIMPIEZA LOGICA DEL EQUIPO
echo ==========================================
timeout /t 1 >nul

echo.
echo [20%%] Rutas detectadas...

echo WINDOWS TEMP: %SystemRoot%\Temp
REM ====================================================
REM WINDOWS TEMP
REM ====================================================
echo.
echo [50%%] Limpiando Windows Temp...
del /f /s /q "%SystemRoot%\Temp\*" >nul 2>&1
for /d %%i in ("%SystemRoot%\Temp\*") do rd /s /q "%%i" >nul 2>&1
REM ====================================================
REM TEMP DE PERFILES DE USUARIO
REM ====================================================
echo.
echo [80%%] Limpiando temporales de perfiles locales...
for /d %%U in ("C:\Users\*") do (
    del /f /s /q "%%U\AppData\Local\Temp\*" >nul 2>&1
    for /d %%T in ("%%U\AppData\Local\Temp\*") do rd /s /q "%%T" >nul 2>&1
)
echo.
echo [100%%] Limpieza finalizada.
echo.
echo ==========================================
echo    OPERACION COMPLETADA EXITOSAMENTE
echo ==========================================
cls


REM ====================================================
REM LIBERACION DE MEMORIA RAM
REM ====================================================
echo.
echo ==========================================
echo          LIBERADOR DE MEMORIA RAM
echo ==========================================
timeout /t 1 >nul
if exist "%~dp0EmptyStandbyList.exe" (
    echo.
    echo [30%%] Liberando Working Sets...
    "%~dp0EmptyStandbyList.exe" workingsets
    echo.
    echo [70%%] Limpiando Standby List...
    "%~dp0EmptyStandbyList.exe" standbylist
    echo.
    echo [100%%] Liberacion completada.
) else (
    echo.
    echo ERROR: EmptyStandbyList.exe no encontrado.
    echo [%date% %time%] ERROR: EmptyStandbyList.exe no encontrado >> "%LOG%"
)
echo.
echo ==========================================
echo    OPERACION COMPLETADA EXITOSAMENTE
echo ==========================================
cls


REM ====================================================
REM REGISTRO FINAL
REM ====================================================
echo [%date% %time%] EJECUCION FINALIZADA CORRECTAMENTE >> "%LOG%"
cls

timeout /t 1 >nul

endlocal
exit /b