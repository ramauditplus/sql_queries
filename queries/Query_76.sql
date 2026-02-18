alter table print_layout
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table print_layout
    alter changed_at drop default;
--##