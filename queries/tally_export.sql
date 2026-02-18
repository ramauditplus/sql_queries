--## create tally_account_map table
create table if not exists tally_account_map
(
	id                  int       not null primary key,
	name                text      not null,
    account_type_id     int       not null,
    account_type_name   text      not null,
    base_account_types  text[]    not null,
    contact_type        text      not null,
	tally_name          text      not null,
	created_at          timestamp not null,
    updated_at          timestamp not null,
    created_by          int       not null,
    updated_by          int       not null
);
--##
--## create tally_voucher_type_map table
create table if not exists tally_voucher_type_map
(
	id                  int       not null primary key,
    name                text      not null,
    base_type           text      not null,
    tally_name          text      not null,
	created_at          timestamp not null,
    updated_at          timestamp not null,
    created_by          int       not null,
    updated_by          int       not null
);
--##

ALTER TABLE tally_account_map ADD UNIQUE (tally_name);
ALTER TABLE tally_voucher_type_map ADD UNIQUE (tally_name);