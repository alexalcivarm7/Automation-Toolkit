# =============================================================================================================
# Proyecto : Script de Monitoreo y Autorrecuperación de Servicios Web
# Autor    : Alex Alcivar Moya
# Perfil   : IT Engineer | Cibersecurity Analyst 
#
# Filosofía del proyecto:
# No se trata únicamente de reiniciar un servicio cuando falla.
# Se trata de hacerlo de forma controlada, verificable y asegurando
# que realmente vuelva a estar disponible.
#
# Personalización:
# - Modifique la URL a monitorear.
# - Modifique las rutas de los archivos BAT.
# - Ajuste los tiempos de validación.
# - Ajuste la cantidad de fallos consecutivos requeridos.
#
# Licencia:
# Puede usar, modificar y adaptar este script para fines educativos
# y profesionales.
# =============================================================================================================

Add-Type -AssemblyName System.Windows.Forms

# =============================================================================================================
# TITULO DEL SCRIPT
# -------------------------------------------------------------------------------------------------------------
# Configurar el nombre que desea mostrar como titulo en la ventana de ejecución.
# =============================================================================================================
$Host.UI.RawUI.WindowTitle = "MONITOREO - SRV_PRODUCCION"

$ConfirmPreference = 'None'
$WarningPreference = 'SilentlyContinue'

# =============================================================================================================
# URL A MONITOREAR
# -------------------------------------------------------------------------------------------------------------
# La aplicación debe responder HTTP 200 cuando se encuentre operativa.
# =============================================================================================================

$url = "http://url_del_Servidor.com"

# =============================================================================================================
# ARCHIVOS DE CONTROL DEL SERVICIO
# -------------------------------------------------------------------------------------------------------------
# Configure aquí los archivos BAT responsables de detener e iniciar
# el servidor o servicio que desee monitorear.
# =============================================================================================================

$stopBat  = "C:\ruta\del\bat\stopserv.bat"
$startBat = "C:\ruta\del\bat\startserv.bat"

# =============================================================================================================
# CONFIGURACIÓN DEL MONITOREO
# -------------------------------------------------------------------------------------------------------------
# $intervaloValidacion
# Tiempo entre validaciones HTTP (en segundos).
#
# $maxFallosConsecutivos
# Cantidad de errores consecutivos necesarios para iniciar
# el proceso de recuperación automática.
# =============================================================================================================

$intervaloValidacion = 30
$maxFallosConsecutivos = 2

$fallosConsecutivos = 0
$reiniciando = $false

# =============================================================================================================
# INICIO DEL MONITOREO
# =============================================================================================================

Write-Host "==========================================================================" 
Write-Host " MONITOREO SRV_PRODUCCION" -ForegroundColor Cyan
Write-Host " URL: $url" -ForegroundColor Cyan
Write-Host "==========================================================================" 
Write-Host ""

# =============================================================================================================
# BUCLE PRINCIPAL DE MONITOREO
# -------------------------------------------------------------------------------------------------------------
# El script permanecerá ejecutándose de manera indefinida:
#   1. Consulta la URL.
#   2. Valida la respuesta HTTP.
#   3. Registra el estado.
#   4. Ejecuta recuperación automática cuando corresponde.
# =============================================================================================================

while ($true)
{
    $fechaHora = Get-Date -Format "HH:mm:ss dd/MM/yyyy"

    try
    {
        $response = Invoke-WebRequest `
            -Uri $url `
            -TimeoutSec 10 `
            -UseBasicParsing `
            -ErrorAction Stop

        if ($response.StatusCode -eq 200)
        {
            Write-Host "$fechaHora : SERVICIO EN LINEA (HTTP 200)" -ForegroundColor Green
            $fallosConsecutivos = 0
        }
        else
        {
            throw "HTTP Status $($response.StatusCode)"
        }
    }
    catch
    {
        $fallosConsecutivos++

        Write-Host "$fechaHora : ERROR DE CONEXION. Intento $fallosConsecutivos/$maxFallosConsecutivos" -ForegroundColor Red

        if (($fallosConsecutivos -ge $maxFallosConsecutivos) -and (-not $reiniciando))
        {
            $reiniciando = $true

            try
            {
                Write-Host ""
                Write-Host "==========================================================================" 
                Write-Host " INICIANDO PROCESO DE RECUPERACION AUTOMATICA..." -ForegroundColor Yellow
                Write-Host "==========================================================================" 

                # =============================================================================================
                # PASO 1 - DETENER SERVICIO
                # Espera a que el proceso finalice completamente antes de continuar.
                # =============================================================================================

                Start-Process `
                    -FilePath $stopBat `
                    -WindowStyle Hidden `
                    -Wait

                Start-Sleep -Seconds 5

                # =============================================================================================
                # PASO 2 - INICIAR SERVICIO
                # Se abre una ventana CMD independiente para visualizar
                # los logs de arranque del servidor.
                # =============================================================================================

                Start-Process `
                    -FilePath "cmd.exe" `
                    -ArgumentList "/k `"$startBat`""

                # =============================================================================================
                # PASO 3 - VALIDAR DISPONIBILIDAD
                # Se mantiene consultando la aplicación hasta recibir
                # nuevamente una respuesta HTTP 200.
                # =============================================================================================

                do
                {
                    Start-Sleep -Seconds 10

                    try
                    {
                        $validacion = Invoke-WebRequest `
                            -Uri $url `
                            -TimeoutSec 10 `
                            -UseBasicParsing `
                            -ErrorAction Stop

                        $servidorDisponible = ($validacion.StatusCode -eq 200)
                    }
                    catch
                    {
                        $servidorDisponible = $false
                    }

                } while (-not $servidorDisponible)

                Write-Host " REANUDANDO MONITOREO DEL SERVICIO" -ForegroundColor Cyan
                Write-Host "==========================================================================" 
                Write-Host ""

                $fallosConsecutivos = 0
            }
            catch
            {
                Write-Host "ERROR DURANTE EL PROCESO DE RECUPERACION" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
            finally
            {
                $reiniciando = $false
            }
        }
    }

    Start-Sleep -Seconds $intervaloValidacion
}
