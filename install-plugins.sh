#!/bin/bash

echo "👇 Instalando plugin LCO Detailed Names..."
mkdir -p /opt/idempiere/dropins
cd /opt/idempiere/dropins || exit 1

# Descargar el archivo directamente desde Jenkins
curl -fsSL -o org.globalqss.idempiere.LCO.detailednames.jar \
  https://jenkins.idempiere.org/job/globalqss-iDempiere-LCO/ws/org.globalqss.idempiere.LCO.detailednames/target/org.globalqss.idempiere.LCO.detailednames-11.0.0-SNAPSHOT.jar

if [ $? -eq 0 ]; then
  echo "✅ Plugin copiado correctamente a dropins/"
else
  echo "❌ Error al descargar el plugin"
  exit 1
fi

