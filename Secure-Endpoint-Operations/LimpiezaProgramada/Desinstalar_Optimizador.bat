@echo off
setlocal

REM ====================================================
REM DESINSTALADOR DE OPTIMIZADOR
REM Autor    : Alex Alcivar Moya
REM Version  : 1.0
REM Fecha    : 11/09/2026
REM Objetivo :
REM   - Eliminar tarea programada
REM   - Eliminar componentes de optimizacion
REM   - Conservar historial de ejecucion
REM ====================================================

title Desinstalador - Optimizador
color 0C

echo.
echo ===================================================
echo         DESINSTALADOR DE OPTIMIZADOR
echo ===================================================
echo.

REM ====================================================
REM ELIMINAR TAREA PROGRAMADA
REM ====================================================

schtasks /query /tn "Optimizador Alex Alcivar" >nul 2>&1

if %errorlevel% equ 0 (
    schtasks /delete /tn "Optimizador Alex Alcivar" /f >nul 2>&1
    echo Tarea programada eliminada correctamente.
) else (
    echo La tarea programada no existe.
)

echo.

REM ====================================================
REM ELIMINAR ARCHIVOS
REM ====================================================

if exist "C:\LimpiezaProgramada\Optimizador.bat" (
    del /f /q "C:\LimpiezaProgramada\Optimizador.bat"
    echo Optimizador.bat eliminado.
)

if exist "C:\LimpiezaProgramada\EmptyStandbyList.exe" (
    del /f /q "C:\LimpiezaProgramada\EmptyStandbyList.exe"
    echo EmptyStandbyList.exe eliminado.
)

echo.
echo Historial.log conservado para auditoria.
echo.

echo ===================================================
echo      DESINSTALACION FINALIZADA
echo ===================================================
echo.
echo Componentes eliminados:
echo    - Tarea Programada
echo    - Optimizador.bat
echo    - EmptyStandbyList.exe
echo.
echo Componentes conservados:
echo    - Historial.log
echo    - Desinstalar_Optimizador.bat
echo.
echo ===================================================
echo                 ALEX ALCIVAR MOYA
echo ===================================================
echo.

pause

endlocal
exit /b