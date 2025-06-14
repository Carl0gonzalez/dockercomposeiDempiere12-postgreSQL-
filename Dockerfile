# Usa Java 17 como base
FROM openjdk:17-jdk-slim as base

# Variables de entorno
ENV IDEMPIERE_HOME=/opt/sas/60_idempiere \
    JAVA_HOME=/usr/local/openjdk-17 \
    PATH=$JAVA_HOME/bin:$PATH

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    dos2unix \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Crea directorio de trabajo
WORKDIR /opt

# Descarga última versión de iDempiere 12 (daily build)
RUN mkdir -p /opt/sas \
 && curl -L -o idempiere.zip \
    https://sourceforge.net/projects/idempiere/files/v12/daily-server/idempiereServer12Daily.gtk.linux.x86_64.zip/download \
 && unzip idempiere.zip -d /opt/ \
 && mv /opt/idempiere.gtk.linux.x86_64/idempiere-server $IDEMPIERE_HOME \
 && rm -rf idempiere.zip /opt/idempiere.gtk.linux.x86_64

# Crea carpeta dropins para plugins
RUN mkdir -p $IDEMPIERE_HOME/dropins

# Copia y ejecuta script para instalación de plugins
COPY install-plugins.sh /opt/install-plugins.sh
RUN chmod +x /opt/install-plugins.sh && /opt/install-plugins.sh

# Copia el entrypoint personalizado y corrige formato Unix
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh && dos2unix /opt/entrypoint.sh

# Expone puerto para iDempiere
EXPOSE 8080

# Define el entrypoint
ENTRYPOINT ["/opt/entrypoint.sh"]

