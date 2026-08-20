# Web-Service-AutoRecovery

Script de monitoreo y autorrecuperación de servicios web desarrollado en **PowerShell**, orientado a entornos Windows Server.

La herramienta permite supervisar continuamente la disponibilidad de una aplicación mediante validaciones HTTP y ejecutar un proceso controlado de recuperación cuando se detectan fallos consecutivos.

---

## Descripción

**Web-Service-AutoRecovery** fue desarrollado para reducir los tiempos de indisponibilidad de aplicaciones web y disminuir la intervención manual ante fallos recurrentes de un servicio.

El script realiza comprobaciones periódicas sobre una URL configurada y utiliza un umbral de fallos consecutivos para determinar cuándo debe iniciar un proceso de recuperación.

La recuperación contempla:

1. Detección de indisponibilidad.
2. Confirmación mediante fallos consecutivos.
3. Detención controlada del servicio.
4. Espera para garantizar la finalización del proceso.
5. Inicio del servicio.
6. Validación posterior del estado de la aplicación.
7. Reanudación del monitoreo.

El objetivo no es simplemente reiniciar un servicio cuando presenta un fallo, sino **detectar, recuperar y verificar que la aplicación vuelva a estar disponible**.

---

## Problema

En determinados entornos, una aplicación web puede dejar de responder mientras el servidor continúa operativo.

Cuando esto ocurre, la recuperación puede requerir intervención manual:

```text
Aplicación no disponible
        ↓
Detección manual
        ↓
Acceso al servidor
        ↓
Detener servicio
        ↓
Iniciar servicio
        ↓
Esperar arranque
        ↓
Comprobar aplicación
```

Este procedimiento puede generar tiempos de indisponibilidad innecesarios y requiere que un administrador intervenga cada vez que ocurre el incidente.

---

## Solución

La herramienta automatiza este procedimiento mediante un mecanismo de **Health Check + Failure Threshold + Recovery + Validation**.

```text
┌───────────────────────┐
│   Monitorización      │
│      HTTP/HTTPS       │
└───────────┬───────────┘
            │
            ▼
    ┌───────────────┐
    │ ¿HTTP 200?    │
    └───────┬───────┘
        Sí  │  No
            │
     ┌──────▼──────┐
     │ Incrementar  │
     │   contador   │
     └──────┬──────┘
            │
            ▼
    ┌─────────────────┐
    │ ¿Superó el      │
    │    umbral?      │
    └───────┬─────────┘
        No  │  Sí
            │
            ▼
   ┌──────────────────┐
   │ Iniciar proceso  │
   │ de recuperación  │
   └────────┬─────────┘
            │
            ▼
     ┌──────────────┐
     │ Detener      │
     │ servicio     │
     └──────┬───────┘
            │
            ▼
     ┌──────────────┐
     │ Iniciar      │
     │ servicio     │
     └──────┬───────┘
            │
            ▼
    ┌─────────────────┐
    │ Validar HTTP    │
    │ nuevamente      │
    └───────┬─────────┘
            │
            ▼
     ┌──────────────┐
     │ ¿Disponible? │
     └──────┬───────┘
            │
            ▼
   Reanudar monitoreo
```

También se incluye un diagrama visual del flujo dentro del directorio del proyecto.

---

## Características

* Monitoreo continuo mediante solicitudes HTTP.
* Validación del código de respuesta HTTP.
* Detección mediante fallos consecutivos.
* Umbral configurable de fallos.
* Timeout configurable para las solicitudes HTTP.
* Detención controlada mediante script BAT.
* Inicio controlado mediante script BAT.
* Espera entre las etapas de recuperación.
* Validación posterior al arranque.
* Restablecimiento del contador después de una recuperación exitosa.
* Manejo de excepciones durante el monitoreo y recuperación.
* Ejecución continua mientras el proceso permanezca activo.
* Visualización de la salida del proceso de arranque.

---

## Tecnologías

* **PowerShell**
* **Windows Server**
* **HTTP/HTTPS**
* **Windows CMD / BAT**
* **Web Service Monitoring**
* **IT Operations Automation**

---

## Requisitos

* Windows Server o sistema Windows compatible con PowerShell.
* PowerShell 5.1 o superior.
* Permisos suficientes para ejecutar los scripts de detención e inicio.
* Conectividad hacia la URL que será monitoreada.
* Script BAT para detener el servicio.
* Script BAT para iniciar el servicio.

> Las rutas y parámetros utilizados por el proyecto deben adaptarse al entorno donde será implementado.

---

## Configuración

Antes de ejecutar la herramienta deben configurarse los siguientes parámetros dentro del script.

### URL de monitoreo

```powershell
$url = "http://SERVER-IP:PORT/health"
```

La URL debe corresponder al endpoint que permita determinar la disponibilidad de la aplicación.

Actualmente, la herramienta considera que el servicio está disponible cuando recibe:

```text
HTTP 200
```

---

### Script de detención

```powershell
$stopBat = "C:\ruta\del\bat\stopserv.bat"
```

Este archivo debe contener el procedimiento necesario para detener correctamente el servicio o servidor de aplicaciones.

---

### Script de inicio

```powershell
$startBat = "C:\ruta\del\bat\startserv.bat"
```

