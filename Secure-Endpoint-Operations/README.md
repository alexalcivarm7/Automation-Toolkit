# Secure Endpoint Operations

Automatización de tareas de mantenimiento preventivo para estaciones de trabajo Windows.

## Descripción

En entornos corporativos es común encontrar equipos que presentan lentitud progresiva, congelamientos ocasionales o degradación de rendimiento, incluso disponiendo de recursos aparentemente suficientes.

Esto suele estar relacionado con la acumulación de:

- Archivos temporales del sistema.
- Archivos temporales de perfiles de usuario.
- Memory Standby List.
- Fragmentación y uso ineficiente de memoria por procesos de larga ejecución.

**Secure Endpoint Operations** fue desarrollado para automatizar estas tareas operativas mediante una solución ligera basada en Batch, PowerShell y Scheduled Tasks.

El objetivo no es reemplazar soluciones de monitoreo o administración empresarial, sino reducir actividades repetitivas de soporte a través de automatización controlada, trazable y segura.

---

## Problema

En operaciones de TI es habitual recibir incidentes asociados a:

- Lentitud general del sistema.
- Aplicaciones que tardan en responder.
- Congelamientos temporales.
- Reinicios frecuentes solicitados por usuarios.
- Intervenciones repetitivas del área de soporte.

Aunque muchos equipos disponen de:

```text
8 GB RAM
16 GB RAM
SSD/NVMe
Windows actualizado
```

la acumulación de temporales y memoria en espera (Standby Memory) puede generar una degradación progresiva de la experiencia del usuario.

---

## Solución

La solución implementa un proceso automatizado que:

✅ Limpia Windows Temp.

✅ Limpia archivos temporales de perfiles locales.

✅ Libera Working Sets.

✅ Libera Standby List.

✅ Genera registros de ejecución.

✅ Se ejecuta automáticamente mediante una tarea programada.

✅ Utiliza la cuenta NT AUTHORITY\SYSTEM.

✅ No requiere credenciales administrativas almacenadas.

✅ No requiere intervención del usuario final.

---

## Componentes

```text
Secure-Endpoint-Operations
│
├── Optimizador.bat
├── Instalar_Tarea.bat
└── Desinstalar_Optimizador.bat
```

### Optimizador.bat

Script principal encargado de:

- Limpieza de Windows Temp.
- Limpieza de temporales de perfiles locales.
- Liberación de memoria RAM.
- Generación de registros.

---

### Instalar_Tarea.bat

Instala automáticamente una tarea programada con las siguientes características:

```text
Nombre              : Endpoint Maintenance Automation
Cuenta              : NT AUTHORITY\SYSTEM
Privilegios         : Elevados
Inicio              : Al iniciar sesión
Frecuencia          : Cada 1 hora
```

Incluye:

- Validación de archivos requeridos.
- Detección de tareas existentes.
- Actualización automática de configuración.
- Validación final de instalación.

---

### Desinstalar_Optimizador.bat

Permite eliminar completamente la solución.

Realiza:

```text
- Eliminación de tarea programada.
- Eliminación de archivos operativos.
```

Conserva:

```text
Historial.log
```

para fines de auditoría.

---

## Dependencias

La herramienta requiere:

```text
EmptyStandbyList.exe
```

Ubicado junto a:

```text
Optimizador.bat
```

Esta utilidad es utilizada para:

```text
Working Sets
Standby List
```

---

## Instalación

### 1. Crear carpeta

```text
C:\LimpiezaProgramada
```

### 2. Copiar archivos

```text
Optimizador.bat
Instalar_Tarea.bat
Desinstalar_Optimizador.bat
EmptyStandbyList.exe
```

### 3. Ejecutar

```text
Instalar_Tarea.bat
```

como Administrador.

### 4. Verificar

Abrir:

```text
Programador de tareas
```

Ruta:

```text
Biblioteca del Programador de tareas
```

Validar que exista:

```text
Endpoint Maintenance Automation
```

---

## Registro y Auditoría

La herramienta genera automáticamente:

```text
C:\LimpiezaProgramada\Historial.log
```

Ejemplo:

```text
===================================================
EQUIPO: LAP-SBX-008
USUARIO CON SESION INICIADA: aalcivar
[vie 11/09/2026 17:41:16,18] INICIO DE EJECUCION
[vie 11/09/2026 17:41:31,13] EJECUCION FINALIZADA CORRECTAMENTE
===================================================
```

Los registros se eliminan automáticamente después de 30 días.

---

## Ventajas

### Operativas

- Reduce intervenciones manuales.
- Disminuye tickets relacionados con lentitud general.
- Estandariza tareas de mantenimiento.

### Técnicas

- Automatización completa.
- Ejecución silenciosa.
- Trazabilidad mediante logs.

### Seguridad

- No almacena credenciales.
- No depende de cuentas de dominio.
- Utiliza NT AUTHORITY\SYSTEM.

---

## Consideraciones

Esta solución debe utilizarse bajo criterios técnicos adecuados.

### Beneficios esperados

✅ Mantenimiento automatizado.

✅ Reducción de carga operativa.

✅ Eliminación de archivos temporales.

✅ Optimización periódica de memoria.

### Lo que NO hace

❌ No reemplaza una ampliación de RAM.

❌ No corrige problemas físicos de hardware.

❌ No corrige Memory Leaks.

❌ No sustituye herramientas de monitoreo empresarial.

---

## Criterio de Uso

La liberación periódica de memoria puede resultar especialmente útil en:

```text
Equipos de gama media
Entornos compartidos
Estaciones con alta carga operativa
Usuarios con largas jornadas de trabajo
```

Sin embargo, en equipos modernos con abundante memoria RAM, Windows suele gestionar eficientemente la Standby Memory para acelerar aplicaciones frecuentes.

Esta solución debe entenderse como una herramienta de automatización operativa y no como sustituto de una correcta gestión de hardware, monitoreo o capacity planning.

---

## Filosofía del Proyecto

La intención de este proyecto no fue desarrollar otro "limpiador de Windows".

El objetivo fue eliminar actividades repetitivas mediante:

- Automatización.
- Seguridad.
- Trazabilidad.
- Estandarización.
- Mejora continua.

Permitiendo que los equipos de TI dediquen más tiempo a actividades de mayor valor para la organización.

---

## Autor

**Alex Vicente Alcivar Moya**

Ingeniero en tecnologías de la información | Analista de ciberseguridad | Seguridad de la información

* GitHub: https://github.com/alexalcivarm7
* LinkedIn: https://www.linkedin.com/in/alexalcivarm7/
