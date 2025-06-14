# iDempiere 12 + PostgreSQL via Docker Compose

Este proyecto configura una instalación de iDempiere 12 utilizando Docker y Docker Compose. Es ideal para entornos de desarrollo y pruebas rápidas.

## 🚀 Requisitos

Asegúrate de tener instalado:

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Al menos 4 GB de RAM disponible para los contenedores
- Acceso a puertos locales `8480`, `8640`, y `5436` libres

## 📦 Servicios

- `idempiere`: Servidor de aplicaciones iDempiere (versión 12)
- `db`: PostgreSQL 15 configurado como backend de base de datos

## 🔧 Uso

1. Clona este repositorio:

```bash
git clone https://github.com/Carl0gonzalez/dockercomposeiDempiere12-postgreSQL-.git
cd idempiere12-docker
```

2. Inicia los contenedores:

```bash
./instalar_idempiere.sh
```

3. Accede a iDempiere desde tu navegador:

- http://localhost:8460
- Usuario: `SuperUser`
- Contraseña: `System`

## ⚠️ Instalación automática de plugins

> ⚠️ La instalación automática de plugins (como el plugin LCO Detailed Names) está en construcción.  
> Actualmente el contenedor genera el directorio `dropins`, pero el plugin debe instalarse manualmente si no se encuentra disponible en una URL pública estable.

## 📁 Estructura del proyecto

```
.
├── docker-compose.yml 
├── Dockerfile
├── install-plugins.sh
├── init-user.sql
├── instalar_idempiere.sh
├── entrypoint.sh
└── README.MD
```

## 🧪 Notas adicionales

- El contenedor de base de datos expone el puerto `5436`, y la contraseña del usuario `postgres` es `postgres`.
- Los datos persistentes se almacenan en volúmenes Docker (`pgdata` y `idempiere_data`).
- Si realizas cambios al script de instalación de plugins, asegúrate de reconstruir los contenedores con `--build`.
- Despues de la instalación inicial espera dos minutos (o anda a mirar el log del Contenedor de Idempiere para ver la magia) mientras se instala la base de datos.

## 📬 Contribuciones

Las contribuciones están abiertas. Puedes abrir un issue o enviar un pull request.

## 📄 Licencia

Este proyecto está bajo licencia MIT.  
