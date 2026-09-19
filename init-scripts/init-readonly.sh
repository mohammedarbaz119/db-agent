#!/bin/bash
set -e

# Verify that the required environment variables are set
if [ -z "$DB_READONLY_USER" ] || [ -z "$DB_READONLY_PASSWORD" ]; then
    echo "Missing DB_READONLY_USER or DB_READONLY_PASSWORD. Skipping read-only user creation."
    exit 0
fi

echo "Creating read-only user: $DB_READONLY_USER"

# Execute SQL statements as the superuser
# PostgreSQL 14+ allows us to simply grant pg_read_all_data for universal read access
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER "$DB_READONLY_USER" WITH PASSWORD '$DB_READONLY_PASSWORD';
    GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO "$DB_READONLY_USER";
    GRANT pg_read_all_data TO "$DB_READONLY_USER";
EOSQL

echo "Read-only user created successfully."
