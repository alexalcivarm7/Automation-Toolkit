@echo off
setlocal

REM ====================================================
REM INSTALADOR DE TAREA PROGRAMADA
REM Autor    : Alex Alcivar Moya
REM Version  : 1.0
REM Fecha    : 11/09/2026
REM Objetivo :
REM   - Crear tarea programada de optimizacion
REM   - Ejecutar como NT AUTHORITY\SYSTEM
REM   - Ejecutar con privilegios elevados
REM   - Iniciar al iniciar sesion
REM   - Repetir ejecucion cada 1 hora
REM ====================================================

title Instalador de Tarea - Optimizador
color 0A

echo.
echo ===================================================
echo        INSTALADOR DE TAREA PROGRAMADA
echo ===================================================
echo.
echo Nombre de la tarea : Endpoint Maintenance Automation
echo Cuenta            : NT AUTHORITY\SYSTEM
echo Privilegios       : Elevados
echo Frecuencia        : Cada 1 hora
echo Inicio            : Al iniciar sesion
echo.

REM ====================================================
REM VALIDAR ARCHIVOS REQUERIDOS
REM ====================================================
if not exist "C:\LimpiezaProgramada\Optimizador.bat" (
    echo ERROR: No se encuentra:
    echo C:\LimpiezaProgramada\Optimizador.bat
    echo.
    pause
    exit /b 1
)

if not exist "C:\LimpiezaProgramada\EmptyStandbyList.exe" (
    echo ERROR: No se encuentra:
    echo C:\LimpiezaProgramada\EmptyStandbyList.exe
    echo.
    pause
    exit /b 1
)

REM ====================================================
REM VALIDAR SI LA TAREA YA EXISTE
REM ====================================================

schtasks /query /tn "Endpoint Maintenance Automation" >nul 2>&1

if %errorlevel% equ 0 (
    echo Tarea existente detectada.
    echo Actualizando configuracion...
    echo.
) else (
    echo Tarea no encontrada.
    echo Creando configuracion...
    echo.
)

REM ====================================================
REM CREACION / ACTUALIZACION DE TAREA
REM ====================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command "$Accion = New-ScheduledTaskAction -Execute 'C:\LimpiezaProgramada\Optimizador.bat'; $TriggerInicio = New-ScheduledTaskTrigger -AtLogOn; $TriggerHora = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration (New-TimeSpan -Days 3650); $Principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest -LogonType ServiceAccount; Register-ScheduledTask -TaskName 'Endpoint Maintenance Automation' -Action $Accion -Trigger @($TriggerInicio,$TriggerHora) -Principal $Principal -Force"


REM ====================================================
REM VALIDACION FINAL
REM ====================================================
schtasks /query /tn "Endpoint Maintenance Automation" >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ===================================================
    echo         ERROR EN LA INSTALACION
    echo ===================================================
    echo.
    echo No fue posible crear la tarea programada.
    echo.
    pause
    exit /b 1
)
echo.
echo ===================================================
echo      INSTALACION FINALIZADA CORRECTAMENTE
echo ===================================================
echo.
echo Nombre de tarea : Endpoint Maintenance Automation
echo Usuario         : NT AUTHORITY\SYSTEM
echo Estado          : Operativo
echo.
echo La optimizacion se ejecutara:
echo    - Al iniciar sesion
echo    - Cada 1 hora
echo.
echo ===================================================
echo                 ALEX ALCIVAR MOYA
echo ===================================================
echo.
echo Puede validar la configuracion desde:
echo Programador de tareas ^> Biblioteca del Programador.
echo.
pause

endlocal
exit /b