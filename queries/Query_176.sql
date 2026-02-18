drop table if exists field_metadata;
drop table if exists model_metadata;
drop table if exists tbl_account;
--## model_metadata
create table if not exists model_metadata
(
    name        text      not null primary key,
    permissions json      not null,
    created_at  timestamp not null,
    updated_at  timestamp not null
);
--##
--## field_metadata
create table if not exists field_metadata
(
    name        text      not null,
    model       text      not null,
    kind        text      not null,
    is_computed boolean default false,
    value       text,
    assert      text,
    permissions json      not null,
    created_at  timestamp not null,
    updated_at  timestamp not null,
    primary key (model, name)
);
--## field_metadata foreign keys
alter table field_metadata
    add constraint field_metadata_model_fkey foreign key (model) references model_metadata;
--##
--

drop database aerp_test;
