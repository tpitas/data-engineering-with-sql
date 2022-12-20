-- Create datawarehouses
-- 1 create schema
create schema dtwh_admin;

-- 2 create tables
-- table datawh
create table dtwh_admin.datawh (
    dtwh_id integer not null unique primary key,
    db_env_id integer not null,
    client_id integer not null,
    db_name text,
    db_host text,
    db_version text,
    description text,
    id integer,
    is_active bool not null,
    db_type_code text not null
);

-- table client
create table dtwh_admin.client(
    client_id integer not null primary key,
    client_name varchar(50),
    is_active bool not null
);

-- 3 insert 

-- 2 records into table datawh

insert into dtwh_admin.datawh(
	dtwh_id, db_env_id, client_id, db_name,db_host, db_version, description, id, is_active, db_type_code) values 
	(10,1,1010,'pitasare','pita',1,'regional hospital',1,true,'dev')
	(20,1,1011,'labesare','labe',1,'regional clinic',1,true,'dev');





