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

alter table only notes alter column id set default generate_id();

create table if not exists projects (
    id text primary key,
    title text not null,
    description text
);

alter table only projects alter column id set default generate_id();

create table if not exists parts (
    id text primary key,
    title text not null,
    description text,
    count_onhand integer not null default 0
);

alter table only parts alter column id set default generate_id();
alter table parts add column if not exists generic_type text default null;
alter table parts add column if not exists form_factor text default null;

create table if not exists containers (
    id text primary key,
    title text not null,
    location text
);

alter table only containers alter column id set default generate_id();

create table if not exists container_contents (
    id text primary key,
    container text not null,
    ptr_type text not null,
    ptr_id text not null
);

alter table only container_contents alter column id set default generate_id();
alter table container_contents drop constraint if exists container_contents_container_fk;
alter table container_contents add constraint container_contents_container_fk foreign key (container) references containers (id) on update cascade on delete cascade;

create table if not exists serial_lookup_apple (
    sn text primary key,
    model_identifier text,
    marketing_name text,
    model_family text,
    configuration_code text,
    updated timestamp not null default NOW()::timestamp
);

create table if not exists package_tracking (
    track_no text primary key,
    carrier text not null,
    notes text,
    completed boolean default false,
    marked timestamp,
    updated timestamp not null default NOW()::timestamp
);

alter table package_tracking add column if not exists direction text not null default 'incoming' check (direction = any (array['incoming', 'outgoing']));

create table if not exists package_tracking_updates (
    id text primary key,
    track_no text not null,
    status text not null,
    description text,
    updated timestamp not null default NOW()::timestamp
);

alter table only package_tracking_updates alter column id set default generate_id();
alter table package_tracking_updates drop constraint if exists package_tracking_updates_track_no_fk;
alter table package_tracking_updates add constraint package_tracking_updates_track_no_fk foreign key (track_no) references package_tracking (track_no) on update cascade on delete cascade;

create table if not exists images (
    id text primary key default generate_id(),
    original_name text not null,
    original_size_bytes bigint not null,
    width integer,
    height integer,
    image_fn text,
    thumb_fn text,
    updated timestamp not null default NOW()::timestamp
);

create table if not exists image_links (
    id text primary key default generate_id(),
    image text not null,
    ptr_type text not null,
    ptr_id text not null
);

alter table image_links drop constraint if exists image_links_image_fk;
alter table image_links add constraint image_links_image_fk foreign key (image) references images (id) on update cascade on delete cascade;

create table if not exists project_updates (
    id text primary key default generate_id(),
    project text not null,
    description text,
    created timestamp not null default NOW()::timestamp,
    updated timestamp not null default NOW()::timestamp
);

alter table project_updates drop constraint if exists project_updates_project_fk;
alter table project_updates add constraint project_updates_project_fk foreign key (project) references projects (id) on update cascade on delete cascade;
