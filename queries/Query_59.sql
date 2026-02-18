--##
create table if not exists organization
(
    id                      uuid        not null primary key,
    org_id                  uuid        not null unique,
    name                    text        not null,
    full_name               text        not null,
    access_key              text,
    access_key_valid_upto   timestamp,
    is_connect              boolean     not null,
    created_at              timestamp   not null,
    updated_at              timestamp   not null
);
--##