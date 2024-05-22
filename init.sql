create table if not exists barcode_pointers (
    id text primary key,
    ptr_type text not null,
    ptr_id text not null
);

create table if not exists notes (
    id text primary key,
    title text not null,
    body text
);

create table if not exists projects (
    id text primary key,
    title text not null,
    description text
);

create table if not exists parts (
    id text primary key,
    title text not null,
    description text,
    count_onhand integer not null default 0
);

create table if not exists containers (
    id text primary key,
    title text not null,
    location text
);

create table if not exists container_contents (
    id text primary key,
    container text not null,
    ptr_type text not null,
    ptr_id text not null
);

create table if not exists serial_lookup_apple (
    sn text primary key,
    model_identifier text,
    marketing_name text,
    model_family text,
    configuration_code text,
    updated timestamp not null default NOW()::timestamp
);
