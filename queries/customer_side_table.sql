--##
create table if not exists organization
(
    id         uuid      not null primary key,
    name       text      not null,
    full_name  text      not null,
    org_url    text,
    access_key text,
    valid_upto timestamp,
    is_connect boolean   not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
create table if not exists customer
(
    id         uuid      not null primary key,
    mobile     text      not null,
    org_id     uuid      not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    unique (mobile, org_id)
);
--##
alter table if exists customer
    add constraint customer_org_id_fkey foreign key (org_id) references organization;
--##