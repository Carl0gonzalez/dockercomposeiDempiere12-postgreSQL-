#!/bin/bash

set -e

echo "🔧 Inicializando entorno de iDempiere..."

# Variables por defecto
IDEMPIERE_HOME=${IDEMPIERE_HOME:-/opt/sas/60_idempiere}
JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
DB_SERVER=${IDEMPIERE_DB_SERVER:-db}
DB_PORT=${IDEMPIERE_DB_PORT:-5432}
DB_NAME=${IDEMPIERE_DB_NAME:-idempiere}
DB_PASS=${IDEMPIERE_DB_PASS:-adempiere}
DB_USER=${IDEMPIERE_DB_USER:-adempiere}

# Opcionalmente puedes definir IDEMPIERE_PORT y IDEMPIERE_ENV para construir DB_NAME si lo necesitas
# DB_NAME=${IDEMPIERE_PORT}_${IDEMPIERE_ENV}

echo "📄 Generando idempiereEnv.properties en $IDEMPIERE_HOME..."

cat << EOF > "$IDEMPIERE_HOME/idempiereEnv.properties"
# Archivo generado automáticamente

IDEMPIERE_HOME=$IDEMPIERE_HOME
JAVA_HOME=$JAVA_HOME
IDEMPIERE_JAVA_OPTIONS=-Xms1G -Xmx1G

ADEMPIERE_DB_TYPE=PostgreSQL
ADEMPIERE_DB_EXISTS=N
ADEMPIERE_DB_PATH=postgresql
ADEMPIERE_DB_SERVER=$DB_SERVER
ADEMPIERE_DB_PORT=$DB_PORT
ADEMPIERE_DB_NAME=$DB_NAME
ADEMPIERE_DB_SYSTEM=postgres
ADEMPIERE_DB_SYSTEM_PASSWORD=postgres
ADEMPIERE_DB_USER=$DB_USER
ADEMPIERE_DB_PASSWORD=$DB_PASS

ADEMPIERE_APPS_SERVER=0.0.0.0
ADEMPIERE_WEB_ALIAS=localhost
ADEMPIERE_WEB_PORT=8660
ADEMPIERE_SSL_PORT=8460

ADEMPIERE_KEYSTORE=$IDEMPIERE_HOME/keystore/myKeystore
ADEMPIERE_KEYSTOREWEBALIAS=adempiere
ADEMPIERE_KEYSTORECODEALIAS=adempiere
ADEMPIERE_KEYSTOREPASS=myPassword

ADEMPIERE_CERT_CN=localhost
ADEMPIERE_CERT_ORG=iDempiere Bazaar
ADEMPIERE_CERT_ORG_UNIT=iDempiereUser
ADEMPIERE_CERT_LOCATION=myTown
ADEMPIERE_CERT_STATE=CA
ADEMPIERE_CERT_COUNTRY=US

ADEMPIERE_MAIL_SERVER=localhost
ADEMPIERE_ADMIN_EMAIL=
ADEMPIERE_MAIL_USER=
ADEMPIERE_MAIL_PASSWORD=

ADEMPIERE_FTP_SERVER=localhost
ADEMPIERE_FTP_PREFIX=my
ADEMPIERE_FTP_USER=anonymous
ADEMPIERE_FTP_PASSWORD=user@host.com
EOF

cd "$IDEMPIERE_HOME"

echo "⏳ Esperando a que la base de datos esté lista en $DB_SERVER:$DB_PORT..."

until pg_isready -h "$DB_SERVER" -p "$DB_PORT" -U postgres > /dev/null 2>&1; do
  echo "🔁 Esperando conexión a PostgreSQL..."
  sleep 2
done

echo "✅ Base de datos disponible."

# Bandera para evitar reinstalación
if [ ! -f "$IDEMPIERE_HOME/.installed" ]; then
  echo "🚀 Ejecutando instalación silenciosa de iDempiere..."

  sh silent-setup-alt.sh
  sh utils/RUN_ImportIdempiere.sh
  sh utils/RUN_SyncDB.sh
  sh sign-database-build-alt.sh

  touch "$IDEMPIERE_HOME/.installed"
  echo "📦 Instalación completada correctamente."
else
  echo "🔁 Instalación ya detectada, omitiendo pasos de setup."
fi

echo "🚀 Iniciando servidor iDempiere..."
exec "$IDEMPIERE_HOME/idempiere-server.sh"

