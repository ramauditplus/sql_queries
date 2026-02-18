UPDATE organization
SET configuration = jsonb_set(
    configuration::jsonb,
    '{wanted_note_config,completed_status}',
    to_jsonb(ARRAY[configuration::jsonb->'wanted_note_config'->>'completed_status'])
)::json
WHERE configuration::jsonb->'wanted_note_config'->>'completed_status' IS NOT NULL;


--##
create table if not exists wanted_note_log
(
    id                uuid      not null primary key,
    message           text      not null,
    wanted_note_id    uuid      not null,
    changed_at        timestamp not null
);
--##
alter table wanted_note_log
    add constraint wanted_note_log_wanted_note_id_fkey foreign key (wanted_note_id) references wanted_note;
--##


select
        wn.id,
        wn.inventory_name,
        wn.inventory_id,
        log.message,
        log.changed_at
    from wanted_note wn
    left join wanted_note_log log
    on wn.id = log.wanted_note_id
    where wn.id = 'db8772e6-b132-402a-a8d3-601f04d12cd7';