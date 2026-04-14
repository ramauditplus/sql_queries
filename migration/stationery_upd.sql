create sequence if not exists oid_counter_seq;
--##
create or replace function oid() returns text as
$$
declare
    ts       bigint = extract(epoch from clock_timestamp())::bigint;
    ts_hex   text   = lpad(to_hex(ts), 8, '0');
    rand_hex text   = substr(md5(random()::text || ts::text || pg_backend_pid()::text || txid_current()::text), 1, 10);
    ctr      bigint = nextval('oid_counter_seq') % 16777216;
    ctr_hex  text   = lpad(to_hex(ctr), 6, '0');
begin
    return ts_hex || rand_hex || ctr_hex;
end;
$$ language plpgsql;
--##
select now() as time, 'MIGRATION START' as msg;
--##
select now() as time, 'general_migration_start' as msg;
-- REMOVE RECORDS RELATED TO UNWANTED TABLE

with a as (select voucher_id from sales_emi_reconciliation_voucher),
     b as ( delete from ac_txn using a where ac_txn.voucher_id = a.voucher_id),
     c as ( delete from bill_allocation using a where bill_allocation.voucher_id = a.voucher_id),
     d as ( delete from bank_txn using a where bank_txn.voucher_id = a.voucher_id),
     e as ( delete from inv_txn using a where inv_txn.voucher_id = a.voucher_id)
delete
from voucher using a
where voucher.id = a.voucher_id;

with a as (select voucher_id from customer_advance),
     b as ( delete from ac_txn using a where ac_txn.voucher_id = a.voucher_id),
     c as ( delete from bill_allocation using a where bill_allocation.voucher_id = a.voucher_id),
     d as ( delete from bank_txn using a where bank_txn.voucher_id = a.voucher_id),
     e as ( delete from inv_txn using a where inv_txn.voucher_id = a.voucher_id)
delete
from voucher using a
where voucher.id = a.voucher_id;

with a as (select voucher_id from gift_voucher),
     b as ( delete from ac_txn using a where ac_txn.voucher_id = a.voucher_id),
     c as ( delete from bill_allocation using a where bill_allocation.voucher_id = a.voucher_id),
     d as ( delete from bank_txn using a where bank_txn.voucher_id = a.voucher_id),
     e as ( delete from inv_txn using a where inv_txn.voucher_id = a.voucher_id)
delete
from voucher using a
where voucher.id = a.voucher_id;

with a as (select voucher_id from shipment),
     b as ( delete from ac_txn using a where ac_txn.voucher_id = a.voucher_id),
     c as ( delete from bill_allocation using a where bill_allocation.voucher_id = a.voucher_id),
     d as ( delete from bank_txn using a where bank_txn.voucher_id = a.voucher_id),
     e as ( delete from inv_txn using a where inv_txn.voucher_id = a.voucher_id)
delete
from voucher using a
where voucher.id = a.voucher_id;

--REMOVE FOREIGN KEY--

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT n.nspname, c.relname, con.conname
    FROM pg_constraint con
    JOIN pg_class c ON c.oid = con.conrelid
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE con.contype = 'f'
      AND n.nspname = 'public'
  LOOP
    EXECUTE format(
      'ALTER TABLE %I.%I DROP CONSTRAINT %I;',
      r.nspname, r.relname, r.conname
    );
  END LOOP;
END $$;

--REMOVE DEFAULT--

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT table_schema, table_name, column_name
    FROM information_schema.columns
    WHERE column_default IS NOT NULL
      AND column_name <> 'id'
      AND is_identity = 'NO'
      AND table_schema = 'public'
  LOOP
    EXECUTE format(
      'ALTER TABLE %I.%I ALTER COLUMN %I DROP DEFAULT;',
      r.table_schema,
      r.table_name,
      r.column_name
    );
  END LOOP;
END $$;

--REMOVE TRIGGER--


DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT event_object_schema,
           event_object_table,
           trigger_name
    FROM information_schema.triggers
    WHERE trigger_schema = 'public'
  LOOP
    EXECUTE format(
      'DROP TRIGGER IF EXISTS %I ON %I.%I;',
      r.trigger_name,
      r.event_object_schema,
      r.event_object_table
    );
  END LOOP;
END $$;

--REMOVE TRIGGER FUNCTION--

DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT
      n.nspname AS schema_name,
      p.proname AS function_name,
      pg_get_function_identity_arguments(p.oid) AS args
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.prorettype = 'pg_catalog.trigger'::regtype
  LOOP
    EXECUTE format(
      'DROP FUNCTION IF EXISTS %I.%I(%s);',
      r.schema_name,
      r.function_name,
      r.args
    );
  END LOOP;
END $$;

--REMOVE VIEWS--

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT viewname
        FROM pg_views
        WHERE schemaname = 'public'
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS public.' || quote_ident(r.viewname) || ' CASCADE';
    END LOOP;
END $$;
--##

--## ORGANIZATION
alter table organization
    add if not exists oid_id text,
    add if not exists created_by text,
    add if not exists updated_by text,
    add if not exists email_config jsonb;
    -- add if not exists udf_wanted_item_config jsonb;
--##
UPDATE organization SET oid_id = oid() where true;
--##
alter table organization
    alter column configuration type jsonb using configuration::jsonb,
    alter column license_claims type jsonb using license_claims::jsonb;
--##
UPDATE organization
SET email_config = configuration -> 'email_config',
    configuration = configuration - 'email_config'
WHERE configuration IS NOT NULL
  AND configuration ? 'email_config';
--##
-- UPDATE organization
-- SET udf_wanted_item_config = configuration -> 'wanted_note_config',
--    configuration = configuration - 'wanted_note_config'
-- WHERE configuration IS NOT NULL
--  AND configuration ? 'wanted_note_config';
--## ORGANIZATION

--## GSTR_2B
drop table if exists gstr_2b;
--##
create table gstr_2b
(
    ctin       text             not null,
    trdnm      text             not null,
    inum       text             not null,
    dt         date             not null,
    val        double precision not null,
    txval      double precision not null,
    igst       double precision not null,
    cgst       double precision not null,
    sgst       double precision not null,
    cess       double precision not null,
    created_at timestamp        not null,
    created_by text             not null
);
--## GSTR_2B

