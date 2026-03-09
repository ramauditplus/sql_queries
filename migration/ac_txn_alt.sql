ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
--##
create index on ac_txn (alt_account_id);
UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id;
--##
-- ACCOUNT
    alter table account drop column if exists id;
    alter table account rename column uuid_id to id;
    alter table account alter column id set not null;
    ALTER TABLE account ADD CONSTRAINT account_pkey PRIMARY KEY (id);
--##
    alter table ac_txn drop column if exists alt_account_id;
    alter table ac_txn rename column alt_account_uuid to alt_account_id;