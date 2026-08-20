# Web-Service-AutoRecovery

Script de monitoreo y autorrecuperación de servicios web desarrollado en PowerShell.

## Descripción

Este proyecto fue desarrollado con el objetivo de reducir los tiempos de indisponibilidad de una aplicación y minimizar la intervención manual ante fallos del servicio.

El script monitorea continuamente una URL mediante solicitudes HTTP y, al detectar una cantidad determinada de fallos consecutivos, ejecuta automáticamente una secuencia controlada de recuperación.

## Problema

En múltiples ocasiones era necesario interrumpir otras actividades para conectarse al servidor y realizar manualmente el proceso de recuperación cuando la aplicación dejaba de responder.

La necesidad de actuar rápidamente ante cada incidente motivó el desarrollo de una solución automatizada capaz de detectar la indisponibilidad y ejecutar una recuperación controlada.

## Solución

El script implementa un mecanismo de monitoreo y recuperación basado en los siguientes principios:

- Monitoreo continuo de disponibilidad HTTP.
- Validación de fallos consecutivos.
- Detención controlada del servicio.
- Inicio controlado del servicio.
- Verificación posterior al arranque.
- Prevención de reinicios simultáneos.
- Seguimiento de logs de arranque.

## Flujo de funcionamiento

```text
Monitoreo
    ↓
Consulta URL
    ↓
¿HTTP 200?
 ↙        ↘
Sí         No
 ↓          ↓
Continuar   Recuento de fallos
             ↓
     ¿Se alcanzó el límite?
             ↓
            Sí
             ↓
      Ejecutar STOP
             ↓
      Esperar finalización
             ↓
      Ejecutar START
             ↓
      Esperar HTTP 200
             ↓
      Reanudar monitoreo
