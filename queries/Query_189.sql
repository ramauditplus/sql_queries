SELECT
    created_at,
--     '2019-10-12 07:20:50.52Z'::timestamp AS date_alias  -- Single quotes for the value, simple alias for the name
    '2019-10-12 07:20:50.543210Z'::timestamp AS date_alias  -- Single quotes for the value, simple alias for the name

FROM
    account
LIMIT 10;

insert into account (created_at) values ('2019-10-12 07:20:50.543210Z');