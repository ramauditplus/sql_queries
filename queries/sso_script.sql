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
