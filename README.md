# T24 Migration Repository

Este repositorio contiene la estructura, documentación y artefactos relacionados con la migración del core bancario T24 de la versión R13 a R24. Está diseñado para garantizar una transición organizada y eficiente, facilitando el desarrollo, las pruebas y el despliegue.

## Estructura del Repositorio

- **`/source-code`**: Código fuente de desarrollos personalizados.
  - `/routines`: Rutinas personalizadas en T24.
  - `/microservices`: Código fuente de microservicios.
  - `/core-extensions`: Extensiones del core bancario.
  - `/configurations`: Configuraciones relacionadas con los desarrollos.

- **`/artifacts`**: Artefactos generados tras el proceso de compilación.
  - `/routines`: JARs generados para rutinas.
  - `/microservices`: WARs de microservicios.
  - `/configs`: Configuraciones empaquetadas.
  - `/logs`: Registros de compilaciones y pruebas.

- **`/bcon-logs`**: Registros de cambios y versiones en formato BCON.
  - `/routines`: Logs para rutinas.
  - `/microservices`: Logs para microservicios.
  - `/global`: Logs globales de configuraciones.

- **`/docs`**: Documentación relacionada con el proyecto.
  - `architecture.md`: Descripción de la arquitectura.
  - `migration-plan.md`: Plan de migración detallado.
  - `development-guides.md`: Guías de desarrollo y codificación.
  - `changelog.md`: Registro de cambios.

- **`/scripts`**: Scripts automatizados para diversas tareas.
  - `/deployment`: Scripts de despliegue.
  - `/testing`: Scripts para pruebas.
  - `/utilities`: Herramientas de soporte.
  - `/migrations`: Scripts de migración.

- **`/environment`**: Configuraciones específicas para cada entorno.
  - `/dev`: Desarrollo.
  - `/qa`: Pruebas.
  - `/prod`: Producción.

## Cómo Contribuir
1. Sigue las guías en `docs/development-guides.md`.
2. Asegúrate de documentar cualquier cambio en `docs/changelog.md`.
3. Realiza pruebas antes de fusionar cambios en las ramas principales.

## Contacto
Para más información, contacta con el equipo técnico o revisa la documentación en la carpeta `docs`.
