--##
create table if not exists organization
(
    id                  int       not null generated always as identity primary key,
    user_id             uuid      not null,
    org_id              uuid      not null,
    created_at          timestamp not null,
    updated_at          timestamp not null
);
--##