Este archivo debe contener el procedimiento necesario para iniciar nuevamente el servicio.

---

### Intervalo de monitoreo

```powershell
$intervaloValidacion = 30
```

Define el tiempo, en segundos, entre cada validación HTTP durante el monitoreo normal.

---

### Umbral de fallos consecutivos

```powershell
$maxFallosConsecutivos = 2
```

Define cuántos fallos consecutivos deben producirse antes de iniciar la recuperación automática.

Por ejemplo:

```text
Validación 1 → FAIL → contador = 1
Validación 2 → FAIL → contador = 2
                         ↓
                 Iniciar recuperación
```

Una respuesta HTTP 200 reinicia el contador:

```text
FAIL → contador = 1
FAIL → contador = 2
OK   → contador = 0
```

---

## Ejecución

El script puede ejecutarse directamente desde PowerShell:

```powershell
.\Web-Service-AutoRecovery.ps1
```

Una vez iniciado, permanecerá ejecutándose y realizando validaciones periódicas sobre la URL configurada.

Ejemplo de funcionamiento:

```text
MONITOREO INICIADO
        ↓
Validación HTTP
        ↓
HTTP 200
        ↓
Servicio en línea
        ↓
Espera configurada
        ↓
Nueva validación
```

Cuando se alcanza el umbral de fallos:

```text
HTTP FAIL
    ↓
HTTP FAIL
    ↓
Umbral alcanzado
    ↓
Detener servicio
    ↓
Esperar
    ↓
Iniciar servicio
    ↓
Validar disponibilidad
    ↓
HTTP 200
    ↓
Reanudar monitoreo
```

---

## Proceso de recuperación

Cuando se alcanza el número configurado de fallos consecutivos, el script ejecuta la siguiente secuencia:

### 1. Detención

Ejecuta el BAT configurado para detener el servicio:

```powershell
Start-Process `
    -FilePath $stopBat `
    -WindowStyle Hidden `
    -Wait
```

El parámetro `-Wait` permite esperar a que finalice el proceso antes de continuar.

### 2. Espera

Se establece una pausa para permitir que el proceso de detención finalice correctamente.

### 3. Inicio

Se ejecuta el BAT de inicio mediante `cmd.exe`.

La consola permanece visible para permitir observar la salida generada durante el arranque del servidor o servicio.

### 4. Validación posterior

El script vuelve a consultar la URL periódicamente hasta obtener una respuesta HTTP 200.

### 5. Reanudación

Una vez recuperada la aplicación, el contador de fallos se restablece y el monitoreo continúa normalmente.

---

## Consideraciones de seguridad

Antes de utilizar la herramienta en un entorno productivo:

* Revisar completamente el código fuente.
* Validar los permisos requeridos por los scripts BAT.
* No almacenar credenciales directamente dentro del código.
* No publicar direcciones IP internas, URLs privadas, nombres de servidores o información corporativa.
* Utilizar endpoints de monitoreo apropiados para el entorno.
* Probar previamente el procedimiento de recuperación.
* Verificar que los scripts de detención e inicio sean seguros y estén correctamente controlados.
* Ejecutar la herramienta con el menor nivel de privilegios necesario.

**No se deben publicar en el repositorio valores reales pertenecientes a entornos corporativos.**

---

## Limitaciones actuales

La versión actual presenta las siguientes limitaciones:

* La disponibilidad se determina mediante el código de respuesta HTTP.
* Una respuesta HTTP 200 no garantiza que todos los componentes internos de la aplicación estén funcionando correctamente.
* La recuperación depende de scripts BAT externos.
* La herramienta está orientada principalmente a entornos Windows.
* El proceso de validación posterior al arranque continúa hasta detectar nuevamente disponibilidad HTTP.
* Actualmente no incorpora un sistema persistente de logging en archivos.
* No incorpora notificaciones externas por correo, Teams, Slack u otros canales.
* No utiliza almacenamiento externo para métricas históricas.

Estas limitaciones forman parte del alcance actual del proyecto y pueden abordarse en futuras versiones.

---

## Posibles mejoras

Como evolución futura, la herramienta podría incorporar:

* Health Checks más avanzados.
* Validación del contenido de la respuesta HTTP.
* Registro persistente de eventos.
* Rotación de logs.
* Sistema de alertas.
* Notificaciones por correo electrónico o webhook.
* Historial de incidentes y recuperaciones.
* Soporte para múltiples aplicaciones.
* Integración con plataformas de monitoreo.

---

## Estructura del proyecto

```text
Web-Service-AutoRecovery/
│
├── README.md
├── Web-Service-AutoRecovery.ps1
└── Flujo - Script monitoreo y autorecuperacion.png
```

---

## Licencia

Este proyecto está destinado a fines educativos, profesionales y de automatización de tareas de administración de sistemas.

El código puede ser utilizado, modificado y adaptado según las condiciones establecidas por la licencia del repositorio.

---

## Autor

**Alex Vicente Alcivar Moya**

Ingeniero en tecnologías de la información | Analisas de ciberseguridad | Seguridad de la información

* [Github](https://github.com/alexalcivarm7)
* [Linkedin](https://www.linkedin.com/in/alexalcivarm7/)
