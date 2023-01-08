#!/usr/bin/env sh

# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL 15 :
sudo dnf install -y postgresql15-server

# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl enable postgresql-15
sudo systemctl start postgresql-15

# Switch over to the postgres account on your server
psql -h localhost -p 5432 -U postgres

# Check your current connection information
\conninfo

# List Databases
\l

# Create a schema 
create schema taxi_yellow ;

# Add the new schema to the search path
set search_path to taxi_yellow, public;

# Verify current schema is set
SELECT current_schema();

# Create database 
CREATE DATABASE taxiny01-23;

# Close the connection
\q

# Reconnect 
psql -h localhost -p 5432 -U postgres -d taxiny01-23