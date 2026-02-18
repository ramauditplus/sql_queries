--## create tally_account_map table
create table if not exists tally_account_map
(
	account_id          int       not null primary key,
	tally_name          text      not null,
	created_at          timestamp not null,
    updated_at          timestamp not null,
    created_by          int       not null,
    updated_by          int       not null
);
--##
alter table tally_account_map
    add constraint tally_account_map_account_id_fkey foreign key (account_id) references account,
    add constraint tally_account_map_created_by_fkey foreign key (created_by) references member,
    add constraint tally_account_map_updated_by_fkey foreign key (updated_by) references member;
--##