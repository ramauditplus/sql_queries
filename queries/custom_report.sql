create table if not exists custom_report
(
    id         uuid      not null primary key,
    name       text      not null,
    definition json      not null,
    members    int[],
    created_at timestamp not null,
    updated_at timestamp not null,
    changed_at timestamp not null,
    created_by int       not null,
    updated_by int       not null
);
