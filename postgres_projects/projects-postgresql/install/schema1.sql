-- SCHEMA: health1

-- DROP SCHEMA IF EXISTS health1 ;

CREATE SCHEMA IF NOT EXISTS health1
    AUTHORIZATION postgres;

GRANT ALL ON SCHEMA  health1 TO health1;

GRANT ALL ON SCHEMA health1  TO postgres;

-- Database: hospitals

-- DROP DATABASE IF EXISTS "hospitals";

CREATE DATABASE "hospitals"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
