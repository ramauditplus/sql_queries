create table if not exists "user"
(
    id                  uuid      not null primary key,
    email               text      not null unique,
    mobile              text      not null unique,
    password            text      not null,
    full_name           text      not null,
    address             text,
    email_verified      boolean   not null default false,
    mobile_verified     boolean   not null default false,
    is_active           boolean   not null default false,
    created_at          timestamp not null,
    updated_at          timestamp not null
);
--##
create table if not exists otp_detail
(
    id          uuid        not null primary key,
    identity    text        not null unique,
    otp         text        not null,
    updated_at  timestamp   not null
);
--##
create table if not exists organization
(
    id            uuid      not null primary key,
    name          text      not null unique,
    full_name     text      not null,
    country       text      not null,
    book_begin    date      not null,
    gst_no        text,
    fp_code       int       not null,
    created_by    uuid      not null references "user",
    created_at    timestamp not null,
    updated_at    timestamp not null
);
--##
create table if not exists license
(
    serial_no       int         not null primary key,
    serial_key      text        not null unique,
    name            text        not null,
    license         json        not null,
    disk_serial     text,
    org_id          uuid,
    session_key     text,
    last_sync       timestamp,
    status          text,
    reason          text,
    created_by      uuid        not null references "user",
    created_at      timestamp   not null,
    updated_at      timestamp   not null
);
--##
create table if not exists key
(
    id          uuid        not null primary key,
    active      bool        not null default false,
    pub_key     text        not null,
    pvt_key     text        not null,
    created_at  timestamp   not null,
    updated_at  timestamp   not null
);
--##
create table if not exists cluster
(
    id         int       not null generated always as identity primary key,
    name       text      not null unique,
    access_id  text      not null,
    access_key text      not null,
    erp_host   text      not null,
    is_active  bool      not null default true,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##