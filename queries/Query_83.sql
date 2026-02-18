--##
alter table license
    alter column license set data type json,
    alter column license set not null;
--##
update license set license=(case when license->>'status' = 'active'
    then license::jsonb - 'status' || '{"is_active": true}'
    else license::jsonb - 'status' || '{"is_active": false}'
    end);
--##