--## PERMISSION
drop table if exists permission;
--##
create table if not exists permission
(
    name       text primary key,
    created_by text      not null,
    updated_by text      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
--## permission insert
insert into permission (name, created_by, updated_by, created_at, updated_at)
values
    --account
    ('account_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --account_type
    ('account_type_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_type_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_type_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_type_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_type_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --bank_beneficiary
    ('bank_beneficiary_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_beneficiary_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_beneficiary_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_beneficiary_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_beneficiary_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --base_voucher_type
    ('base_voucher_type_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('base_voucher_type_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('base_voucher_type_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('base_voucher_type_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --batch
    ('batch_label', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('batch_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('batch_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --bill_allocation_breakup
    ('bill_allocation_breakup', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --bill_of_material
    ('bill_of_material_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bill_of_material_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bill_of_material_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bill_of_material_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bill_of_material_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --branch
    ('branch_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('branch_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('branch_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('branch_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('branch_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --gst_registration
    ('gst_registration_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gst_registration_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gst_registration_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gst_registration_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gst_registration_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --gst_tax
    ('gst_tax_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --gstr_2b
    ('gstr_2b_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gstr_2b_reconcile', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gstr_2b_upload', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --section
    ('section_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('section_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('section_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('section_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('section_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --inventory_category
    ('inventory_category_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_category_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_category_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_category_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_category_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --inventory_sub_category
    ('inventory_sub_category_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_sub_category_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_sub_category_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_sub_category_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_sub_category_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --inventory
    ('inventory_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --inventory_opening
    ('inventory_opening', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --unit_conversion
    ('unit_conversion_set', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --unit
    ('unit_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('unit_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('unit_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('unit_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('unit_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --financial_report
    ('financial_report', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('opening_balance_difference', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --financial_year
    ('financial_year_add', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('financial_year_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('financial_year_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --manufacturer
    ('manufacturer_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('manufacturer_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('manufacturer_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('manufacturer_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('manufacturer_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --warehouse
    ('warehouse_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('warehouse_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('warehouse_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('warehouse_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('warehouse_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --member
    ('member_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('member_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('member_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('member_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --permission
    ('permission_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('permission_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('permission_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('permission_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('permission_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --tds_nature_of_payment
    ('tds_nature_of_payment_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('tds_nature_of_payment_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('tds_nature_of_payment_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('tds_nature_of_payment_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('tds_nature_of_payment_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --tds_section_breakup
    ('tds_section_breakup', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --print_layout
    ('print_layout_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_layout_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_layout_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_layout_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --print_template
    ('print_template_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_template_reset', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_template_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_template_cancel', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('print_template_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --stock_location
    ('stock_location_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_location_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_location_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_location_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_location_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_location_assign', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --set_inventory_branch_price_configuration
    ('price_configuration_set', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --organization
    ('organization_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('organization_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --voucher_register
    ('voucher_register_detail', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_register_group', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --voucher_type
    ('voucher_type_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_type_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_type_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_type_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_type_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --voucher
    ('voucher_create', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_update', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_get', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_cancel', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('voucher_delete', '677485800000000000000000', '677485800000000000000000', now(), now()),
    --report and other
    ('account_book', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_outstanding', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_transaction_history', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bill_outstanding', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_collection', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_list', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('gst_r1', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('day_book', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('bank_reconciliation', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('sale_analysis', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('stock_analysis', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('expiry_analysis', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('negative_stock_analysis', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('non_movement_analysis', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_batch', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_book', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('inventory_transaction_history', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('memorandum', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('partywise_detail', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('get_batch_detail_with_stock_location', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('get_inventory_branch_stock_location_label', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('get_stock_location_wise_branch_stock', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('get_transfer_pending', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('account_opening', '677485800000000000000000', '677485800000000000000000', now(), now()),
    ('tds_detail', '677485800000000000000000', '677485800000000000000000', now(), now());
    -- wanted_item_config
    -- ('wanted_item_configuration', '677485800000000000000000', '677485800000000000000000', now(), now()),
    -- ('wanted_item_status', '677485800000000000000000', '677485800000000000000000', now(), now());
--## PERMISSION

--## SECTION
drop table if exists section;
--##
create table if not exists section
(
    id         text       not null primary key,
    old_id     int,
    name       text       not null,
    created_by text       not null,
    updated_by text       not null,
    created_at timestamp  not null,
    updated_at timestamp  not null
);
--##
INSERT INTO section
SELECT oid(), id, name, '677485800000000000000000', '677485800000000000000000', created_at, updated_at
FROM category_option
where category_id = 'INV_CAT1';
--## SECTION

--## INVENTORY_CATEGORY
drop table if exists inventory_category;
--##
create table if not exists inventory_category
(
    id         text       not null primary key,
    old_id     int,
    name       text       not null,
    created_by text       not null,
    updated_by text       not null,
    created_at timestamp  not null,
    updated_at timestamp  not null
);
--##
INSERT INTO inventory_category
SELECT oid(), id, name, '677485800000000000000000', '677485800000000000000000', created_at, updated_at
FROM category_option
where category_id = 'INV_CAT2';
--## INVENTORY_CATEGORY

--## INVENTORY_SUB_CATEGORY
drop table if exists inventory_sub_category;
--##
create table if not exists inventory_sub_category
(
    id         text       not null primary key,
    old_id     int,
    name       text       not null,
    created_by text       not null,
    updated_by text       not null,
    created_at timestamp  not null,
    updated_at timestamp  not null
);
--##
INSERT INTO inventory_sub_category
SELECT oid(), id, name, '677485800000000000000000', '677485800000000000000000', created_at, updated_at
FROM category_option
where category_id = 'INV_CAT3';
--## INVENTORY_SUB_CATEGORY

--## UNIT AND UNIT_CONVERSION
drop table if exists unit;
create table unit
(
    id         text      not null primary key,
    name       text      not null,
    uqc        text      not null,
    symbol     text      not null,
    precision  integer   not null,
    created_by text      not null,
    updated_by text      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
drop table if exists unit_conversion;
create table unit_conversion
(
    primary_unit_id    text  not null,
    conversion_unit_id text  not null,
    conversion         float not null,
    primary key (primary_unit_id, conversion)
);
--##
with a as (select distinct retail_qty
           from batch
           order by retail_qty)
insert
into unit
select oid(),
       a.retail_qty::text || 'S',
       'OTH',
       a.retail_qty::text,
       1,
       '677485800000000000000000',
       '677485800000000000000000',
       now(),
       now()
from a;
--##
insert into unit_conversion
select (select u.id from unit u where symbol = '1'), id, symbol::float
from unit;
--##

--## BASE_VOUCHER_TYPE
drop table if exists base_voucher_type;
--##
create table if not exists base_voucher_type
(
    base_type text  not null primary key,
    name text       not null,
    is_default bool not null
);
--##
insert into base_voucher_type (base_type, name, is_default)
values ('PAYMENT', 'Payment', true),
       ('RECEIPT', 'Receipt', true),
       ('CONTRA', 'Contra', true),
       ('JOURNAL', 'Journal', true),
       ('SALE', 'Sale', true),
       ('CREDIT_NOTE', 'Credit Note', true),
       ('PURCHASE', 'Purchase', true),
       ('DEBIT_NOTE', 'Debit Note', true),
       ('SALE_QUOTATION', 'Sale Quotation', true),
       ('STOCK_JOURNAL', 'Stock Journal', true),
       ('GOODS_INWARD_NOTE', 'Goods Inward Note', true),
       ('DELIVERY_NOTE', 'Delivery Note', true),
       ('DELIVERY_RECEIPT', 'Delivery Receipt', true);
--##
--## BASE_VOUCHER_TYPE

--## GST_TAX
drop table if exists gst_tax;
--##
create table if not exists gst_tax
(
    name                       text  primary key,
    display_name               text  not null,
    igst                       float not null,
    cgst                       float not null,
    sgst                       float not null,
    cgst_payable_account_id    text   not null,
    sgst_payable_account_id    text   not null,
    igst_payable_account_id    text   not null,
    cgst_receivable_account_id text   not null,
    sgst_receivable_account_id text   not null,
    igst_receivable_account_id text   not null
);
--##
insert into gst_tax
(name, display_name, igst, cgst, sgst, cgst_payable_account_id, sgst_payable_account_id, igst_payable_account_id,
 cgst_receivable_account_id, sgst_receivable_account_id, igst_receivable_account_id)
values ('gstna', 'Not Applicable', 0.0, 0.0, 0.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gstexempt', 'Exempt', 0.0, 0.0, 0.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gstngs', 'Non Gst Supply', 0.0, 0.0, 0.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst0', 'Gst 0%', 0.0, 0.0, 0.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst0p1', 'Gst 0.1%', 0.1, 0.05, 0.05, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst0p25', 'Gst 0.25%', 0.25, 0.125, 0.125, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst1', 'Gst 1%', 1.0, 0.5, 0.5, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst1p5', 'Gst 1.5%', 1.50, 0.75, 0.75, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst3', 'Gst 3%', 3.0, 1.5, 1.5, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst5', 'Gst 5%', 5.0, 2.5, 2.5, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst6', 'Gst 6%', 6.0, 3.0, 3.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst7p5', 'Gst 7.5%', 7.5, 3.75, 3.75, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst12', 'Gst 12%', 12.0, 6.0, 6.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst18', 'Gst 18%', 18.0, 9.0, 9.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst28', 'Gst 28%', 28.0, 14.0, 14.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000'),
       ('gst40', 'Gst 40%', 40.0, 20.0, 20.0, '679c12800000000000000000', '679d64000000000000000000', '679eb5800000000000000000', '67a158800000000000000000', '67a2aa000000000000000000', '67a3fb800000000000000000');
--## GST_TAX

--## UQC
create table if not exists uqc
(
    id   text primary key,
    name text not null
);
--##
insert into uqc (id, name)
values ('BAG', 'BAG-BAGS'),
       ('BAL', 'BAL-BALE'),
       ('BDL', 'BDL-BUNDLES'),
       ('BKL', 'BKL-BUCKLES'),
       ('BOU', 'BOU-BILLION OF UNITS'),
       ('BOX', 'BOX-BOX'),
       ('BTL', 'BTL-BOTTLES'),
       ('BUN', 'BUN-BUNCHES'),
       ('CAN', 'CAN-CANS'),
       ('CBM', 'CBM-CUBIC METERS'),
       ('CCM', 'CCM-CUBIC CENTIMETERS'),
       ('CMS', 'CMS-CENTIMETERS'),
       ('CTN', 'CTN-CARTONS'),
       ('DOZ', 'DOZ-DOZENS'),
       ('DRM', 'DRM-DRUMS'),
       ('GGK', 'GGK-GREAT GROSS'),
       ('GMS', 'GMS-GRAMMES'),
       ('GRS', 'GRS-GROSS'),
       ('GYD', 'GYD-GROSS YARDS'),
       ('KGS', 'KGS-KILOGRAMS'),
       ('KLR', 'KLR-KILOLITRE'),
       ('KME', 'KME-KILOMETRE'),
       ('LTR', 'LTR-LITRES'),
       ('MLT', 'MLT-MILILITRE'),
       ('MTR', 'MTR-METERS'),
       ('MTS', 'MTS-METRIC TON'),
       ('NOS', 'NOS-NUMBERS'),
       ('PAC', 'PAC-PACKS'),
       ('PCS', 'PCS-PIECES'),
       ('PRS', 'PRS-PAIRS'),
       ('QTL', 'QTL-QUINTAL'),
       ('ROL', 'ROL-ROLLS'),
       ('SET', 'SET-SETS'),
       ('SQF', 'SQF-SQUARE FEET'),
       ('SQM', 'SQM-SQUARE METERS'),
       ('SQY', 'SQY-SQUARE YARDS'),
       ('TBS', 'TBS-TABLETS'),
       ('TGM', 'TGM-TEN GROSS'),
       ('THD', 'THD-THOUSANDS'),
       ('TON', 'TON-TONNES'),
       ('TUB', 'TUB-TUBES'),
       ('UGS', 'UGS-US GALLONS'),
       ('UNT', 'UNT-UNITS'),
       ('YDS', 'YDS-YARDS'),
       ('OTH', 'OTH-OTHERS');
--##
--## UQC
ALTER TABLE warehouse ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE manufacturer ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
drop table if exists bank;
--##
create table bank
(
    id         text not null primary key,
    name       text not null,
    code       text not null,
    short_name text not null,
    e_banking  boolean
);
--##
INSERT INTO bank (id, name, code, short_name, e_banking)
VALUES
(oid(), 'Axis Bank', 'UTIB', 'AXIS', NULL),
(oid(), 'Canara Bank', 'CNRB', 'CANARA', NULL),
(oid(), 'HDFC Bank', 'HDFC', 'HDFC', NULL),
(oid(), 'ICICI Bank Ltd', 'ICIC', 'ICICI', NULL),
(oid(), 'IDBI Bank', 'IBKL', 'IDBI', NULL),
(oid(), 'Indian Bank', 'IDIB', 'INDIAN', NULL),
(oid(), 'Indian Overseas Bank', 'IOBA', 'IOB', NULL),
(oid(), 'Karur Vysya Bank', 'KVBL', 'KVB', NULL),
(oid(), 'State Bank of India', 'SBIN', 'SBI', NULL),
(oid(), 'Tamilnad Mercantile Bank Ltd', 'TMBL', 'TMB', true),
(oid(), 'Vijaya Bank', 'VIJB', 'VIJAYA', NULL),
(oid(), 'Punjab National Bank', 'PUNB', 'PUNB', NULL);
--##
-- alter table bank add unique (code);
-- alter table bank add unique (name);
--##
drop table if exists bank_beneficiary;
--##
create table bank_beneficiary
(
    id                text      not null primary key,
    name              text      not null,
    code              text      not null,
    bank_id           text      not null,
    bank_account_type text      not null,
    bank_account_no   text      not null,
    branch_name       text,
    ifs_code          text,
    micr_code         text,
    bsr_code          text,
    branch_code       text,
    created_at        timestamp not null,
    updated_at        timestamp not null,
    created_by        text      not null,
    updated_by        text      not null
);
--##
drop table if exists device;
--##
create table if not exists device
(
    id         text      not null primary key,
    name       text      not null,
    branch_id  text      not null,
    session_id text,
    expired_at timestamp,
    created_by text      not null,
    updated_by text      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
drop table if exists bill_of_material;
--##
create table bill_of_material
(
    id           text      not null primary key,
    name         text      not null,
    inventory_id text      not null,
    created_at   timestamp not null,
    updated_at   timestamp not null,
    created_by   text      not null,
    updated_by   text      not null
);
--##
ALTER TABLE member ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE division ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
UPDATE member SET oid_id = '677485800000000000000000' WHERE id = 1;
alter table member alter column remote_access set not null;
--##
select now() as time, 'SETTING UUID AS COLUMN STARTS' as msg;
--##
ALTER TABLE account_type ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
    UPDATE account_type SET oid_id = '6775d7000000000000000000' WHERE id = 1;
    UPDATE account_type SET oid_id = '677728800000000000000000' WHERE id = 2;
    UPDATE account_type SET oid_id = '67787a000000000000000000' WHERE id = 3;
    UPDATE account_type SET oid_id = '6779cb800000000000000000' WHERE id = 4;
    UPDATE account_type SET oid_id = '677b1d000000000000000000' WHERE id = 5;
    UPDATE account_type SET oid_id = '677c6e800000000000000000' WHERE id = 6;
    UPDATE account_type SET oid_id = '677dc0000000000000000000' WHERE id = 7;
    UPDATE account_type SET oid_id = '677f11800000000000000000' WHERE id = 8;
    UPDATE account_type SET oid_id = '678063000000000000000000' WHERE id = 9;
    UPDATE account_type SET oid_id = '6781b4800000000000000000' WHERE id = 10;
    UPDATE account_type SET oid_id = '678306000000000000000000' WHERE id = 11;
    UPDATE account_type SET oid_id = '678457800000000000000000' WHERE id = 12;
    UPDATE account_type SET oid_id = '6785a9000000000000000000' WHERE id = 13;
    UPDATE account_type SET oid_id = '6786fa800000000000000000' WHERE id = 14;
    UPDATE account_type SET oid_id = '67884c000000000000000000' WHERE id = 15;
    UPDATE account_type SET oid_id = '67899d800000000000000000' WHERE id = 16;
    UPDATE account_type SET oid_id = '678aef000000000000000000' WHERE id = 17;
    UPDATE account_type SET oid_id = '678c40800000000000000000' WHERE id = 18;
    UPDATE account_type SET oid_id = '678d92000000000000000000' WHERE id = 19;
    UPDATE account_type SET oid_id = '678ee3800000000000000000' WHERE id = 20;
    UPDATE account_type SET oid_id = '679035000000000000000000' WHERE id = 21;
    UPDATE account_type SET oid_id = '679186800000000000000000' WHERE id = 22;
    UPDATE account_type SET oid_id = '6792d8000000000000000000' WHERE id = 23;
    UPDATE account_type SET oid_id = '679429800000000000000000' WHERE id = 24;
    UPDATE account_type SET oid_id = '67957b000000000000000000' WHERE id = 25;
    UPDATE account_type SET oid_id = '6796cc800000000000000000' WHERE id = 26;
--##
ALTER TABLE account_type ADD COLUMN IF NOT EXISTS parent_oid text;
--##
UPDATE account_type b SET parent_oid = a.oid_id FROM account_type a WHERE a.id = b.parent_id;
--##
ALTER TABLE account ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_oid text;
--##
    UPDATE account SET oid_id = '67981e000000000000000000', account_type_oid = '678aef000000000000000000' WHERE id = 1;
    UPDATE account SET oid_id = '67996f800000000000000000', account_type_oid = '677b1d000000000000000000' WHERE id = 2;
    UPDATE account SET oid_id = '679ac1000000000000000000', account_type_oid = '677f11800000000000000000' WHERE id = 3;
    UPDATE account SET oid_id = '679c12800000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 4;
    UPDATE account SET oid_id = '679d64000000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 5;
    UPDATE account SET oid_id = '679eb5800000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 6;
    UPDATE account SET oid_id = '67a007000000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 7;
    UPDATE account SET oid_id = '67a158800000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 8;
    UPDATE account SET oid_id = '67a2aa000000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 9;
    UPDATE account SET oid_id = '67a3fb800000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 10;
    UPDATE account SET oid_id = '67a54d000000000000000000', account_type_oid = '679186800000000000000000' WHERE id = 11;
    UPDATE account SET oid_id = '67a69e800000000000000000', account_type_oid = '6779cb800000000000000000' WHERE id = 12;
    UPDATE account SET oid_id = '67a7f0000000000000000000', account_type_oid = '677dc0000000000000000000' WHERE id = 13;
    UPDATE account SET oid_id = '67a941800000000000000000', account_type_oid = '6779cb800000000000000000' WHERE id = 14;
    UPDATE account SET oid_id = '67aa93000000000000000000', account_type_oid = '677728800000000000000000' WHERE id = 15;
    UPDATE account SET oid_id = '67abe4800000000000000000', account_type_oid = '678457800000000000000000' WHERE id = 16;
    UPDATE account SET oid_id = '67ad36000000000000000000', account_type_oid = '677728800000000000000000' WHERE id = 17;
    UPDATE account SET oid_id = '67ae87800000000000000000', account_type_oid = '6779cb800000000000000000' WHERE id = 18;
    UPDATE account SET oid_id = '67afd9000000000000000000', account_type_oid = '67787a000000000000000000' WHERE id = 19;
    UPDATE account SET oid_id = '67b12a800000000000000000', account_type_oid = '679429800000000000000000' WHERE id = 20;
--##
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE gst_registration ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE branch
    add if not exists oid_id      text DEFAULT oid(),
    add if not exists account_oid text,
    add if not exists gst_registration_oid text;
--##
update branch b set gst_registration_oid = a.oid_id from gst_registration a where a.id = b.gst_registration_id;
--##
update branch b set account_oid = a.oid_id from account a where a.id = b.account_id;
--##
ALTER TABLE branch ADD COLUMN IF NOT EXISTS members_oid text[];
UPDATE branch t
        SET members_oid =
                (SELECT array_agg(member.oid_id)
                 FROM unnest(t.members) AS u(class_id)
                          JOIN member
                               ON member.id = u.class_id)
        WHERE t.members IS NOT NULL;
--##
ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
    UPDATE voucher_type SET oid_id = '67b27c000000000000000000' WHERE id = 1;
    UPDATE voucher_type SET oid_id = '67b3cd800000000000000000' WHERE id = 2;
    UPDATE voucher_type SET oid_id = '67b51f000000000000000000' WHERE id = 3;
    UPDATE voucher_type SET oid_id = '67b670800000000000000000' WHERE id = 4;
    UPDATE voucher_type SET oid_id = '67b7c2000000000000000000' WHERE id = 5;
    UPDATE voucher_type SET oid_id = '67b913800000000000000000' WHERE id = 6;
    UPDATE voucher_type SET oid_id = '67ba65000000000000000000' WHERE id = 7;
    UPDATE voucher_type SET oid_id = '67bbb6800000000000000000' WHERE id = 8;
    UPDATE voucher_type SET oid_id = '67bd08000000000000000000' WHERE id = 9;
    UPDATE voucher_type SET oid_id = '67be59800000000000000000' WHERE id = 10;
    UPDATE voucher_type SET oid_id = '67bfab000000000000000000' WHERE id = 17;
    UPDATE voucher_type SET oid_id = '67c0fc800000000000000000' WHERE id = 21;
    UPDATE voucher_type SET oid_id = '67c24e000000000000000000' WHERE id = 23;
    alter table voucher_type alter column config type jsonb using config::jsonb;
--##
UPDATE voucher_type
SET config = (SELECT jsonb_object_agg(
                             key,
                             value_cleaned
                     )
              FROM jsonb_each(config) t(key, value)
                       CROSS JOIN LATERAL (
                  SELECT jsonb_strip_nulls(
                                 value
                                     - 'allowed_expense_accounts'
                                     - 'allowed_credit_accounts'
                                     - 'allowed_emi_accounts'
                                     - 'allowed_card_accounts'
                                     - 'exchange_account'
                                     - 'shipping_charge_account'
                                     - 'by_accounts'
                                     - 'to_accounts'
                                     - 'default_print_template'
                                     - 'cheque_print_template'
                                     - 'approvers'
                         )
                  ) AS cleaned(value_cleaned));
--##
UPDATE voucher_type SET config = config -> lower(base_type) WHERE config ? lower(base_type);
--##
UPDATE voucher_type
SET config = config -> 'inventory'
WHERE base_type IN ('PURCHASE', 'SALE', 'CREDIT_NOTE', 'DEBIT_NOTE')
  AND config ? 'inventory';
--##
UPDATE voucher_type SET name = 'Stock Journal', base_type = 'STOCK_JOURNAL' WHERE id = 10;
--##
UPDATE voucher_type vt
        SET members = (SELECT jsonb_agg(
                                      jsonb_set(
                                              elem,
                                              '{member_id}',
                                              jsonb_build_object(
                                                      '$text',
                                                      m.oid_id
                                              )
                                      )
                              )
                       FROM jsonb_array_elements(vt.members) elem
                                JOIN member m
                                     ON m.id = (elem ->> 'member_id')::int)
        WHERE vt.members IS NOT NULL;
--##
ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS sequence_oid text;
        UPDATE voucher_type b SET sequence_oid = a.oid_id FROM voucher_type a WHERE a.id = b.sequence_id;
--##
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE sales_person ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
--##
ALTER TABLE tds_nature_of_payment  ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();

--## MODIFY_TABLE
drop table if exists vendor_bill_map;
drop table if exists vendor_item_map;
drop table if exists wanted_note;
--
drop table if exists doctor;
-- alter table doctor rename to udm_doctor;
--     alter table udm_doctor drop if exists display_name;
--     alter table udm_doctor drop if exists alias_name;
--     alter table udm_doctor drop if exists age;
drop table if exists drug_classification;
drop table if exists inventory_composition;
--
alter table pos_counter rename to udm_pos_counter;
alter table pos_counter_session rename to udm_pos_session;
alter table pos_counter_settlement rename to udm_pos_counter_settlement;
--

--
--## f_key
-- alter table udm_vendor_bill_map
--     rename constraint vendor_bill_map_pkey to udm_vendor_bill_map_pkey;
-- alter table udm_vendor_item_map
--     rename constraint vendor_item_map_pkey to udm_vendor_item_map_pkey;
-- alter table udm_doctor
--     rename constraint doctor_pkey to udm_doctor_pkey;
-- alter table udm_drug_classification
--     rename constraint drug_classification_pkey to udm_drug_classification_pkey;
-- alter table udm_inventory_composition
--     rename constraint inventory_composition_pkey to udm_inventory_composition_pkey;
-- alter table udm_wanted_item
--    rename constraint wanted_note_pkey to udm_wanted_item_pkey;
alter table udm_pos_counter
    rename constraint pos_counter_pkey to udm_pos_counter_pkey;
alter table udm_pos_session
    rename constraint pos_counter_session_pkey to udm_pos_session_pkey;
alter table udm_pos_counter_settlement
    rename constraint pos_counter_settlement_pkey to udm_pos_counter_settlement_pkey;
--## f_key

------------------------------------------------------------------------
-- created & updated by changes
------------------------------------------------------------------------
    ALTER TABLE ac_txn ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE ac_txn ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE account_type ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE account_type ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE account ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE account ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE bank_beneficiary ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE bank_beneficiary ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE batch ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE batch ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE bill_allocation ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE bill_allocation ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE branch ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE branch ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE division ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE division ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE financial_year ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE financial_year ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE gst_registration ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE gst_registration ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE gstr_2b ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inv_txn ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inv_txn ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inventory_branch_detail ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inventory_branch_detail ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inventory ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE inventory ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE manufacturer ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE manufacturer ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE member ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE member ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE organization ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE organization ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE print_template ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE print_template ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE sales_person ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE sales_person ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE stock_location ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE stock_location ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE voucher_type ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE voucher_type ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE voucher ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE voucher ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE warehouse ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE warehouse ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_counter ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_counter ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_session ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_session ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_counter_settlement ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
    ALTER TABLE udm_pos_counter_settlement ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_wanted_item ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_wanted_item ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_doctor ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_doctor ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_drug_classification ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_drug_classification ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_inventory_composition ALTER COLUMN created_by TYPE text USING '677485800000000000000000'::text;
--     ALTER TABLE udm_inventory_composition ALTER COLUMN updated_by TYPE text USING '677485800000000000000000'::text;

ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
ALTER TABLE print_template ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
-- ALTER TABLE udm_wanted_item ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
-- ALTER TABLE udm_doctor ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
-- ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
-- ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
ALTER TABLE udm_pos_session  ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();
ALTER TABLE udm_pos_counter_settlement  ADD COLUMN IF NOT EXISTS oid_id text DEFAULT oid();

select now() as time, 'SETTING UUID AS COLUMN FOR TABLES ENDS' as msg;

--ADD OR MODIFY COLUMN--
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## ACCOUNT
select now() as time, 'CHANGES FOR ACCOUNT STARTS' as msg;
-- Account field related changes
alter table account alter column transaction_enabled set not null;
alter table account ADD column code int;
update account SET code = id;
alter table account alter column code SET NOT NULL;
alter table account alter column e_banking_info type jsonb using e_banking_info::jsonb;
-- Account oid related changes
ALTER TABLE account ADD COLUMN IF NOT EXISTS tds_nature_of_payment_oid text;
------------------
    UPDATE account b SET account_type_oid = a.oid_id FROM account_type a WHERE b.account_type_oid is null and a.id = b.account_type_id;
    UPDATE account b SET tds_nature_of_payment_oid = a.oid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
select now() as time, 'CHANGES FOR ACCOUNT ENDS' as msg;
--## ACCOUNT
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## BANK_TXN
select now() as time, 'OID_CHANGES FOR BANK_TXN STARTS' as msg;
-- bank_txn field related changes
alter table bank_txn alter column sno type integer using sno::integer;
alter table bank_txn alter column is_memo set not null;
-- bank_txn oid related changes
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS account_oid text;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS alt_account_oid text;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS voucher_oid text;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS ac_txn_oid text;
------------------
    UPDATE bank_txn b SET account_oid = a.oid_id FROM account a WHERE a.id = b.account_id;
    UPDATE bank_txn b SET alt_account_oid = a.oid_id FROM account a WHERE a.id = b.alt_account_id;
    UPDATE bank_txn b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bank_txn b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
    UPDATE bank_txn b SET ac_txn_oid = a.oid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
select now() as time, 'OID_CHANGES FOR BANK_TXN ENDS' as msg;
--## BANK_TXN
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## INVENTORY
select now() as time, 'OID_CHANGES FOR INVENTORY STARTS' as msg;
-- inventory field related changes
alter table inventory
    add if not exists section_id  text,
    add if not exists category_id  text,
    add if not exists sub_category_id  text,
    add if not exists cess_qty    float,
    add if not exists cess_value  float;
alter table inventory drop column if exists compositions;
--##
update inventory
set cess_qty   = (cess ->> 'on_quantity')::double precision,
    cess_value = (cess ->> 'on_value')::double precision;
--##
alter table inventory add column code integer;
update inventory set code = id;
alter table inventory alter column code set not null;
-- inventory oid related changes
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_account_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_account_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS manufacturer_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS division_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS unit_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_unit_oid text;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_unit_oid text;
-- ALTER TABLE inventory ADD COLUMN IF NOT EXISTS udf_compositions_oid text[];
------------------
    UPDATE inventory b SET sale_account_oid = a.oid_id FROM account a WHERE a.id = b.sale_account_id and a.transaction_enabled;
    UPDATE inventory b SET purchase_account_oid = a.oid_id FROM account a WHERE a.id = b.purchase_account_id and a.transaction_enabled;
    UPDATE inventory b SET manufacturer_oid = a.oid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    UPDATE inventory b SET division_oid = a.oid_id FROM division a WHERE a.id = b.division_id;
    UPDATE inventory b SET section_id = a.id FROM section a WHERE a.old_id = b.category1_id;
    UPDATE inventory b SET category_id = a.id FROM inventory_category a WHERE a.old_id = b.category2_id;
    UPDATE inventory b SET sub_category_id = a.id FROM inventory_sub_category a WHERE a.old_id = b.category3_id;
    UPDATE inventory b
    SET unit_oid          = (select id from unit where symbol = '1'),
        sale_unit_oid     = (select id from unit where symbol = '1'),
        purchase_unit_oid = (select id from unit where symbol = '1');
--     UPDATE inventory t
--         SET udf_compositions_oid =
--                 (SELECT array_agg(udm_inventory_composition.oid_id)
--                  FROM unnest(t.udf_compositions) AS u(class_id)
--                           JOIN udm_inventory_composition
--                                ON udm_inventory_composition.id = u.class_id)
--         WHERE t.udf_compositions IS NOT NULL;
select now() as time, 'OID_CHANGES FOR INVENTORY ENDS' as msg;
--
    alter table inventory drop column if exists manufacturer_id;
    alter table inventory rename column manufacturer_oid to manufacturer_id;
--## INVENTORY
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## INVENTORY_BRANCH_DETAIL
select now() as time, 'OID_CHANGES FOR INVENTORY_BRANCH_DETAIL STARTS' as msg;
-- inventory_branch_detail field related changes
alter table inventory_branch_detail add if not exists s_disc_percentage float;
--##
alter table inventory_branch_detail alter column mrp_price_list type jsonb using mrp_price_list::jsonb;
alter table inventory_branch_detail alter column s_rate_price_list type jsonb using mrp_price_list::jsonb;
alter table inventory_branch_detail alter column nlc_price_list type jsonb using mrp_price_list::jsonb;
--##
update inventory_branch_detail x
set s_disc_percentage = y.value
from price_list_condition y
where x.inventory_id = y.inventory_id
  and (x.branch_id = any (y.branches) or y.branches is null or array_length(y.branches, 1) = 0);
--##
-- alter table inventory_branch_detail alter column reorder_mode drop not null;
--##
-- alter table inventory_branch_detail alter column reorder_level drop not null;
--##
alter table inventory_branch_detail drop if exists reorder_mode;
alter table inventory_branch_detail drop if exists reorder_level;
alter table inventory_branch_detail drop if exists min_order;
alter table inventory_branch_detail drop if exists max_order;
-- inventory_branch_detail oid related changes
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS preferred_vendor_oid text;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS last_vendor_oid text;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS inventory_oid text;
------------------
    UPDATE inventory_branch_detail b SET preferred_vendor_oid = a.oid_id FROM account a WHERE a.id = b.preferred_vendor_id;
    UPDATE inventory_branch_detail b SET last_vendor_oid = a.oid_id FROM account a WHERE a.id = b.last_vendor_id;
    UPDATE inventory_branch_detail b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE inventory_branch_detail b SET inventory_oid = a.oid_id FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'OID_CHANGES FOR INVENTORY_BRANCH_DETAIL ENDS' as msg;
--## INVENTORY_BRANCH_DETAIL
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## TDS_NATURE_OF_PAYMENT
select now() as time, 'OID_CHANGES FOR TDS_NATURE_OF_PAYMENT STARTS' as msg;
-- tds_nature_of_payment field related changes
alter table tds_nature_of_payment
    add if not exists tds_account_id int;
--##
WITH a AS (SELECT id, tds_nature_of_payment_id, tds_deductee_type
           FROM account
           WHERE tds_nature_of_payment_id IS NOT NULL)
UPDATE tds_nature_of_payment t
SET tds_account_id = a.id
FROM a
WHERE a.tds_nature_of_payment_id = t.id
  and tds_account_id is null;
--##
--##
update tds_nature_of_payment
set tds_account_id = coalesce((select id
                               from account
                               where tds_nature_of_payment_id is not null
                               limit 1), 1)
where tds_account_id is null;
--##
alter table tds_nature_of_payment
    alter tds_account_id set not null;
-- tds_nature_of_payment text related changes
ALTER TABLE tds_nature_of_payment ADD COLUMN IF NOT EXISTS tds_account_oid text;
------------------
    UPDATE tds_nature_of_payment b SET tds_account_oid = a.oid_id FROM account a WHERE a.id = b.tds_account_id;
select now() as time, 'OID_CHANGES FOR TDS_NATURE_OF_PAYMENT ENDS' as msg;
--## TDS_NATURE_OF_PAYMENT
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## TDS_ON_VOUCHER
select now() as time, 'OID_CHANGES FOR TDS_ON_VOUCHER STARTS' as msg;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS party_account_oid text;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_account_oid text;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_nature_of_payment_oid text;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS voucher_oid text;
------------------
    UPDATE tds_on_voucher b SET party_account_oid = a.oid_id FROM account a WHERE a.id = b.party_account_id;
    UPDATE tds_on_voucher b SET tds_account_oid = a.oid_id FROM account a WHERE a.id = b.tds_account_id;
    UPDATE tds_on_voucher b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE tds_on_voucher b SET tds_nature_of_payment_oid = a.oid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
    UPDATE tds_on_voucher b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR TDS_ON_VOUCHER ENDS' as msg;
--## TDS_ON_VOUCHER
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_POS_COUNTER
select now() as time, 'OID_CHANGES FOR UDM_POS_COUNTER STARTS' as msg;
ALTER TABLE udm_pos_counter ADD COLUMN IF NOT EXISTS branch_oid text;
------------------
    UPDATE udm_pos_counter b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'OID_CHANGES FOR UDM_POS_COUNTER ENDS' as msg;
--## UDM_POS_COUNTER
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_POS_SESSION
select now() as time, 'text_changes for udm_pos_session starts' as msg;
alter table udm_pos_session add column if not exists settlement_oid text;
------------------
    update udm_pos_session b set settlement_oid = a.oid_id from udm_pos_counter_settlement a where a.id = b.settlement_id;
    alter table udm_pos_session alter column cash_denomination type jsonb using cash_denomination::jsonb;
    alter table udm_pos_session alter column petty_cash_denomination type jsonb using petty_cash_denomination::jsonb;
    alter table udm_pos_session alter column other_denomination type jsonb using other_denomination::jsonb;
select now() as time, 'text_changes for udm_pos_session ends' as msg;
--## UDM_POS_SESSION
---------------------------------------------------------------------------

/*
---------------------------------------------------------------------------
--## UDM_VENDOR_ITEM_MAP
select now() as time, 'OID_CHANGES FOR UDM_VENDOR_ITEM_MAP STARTS' as msg;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS vendor_oid text;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS inventory_oid text;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS unit_id text;
------------------
    UPDATE udm_vendor_item_map b SET vendor_oid = a.oid_id FROM account a WHERE a.id = b.vendor_id;
    UPDATE udm_vendor_item_map b SET inventory_oid = a.oid_id FROM inventory a WHERE a.id = b.inventory_id;
    UPDATE udm_vendor_item_map b SET unit_id = a.unit_oid FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'OID_CHANGES FOR UDM_VENDOR_ITEM_MAP ENDS' as msg;
--## UDM_VENDOR_ITEM_MAP
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_VENDOR_BILL_MAP
select now() as time, 'OID_CHANGES FOR UDM_VENDOR_BILL_MAP STARTS' as msg;
ALTER TABLE udm_vendor_bill_map ADD COLUMN IF NOT EXISTS vendor_oid text;
------------------
    UPDATE udm_vendor_bill_map b SET vendor_oid = a.oid_id FROM account a WHERE a.id = b.vendor_id;
select now() as time, 'OID_CHANGES FOR UDM_VENDOR_BILL_MAP ENDS' as msg;
--## UDM_VENDOR_BILL_MAP
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_INVENTORY_COMPOSITION
select now() as time, 'OID_CHANGES FOR UDM_INVENTORY_COMPOSITION STARTS' as msg;
ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS drug_classifications_oid text[];
------------------
    UPDATE udm_inventory_composition t
        SET drug_classifications_oid =
                (SELECT array_agg(udm_drug_classification.oid_id)
                 FROM unnest(t.drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.drug_classifications IS NOT NULL;
select now() as time, 'OID_CHANGES FOR UDM_INVENTORY_COMPOSITION ENDS' as msg;
--## UDM_INVENTORY_COMPOSITION
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_WANTED_ITEM
select now() as time, 'OID_CHANGES FOR UDM_WANTED_ITEM STARTS' as msg;
ALTER TABLE udm_wanted_item ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE udm_wanted_item ADD COLUMN IF NOT EXISTS inventory_oid text;
ALTER TABLE udm_wanted_item ADD COLUMN IF NOT EXISTS item_description text;
------------------
    UPDATE udm_wanted_item b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE udm_wanted_item b SET inventory_oid = a.oid_id FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'OID_CHANGES FOR UDM_WANTED_ITEM ENDS' as msg;
--## UDM_WANTED_ITEM
---------------------------------------------------------------------------
*/

---------------------------------------------------------------------------
--## ACCOUNT_DAILY_SUMMARY
select now() as time, 'OID_CHANGES FOR ACCOUNT_DAILY_SUMMARY STARTS' as msg;
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS account_oid text;
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS branch_oid text;
------------------
    UPDATE account_daily_summary b SET account_oid = a.oid_id FROM account a WHERE a.id = b.account_id;
    UPDATE account_daily_summary b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'OID_CHANGES FOR ACCOUNT_DAILY_SUMMARY ENDS' as msg;
--## ACCOUNT_DAILY_SUMMARY
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## VOUCHER_NUMBERING
select now() as time, 'OID_CHANGES FOR VOUCHER_NUMBERING STARTS' as msg;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS voucher_type_oid text;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS f_year_oid text;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS branch_oid text;
------------------
    UPDATE voucher_numbering b SET voucher_type_oid = a.oid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    UPDATE voucher_numbering SET f_year_oid = oid_id FROM financial_year WHERE financial_year.id = voucher_numbering.f_year_id;
    UPDATE voucher_numbering b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'OID_CHANGES FOR VOUCHER_NUMBERING ENDS' as msg;
--## VOUCHER_NUMBERING
---------------------------------------------------------------------------

---------------------------------------------------------------------------
select now() as time, 'MEMBER TABLE ALTER START' as msg;
--## MEMBER
alter table member
    add if not exists perms text[],
    add if not exists ui_perms text[];
--##
-- update member m
-- set
--     perms    = coalesce(mr.perms, '{}'::text[]),
--     ui_perms = coalesce(to_jsonb(mr.perms), '[]'::jsonb)
-- from member_role mr
-- where mr.name = m.role_id;
--##
alter table member alter column settings type jsonb using settings::jsonb;
--## MEMBER
select now() as time, 'MEMBER TABLE ALTER ENDS' as msg;
---------------------------------------------------------------------------

---------------------------------------------------------------------------
select now() as time, 'PRINT_LAYOUT TABLE ALTER START' as msg;
--## PRINT_LAYOUT
alter table print_layout
    add column if not exists is_default boolean default true;
--##
alter table print_layout
    alter column is_default set not null;
--##
update print_layout
set id = 'STOCK_JOURNAL'
where id = 'STOCK_DEDUCTION';
--##
alter table print_layout
    alter column is_default drop default;
--##
alter table print_layout
    rename column type to mode;
--##
alter table print_layout alter column sample_data type jsonb using sample_data::jsonb;
--## PRINT_LAYOUT
select now() as time, 'PRINT_LAYOUT TABLE ALTER ENDS' as msg;
---------------------------------------------------------------------------

---------------------------------------------------------------------------
select now() as time, 'PRINT_TEMPLATE TABLE ALTER START' as msg;
--## PRINT_TEMPLATE
update print_template
set layout = 'STOCK_JOURNAL'
where layout = 'STOCK_DEDUCTION';
--##
alter table print_template
    rename column type to mode;
--## PRINT_TEMPLATE
select now() as time, 'PRINT_TEMPLATE TABLE ALTER ENDS' as msg;
---------------------------------------------------------------------------

---------------------------------------------------------------------------
select now() as time, 'SEQUENCE TABLE ALTER START' as msg;
--## SEQUENCE
drop table if exists sequence;
--##
create table sequence (
    model_name text not null,
    seq integer not null,
    constraint sequence_pkey primary key (model_name)
);
--##
insert into sequence (model_name, seq)
select 'account', coalesce(max(code), 0)
from account
on conflict (model_name)
do update set seq = excluded.seq;
--##
insert into sequence (model_name, seq)
select 'inventory', coalesce(max(code), 0)
from inventory
on conflict (model_name)
do update set seq = excluded.seq;
--##
insert into sequence (model_name, seq)
select 'batch', coalesce(max(id), 0)
from batch
on conflict (model_name)
do update set seq = excluded.seq;
--## SEQUENCE
select now() as time, 'SEQUENCE TABLE ALTER ENDS' as msg;
---------------------------------------------------------------------------

---------------------------------------------------------------------------
select now() as time, 'general_migration_end' as msg;

-------------------------------------------------------------------------------------------------
---- APPLY UUID for batch, voucher
-------------------------------------------------------------------------------------------------

--## BATCH
-- field related changes
alter table batch drop column if exists section_id;
alter table batch drop column if exists category_id;
alter table batch drop column if exists sub_category_id;
alter table batch drop column if exists manufacturer_id;
--
update batch
set batch_no = coalesce(nullif(upper(regexp_replace(batch_no, '\s+', '', 'g')), ''), '1');
--##
alter table batch alter batch_no set not null;
--## duplicate batch_no fixed, with concat batch_no, - , id
with a as
         (select array_agg(id) as ids
          from batch
          group by branch_id, warehouse_id, inventory_id, vendor_id, batch_no
          having count(1) > 1)
update batch b
set batch_no = b.batch_no || '-' || b.id::text
from a
where b.id = any (a.ids);
--##
-- text related changes
select now() as time, 'OID_CHANGES FOR BATCH STARTS' as msg;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS vendor_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS inventory_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS manufacturer_id text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS section_id text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS category_id text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS sub_category_id text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS unit_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS voucher_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS warehouse_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS division_oid text;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS inv_retail_qty int;
--##
select now() as time, 'OID_CHANGES FOR BATCH vendor_id STARTS' as msg;
create index on batch (vendor_id);
UPDATE batch b SET vendor_oid = a.oid_id FROM account a WHERE a.id = b.vendor_id;
select now() as time, 'OID_CHANGES FOR BATCH vendor_id ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR BATCH branch_id STARTS' as msg;
create index on batch (branch_id);
UPDATE batch b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'OID_CHANGES FOR BATCH branch_id ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR BATCH inv_id, sec_id, inv_cat_id, inv_sub_cat_id manu_id STARTS' as msg;
create index on batch (inventory_id);
UPDATE batch b
    SET inventory_oid            = a.oid_id,
        section_id                = a.section_id,
        category_id     = a.category_id,
        sub_category_id = a.sub_category_id,
        manufacturer_id           = a.manufacturer_id,
        inv_retail_qty            = a.retail_qty
    FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'OID_CHANGES FOR BATCH inv_id, sec_id, inv_cat_id, inv_sub_cat_id manu_id ENDS' as msg;
--##
select now() as time, 'UNIT_CONV ASSIGN FOR BATCH STARTS' as msg;
update batch b
    set unit_conv = case when b.is_retail_qty then 1 else b.retail_qty end;
select now() as time, 'UNIT_CONV ASSIGN FOR BATCH ENDS' as msg;
--##
select now() as time, 'UNIT_UUID ASSIGN FOR BATCH STARTS' as msg;
update batch b
    set unit_oid = u.conversion_unit_id
        from unit_conversion u
            where u.conversion = b.unit_conv;
select now() as time, 'UNIT_UUID ASSIGN FOR BATCH ENDS' as msg;
--##
alter table batch alter column unit_conv set not null;
--##
select now() as time, 'OID_CHANGES FOR BATCH VOUCHER_ID STARTS' as msg;
create index on batch (voucher_id);
UPDATE batch b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR BATCH VOUCHER_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR BATCH WAREHOUSE_ID STARTS' as msg;
create index on batch (warehouse_id);
UPDATE batch b SET warehouse_oid = a.oid_id FROM warehouse a WHERE a.id = b.warehouse_id;
select now() as time, 'OID_CHANGES FOR BATCH WAREHOUSE_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR BATCH DIVISION_ID STARTS' as msg;
create index on batch (division_id);
UPDATE batch b SET division_oid = a.oid_id FROM division a WHERE a.id = b.division_id;
select now() as time, 'OID_CHANGES FOR BATCH DIVISION_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR BATCH ENDS' as msg;
--## BATCH
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## VOUCHER
select now() as time, 'OID_CHANGES FOR VOUCHER STARTS' as msg;
-- voucher field related changes
alter table voucher
    add if not exists metadata                     jsonb,
    add if not exists branch_gst_reg_type          text,
    add if not exists branch_gst_location_id       text,
    add if not exists branch_gst_no                text,
    add if not exists party_gst_reg_type           text,
    add if not exists party_gst_location_id        text,
    add if not exists party_gst_no                 text,
    add if not exists gst_location_type            text,
    add if not exists vendor_id                    text,
    add if not exists vendor_name                  text,
    add if not exists customer_id                  text,
    add if not exists customer_name                text,
    add if not exists warehouse_id                 text,
    add if not exists warehouse_name               text,
    add if not exists rounded_off                  float,
    add if not exists disc_mode                    text,
    add if not exists discount                     float,
    add if not exists sales_person_id              text,
    add if not exists sale_value                   float,
    add if not exists profit_value                 float,
    add if not exists nlc_value                    float,
    add if not exists valid_provisional_profit     bool,
    add if not exists udf_alt_branch_id            text,
    add if not exists udf_alt_warehouse_id         text,
    add if not exists udf_transfer_voucher_id      text,
    add if not exists udf_approved                 bool,
    add if not exists branch_oid                  text,
    add if not exists voucher_type_oid            text,
    add if not exists udf_pos_counter_session_id   text,
    add if not exists udf_pos_counter_settlement_id text;
--     add if not exists udf_customer_mobile          text,
--     add if not exists udf_reminder_date            date,
--     add if not exists udf_doctor_id                text;
--##
alter table voucher rename pos_counter_code to udf_pos_counter_code;
--##
UPDATE voucher v
set udf_pos_counter_session_id = b.oid_id
from udm_pos_session b
where v.pos_counter_session_id = b.id;
--##
UPDATE voucher v
set udf_pos_counter_settlement_id = b.oid_id
from udm_pos_counter_settlement b
where v.pos_counter_settlement_id = b.id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.oid_id,
    warehouse_name         = b.warehouse_name,
    vendor_id              = a.oid_id,
    vendor_name            = b.vendor_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    branch_oid            = br.oid_id,
    voucher_type_oid      = vt.oid_id
FROM debit_note b
    LEFT JOIN warehouse w ON b.warehouse_id = w.id
    LEFT JOIN account a   ON b.vendor_id = a.id
    LEFT JOIN branch br ON b.branch_id = br.id
    LEFT JOIN voucher_type vt on b.voucher_type_id = vt.id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.oid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.oid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.oid_id,
    branch_oid            = br.oid_id,
    voucher_type_oid      = vt.oid_id
FROM credit_note b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN account a   ON a.id = b.customer_id
    LEFT JOIN sales_person sp on b.s_inc_id = sp.id
    LEFT JOIN branch br ON b.branch_id = br.id
    LEFT JOIN voucher_type vt on b.voucher_type_id = vt.id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id            = w.oid_id,
    warehouse_name          = b.warehouse_name,
    udf_alt_branch_id       = br.oid_id,
    udf_alt_warehouse_id    = w.oid_id,
    udf_transfer_voucher_id = tv.oid_id,
    udf_approved            = b.approved,
    branch_oid             = br.oid_id,
    voucher_type_oid       = vt.oid_id
FROM stock_journal b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher tv  ON tv.id = b.transfer_voucher_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id   = w.oid_id,
    warehouse_name = b.warehouse_name,
    vendor_id      = a.oid_id,
    vendor_name    = b.vendor_name,
    branch_oid    = br.oid_id
FROM goods_inward_note b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN account a   ON a.id = b.vendor_id
    LEFT JOIN branch br   ON br.id = b.branch_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    warehouse_id           = w.oid_id,
    warehouse_name         = b.warehouse_name,
    branch_oid            = br.oid_id,
    voucher_type_oid      = vt.oid_id
FROM personal_use_purchase b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type      = b.branch_gst ->> 'reg_type',
    branch_gst_location_id   = b.branch_gst ->> 'location_id',
    branch_gst_no            = b.branch_gst ->> 'gst_no',
    party_gst_reg_type       = b.party_gst ->> 'reg_type',
    party_gst_location_id    = b.party_gst ->> 'location_id',
    party_gst_no             = b.party_gst ->> 'gst_no',
    warehouse_id             = w.oid_id,
    warehouse_name           = b.warehouse_name,
    vendor_id                = a.oid_id,
    vendor_name              = b.vendor_name,
    customer_id              = ac.oid_id,
    customer_name            = b.customer_name,
    rounded_off              = b.rounded_off,
    disc_mode                = b.discount_mode,
    discount                 = b.discount_amount,
    sale_value               = b.sale_value,
    profit_value             = b.profit_value,
    nlc_value                = b.nlc_value,
    valid_provisional_profit = b.valid_provisional_profit,
    branch_oid              = br.oid_id,
    voucher_type_oid        = vt.oid_id
FROM purchase_bill b
    LEFT JOIN warehouse w ON b.warehouse_id = w.id
    LEFT JOIN account a   ON b.vendor_id = a.id
    LEFT JOIN account ac  ON b.customer_id = ac.id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.oid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.oid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.oid_id,
    branch_oid            = br.oid_id,
    voucher_type_oid      = vt.oid_id
--     udf_customer_mobile    = a.mobile,
--     udf_reminder_date      = b.date + b.reminder_days,
--     udf_doctor_id          = ud.oid_id
FROM sale_bill b
    LEFT JOIN warehouse w     ON w.id = b.warehouse_id
    LEFT JOIN account a       ON a.id = b.customer_id
    LEFT JOIN sales_person sp ON sp.id = b.s_inc_id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
--     LEFT JOIN udm_doctor ud   ON ud.id = b.doctor_id
WHERE v.id = b.voucher_id;
--##
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.oid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.oid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.oid_id,
    branch_oid            = br.oid_id,
    voucher_type_oid      = vt.oid_id
FROM sale_quotation b
    LEFT JOIN warehouse w     ON w.id = b.warehouse_id
    LEFT JOIN account a       ON a.id = b.customer_id
    LEFT JOIN sales_person sp ON sp.id = b.s_inc_id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
WHERE v.id = b.voucher_id;

--##
alter table voucher
    alter column mode set not null,
    alter column e_invoice_details type jsonb using e_invoice_details::jsonb,
    alter column eway_bill_details type jsonb using eway_bill_details::jsonb;
------------------
select now() as time, 'OID_CHANGES FOR VOUCHER BRANCH_ID STARTS' as msg;
create index on voucher (branch_id, branch_oid);
UPDATE voucher b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id and branch_oid is null;
select now() as time, 'OID_CHANGES FOR VOUCHER BRANCH_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR VOUCHER VOUCHER_TYPE_ID ENDS' as msg;
create index on voucher (voucher_type_id, voucher_type_oid);
UPDATE voucher b SET voucher_type_oid = a.oid_id FROM voucher_type a WHERE a.id = b.voucher_type_id and voucher_type_oid is null;
--##
select now() as time, 'OID_CHANGES FOR VOUCHER ENDS' as msg;
------------------
--## VOUCHER
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## AC_TXN
select now() as time, 'OID_CHANGES FOR AC_TXN STARTS' as msg;
create index on gst_txn (ac_txn_id);
-- ac_txn field related changes
alter table ac_txn
    add if not exists qty            float,
    add if not exists hsn_code       text,
    add if not exists uqc            text,
    add if not exists gst_tax        text,
    add if not exists gst_ratio      float,
    add if not exists taxable_amount float,
    add if not exists cgst_amount    float,
    add if not exists sgst_amount    float,
    add if not exists igst_amount    float,
    add if not exists cess_amount    float;
--##
UPDATE ac_txn a
SET qty            = g.qty,
    gst_tax        = g.gst_tax,
    gst_ratio      = g.tax_ratio,
    hsn_code       = g.hsn_code,
    uqc            = g.uqc,
    taxable_amount = g.taxable_amount,
    cgst_amount    = g.cgst_amount,
    sgst_amount    = g.sgst_amount,
    igst_amount    = g.igst_amount,
    cess_amount    = g.cess_amount
FROM gst_txn g
WHERE a.id = g.ac_txn_id;
--##
alter table ac_txn
    alter column is_memo set not null,
    alter column metadata type jsonb using metadata::jsonb,
    alter column sno type integer using sno::integer;
-- ac_txn text related changes
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_oid text;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID STARTS' as msg;
UPDATE ac_txn b SET account_oid = a.oid_id, account_type_oid = a.account_type_oid FROM account a WHERE a.id = b.account_id;
select now() as time, 'OID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID STARTS' as msg;
UPDATE ac_txn b SET alt_account_oid = a.oid_id FROM account a WHERE a.id = b.alt_account_id;
select now() as time, 'OID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN VOUCHER_ID, voucher_type_oid, branch_oid STARTS' as msg;
UPDATE ac_txn b SET voucher_oid = a.oid_id, voucher_type_oid = a.voucher_type_oid, branch_oid = a.branch_oid  FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR AC_TXN VOUCHER_ID, voucher_type_oid, branch_oid ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN BRANCH_ID STARTS' as msg;
create index on ac_txn (branch_id, branch_oid);
UPDATE ac_txn b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id and branch_oid is null;
select now() as time, 'OID_CHANGES FOR AC_TXN BRANCH_ID ENDS' as msg;
--## AC_TXN
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## INV_TXN
select now() as time, 'OID_CHANGES FOR INV_TXN STARTS' as msg;
-- inv_txn field related changes
alter table inv_txn drop column if exists section_id;
alter table inv_txn drop column if exists category_id;
alter table inv_txn drop column if exists sub_category_id;
alter table inv_txn drop column if exists manufacturer_id;
--
alter table inv_txn
    add if not exists sno                      int,
    add if not exists qty                      float,
    add if not exists unit_id                  text,
    add if not exists unit_conv                float,
    add if not exists rate                     float,
    add if not exists batch_no                 text,
    add if not exists metadata                 jsonb,
    add if not exists rate_tax_inclusive       bool,
    add if not exists gst_tax                  text,
    add if not exists mrp                      float,
    add if not exists p_rate                   float,
    add if not exists s_rate                   float,
    add if not exists barcode                  text,
    add if not exists expiry                   date,
    add if not exists nlc                      float,
    add if not exists cost                     float,
    add if not exists landing_cost             float,
    add if not exists disc_mode1               text,
    add if not exists discount1                float,
    add if not exists disc_mode2               text,
    add if not exists discount2                float,
    add if not exists disc_mode3               text,
    add if not exists discount3                float,
    add if not exists hsn_code                 text,
    add if not exists cess_on_qty              float,
    add if not exists cess_on_val              float,
    add if not exists customer_id              text,
    add if not exists sales_person_id          text,
    add if not exists inventory_oid           text,
    add if not exists branch_oid              text,
    add if not exists voucher_oid             text,
    add if not exists voucher_type_oid        text,
    add if not exists warehouse_oid           text,
    add if not exists section_id               text,
    add if not exists category_id    text,
    add if not exists sub_category_id text,
    add if not exists manufacturer_id          text,
    add if not exists free_qty                 float,
    add if not exists vendor_oid              text,
    add if not exists division_oid            text;
--     add if not exists udf_reminder_date        date,
--     add if not exists udf_drug_classifications text[];
--##
--select now() as time, 'inv_txn set udf_reminder_date from sale_bill STARTS' as msg;
--update inv_txn t
--set udf_reminder_date = i.date + i.reminder_days
--from sale_bill i
--    where i.voucher_id = t.voucher_id
--    and i.reminder_days is not null;
--select now() as time, 'inv_txn set udf_reminder_date from sale_bill ENDS' as msg;
--##
select now() as time, 'inv_txn set data from credit_note_inv_item STARTS' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    rate_tax_inclusive          = true,
    gst_tax                     = i.gst_tax,
    disc_mode1                  = i.disc_mode,
    discount1                   = i.discount,
    hsn_code                    = i.hsn_code,
    cess_on_qty                 = i.cess_on_qty,
    cess_on_val                 = i.cess_on_val,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    inventory_oid              = b.inventory_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from credit_note_inv_item i
         left join batch b on b.id = i.batch_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
select now() as time, 'inv_txn set data from credit_note_inv_item END' as msg;
--##
select now() as time, 'inv_txn set customer from credit_note STARTS' as msg;
UPDATE inv_txn t
SET customer_id = a.oid_id
FROM credit_note b
LEFT JOIN account a ON a.id = b.customer_id
    WHERE t.voucher_id = b.voucher_id
  AND b.customer_id IS NOT NULL;
--##
select now() as time, 'inv_txn set customer from credit_note end' as msg;
--##
select now() as time, 'inv_txn set data from debit_note_inv_item start' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    gst_tax                     = i.gst_tax,
    disc_mode1                  = i.disc1_mode,
    discount1                   = i.discount1,
    disc_mode2                  = i.disc2_mode,
    discount2                   = i.discount2,
    rate_tax_inclusive          = false,
    hsn_code                    = i.hsn_code,
    cess_on_qty                 = i.cess_on_qty,
    cess_on_val                 = i.cess_on_val,
    batch_no                    = b.batch_no,
    inventory_oid              = b.inventory_oid,
    vendor_oid                 = b.vendor_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from debit_note_inv_item i
         left join batch b on b.id = i.batch_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
select now() as time, 'inv_txn set data from debit_note_inv_item end' as msg;
--##
select now() as time, 'inv_txn set data from personal_use_purchase_inv_item start' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.cost,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    gst_tax                     = i.gst_tax,
    hsn_code                    = i.hsn_code,
    cess_on_qty                 = i.cess_on_qty,
    cess_on_val                 = i.cess_on_val,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    inventory_oid              = b.inventory_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from personal_use_purchase_inv_item i
         left join batch b on b.id = i.batch_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
select now() as time, 'inv_txn set data from personal_use_purchase_inv_item end' as msg;
--##
select now() as time, 'inv_txn set data from purchase_bill_inv_item start' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    p_rate                      = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    gst_tax                     = i.gst_tax,
    disc_mode1                  = i.disc1_mode,
    discount1                   = i.discount1,
    disc_mode2                  = i.disc2_mode,
    discount2                   = i.discount2,
    hsn_code                    = i.hsn_code,
    cess_on_qty                 = i.cess_on_qty,
    cess_on_val                 = i.cess_on_val,
    inventory_oid              = b.inventory_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id,
    free_qty                    = i.free_qty,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    s_rate                      = b.s_rate,
    mrp                         = b.mrp,
    expiry                      = b.expiry,
    nlc                         = b.nlc,
    landing_cost                = b.landing_cost,
    cost                        = b.cost
from purchase_bill_inv_item i
    left join batch b on b.txn_id = i.id
    left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
--##
select now() as time, 'inv_txn set data from purchase_bill_inv_item end' as msg;
--##
select now() as time, 'inv_txn set data from sale_bill_inv_item start' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    gst_tax                     = i.gst_tax,
    disc_mode1                  = i.disc_mode,
    discount1                   = i.discount,
    hsn_code                    = i.hsn_code,
    cess_on_qty                 = i.cess_on_qty,
    cess_on_val                 = i.cess_on_val,
    sales_person_id             = sp.oid_id,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    inventory_oid              = b.inventory_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from sale_bill_inv_item i
    left join batch b on b.id = i.batch_id
    left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
    left join sales_person sp on sp.id = i.s_inc_id
where t.id = i.id;
--##
/*
select now() as time, 'inv_txn set drug_classifications from sale_bill_inv_item start' as msg;
WITH a AS (
    SELECT drug_classifications, id
    FROM sale_bill_inv_item
    WHERE date > '2026-02-01'
      AND array_length(drug_classifications, 1) > 0
)
UPDATE inv_txn t
SET udf_drug_classifications = (
        SELECT array_agg(d.oid_id)
        FROM udm_drug_classification d
        WHERE d.id = ANY(a.drug_classifications)
    )
FROM a
WHERE t.id = a.id;
select now() as time, 'inv_txn set drug_classifications from sale_bill_inv_item end' as msg;
*/
--##
select now() as time, 'inv_txn set data from sale_bill_inv_item end' as msg;
--##
select now() as time, 'inv_txn set customer from sale_bill start' as msg;
update inv_txn t
set customer_id   = cid.oid_id
from sale_bill b
    left join account cid on cid.id = b.customer_id
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
--##
select now() as time, 'inv_txn set customer from sale_bill end' as msg;
--##
select now() as time, 'inv_txn set data from stock_journal_inv_item start' as msg;
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    barcode                     = i.barcode,
    asset_amount                = i.asset_amount,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    s_rate                      = b.s_rate,
    mrp                         = b.mrp,
    expiry                      = b.expiry,
    nlc                         = b.nlc,
    landing_cost                = b.landing_cost,
    cost                        = b.cost,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    inventory_oid              = b.inventory_oid,
    manufacturer_id             = b.manufacturer_id
from stock_journal_inv_item i
         left join batch b on b.id = i.batch_id or b.txn_id = i.id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
--##
select now() as time, 'inv_txn set data from stock_journal_inv_item end' as msg;
--##
select now() as time, 'inv_txn set data from inv_opening start' as msg;
update inv_txn t
set sno                         = i.sno,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    qty                         = i.qty,
    rate                        = i.rate,
    asset_amount                = i.asset_amount,
    batch_no                    = b.batch_no,
    vendor_oid                 = b.vendor_oid,
    s_rate                      = b.s_rate,
    mrp                         = b.mrp,
    expiry                      = b.expiry,
    nlc                         = b.nlc,
    landing_cost                = b.landing_cost,
    cost                        = b.cost,
    inventory_oid              = b.inventory_oid,
    section_id                  = b.section_id,
    category_id       = b.category_id,
    sub_category_id   = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from inventory_opening i
         left join batch b on b.txn_id = i.id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
select now() as time, 'inv_txn set data from inv_opening end' as msg;
--##
alter table inv_txn
    alter column sno set not null,
    alter column qty set not null,
    alter column unit_id set not null,
    alter column unit_conv set not null,
    alter column rate set not null,
    alter column inward set not null,
    alter column outward set not null;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN BRANCH_ID STARTS' as msg;
create index on inv_txn (branch_id);
UPDATE inv_txn b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'OID_CHANGES FOR INV_TXN BRANCH_ID ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN VOUCHER_ID, voucher_type_oid STARTS' as msg;
create index on inv_txn (voucher_id);
UPDATE inv_txn b SET voucher_oid = a.oid_id, voucher_type_oid = a.voucher_type_oid FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR INV_TXN VOUCHER_ID, voucher_type_oid ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN WAREHOUSE_ID STARTS' as msg;
create index on inv_txn (warehouse_id);
UPDATE inv_txn b SET warehouse_oid = a.oid_id FROM warehouse a WHERE a.id = b.warehouse_id;
select now() as time, 'OID_CHANGES FOR INV_TXN WAREHOUSE_ID ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN DIVISION_ID STARTS' as msg;
create index on inv_txn (division_id);
UPDATE inv_txn b SET division_oid = a.oid_id FROM division a WHERE a.id = b.division_id;
select now() as time, 'OID_CHANGES FOR INV_TXN DIVISION_ID ENDS' as msg;
------------------
alter table inv_txn alter column batch_no set not null;
--## INV_TXN
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## BILL_ALLOCATION
alter table bill_allocation
    add if not exists new_ref_no text;
--##
create index bill_allocation_pending
    on bill_allocation (pending);
--##
with a as (select coalesce(nullif(upper(regexp_replace(ref_no, '\s+', '', 'g')), ''), voucher_no, '1') as no,
                  array_agg(pending)                                                                   as pids
           from bill_allocation
           where ref_type = 'NEW'
           group by account_id, branch_id,
                    coalesce(nullif(upper(regexp_replace(ref_no, '\s+', '', 'g')), ''), voucher_no, '1'))
update bill_allocation b
set new_ref_no = a.no
from a
where b.pending = any (a.pids);
--##
alter table bill_allocation
    rename ref_no to old_ref_no;
--##
alter table bill_allocation
    rename new_ref_no to ref_no;
--##
select now() as time, 'OID_CHANGES FOR BILL_ALLOCATION STARTS' as msg;
-- bill_allocation field related changes
alter table bill_allocation rename meta_data to metadata;
alter table bill_allocation alter column metadata type jsonb using metadata::jsonb;
alter table bill_allocation alter column sno type int using sno::int;
-- bill_allocation text related changes
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_oid text;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_type_oid text;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS voucher_oid text;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS ac_txn_oid text;
------------------
    UPDATE bill_allocation b SET account_oid = a.oid_id, account_type_oid = a.account_type_oid FROM account a WHERE a.id = b.account_id;
    UPDATE bill_allocation b SET branch_oid = a.oid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bill_allocation b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
    UPDATE bill_allocation b SET ac_txn_oid = a.oid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
select now() as time, 'OID_CHANGES FOR BILL_ALLOCATION STARTS' as msg;
--## BILL_ALLOCATION
---------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN, EXPRESSION, DEFAULT
-------------------------------------------------------------------------------------------------
select now() as time, 'DROPPING UNWANTED COLUMN & TABLE START' as msg;
-- AC_TXN --
    alter table ac_txn alter column amount drop expression;
    alter table ac_txn drop column if exists is_opening;
    alter table ac_txn drop column if exists voucher_prefix;
    alter table ac_txn drop column if exists voucher_fy;
    alter table ac_txn drop column if exists voucher_seq;
    alter table ac_txn drop column if exists eft_reconciliation_voucher_id;
    alter table ac_txn drop column if exists account_type_name;
    alter table ac_txn drop column if exists alt_account_name;
    alter table ac_txn drop column if exists inst_no;
    alter table ac_txn drop column if exists base_account_types;
-- INV_TXN --
    alter table inv_txn drop column if exists party_id;
    alter table inv_txn drop column if exists party_name;
    alter table inv_txn drop column if exists vendor_name;
    alter table inv_txn drop column if exists reorder_inventory_id;
    alter table inv_txn drop column if exists inventory_hsn;
    alter table inv_txn drop column if exists division_name;
    alter table inv_txn drop column if exists manufacturer_name;
    alter table inv_txn drop column if exists is_opening;
    alter table inv_txn drop column if exists inventory_voucher_id;
    alter table inv_txn drop column if exists category1_id;
    alter table inv_txn drop column if exists category1_name;
    alter table inv_txn drop column if exists category2_id;
    alter table inv_txn drop column if exists category2_name;
    alter table inv_txn drop column if exists category3_id;
    alter table inv_txn drop column if exists category3_name;
    alter table inv_txn drop column if exists doctor_id;
    alter table inv_txn drop column if exists doctor_name;
    alter table inv_txn drop column if exists sale_taxable_amount;
    alter table inv_txn drop column if exists sale_tax_amount;
    alter table inv_txn drop column if exists pos_id;
--     alter table inv_txn drop if exists batch_id;
    alter table inv_txn alter column batch_id drop not null;
    alter table inv_txn drop if exists dummy;
-- VOUCHER --
    alter table voucher drop column if exists branch_gst;
    alter table voucher drop column if exists party_gst;
    alter table voucher drop column if exists party_id;
    alter table voucher drop column if exists party_name;
    alter table voucher drop column if exists pos_counter_code;
    alter table voucher drop column if exists approval_state;
    alter table voucher drop column if exists require_no_of_approval;
    alter table voucher drop column if exists pos_counter_session_id;
    alter table voucher drop column if exists session;
    alter table voucher drop column if exists pos_counter_settlement_id;
-- ACCOUNT_DAILY_SUMMARY --
    alter table account_daily_summary alter column amount drop expression;
-- ACCOUNT --
    alter table account alter column val_name drop expression;
    alter table account drop column if exists contact_type;
    alter table account drop column if exists hide;
    alter table account drop column if exists short_name;
    alter table account drop column if exists gst_type;
    alter table account drop column if exists cheque_in_favour_of;
    alter table account drop column if exists description;
    alter table account drop column if exists is_commission_discounted;
    alter table account drop column if exists commission;
    alter table account drop column if exists aadhar_no;
    alter table account drop column if exists category1;
    alter table account drop column if exists category2;
    alter table account drop column if exists category3;
    alter table account drop column if exists category4;
    alter table account drop column if exists category5;
    alter table account drop column if exists agent_id;
    alter table account drop column if exists commission_account_id;
    alter table account drop column if exists delivery_address;
    alter table account drop column if exists enable_loyalty_point;
    alter table account drop column if exists loyalty_point;
    alter table account drop column if exists tags;
    alter table account drop column if exists e_banking_enabled;
    alter table account drop column if exists transport_detail;
    alter table account drop column if exists service_charge_gst_account_id;
    alter table account drop column if exists service_charge_non_gst_account_id;
    alter table account drop column if exists itc_ineligible;
    alter table account drop column if exists secondary_emails;
-- BANK_TXN --
    alter table bank_txn alter column credit drop expression;
    alter table bank_txn alter column debit drop expression;
    alter table bank_txn drop column if exists in_favour_of;
    alter table bank_txn drop column if exists base_account_types;
    alter table bank_txn drop column if exists alt_account_name;
    alter table bank_txn drop column if exists bank_beneficiary_id;
    alter table bank_txn drop column if exists epayment_tran_ref;
    alter table bank_txn drop column if exists epayment_req_ref;
    alter table bank_txn drop column if exists epayment_status;
    alter table bank_txn drop column if exists bank_ref_no;
    alter table bank_txn drop column if exists bank_particulars;
-- BATCH --
    alter table batch alter column p_rate drop expression;
    alter table batch alter column closing drop expression;
    alter table batch drop column if exists sno;
    alter table batch drop column if exists reorder_inventory_id;
    alter table batch drop column if exists inventory_hsn;
    alter table batch drop column if exists branch_name;
    alter table batch drop column if exists division_name;
    alter table batch drop column if exists warehouse_name;
    alter table batch drop column if exists txn_id;
    alter table batch drop column if exists inventory_voucher_id;
    alter table batch drop column if exists opening_p_rate;
    alter table batch drop column if exists label_qty;
    alter table batch drop column if exists retail_qty;
    alter table batch drop column if exists is_retail_qty;
    alter table batch drop column if exists unit_name;
    alter table batch drop column if exists source_batch_id;
    alter table batch drop column if exists manufacturer_name;
    alter table batch drop column if exists vendor_name;
    alter table batch drop column if exists category1_id;
    alter table batch drop column if exists category1_name;
    alter table batch drop column if exists category2_id;
    alter table batch drop column if exists category2_name;
    alter table batch drop column if exists category3_id;
    alter table batch drop column if exists category3_name;
    alter table batch drop column if exists inv_retail_qty;
-- BILL_ALLOCATION --
    alter table bill_allocation drop column if exists base_account_types;
--     alter table bill_allocation drop column if exists pending;
    alter table bill_allocation drop column if exists old_ref_no;
    alter table bill_allocation drop column if exists is_approved;
    alter table bill_allocation drop column if exists due_date;
    alter table bill_allocation drop column if exists account_type_name;
    alter table bill_allocation drop column if exists bill_date;
-- INVENTORY --
    alter table inventory alter column val_name drop expression;
    alter table inventory drop column if exists cess;
    alter table inventory drop column if exists inventory_type;
    alter table inventory drop column if exists retail_qty;
    alter table inventory drop column if exists reorder_inventory_id;
    alter table inventory drop column if exists bulk_inventory_id;
    alter table inventory drop column if exists distribution_qty;
    alter table inventory drop column if exists purchase_config;
    alter table inventory drop column if exists sale_config;
    alter table inventory drop column if exists tags;
    alter table inventory drop column if exists description;
    alter table inventory drop column if exists manufacturer_name;
    alter table inventory drop column if exists vendor_id;
    alter table inventory drop column if exists vendor_name;
    alter table inventory drop column if exists vendors;
    alter table inventory drop column if exists set_rate_values_via_purchase;
    alter table inventory drop column if exists apply_s_rate_from_master_for_sale;
    alter table inventory drop column if exists fitting_charge;
    alter table inventory drop column if exists itc_ineligible;
    alter table inventory drop column if exists category1_id;
    alter table inventory drop column if exists category2_id;
    alter table inventory drop column if exists category3_id;
    alter table inventory drop column if exists category1_name;
    alter table inventory drop column if exists category2_name;
    alter table inventory drop column if exists category3_name;
    alter table inventory drop column if exists incentive_applicable;
    alter table inventory drop column if exists incentive_range_id;
    alter table inventory drop column if exists incentive_type;
-- INVENTORY_BRANCH_DETAIL --
    alter table inventory_branch_detail drop column if exists inventory_name;
    alter table inventory_branch_detail drop column if exists branch_name;
    alter table inventory_branch_detail drop column if exists inventory_barcodes;
    alter table inventory_branch_detail drop column if exists s_disc;
    alter table inventory_branch_detail drop column if exists discount_1;
    alter table inventory_branch_detail drop column if exists discount_2;
    alter table inventory_branch_detail drop column if exists division_id;
    alter table inventory_branch_detail drop column if exists preferred_vendor_name;
    alter table inventory_branch_detail drop column if exists last_vendor_name;
    alter table inventory_branch_detail drop column if exists s_customer_disc;
    alter table inventory_branch_detail drop column if exists p_rate_tax_inc;
    alter table inventory_branch_detail drop column if exists reorder_inventory_id;
    alter table inventory_branch_detail drop column if exists val_name;
-- MEMBER --
    alter table member drop column if exists user_id;
    alter table member drop column if exists role_id;
-- VOUCHER_TYPE --
    alter table voucher_type drop column if exists approve1_id;
    alter table voucher_type drop column if exists approve2_id;
    alter table voucher_type drop column if exists approve3_id;
    alter table voucher_type drop column if exists approve4_id;
    alter table voucher_type drop column if exists approve5_id;
-- TDS_ON_VOUCHER --
    alter table tds_on_voucher alter column amount_after_tds_deduction drop expression;
    alter table tds_on_voucher drop column if exists branch_name;
    alter table tds_on_voucher drop column if exists pending_id;
-- SECTION --
    alter table section drop column if exists old_id;
-- INVENTORY_CATEGORY --
    alter table inventory_category drop column if exists old_id;
-- INVENTORY_SUB_CATEGORY --
    alter table inventory_sub_category drop column if exists old_id;
-- UDM_POS_SESSION --
    alter table udm_pos_session drop column if exists closed_by;
    alter table udm_pos_session drop column if exists closed_by_id;
-- UDM_POS_COUNTER_SETTLEMENT --
    alter table udm_pos_counter_settlement drop column if exists created_by_id;
    alter table udm_pos_counter_settlement drop column if exists opening;
    alter table udm_pos_counter_settlement drop column if exists closing;
-- changed_at removal --
    alter table account                 drop if exists changed_at;
    alter table account_type            drop if exists changed_at;
    alter table batch                   drop if exists changed_at;
    alter table branch                  drop if exists changed_at;
    alter table country                 drop if exists changed_at;
    alter table division                drop if exists changed_at;
    alter table gst_registration        drop if exists changed_at;
    alter table inventory               drop if exists changed_at;
    alter table inventory_branch_detail drop if exists changed_at;
    alter table member                  drop if exists changed_at;
    alter table organization            drop if exists changed_at;
    alter table print_layout            drop if exists changed_at;
    alter table print_template          drop if exists changed_at;
    alter table sales_person            drop if exists changed_at;
    alter table unit                    drop if exists changed_at;
    alter table voucher_type            drop if exists changed_at;
    alter table warehouse               drop if exists changed_at;
    alter table udm_pos_counter         drop if exists changed_at;
--     alter table udm_doctor                  drop if exists changed_at;
--     alter table udm_drug_classification     drop if exists changed_at;
--DROP OR MODIFY TABLE--
    drop table if exists acc_cat_txn;
    drop table if exists account_opening;
    drop table if exists approval_log;
    drop table if exists approval_tag;
    drop table if exists pincode_distance;
    drop table if exists dispatch_address;
    drop table if exists area;
    drop table if exists bill_of_material_component;
    drop table if exists category;
    drop table if exists category_option;
    drop table if exists credit_note;
    drop table if exists credit_note_inv_item;
    drop table if exists customer_advance;
    drop table if exists debit_note;
    drop table if exists debit_note_inv_item;
    drop table if exists purchase_bill;
    drop table if exists purchase_bill_inv_item;
    drop table if exists sale_bill_reminder_inv_item;
    drop table if exists sale_bill_reminder;
    drop table if exists sale_bill;
    drop table if exists sale_bill_inv_item;
    drop table if exists sale_package;
    drop table if exists sale_quotation;
    drop table if exists delete_log;
    drop table if exists delivery_note;
    drop table if exists delivery_note_inv_item;
    drop table if exists delivery_receipt;
    drop table if exists display_rack;
    drop table if exists e_banking_log;
    drop table if exists eft_reconciliation_voucher;
    drop table if exists environment;
    drop table if exists exchange;
    drop table if exists exchange_adjustment;
    drop table if exists gate_entry;
    drop table if exists gift_coupon;
    drop table if exists gift_voucher;
    drop table if exists goods_inward_note;
    drop table if exists gst_txn;
    drop table if exists incentive_range;
    drop table if exists inventory_opening;
    drop table if exists material_conversion;
    drop table if exists material_conversion_inv_item;
    drop table if exists member_role;
    drop table if exists offer_management;
    drop table if exists organization_old;
    drop table if exists personal_use_purchase_inv_item;
    drop table if exists personal_use_purchase;
    drop table if exists pos_offline_voucher;
    drop table if exists pos_server;
    drop table if exists power_bi;
    drop table if exists price_list_condition;
    drop table if exists price_list;
    drop table if exists shipment;
    drop table if exists stock_journal;
    drop table if exists stock_journal_inv_item;
    drop table if exists stock_value;
    drop table if exists stock_value_opening;
    drop table if exists sales_emi_reconciliation_voucher;
    drop table if exists tag;
    drop table if exists tally_account_map;
    drop table if exists vault;
    drop table if exists seaql_migrations;
select now() as time, 'DROPPING UNWANTED COLUMN & TABLE END' as msg;
-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN AND RENAME THE REQUIRED ONE
-------------------------------------------------------------------------------------------------
select now() as time, 'RENAMING AND DROPPING UUID COLUMN START' as msg;
-- ACCOUNT
    alter table account drop column if exists id;
    alter table account rename column oid_id to id;
    alter table account alter column id set not null;
    ALTER TABLE account ADD CONSTRAINT account_pkey PRIMARY KEY (id);
        --
        alter table ac_txn drop column if exists account_id;
        alter table ac_txn rename column account_oid to account_id;
        alter table ac_txn alter column account_id set not null;
        --
        alter table ac_txn drop column if exists alt_account_id;
        alter table ac_txn rename column alt_account_oid to alt_account_id;
        --
        alter table account_daily_summary drop column if exists account_id;
        alter table account_daily_summary rename column account_oid to account_id;
        alter table account_daily_summary alter column account_id set not null;
        --
        alter table bank_txn drop column if exists account_id;
        alter table bank_txn rename column account_oid to account_id;
        alter table bank_txn alter column account_id set not null;
        --
        alter table bank_txn drop column if exists alt_account_id;
        alter table bank_txn rename column alt_account_oid to alt_account_id;
        --
        alter table branch drop column if exists account_id;
        alter table branch rename column account_oid to account_id;
        alter table branch alter column account_id set not null;
        alter table branch add unique (account_id);
        --
        alter table bill_allocation drop column if exists account_id;
        alter table bill_allocation rename column account_oid to account_id;
        alter table bill_allocation alter column account_id set not null;
        --
        alter table batch drop column if exists vendor_id;
        alter table batch rename column vendor_oid to vendor_id;
        --
        alter table inventory drop column if exists sale_account_id;
        alter table inventory rename column sale_account_oid to sale_account_id;
        alter table inventory alter column sale_account_id set not null;
        --
        alter table inventory drop column if exists purchase_account_id;
        alter table inventory rename column purchase_account_oid to purchase_account_id;
        alter table inventory alter column purchase_account_id set not null;
        --
        alter table tds_nature_of_payment drop column if exists tds_account_id;
        alter table tds_nature_of_payment rename column tds_account_oid to tds_account_id;
        alter table tds_nature_of_payment alter column tds_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists party_account_id;
        alter table tds_on_voucher rename column party_account_oid to party_account_id;
        alter table tds_on_voucher alter column party_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists tds_account_id;
        alter table tds_on_voucher rename column tds_account_oid to tds_account_id;
        alter table tds_on_voucher alter column tds_account_id set not null;
        --
        alter table inv_txn drop column if exists vendor_id;
        alter table inv_txn rename column vendor_oid to vendor_id;
        --
        alter table inventory_branch_detail drop column if exists preferred_vendor_id;
        alter table inventory_branch_detail rename column preferred_vendor_oid to preferred_vendor_id;
        --
        alter table inventory_branch_detail drop column if exists last_vendor_id;
        alter table inventory_branch_detail rename column last_vendor_oid to last_vendor_id;
        --
        -- alter table udm_vendor_bill_map drop column if exists vendor_id;
        -- alter table udm_vendor_bill_map rename column vendor_oid to vendor_id;
        -- alter table udm_vendor_bill_map alter column vendor_id set not null;
        -- alter table udm_vendor_bill_map add constraint udm_vendor_bill_map_pkey PRIMARY KEY (vendor_id);
        --
        -- alter table udm_vendor_item_map drop column if exists vendor_id;
        -- alter table udm_vendor_item_map rename column vendor_oid to vendor_id;
        -- alter table udm_vendor_item_map alter column vendor_id set not null;
        -- alter table udm_vendor_item_map alter column unit_id set not null;
        -- alter table udm_vendor_item_map add constraint udm_vendor_item_map_pkey PRIMARY KEY (vendor_id, vendor_inventory);
-- ACCOUNT_TYPE
    alter table account_type drop column if exists id;
    alter table account_type rename column oid_id to id;
    alter table account_type alter column id set not null;
    ALTER TABLE account_type ADD CONSTRAINT account_type_pkey PRIMARY KEY (id);
    alter table account_type drop column if exists parent_id;
    alter table account_type rename column parent_oid to parent_id;
        --
        alter table ac_txn drop column if exists account_type_id;
        alter table ac_txn rename column account_type_oid to account_type_id;
        alter table ac_txn alter column account_type_id set not null;
        --
        alter table account drop column if exists account_type_id;
        alter table account rename column account_type_oid to account_type_id;
        alter table account alter column account_type_id set not null;
        --
        alter table bill_allocation drop column if exists account_type_id;
        alter table bill_allocation rename column account_type_oid to account_type_id;
        alter table bill_allocation alter column account_type_id set not null;
        --
        alter table account drop column if exists bank_id;
        alter table account add column if not exists bank_id text;
        --
        alter table account drop column if exists bank_beneficiary_id;
        alter table account add column if not exists bank_beneficiary_id text;
-- AC_TXN
    alter table ac_txn drop column if exists id;
    alter table ac_txn rename column oid_id to id;
    alter table ac_txn alter column id set not null;
    ALTER TABLE ac_txn ADD CONSTRAINT ac_txn_pkey PRIMARY KEY (id);
        --
        alter table bank_txn drop column if exists ac_txn_id;
        alter table bank_txn rename column ac_txn_oid to ac_txn_id;
        alter table bank_txn alter column ac_txn_id set not null;
        --
        alter table bill_allocation drop column if exists ac_txn_id;
        alter table bill_allocation rename column ac_txn_oid to ac_txn_id;
        alter table bill_allocation alter column ac_txn_id set not null;
-- INV_TXN
    alter table inv_txn drop column if exists id;
    alter table inv_txn rename column oid_id to id;
    alter table inv_txn alter column id set not null;
    ALTER TABLE inv_txn ADD CONSTRAINT inv_txn_pkey PRIMARY KEY (id);
-- BANK_TXN
    alter table bank_txn drop column if exists id;
    alter table bank_txn rename column oid_id to id;
    alter table bank_txn alter column id set not null;
    ALTER TABLE bank_txn ADD CONSTRAINT bank_txn_pkey PRIMARY KEY (id);
-- BILL_ALLOCATION
    alter table bill_allocation drop column if exists id;
    alter table bill_allocation rename column oid_id to id;
    alter table bill_allocation alter column id set not null;
    ALTER TABLE bill_allocation ADD CONSTRAINT bill_allocation_pkey PRIMARY KEY (id);
-- TDS_ON_VOUCHER
    alter table tds_on_voucher drop column if exists id;
    alter table tds_on_voucher rename column oid_id to id;
    alter table tds_on_voucher alter column id set not null;
    ALTER TABLE tds_on_voucher ADD CONSTRAINT tds_on_voucher_pkey PRIMARY KEY (id);
-- BRANCH
    alter table branch drop column if exists id;
    alter table branch rename column oid_id to id;
    alter table branch alter column id set not null;
    ALTER TABLE branch ADD CONSTRAINT branch_pkey PRIMARY KEY (id);
    alter table branch alter column misc type jsonb using misc::jsonb;
    alter table branch alter column configuration type jsonb using configuration::jsonb;
    alter table branch alter column members drop not null;
        --
        alter table ac_txn drop column if exists branch_id;
        alter table ac_txn rename column branch_oid to branch_id;
        alter table ac_txn alter column branch_id set not null;
        --
        alter table account_daily_summary drop column if exists branch_id;
        alter table account_daily_summary rename column branch_oid to branch_id;
        alter table account_daily_summary alter column branch_id set not null;
        ALTER TABLE account_daily_summary ADD CONSTRAINT account_daily_summary_pkey PRIMARY KEY (account_id, branch_id, date);
        --
        alter table bank_txn drop column if exists branch_id;
        alter table bank_txn rename column branch_oid to branch_id;
        alter table bank_txn alter column branch_id set not null;
        --
        alter table batch drop column if exists branch_id;
        alter table batch rename column branch_oid to branch_id;
        alter table batch alter column branch_id set not null;
        --
        alter table bill_allocation drop column if exists branch_id;
        alter table bill_allocation rename column branch_oid to branch_id;
        alter table bill_allocation alter column branch_id set not null;
        --
        alter table inv_txn drop column if exists branch_id;
        alter table inv_txn rename column branch_oid to branch_id;
        alter table inv_txn alter column branch_id set not null;
        --
        alter table inventory_branch_detail drop column if exists branch_id;
        alter table inventory_branch_detail rename column branch_oid to branch_id;
        alter table inventory_branch_detail alter column branch_id set not null;
        --
        alter table tds_on_voucher drop column if exists branch_id;
        alter table tds_on_voucher rename column branch_oid to branch_id;
        alter table tds_on_voucher alter column branch_id set not null;
        --
        alter table voucher_numbering drop column if exists branch_id;
        alter table voucher_numbering rename column branch_oid to branch_id;
        --
        alter table voucher drop column if exists branch_id;
        alter table voucher rename column branch_oid to branch_id;
        alter table voucher alter column branch_id set not null;
        --
        alter table udm_pos_counter drop column if exists branch_id;
        alter table udm_pos_counter rename column branch_oid to branch_id;
        alter table udm_pos_counter alter column branch_id set not null;
        --
        -- alter table udm_wanted_item drop column if exists branch_id;
        -- alter table udm_wanted_item rename column branch_oid to branch_id;
        -- alter table udm_wanted_item alter column branch_id set not null;
-- DIVISION
    alter table division drop column if exists id;
    alter table division rename column oid_id to id;
    alter table division alter column id set not null;
    ALTER TABLE division ADD CONSTRAINT division_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists division_id;
        alter table batch rename column division_oid to division_id;
        alter table batch alter column division_id set not null;
        --
        alter table inv_txn drop column if exists division_id;
        alter table inv_txn rename column division_oid to division_id;
        alter table inv_txn alter column division_id set not null;
        --
        alter table inventory drop column if exists division_id;
        alter table inventory rename column division_oid to division_id;
        alter table inventory alter column division_id set not null;
-- GST_REGISTRATION
    alter table gst_registration drop column if exists id;
    alter table gst_registration rename column oid_id to id;
    alter table gst_registration alter column id set not null;
    ALTER TABLE gst_registration ADD CONSTRAINT gst_registration_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists gst_registration_id;
        alter table branch rename column gst_registration_oid to gst_registration_id;
-- INVENTORY
    alter table inventory drop column if exists id;
    alter table inventory rename column oid_id to id;
    alter table inventory alter column id set not null;
    ALTER TABLE inventory ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists inventory_id;
        alter table batch rename column inventory_oid to inventory_id;
        alter table batch alter column inventory_id set not null;
        --
        --
        alter table inv_txn drop column if exists inventory_id;
        alter table inv_txn rename column inventory_oid to inventory_id;
        alter table inv_txn alter column inventory_id set not null;
        --
        alter table inventory_branch_detail drop column if exists inventory_id;
        alter table inventory_branch_detail rename column inventory_oid to inventory_id;
        alter table inventory_branch_detail alter column inventory_id set not null;
        alter table inventory_branch_detail add constraint inventory_branch_detail_pkey primary key (branch_id, inventory_id);
        --
        -- alter table udm_vendor_item_map drop column if exists inventory_id;
        -- alter table udm_vendor_item_map rename column inventory_oid to inventory_id;
        -- alter table udm_vendor_item_map alter column inventory_id set not null;
        --
        -- alter table udm_wanted_item drop column if exists inventory_id;
        -- alter table udm_wanted_item rename column inventory_oid to inventory_id;
-- MANUFACTURER
    alter table manufacturer drop column if exists id;
    alter table manufacturer rename column oid_id to id;
    alter table manufacturer alter column id set not null;
    ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);
-- SALES_PERSON
    alter table sales_person drop column if exists id;
    alter table sales_person rename column oid_id to id;
    alter table sales_person alter column id set not null;
    ALTER TABLE sales_person ADD CONSTRAINT sales_person_pkey PRIMARY KEY (id);
-- TDS_NATURE_OF_PAYMENT
    alter table tds_nature_of_payment drop column if exists id;
    alter table tds_nature_of_payment rename column oid_id to id;
    alter table tds_nature_of_payment alter column id set not null;
    ALTER TABLE tds_nature_of_payment ADD CONSTRAINT tds_nature_of_payment_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists tds_nature_of_payment_id;
        alter table account rename column tds_nature_of_payment_oid to tds_nature_of_payment_id;
        --
        alter table tds_on_voucher drop column if exists tds_nature_of_payment_id;
        alter table tds_on_voucher rename column tds_nature_of_payment_oid to tds_nature_of_payment_id;
        alter table tds_on_voucher alter column tds_nature_of_payment_id set not null;
-- UNIT
        --
        alter table batch drop column if exists unit_id;
        --
        alter table batch rename column unit_oid to unit_id;
        --
        alter table batch alter column unit_id set not null;
        --
        alter table inv_txn alter column unit_id set not null;
        --
        alter table inventory drop column if exists unit_id;
        alter table inventory rename column unit_oid to unit_id;
        alter table inventory alter column unit_id set not null;
        --
        alter table inventory drop column if exists sale_unit_id;
        alter table inventory rename column sale_unit_oid to sale_unit_id;
        --
        alter table inventory drop column if exists purchase_unit_id;
        alter table inventory rename column purchase_unit_oid to purchase_unit_id;
-- VOUCHER
    alter table voucher drop column if exists id;
    alter table voucher rename column oid_id to id;
    alter table voucher alter column id set not null;
    ALTER TABLE voucher ADD CONSTRAINT voucher_pkey PRIMARY KEY (id);
        --
        alter table ac_txn drop column if exists voucher_id;
        alter table ac_txn rename column voucher_oid to voucher_id;
        --
        alter table bank_txn drop column if exists voucher_id;
        alter table bank_txn rename column voucher_oid to voucher_id;
        alter table bank_txn alter column voucher_id set not null;
        --
        alter table batch drop column if exists voucher_id;
        alter table batch rename column voucher_oid to voucher_id;
        --
        alter table bill_allocation drop column if exists voucher_id;
        alter table bill_allocation rename column voucher_oid to voucher_id;
        --
        alter table inv_txn drop column if exists voucher_id;
        alter table inv_txn rename column voucher_oid to voucher_id;
        --
        alter table tds_on_voucher drop column if exists voucher_id;
        alter table tds_on_voucher rename column voucher_oid to voucher_id;
        alter table tds_on_voucher alter column voucher_id set not null;
-- VOUCHER_TYPE
    alter table voucher_type drop column if exists id;
    alter table voucher_type rename column oid_id to id;
    alter table voucher_type alter column id set not null;
    ALTER TABLE voucher_type ADD CONSTRAINT voucher_type_pkey PRIMARY KEY (id);
    alter table voucher_type drop column if exists sequence_id;
    alter table voucher_type rename column sequence_oid to sequence_id;
        --
        alter table ac_txn drop column if exists voucher_type_id;
        alter table ac_txn rename column voucher_type_oid to voucher_type_id;
        --
        alter table inv_txn drop column if exists voucher_type_id;
        alter table inv_txn rename column voucher_type_oid to voucher_type_id;
        --
        alter table voucher_numbering drop column if exists voucher_type_id;
        alter table voucher_numbering rename column voucher_type_oid to voucher_type_id;
         --
        alter table voucher drop column if exists voucher_type_id;
        alter table voucher rename column voucher_type_oid to voucher_type_id;
        alter table voucher alter column voucher_type_id set not null;
-- WAREHOUSE
    alter table warehouse drop column if exists id;
    alter table warehouse rename column oid_id to id;
    alter table warehouse alter column id set not null;
    ALTER TABLE warehouse ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists warehouse_id;
        alter table batch rename column warehouse_oid to warehouse_id;
        alter table batch alter column warehouse_id set not null;
--         alter table batch drop column if exists id;
        --
        alter table inv_txn drop column if exists warehouse_id;
        alter table inv_txn rename column warehouse_oid to warehouse_id;
        alter table inv_txn alter column warehouse_id set not null;
-- MEMBER
    alter table member drop column if exists id;
    alter table member rename column oid_id to id;
    alter table member alter column id set not null;
    ALTER TABLE member ADD CONSTRAINT member_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists members;
        alter table branch rename column members_oid to members;
        alter table branch alter column members set not null;
-- FINANCIAL_YEAR
    alter table financial_year drop column if exists id;
    alter table financial_year rename column oid_id to id;
    alter table financial_year alter column id set not null;
    ALTER TABLE financial_year ADD CONSTRAINT financial_year_pkey PRIMARY KEY (id);
        --
        alter table voucher_numbering drop column if exists f_year_id;
        alter table voucher_numbering rename column f_year_oid to f_year_id;
        alter table voucher_numbering ADD CONSTRAINT voucher_numbering_pkey PRIMARY KEY (branch_id, f_year_id, voucher_type_id);
-- BATCH
    alter table batch add unique (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
-- PRINT_TEMPLATE
    alter table print_template drop column if exists id;
    alter table print_template rename column oid_id to id;
    alter table print_template alter column id set not null;
    ALTER TABLE print_template ADD CONSTRAINT print_template_pkey PRIMARY KEY (id);
-- ORGANIZATION
    alter table organization drop column if exists id;
    alter table organization rename column oid_id to id;
    alter table organization alter column id set not null;
    ALTER TABLE organization ADD CONSTRAINT organization_pkey PRIMARY KEY (id);
-- UDM_POS_SESSION
    alter table udm_pos_session drop column if exists id;
    alter table udm_pos_session rename column oid_id to id;
    alter table udm_pos_session alter column id set not null;
    alter table udm_pos_session add constraint udm_pos_session_pkey primary key (id);
        --
        alter table voucher drop column if exists pos_counter_session_id;
-- UDM_POS_COUNTER_SETTLEMENT
    alter table udm_pos_counter_settlement drop column if exists id;
    alter table udm_pos_counter_settlement rename column oid_id to id;
    alter table udm_pos_counter_settlement alter column id set not null;
    alter table udm_pos_counter_settlement add constraint udm_pos_counter_settlement_pkey primary key (id);
        --
        alter table voucher drop column if exists pos_counter_settlement_id;
        --
        alter table udm_pos_session drop column if exists settlement_id;
        alter table udm_pos_session rename column settlement_oid to settlement_id;
-- UDM_DOCTOR
    -- alter table udm_doctor drop column if exists id;
    -- alter table udm_doctor rename column oid_id to id;
    -- alter table udm_doctor alter column id set not null;
    -- alter table udm_doctor add constraint udm_doctor_pkey primary key (id);
-- UDM_DRUG_CLASSIFICATION
    -- alter table udm_drug_classification drop column if exists id;
    -- alter table udm_drug_classification rename column oid_id to id;
    -- alter table udm_drug_classification alter column id set not null;
    -- alter table udm_drug_classification add constraint udm_drug_classification_pkey primary key (id);
        --
        -- alter table udm_inventory_composition drop column if exists drug_classifications;
        -- alter table udm_inventory_composition rename column drug_classifications_oid to drug_classifications;
-- UDM_INVENTORY_COMPOSITION
    -- alter table udm_inventory_composition drop column if exists id;
    -- alter table udm_inventory_composition rename column oid_id to id;
    -- alter table udm_inventory_composition alter column id set not null;
    -- alter table udm_inventory_composition add constraint udm_inventory_composition_pkey primary key (id);
        --
        -- alter table inventory drop column if exists udf_compositions;
        -- alter table inventory rename column udf_compositions_oid to udf_compositions;
-- UDM_WANTED_ITEM
    -- alter table udm_wanted_item drop column if exists id;
    -- alter table udm_wanted_item rename column oid_id to id;
    -- alter table udm_wanted_item alter column id set not null;
    -- alter table udm_wanted_item add constraint udm_wanted_item_pkey primary key (id);

select now() as time, 'RENAMING AND DROPPING UUID COLUMN END' as msg;
-- -------------------------------------------------------------------------------------------------
-- ---- INDEX RESTORE
-- -------------------------------------------------------------------------------------------------
-- select now() as time, 'ADDING REQUIRED INDEX START' as msg;
-- --## ac_txn
--     create index on ac_txn (voucher_id);
--     create index on ac_txn (date);
--     create index on ac_txn (account_id);
--     create index on ac_txn (branch_id);
-- --## account
--     create index on account (val_name);
--     create index on account (transaction_enabled);
--     create index on account (mobile);
-- --## bank_txn
--     create index on bank_txn (date);
--     drop index if exists bank_txn_ac_txn_id;
--     create index on bank_txn (ac_txn_id);
--     create index on bank_txn (account_id);
--     create index on bank_txn (voucher_id);
-- --## batch
--     drop index if exists batch_barcode;
--     create index on batch (barcode);
--     create index on batch (inventory_id, branch_id, warehouse_id);
-- --## bill_allocation
--     create index on bill_allocation (eff_date);
--     drop index if exists bill_allocation_ac_txn_id;
--     create index on bill_allocation (ac_txn_id);
--     create index on bill_allocation (account_id);
--     create index on bill_allocation (voucher_id);
--     create index on bill_allocation (branch_id, account_id, ref_no);
-- --## inv_txn
--     create index on inv_txn (voucher_id);
--     create index on inv_txn (date);
--     create index on inv_txn (inventory_id);
--     create index on inv_txn (branch_id);
--     create index on inv_txn (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
-- --## inventory
--     create index on inventory (val_name);
-- --## voucher
--     create index on voucher (date);
--     create index on voucher (voucher_no);
--     create index on voucher (branch_id);
--     create index on voucher (base_voucher_type);
-- select now() as time, 'ADDING REQUIRED INDEX END' as msg;
--## last query
delete from unit_conversion where conversion = 1;
--## drop if any default exists
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_schema, table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND column_default IS NOT NULL
    LOOP
        EXECUTE format(
            'ALTER TABLE %I.%I ALTER COLUMN %I DROP DEFAULT',
            r.table_schema,
            r.table_name,
            r.column_name
        );
    END LOOP;
END $$;
--##
select now() as time, 'MIGRATION END' as msg;