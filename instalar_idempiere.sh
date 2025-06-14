#!/bin/bash
set -e

echo "📦 Construyendo e iniciando Docker..."
docker compose build
docker compose up -d

echo "✅ Instalación completa!"
echo "⏳ Espera 2 minutos mientras se instala la base de datos"
echo "🔗 Accede aquí 👉 http://localhost:8460"
