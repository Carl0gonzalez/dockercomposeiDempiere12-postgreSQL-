-- Cambiar la contraseña del usuario 'postgres' a 'postgres'
ALTER USER postgres WITH PASSWORD 'postgres';

-- Crear usuario adempiere si no existe
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'adempiere'
   ) THEN
      CREATE ROLE adempiere LOGIN PASSWORD 'adempiere';
   END IF;
END
$do$;

-- Habilitar extensión dblink solo si no existe
CREATE EXTENSION IF NOT EXISTS dblink;

-- Crear base de datos idempiere con dueño adempiere si no existe
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'idempiere'
   ) THEN
      PERFORM dblink_exec('dbname=postgres user=postgres password=postgres',
         'CREATE DATABASE idempiere OWNER adempiere');
   END IF;
END
$do$;

