create table if not exists seaql_migrations
(
    version    varchar not null primary key,
    applied_at bigint  not null
);
--##
delete
from seaql_migrations;
--##
insert into seaql_migrations (version, applied_at)
values ('m20250807_060223_init', 1754563148),('m20250809_071403_e_invoice_eway', 1754564148);