--##
create table if not exists wanted_note_log
(
    id                uuid      not null primary key,
    message           text      not null,
    wanted_note_id    uuid      not null,
    changed_at        timestamp not null
);
--##