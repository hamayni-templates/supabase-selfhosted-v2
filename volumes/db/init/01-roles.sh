#!/bin/bash
set -e
PW="${POSTGRES_PASSWORD:-changeme}"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticator') THEN
    CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD '${PW}';
  ELSE ALTER ROLE authenticator PASSWORD '${PW}';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'supabase_auth_admin') THEN
    CREATE ROLE supabase_auth_admin NOINHERIT CREATEROLE LOGIN PASSWORD '${PW}';
  ELSE ALTER ROLE supabase_auth_admin PASSWORD '${PW}';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'supabase_storage_admin') THEN
    CREATE ROLE supabase_storage_admin NOINHERIT CREATEROLE LOGIN PASSWORD '${PW}';
  ELSE ALTER ROLE supabase_storage_admin PASSWORD '${PW}';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'supabase_admin') THEN
    CREATE ROLE supabase_admin NOINHERIT CREATEROLE LOGIN PASSWORD '${PW}';
  ELSE ALTER ROLE supabase_admin PASSWORD '${PW}';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN CREATE ROLE anon NOLOGIN NOINHERIT; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN CREATE ROLE authenticated NOLOGIN NOINHERIT; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'supabase_replication_admin') THEN
    CREATE ROLE supabase_replication_admin LOGIN REPLICATION PASSWORD '${PW}';
  ELSE ALTER ROLE supabase_replication_admin PASSWORD '${PW}';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'supabase_read_only_user') THEN CREATE ROLE supabase_read_only_user NOLOGIN NOINHERIT; END IF;
  GRANT anon TO authenticator;
  GRANT authenticated TO authenticator;
  GRANT service_role TO authenticator;
  GRANT supabase_admin TO authenticator;
END \$\$;
EOSQL
echo "Supabase roles initialized"
