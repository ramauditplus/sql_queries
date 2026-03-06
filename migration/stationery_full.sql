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

--## MODIFY_TABLE
drop table if exists vendor_bill_map;
drop table if exists vendor_item_map;
--
drop table if exists doctor;
-- alter table doctor rename to udm_doctor;
--     alter table udm_doctor drop if exists display_name;
--     alter table udm_doctor drop if exists alias_name;
--     alter table udm_doctor drop if exists age;
drop table if exists drug_classification;
drop table if exists inventory_composition;
--
alter table organization
    add if not exists created_by uuid,
    add if not exists updated_by uuid;
--
alter table organization
    alter column configuration type jsonb using configuration::jsonb,
    alter column license_claims type jsonb using license_claims::jsonb;
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
--## f_key
--## MODIFY_TABLE

--## PERMISSION
drop table if exists permission;
--##
create table if not exists permission
(
    name       text primary key,
    created_by uuid      not null,
    updated_by uuid      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--## permission insert
insert into permission (name, created_by, updated_by, created_at, updated_at)
values
    --account
    ('account_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --account_type
    ('account_type_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_type_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_type_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_type_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_type_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --bank_beneficiary
    ('bank_beneficiary_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_beneficiary_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_beneficiary_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_beneficiary_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_beneficiary_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --base_voucher_type
    ('base_voucher_type_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('base_voucher_type_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('base_voucher_type_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('base_voucher_type_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --batch
    ('batch_label', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('batch_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('batch_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --bill_allocation_breakup
    ('bill_allocation_breakup', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --bill_of_material
    ('bill_of_material_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bill_of_material_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bill_of_material_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bill_of_material_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bill_of_material_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --branch
    ('branch_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('branch_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('branch_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('branch_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('branch_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --gst_registration
    ('gst_registration_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gst_registration_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gst_registration_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gst_registration_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gst_registration_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --gst_tax
    ('gst_tax_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --gstr_2b
    ('gstr_2b_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gstr_2b_reconcile', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gstr_2b_upload', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --section
    ('section_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('section_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('section_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('section_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('section_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --inventory
    ('inventory_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --inventory_opening
    ('inventory_opening', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --unit_conversion
    ('unit_conversion_set', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --unit
    ('unit_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('unit_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('unit_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('unit_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('unit_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --financial_report
    ('financial_report', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('opening_balance_difference', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --financial_year
    ('financial_year_add', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('financial_year_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('financial_year_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --manufacturer
    ('manufacturer_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('manufacturer_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('manufacturer_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('manufacturer_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('manufacturer_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --warehouse
    ('warehouse_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('warehouse_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('warehouse_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('warehouse_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('warehouse_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --member
    ('member_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('member_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('member_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('member_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --permission
    ('permission_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('permission_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('permission_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('permission_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('permission_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --tds_nature_of_payment
    ('tds_nature_of_payment_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('tds_nature_of_payment_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('tds_nature_of_payment_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('tds_nature_of_payment_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('tds_nature_of_payment_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --tds_section_breakup
    ('tds_section_breakup', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --print_layout
    ('print_layout_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_layout_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_layout_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_layout_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --print_template
    ('print_template_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_template_reset', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_template_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_template_cancel', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('print_template_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --stock_location
    ('stock_location_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_location_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_location_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_location_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_location_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_location_assign', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --set_inventory_branch_price_configuration
    ('price_configuration_set', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --organization
    ('organization_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('organization_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --voucher_register
    ('voucher_register_detail', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_register_group', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --voucher_type
    ('voucher_type_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_type_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_type_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_type_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_type_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --voucher
    ('voucher_create', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_update', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_get', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_cancel', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('voucher_delete', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    --report and other
    ('account_book', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_outstanding', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_transaction_history', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bill_outstanding', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_collection', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_list', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('gst_r1', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('day_book', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('bank_reconciliation', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('sale_analysis', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('stock_analysis', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('expiry_analysis', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('negative_stock_analysis', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('non_movement_analysis', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_batch', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_book', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('inventory_transaction_history', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('memorandum', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('partywise_detail', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('get_batch_detail_with_stock_location', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('get_inventory_branch_stock_location_label', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('get_stock_location_wise_branch_stock', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('get_transfer_pending', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('account_opening', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp),
    ('tds_detail', '01941f29-7c00-7000-8000-000000000000', '01941f29-7c00-7000-8000-000000000000', current_timestamp, current_timestamp);
--##
--## PERMISSION

--## SECTION
--##
create table if not exists section
(
    id         uuid      not null primary key,
    old_id     int,
    name       text      not null,
    created_by int       not null,
    updated_by int       not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
INSERT INTO section (id, old_id, name, created_by, updated_by, created_at, updated_at)
SELECT uuidv7(), id, name, created_by, updated_by, created_at, updated_at
FROM category_option;
--## SECTION

--## UNIT AND UNIT_CONVERSION
drop table if exists unit;
create table unit
(
    id         uuid      not null primary key,
    name       text      not null,
    uqc        text      not null,
    symbol     text      not null,
    precision  integer   not null,
    created_by uuid      not null,
    updated_by uuid      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
drop table if exists unit_conversion;
create table unit_conversion
(
    primary_unit_id    uuid  not null,
    conversion_unit_id uuid  not null,
    conversion         float not null,
    primary key (primary_unit_id, conversion)
);
--##
with a as (select distinct retail_qty
           from batch
           order by retail_qty)
insert
into unit
select uuidv7(),
       a.retail_qty::text || 'S',
       'OTH',
       a.retail_qty::text,
       1,
       '01941f29-7c00-7000-8000-000000000000',
       '01941f29-7c00-7000-8000-000000000000',
       now(),
       now()
from a;
--##
insert into unit_conversion
select (select u.id from unit u where symbol = '1'), id, symbol::float
from unit;
--## UNIT AND UNIT_CONVERSION

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
    cgst_payable_account_id    uuid   not null,
    sgst_payable_account_id    uuid   not null,
    igst_payable_account_id    uuid   not null,
    cgst_receivable_account_id uuid   not null,
    sgst_receivable_account_id uuid   not null,
    igst_receivable_account_id uuid   not null
);
--##
insert into gst_tax
(name, display_name, igst, cgst, sgst, cgst_payable_account_id, sgst_payable_account_id, igst_payable_account_id,
 cgst_receivable_account_id, sgst_receivable_account_id, igst_receivable_account_id)
values ('gstna', 'Not Applicable', 0.0, 0.0, 0.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gstexempt', 'Exempt', 0.0, 0.0, 0.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gstngs', 'Non Gst Supply', 0.0, 0.0, 0.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst0', 'Gst 0%', 0.0, 0.0, 0.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst0p1', 'Gst 0.1%', 0.1, 0.05, 0.05, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst0p25', 'Gst 0.25%', 0.25, 0.125, 0.125, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst1', 'Gst 1%', 1.0, 0.5, 0.5, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst1p5', 'Gst 1.5%', 1.50, 0.75, 0.75, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst3', 'Gst 3%', 3.0, 1.5, 1.5, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst5', 'Gst 5%', 5.0, 2.5, 2.5, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst6', 'Gst 6%', 6.0, 3.0, 3.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst7p5', 'Gst 7.5%', 7.5, 3.75, 3.75, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst12', 'Gst 12%', 12.0, 6.0, 6.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst18', 'Gst 18%', 18.0, 9.0, 9.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst28', 'Gst 28%', 28.0, 14.0, 14.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000'),
       ('gst40', 'Gst 40%', 40.0, 20.0, 20.0, '0194bece-a000-701f-8000-000000000000', '0194c3f4-fc00-7020-8000-000000000000', '0194c91b-5800-7021-8000-000000000000', '0194d368-1000-7023-8000-000000000000', '0194d88e-6c00-7024-8000-000000000000', '0194ddb4-c800-7025-8000-000000000000');
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

------------------------------------------------------------------------
-- UUID CHANGES
------------------------------------------------------------------------
select now() as time, 'SETTING UUID AS COLUMN STARTS' as msg;

ALTER TABLE account_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE account_type SET uuid_id = '01942976-3400-7002-8000-000000000000' WHERE id = 1;
    UPDATE account_type SET uuid_id = '01942e9c-9000-7003-8000-000000000000' WHERE id = 2;
    UPDATE account_type SET uuid_id = '019433c2-ec00-7004-8000-000000000000' WHERE id = 3;
    UPDATE account_type SET uuid_id = '019438e9-4800-7005-8000-000000000000' WHERE id = 4;
    UPDATE account_type SET uuid_id = '01943e0f-a400-7006-8000-000000000000' WHERE id = 5;
    UPDATE account_type SET uuid_id = '01944336-0000-7007-8000-000000000000' WHERE id = 6;
    UPDATE account_type SET uuid_id = '0194485c-5c00-7008-8000-000000000000' WHERE id = 7;
    UPDATE account_type SET uuid_id = '01944d82-b800-7009-8000-000000000000' WHERE id = 8;
    UPDATE account_type SET uuid_id = '019452a9-1400-700a-8000-000000000000' WHERE id = 9;
    UPDATE account_type SET uuid_id = '019457cf-7000-700b-8000-000000000000' WHERE id = 10;
    UPDATE account_type SET uuid_id = '01945cf5-cc00-700c-8000-000000000000' WHERE id = 11;
    UPDATE account_type SET uuid_id = '0194621c-2800-700d-8000-000000000000' WHERE id = 12;
    UPDATE account_type SET uuid_id = '01946742-8400-700e-8000-000000000000' WHERE id = 13;
    UPDATE account_type SET uuid_id = '01946c68-e000-700f-8000-000000000000' WHERE id = 14;
    UPDATE account_type SET uuid_id = '0194718f-3c00-7010-8000-000000000000' WHERE id = 15;
    UPDATE account_type SET uuid_id = '019476b5-9800-7011-8000-000000000000' WHERE id = 16;
    UPDATE account_type SET uuid_id = '01947bdb-f400-7012-8000-000000000000' WHERE id = 17;
    UPDATE account_type SET uuid_id = '01948102-5000-7013-8000-000000000000' WHERE id = 18;
    UPDATE account_type SET uuid_id = '01948628-ac00-7014-8000-000000000000' WHERE id = 19;
    UPDATE account_type SET uuid_id = '01948b4f-0800-7015-8000-000000000000' WHERE id = 20;
    UPDATE account_type SET uuid_id = '01949075-6400-7016-8000-000000000000' WHERE id = 21;
    UPDATE account_type SET uuid_id = '0194959b-c000-7017-8000-000000000000' WHERE id = 22;
    UPDATE account_type SET uuid_id = '01949ac2-1c00-7018-8000-000000000000' WHERE id = 23;
    UPDATE account_type SET uuid_id = '01949fe8-7800-7019-8000-000000000000' WHERE id = 24;
    UPDATE account_type SET uuid_id = '0194a50e-d400-701a-8000-000000000000' WHERE id = 25;
    UPDATE account_type SET uuid_id = '0194aa35-3000-701b-8000-000000000000' WHERE id = 26;
ALTER TABLE account_type ADD COLUMN IF NOT EXISTS parent_uuid uuid;
    UPDATE account_type b SET parent_uuid = a.uuid_id FROM account_type a WHERE a.id = b.parent_id;

ALTER TABLE account ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
    UPDATE account SET uuid_id = '0194af5b-8c00-701c-8000-000000000000', account_type_uuid = '01947bdb-f400-7012-8000-000000000000' WHERE id = 1;
    UPDATE account SET uuid_id = '0194b481-e800-701d-8000-000000000000', account_type_uuid = '01943e0f-a400-7006-8000-000000000000' WHERE id = 2;
    UPDATE account SET uuid_id = '0194b9a8-4400-701e-8000-000000000000', account_type_uuid = '01944d82-b800-7009-8000-000000000000' WHERE id = 3;
    UPDATE account SET uuid_id = '0194bece-a000-701f-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 4;
    UPDATE account SET uuid_id = '0194c3f4-fc00-7020-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 5;
    UPDATE account SET uuid_id = '0194c91b-5800-7021-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 6;
    UPDATE account SET uuid_id = '0194ce41-b400-7022-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 7;
    UPDATE account SET uuid_id = '0194d368-1000-7023-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 8;
    UPDATE account SET uuid_id = '0194d88e-6c00-7024-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 9;
    UPDATE account SET uuid_id = '0194ddb4-c800-7025-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 10;
    UPDATE account SET uuid_id = '0194e2db-2400-7026-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE id = 11;
    UPDATE account SET uuid_id = '0194e801-8000-7027-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE id = 12;
    UPDATE account SET uuid_id = '0194ed27-dc00-7028-8000-000000000000', account_type_uuid = '0194485c-5c00-7008-8000-000000000000' WHERE id = 13;
    UPDATE account SET uuid_id = '0194f24e-3800-7029-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE id = 14;
    UPDATE account SET uuid_id = '0194f774-9400-702a-8000-000000000000', account_type_uuid = '01942e9c-9000-7003-8000-000000000000' WHERE id = 15;
    UPDATE account SET uuid_id = '0194fc9a-f000-702b-8000-000000000000', account_type_uuid = '0194621c-2800-700d-8000-000000000000' WHERE id = 16;
    UPDATE account SET uuid_id = '019501c1-4c00-702c-8000-000000000000', account_type_uuid = '01942e9c-9000-7003-8000-000000000000' WHERE id = 17;
    UPDATE account SET uuid_id = '019506e7-a800-702d-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE id = 18;
    UPDATE account SET uuid_id = '01950c0e-0400-702e-8000-000000000000', account_type_uuid = '019433c2-ec00-7004-8000-000000000000' WHERE id = 19;
    UPDATE account SET uuid_id = '01951134-6000-702f-8000-000000000000', account_type_uuid = '01949fe8-7800-7019-8000-000000000000' WHERE id = 20;

ALTER TABLE bank ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE bank SET uuid_id = '0195165a-bc00-7030-8000-000000000000' WHERE id = 1;
    UPDATE bank SET uuid_id = '01951b81-1800-7031-8000-000000000000' WHERE id = 2;
    UPDATE bank SET uuid_id = '019520a7-7400-7032-8000-000000000000' WHERE id = 3;
    UPDATE bank SET uuid_id = '019525cd-d000-7033-8000-000000000000' WHERE id = 4;
    UPDATE bank SET uuid_id = '01952af4-2c00-7034-8000-000000000000' WHERE id = 5;
    UPDATE bank SET uuid_id = '0195301a-8800-7035-8000-000000000000' WHERE id = 6;
    UPDATE bank SET uuid_id = '01953540-e400-7036-8000-000000000000' WHERE id = 7;
    UPDATE bank SET uuid_id = '01953a67-4000-7037-8000-000000000000' WHERE id = 8;
    UPDATE bank SET uuid_id = '01953f8d-9c00-7038-8000-000000000000' WHERE id = 9;
    UPDATE bank SET uuid_id = '019544b3-f800-7039-8000-000000000000' WHERE id = 10;
    UPDATE bank SET uuid_id = '019549da-5400-703a-8000-000000000000' WHERE id = 11;
    UPDATE bank SET uuid_id = '01954f00-b000-703b-8000-000000000000' WHERE id = 12;

ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE branch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE gst_registration ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE inventory ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE manufacturer ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE sales_person ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE tds_nature_of_payment  ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE voucher_type SET uuid_id = '01955427-0c00-703c-8000-000000000000' WHERE id = 1;
    UPDATE voucher_type SET uuid_id = '0195594d-6800-703d-8000-000000000000' WHERE id = 2;
    UPDATE voucher_type SET uuid_id = '01955e73-c400-703e-8000-000000000000' WHERE id = 3;
    UPDATE voucher_type SET uuid_id = '0195639a-2000-703f-8000-000000000000' WHERE id = 4;
    UPDATE voucher_type SET uuid_id = '019568c0-7c00-7040-8000-000000000000' WHERE id = 5;
    UPDATE voucher_type SET uuid_id = '01956de6-d800-7041-8000-000000000000' WHERE id = 6;
    UPDATE voucher_type SET uuid_id = '0195730d-3400-7042-8000-000000000000' WHERE id = 7;
    UPDATE voucher_type SET uuid_id = '01957833-9000-7043-8000-000000000000' WHERE id = 8;
    UPDATE voucher_type SET uuid_id = '01957d59-ec00-7044-8000-000000000000' WHERE id = 9;
    UPDATE voucher_type SET uuid_id = '01958280-4800-7045-8000-000000000000' WHERE id = 10;
    UPDATE voucher_type SET uuid_id = '019587a6-a400-7046-8000-000000000000' WHERE id = 17;
    UPDATE voucher_type SET uuid_id = '01958ccd-0000-7047-8000-000000000000' WHERE id = 21;
    UPDATE voucher_type SET uuid_id = '019591f3-5c00-7048-8000-000000000000' WHERE id = 23;
    alter table voucher_type alter column config type jsonb using config::jsonb;
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
    UPDATE voucher_type SET config = config -> lower(base_type) WHERE config ? lower(base_type);
    UPDATE voucher_type SET name = 'Stock Journal', base_type = 'STOCK_JOURNAL' WHERE id = 10;
ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS sequence_uuid uuid;
        UPDATE voucher_type b SET sequence_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.sequence_id;

ALTER TABLE warehouse ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE member ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE member SET uuid_id = '01941f29-7c00-7000-8000-000000000000' WHERE id = 1;
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS members_uuid uuid[];
        UPDATE branch t
        SET members_uuid =
                (SELECT array_agg(member.uuid_id)
                 FROM unnest(t.members) AS u(class_id)
                          JOIN member
                               ON member.id = u.class_id)
        WHERE t.members IS NOT NULL;
        UPDATE voucher_type vt
        SET members = (SELECT jsonb_agg(
                                      jsonb_set(
                                              elem,
                                              '{member_id}',
                                              jsonb_build_object(
                                                      '$uuid',
                                                      m.uuid_id
                                              )
                                      )
                              )
                       FROM jsonb_array_elements(vt.members) elem
                                JOIN member m
                                     ON m.id = (elem ->> 'member_id')::int)
        WHERE vt.members IS NOT NULL;
    ALTER TABLE ac_txn ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE ac_txn ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gstr_2b ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_doctor ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_doctor ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_drug_classification ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_drug_classification ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_inventory_composition ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
--     ALTER TABLE udm_inventory_composition ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;

ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE print_template ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

-- ALTER TABLE udm_doctor ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
--
-- ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
--
-- ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

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
-- Account uuid related changes
ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_uuid uuid;
ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_beneficiary_uuid uuid;
ALTER TABLE account ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
------------------
    UPDATE account b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    UPDATE account b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;
    UPDATE account b SET bank_beneficiary_uuid = a.uuid_id FROM bank_beneficiary a WHERE a.id = b.bank_beneficiary_id;
    UPDATE account b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
select now() as time, 'CHANGES FOR ACCOUNT ENDS' as msg;
--## ACCOUNT
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## BRANCH
select now() as time, 'UUID_CHANGES FOR BRANCH STARTS' as msg;
ALTER TABLE branch ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE branch ADD COLUMN IF NOT EXISTS gst_registration_uuid uuid;
------------------
    UPDATE branch b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE branch b SET gst_registration_uuid = a.uuid_id FROM gst_registration a WHERE a.id = b.gst_registration_id;
select now() as time, 'UUID_CHANGES FOR ACCOUNT ENDS' as msg;
--## BRANCH
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## BANK_BENEFICIARY
select now() as time, 'UUID_CHANGES FOR BANK_BENEFICIARY STARTS' as msg;
-- bank_beneficiary field related changes
alter table bank_beneficiary rename beneficiary_code to code;
alter table bank_beneficiary alter column bank_account_type set not null;
-- bank_beneficiary uuid related changes
ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS bank_uuid uuid;
------------------
    UPDATE bank_beneficiary b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;
select now() as time, 'UUID_CHANGES FOR BANK_BENEFICIARY ENDS' as msg;
--## BANK_BENEFICIARY
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## BANK_TXN
select now() as time, 'UUID_CHANGES FOR BANK_TXN STARTS' as msg;
-- bank_txn field related changes
alter table bank_txn alter column sno type integer using sno::integer;
alter table bank_txn alter column is_memo set not null;
-- bank_txn uuid related changes
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE bank_txn b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE bank_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id;
    UPDATE bank_txn b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bank_txn b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'UUID_CHANGES FOR BANK_TXN ENDS' as msg;
--## BANK_TXN
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
select now() as time, 'UUID_CHANGES FOR BILL_ALLOCATION STARTS' as msg;
-- bill_allocation field related changes
alter table bill_allocation rename meta_data to metadata;
alter table bill_allocation alter column metadata type jsonb using metadata::jsonb;
alter table bill_allocation alter column sno type int using sno::int;
-- bill_allocation uuid related changes
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE bill_allocation b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE bill_allocation b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    UPDATE bill_allocation b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bill_allocation b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'UUID_CHANGES FOR BILL_ALLOCATION STARTS' as msg;
--## BILL_ALLOCATION
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## INVENTORY
select now() as time, 'UUID_CHANGES FOR INVENTORY STARTS' as msg;
-- inventory field related changes
alter table inventory
    add if not exists cess_qty    float,
    add if not exists cess_value    float;
alter table inventory rename column category1_id to section_id;
alter table inventory drop column if exists compositions;
--##
update inventory
set cess_qty   = (cess ->> 'on_quantity')::double precision,
    cess_value = (cess ->> 'on_value')::double precision;
--##
alter table inventory add column code integer;
update inventory set code = id;
alter table inventory alter column code set not null;
-- inventory uuid related changes
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_account_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_account_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS section_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS unit_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_unit_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_unit_uuid uuid;
-- ALTER TABLE inventory ADD COLUMN IF NOT EXISTS udf_compositions_uuid uuid[];
------------------
    UPDATE inventory b SET sale_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sale_account_id and a.transaction_enabled;
    UPDATE inventory b SET purchase_account_uuid = a.uuid_id FROM account a WHERE a.id = b.purchase_account_id and a.transaction_enabled;
    UPDATE inventory b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    UPDATE inventory b SET section_uuid = a.id FROM section a WHERE a.old_id = b.section_id;
    UPDATE inventory b
    SET unit_uuid          = (select id from unit where symbol = '1'),
        sale_unit_uuid     = (select id from unit where symbol = '1'),
        purchase_unit_uuid = (select id from unit where symbol = '1');
--     UPDATE inventory t
--         SET udf_compositions_uuid =
--                 (SELECT array_agg(udm_inventory_composition.uuid_id)
--                  FROM unnest(t.udf_compositions) AS u(class_id)
--                           JOIN udm_inventory_composition
--                                ON udm_inventory_composition.id = u.class_id)
--         WHERE t.udf_compositions IS NOT NULL;
select now() as time, 'UUID_CHANGES FOR INVENTORY ENDS' as msg;
--
    alter table inventory drop column if exists section_id;
    alter table inventory rename column section_uuid to section_id;
--
    alter table inventory drop column if exists manufacturer_id;
    alter table inventory rename column manufacturer_uuid to manufacturer_id;
--## INVENTORY
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## INVENTORY_BRANCH_DETAIL
select now() as time, 'UUID_CHANGES FOR INVENTORY_BRANCH_DETAIL STARTS' as msg;
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
-- inventory_branch_detail uuid related changes
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS preferred_vendor_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS last_vendor_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE inventory_branch_detail b SET preferred_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.preferred_vendor_id;
    UPDATE inventory_branch_detail b SET last_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.last_vendor_id;
    UPDATE inventory_branch_detail b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE inventory_branch_detail b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'UUID_CHANGES FOR INVENTORY_BRANCH_DETAIL ENDS' as msg;
--## INVENTORY_BRANCH_DETAIL
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## TDS_NATURE_OF_PAYMENT
select now() as time, 'UUID_CHANGES FOR TDS_NATURE_OF_PAYMENT STARTS' as msg;
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
-- tds_nature_of_payment uuid related changes
ALTER TABLE tds_nature_of_payment ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
------------------
    UPDATE tds_nature_of_payment b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
select now() as time, 'UUID_CHANGES FOR TDS_NATURE_OF_PAYMENT ENDS' as msg;
--## TDS_NATURE_OF_PAYMENT
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## TDS_ON_VOUCHER
select now() as time, 'UUID_CHANGES FOR TDS_ON_VOUCHER STARTS' as msg;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS party_account_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE tds_on_voucher b SET party_account_uuid = a.uuid_id FROM account a WHERE a.id = b.party_account_id;
    UPDATE tds_on_voucher b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
    UPDATE tds_on_voucher b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE tds_on_voucher b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
    UPDATE tds_on_voucher b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'UUID_CHANGES FOR TDS_ON_VOUCHER ENDS' as msg;
--## TDS_ON_VOUCHER
---------------------------------------------------------------------------

/*
---------------------------------------------------------------------------
--## UDM_VENDOR_ITEM_MAP
select now() as time, 'UUID_CHANGES FOR UDM_VENDOR_ITEM_MAP STARTS' as msg;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE udm_vendor_item_map b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
    UPDATE udm_vendor_item_map b SET inventory_uuid = a.uuid_id FROM account a WHERE a.id = b.inventory_id;
select now() as time, 'UUID_CHANGES FOR UDM_VENDOR_ITEM_MAP ENDS' as msg;
--## UDM_VENDOR_ITEM_MAP
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## UDM_VENDOR_BILL_MAP
select now() as time, 'UUID_CHANGES FOR UDM_VENDOR_BILL_MAP STARTS' as msg;
ALTER TABLE udm_vendor_bill_map ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
------------------
    UPDATE udm_vendor_bill_map b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
select now() as time, 'UUID_CHANGES FOR UDM_VENDOR_BILL_MAP ENDS' as msg;
--## UDM_VENDOR_BILL_MAP
---------------------------------------------------------------------------
*/

---------------------------------------------------------------------------
--## BILL_OF_MATERIAL
select now() as time, 'UUID_CHANGES FOR BILL_OF_MATERIAL STARTS' as msg;
ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE bill_of_material b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'UUID_CHANGES FOR BILL_OF_MATERIAL ENDS' as msg;
--## BILL_OF_MATERIAL
---------------------------------------------------------------------------

/*
---------------------------------------------------------------------------
--## UDM_INVENTORY_COMPOSITION
select now() as time, 'UUID_CHANGES FOR UDM_INVENTORY_COMPOSITION STARTS' as msg;
ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS drug_classifications_uuid uuid[];
------------------
    UPDATE udm_inventory_composition t
        SET drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.drug_classifications IS NOT NULL;
select now() as time, 'UUID_CHANGES FOR UDM_INVENTORY_COMPOSITION ENDS' as msg;
--## UDM_INVENTORY_COMPOSITION
---------------------------------------------------------------------------
*/

---------------------------------------------------------------------------
--## ACCOUNT_DAILY_SUMMARY
select now() as time, 'UUID_CHANGES FOR ACCOUNT_DAILY_SUMMARY STARTS' as msg;
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS branch_uuid uuid;
------------------
    UPDATE account_daily_summary b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE account_daily_summary b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'UUID_CHANGES FOR ACCOUNT_DAILY_SUMMARY ENDS' as msg;
--## ACCOUNT_DAILY_SUMMARY
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## VOUCHER_NUMBERING
select now() as time, 'UUID_CHANGES FOR VOUCHER_NUMBERING STARTS' as msg;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS f_year_uuid uuid;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS branch_uuid uuid;
------------------
    UPDATE voucher_numbering b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    UPDATE voucher_numbering SET f_year_uuid = uuid_id FROM financial_year WHERE financial_year.id = voucher_numbering.f_year_id;
    UPDATE voucher_numbering b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
select now() as time, 'UUID_CHANGES FOR VOUCHER_NUMBERING ENDS' as msg;
--## VOUCHER_NUMBERING

-- GSTR_2B --
--##
alter table if exists gstr_2b drop column IF EXISTS id;
alter table if exists gstr_2b rename column gst_no to ctin;
alter table if exists gstr_2b rename column supplier_name to trdnm;
alter table if exists gstr_2b rename column invoice_no to inum;
alter table if exists gstr_2b rename column invoice_date to dt;
alter table if exists gstr_2b rename column total_invoice_value to val;
alter table if exists gstr_2b rename column total_taxable_amount to txval;
alter table if exists gstr_2b rename column integrated_tax_amount to igst;
alter table if exists gstr_2b rename column central_tax_amount to cgst;
alter table if exists gstr_2b rename column state_tax_amount to sgst;
alter table if exists gstr_2b rename column cess_amount to cess;
-- GSTR_2B --

-- MEMBER --
--##
alter table member
    add if not exists perms text[],
    add if not exists ui_perms jsonb;
--##
update member m
set
    perms    = coalesce(mr.perms, '{}'::text[]),
    ui_perms = coalesce(to_jsonb(mr.perms), '[]'::jsonb)
from member_role mr
where mr.name = m.role_id;
--##
alter table member alter column settings type jsonb using settings::jsonb;
-- MEMBER --

-- PRINT_LAYOUT --
--##
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
-- PRINT_LAYOUT --

-- PRINT_TEMPLATE --
update print_template
set layout = 'STOCK_JOURNAL'
where layout = 'STOCK_DEDUCTION';
--##
alter table print_template
    rename column type to mode;
-- PRINT_TEMPLATE --

--NEW TABLE--

-- SEQUENCE --
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


select now() as time, 'general_migration_end' as msg;

-------------------------------------------------------------------------------------------------
---- APPLY UUID for batch, voucher
-------------------------------------------------------------------------------------------------

--## BATCH
-- field related changes
alter table batch drop column if exists section_id;
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
-- alter table batch rename column category1_id to section_id;
alter table batch alter column batch_no set not null;
-- uuid related changes
select now() as time, 'UUID_CHANGES FOR BATCH STARTS' as msg;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS manufacturer_id uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS section_id uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS unit_uuid uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE batch ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
------------------
create index on batch (vendor_id, vendor_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET vendor_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.vendor_id
              AND i.vendor_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE vendor_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where vendor_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on batch (branch_id, branch_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET branch_uuid = a.uuid_id
            FROM branch a
            WHERE a.id = i.branch_id
              AND i.branch_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE branch_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where branch_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on batch (inventory_id, inventory_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET inventory_uuid  = a.uuid_id,
                section_id      = a.section_id,
                manufacturer_id = a.manufacturer_id
            FROM inventory a
            WHERE a.id = i.inventory_id
              AND i.inventory_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE inventory_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where inventory_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
update batch b
    set unit_uuid = u.conversion_unit_id
        from unit_conversion u
            where u.conversion = b.unit_conv;
--##
update batch b
    set unit_conv = case when b.is_retail_qty then 1 else b.retail_qty end;
------------------
alter table batch alter column unit_conv set not null;
------------------
create index on batch (voucher_id, voucher_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET voucher_uuid = a.session
            FROM voucher a
            WHERE a.id = i.voucher_id
              AND i.voucher_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE voucher_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where voucher_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on batch (warehouse_id, warehouse_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET warehouse_uuid = a.uuid_id
            FROM warehouse a
            WHERE a.id = i.warehouse_id
              AND i.warehouse_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE warehouse_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where warehouse_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
select now() as time, 'UUID_CHANGES FOR BATCH ENDS' as msg;
--## BATCH

--## VOUCHER
select now() as time, 'UUID_CHANGES FOR VOUCHER STARTS' as msg;
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
    add if not exists vendor_id                    uuid,
    add if not exists vendor_name                  text,
    add if not exists customer_id                  uuid,
    add if not exists customer_name                text,
    add if not exists warehouse_id                 uuid,
    add if not exists warehouse_name               text,
    add if not exists rounded_off                  float,
    add if not exists disc_mode                    text,
    add if not exists discount                     float,
    add if not exists sales_person_id              uuid,
    add if not exists sale_value                   float,
    add if not exists profit_value                 float,
    add if not exists nlc_value                    float,
    add if not exists valid_provisional_profit     bool,
    add if not exists udf_alt_branch_id            uuid,
    add if not exists udf_alt_warehouse_id         uuid,
    add if not exists udf_transfer_voucher_id      uuid,
    add if not exists udf_approved                 bool,
    add if not exists branch_uuid                  uuid,
    add if not exists voucher_type_uuid            uuid;
    -- add if not exists udf_doctor_id                uuid;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.uuid_id,
    warehouse_name         = b.warehouse_name,
    vendor_id              = a.uuid_id,
    vendor_name            = b.vendor_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    branch_uuid            = br.uuid_id,
    voucher_type_uuid      = vt.uuid_id
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
    warehouse_id           = w.uuid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.uuid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.uuid_id,
    branch_uuid            = br.uuid_id,
    voucher_type_uuid      = vt.uuid_id
FROM credit_note b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN account a   ON a.id = b.customer_id
    LEFT JOIN sales_person sp on b.s_inc_id = sp.id
    LEFT JOIN branch br ON b.branch_id = br.id
    LEFT JOIN voucher_type vt on b.voucher_type_id = vt.id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id            = w.uuid_id,
    warehouse_name          = b.warehouse_name,
    udf_alt_branch_id       = br.uuid_id,
    udf_alt_warehouse_id    = w.uuid_id,
    udf_transfer_voucher_id = tv.session,
    udf_approved            = b.approved,
    branch_uuid             = br.uuid_id,
    voucher_type_uuid       = vt.uuid_id
FROM stock_journal b
    LEFT JOIN warehouse w ON w.id = b.warehouse_id
    LEFT JOIN branch br   ON br.id = b.branch_id
    LEFT JOIN voucher tv  ON tv.id = b.transfer_voucher_id
    LEFT JOIN voucher_type vt on vt.id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id   = w.uuid_id,
    warehouse_name = b.warehouse_name,
    vendor_id      = a.uuid_id,
    vendor_name    = b.vendor_name,
    branch_uuid    = br.uuid_id
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
    warehouse_id           = w.uuid_id,
    warehouse_name         = b.warehouse_name,
    branch_uuid            = br.uuid_id,
    voucher_type_uuid      = vt.uuid_id
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
    warehouse_id             = w.uuid_id,
    warehouse_name           = b.warehouse_name,
    vendor_id                = a.uuid_id,
    vendor_name              = b.vendor_name,
    customer_id              = ac.uuid_id,
    customer_name            = b.customer_name,
    rounded_off              = b.rounded_off,
    disc_mode                = b.discount_mode,
    discount                 = b.discount_amount,
    sale_value               = b.sale_value,
    profit_value             = b.profit_value,
    nlc_value                = b.nlc_value,
    valid_provisional_profit = b.valid_provisional_profit,
    branch_uuid              = br.uuid_id,
    voucher_type_uuid        = vt.uuid_id
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
    warehouse_id           = w.uuid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.uuid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.uuid_id,
    branch_uuid            = br.uuid_id,
    voucher_type_uuid      = vt.uuid_id
--     udf_doctor_id          = ud.uuid_id
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
    warehouse_id           = w.uuid_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.uuid_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.uuid_id,
    branch_uuid            = br.uuid_id,
    voucher_type_uuid      = vt.uuid_id
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
select now() as time, 'UUID_CHANGES FOR VOUCHER BRANCH_ID STARTS' as msg;
create index on voucher (branch_id, branch_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET branch_uuid = a.uuid_id
            FROM branch a
            WHERE a.id = i.branch_id
              AND i.branch_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE branch_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where branch_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER BRANCH_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER VOUCHER_TYPE_ID STARTS' as msg;
CREATE INDEX ON voucher (voucher_type_id);
    UPDATE voucher b SET voucher_type_uuid = '01955427-0c00-703c-8000-000000000000' WHERE b.voucher_type_id = 1;
    UPDATE voucher b SET voucher_type_uuid = '0195594d-6800-703d-8000-000000000000' WHERE b.voucher_type_id = 2;
    UPDATE voucher b SET voucher_type_uuid = '01955e73-c400-703e-8000-000000000000' WHERE b.voucher_type_id = 3;
    UPDATE voucher b SET voucher_type_uuid = '0195639a-2000-703f-8000-000000000000' WHERE b.voucher_type_id = 4;
    UPDATE voucher b SET voucher_type_uuid = '019568c0-7c00-7040-8000-000000000000' WHERE b.voucher_type_id = 5;
    UPDATE voucher b SET voucher_type_uuid = '01956de6-d800-7041-8000-000000000000' WHERE b.voucher_type_id = 6;
    UPDATE voucher b SET voucher_type_uuid = '0195730d-3400-7042-8000-000000000000' WHERE b.voucher_type_id = 7;
    UPDATE voucher b SET voucher_type_uuid = '01957833-9000-7043-8000-000000000000' WHERE b.voucher_type_id = 8;
    UPDATE voucher b SET voucher_type_uuid = '01957d59-ec00-7044-8000-000000000000' WHERE b.voucher_type_id = 9;
    UPDATE voucher b SET voucher_type_uuid = '01958280-4800-7045-8000-000000000000' WHERE b.voucher_type_id = 10;
    UPDATE voucher b SET voucher_type_uuid = '019587a6-a400-7046-8000-000000000000' WHERE b.voucher_type_id = 17;
    UPDATE voucher b SET voucher_type_uuid = '01958ccd-0000-7047-8000-000000000000' WHERE b.voucher_type_id = 21;
    UPDATE voucher b SET voucher_type_uuid = '019591f3-5c00-7048-8000-000000000000' WHERE b.voucher_type_id = 23;
create index on voucher (voucher_type_id, voucher_type_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET voucher_type_uuid = a.uuid_id
            FROM voucher_type a
            WHERE a.id = i.voucher_type_id
              AND i.voucher_type_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE voucher_type_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where voucher_type_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER VOUCHER_TYPE_ID ENDS' as msg;
select now() as time, 'UUID_CHANGES FOR VOUCHER ENDS' as msg;
------------------
--## VOUCHER

-------------------------------------------------------------------------------------------------
---- APPLY UUID for ac_txn, inv_txn
-------------------------------------------------------------------------------------------------

--## AC_TXN
select now() as time, 'UUID_CHANGES FOR AC_TXN STARTS' as msg;
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
-- ac_txn uuid related changes
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
------------------
select now() as time, 'UUID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID STARTS' as msg;
    UPDATE ac_txn b SET account_uuid = '0194af5b-8c00-701c-8000-000000000000', account_type_uuid = '01947bdb-f400-7012-8000-000000000000' WHERE b.account_id = 1;
    UPDATE ac_txn b SET account_uuid = '0194b481-e800-701d-8000-000000000000', account_type_uuid = '01943e0f-a400-7006-8000-000000000000' WHERE b.account_id = 2;
    UPDATE ac_txn b SET account_uuid = '0194b9a8-4400-701e-8000-000000000000', account_type_uuid = '01944d82-b800-7009-8000-000000000000' WHERE b.account_id = 3;
    UPDATE ac_txn b SET account_uuid = '0194bece-a000-701f-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 4;
    UPDATE ac_txn b SET account_uuid = '0194c3f4-fc00-7020-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 5;
    UPDATE ac_txn b SET account_uuid = '0194c91b-5800-7021-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 6;
    UPDATE ac_txn b SET account_uuid = '0194ce41-b400-7022-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 7;
    UPDATE ac_txn b SET account_uuid = '0194d368-1000-7023-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 8;
    UPDATE ac_txn b SET account_uuid = '0194d88e-6c00-7024-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 9;
    UPDATE ac_txn b SET account_uuid = '0194ddb4-c800-7025-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 10;
    UPDATE ac_txn b SET account_uuid = '0194e2db-2400-7026-8000-000000000000', account_type_uuid = '0194959b-c000-7017-8000-000000000000' WHERE b.account_id = 11;
    UPDATE ac_txn b SET account_uuid = '0194e801-8000-7027-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE b.account_id = 12;
    UPDATE ac_txn b SET account_uuid = '0194ed27-dc00-7028-8000-000000000000', account_type_uuid = '0194485c-5c00-7008-8000-000000000000' WHERE b.account_id = 13;
    UPDATE ac_txn b SET account_uuid = '0194f24e-3800-7029-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE b.account_id = 14;
    UPDATE ac_txn b SET account_uuid = '0194f774-9400-702a-8000-000000000000', account_type_uuid = '01942e9c-9000-7003-8000-000000000000' WHERE b.account_id = 15;
    UPDATE ac_txn b SET account_uuid = '0194fc9a-f000-702b-8000-000000000000', account_type_uuid = '0194621c-2800-700d-8000-000000000000' WHERE b.account_id = 16;
    UPDATE ac_txn b SET account_uuid = '019501c1-4c00-702c-8000-000000000000', account_type_uuid = '01942e9c-9000-7003-8000-000000000000' WHERE b.account_id = 17;
    UPDATE ac_txn b SET account_uuid = '019506e7-a800-702d-8000-000000000000', account_type_uuid = '019438e9-4800-7005-8000-000000000000' WHERE b.account_id = 18;
    UPDATE ac_txn b SET account_uuid = '01950c0e-0400-702e-8000-000000000000', account_type_uuid = '019433c2-ec00-7004-8000-000000000000' WHERE b.account_id = 19;
    UPDATE ac_txn b SET account_uuid = '01951134-6000-702f-8000-000000000000', account_type_uuid = '01949fe8-7800-7019-8000-000000000000' WHERE b.account_id = 20;
------------------
create index on ac_txn(account_id, account_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET account_uuid = a.uuid_id,
                account_type_uuid = a.account_type_uuid
            FROM account a
            WHERE a.id = i.account_id
              AND a.transaction_enabled
              AND i.account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where account_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID STARTS' as msg;
create index on ac_txn(alt_account_id);
    UPDATE ac_txn b SET alt_account_uuid = '0194af5b-8c00-701c-8000-000000000000' WHERE b.alt_account_id = 1;
    UPDATE ac_txn b SET alt_account_uuid = '0194b481-e800-701d-8000-000000000000' WHERE b.alt_account_id = 2;
    UPDATE ac_txn b SET alt_account_uuid = '0194b9a8-4400-701e-8000-000000000000' WHERE b.alt_account_id = 3;
    UPDATE ac_txn b SET alt_account_uuid = '0194bece-a000-701f-8000-000000000000' WHERE b.alt_account_id = 4;
    UPDATE ac_txn b SET alt_account_uuid = '0194c3f4-fc00-7020-8000-000000000000' WHERE b.alt_account_id = 5;
    UPDATE ac_txn b SET alt_account_uuid = '0194c91b-5800-7021-8000-000000000000' WHERE b.alt_account_id = 6;
    UPDATE ac_txn b SET alt_account_uuid = '0194ce41-b400-7022-8000-000000000000' WHERE b.alt_account_id = 7;
    UPDATE ac_txn b SET alt_account_uuid = '0194d368-1000-7023-8000-000000000000' WHERE b.alt_account_id = 8;
    UPDATE ac_txn b SET alt_account_uuid = '0194d88e-6c00-7024-8000-000000000000' WHERE b.alt_account_id = 9;
    UPDATE ac_txn b SET alt_account_uuid = '0194ddb4-c800-7025-8000-000000000000' WHERE b.alt_account_id = 10;
    UPDATE ac_txn b SET alt_account_uuid = '0194e2db-2400-7026-8000-000000000000' WHERE b.alt_account_id = 11;
    UPDATE ac_txn b SET alt_account_uuid = '0194e801-8000-7027-8000-000000000000' WHERE b.alt_account_id = 12;
    UPDATE ac_txn b SET alt_account_uuid = '0194ed27-dc00-7028-8000-000000000000' WHERE b.alt_account_id = 13;
    UPDATE ac_txn b SET alt_account_uuid = '0194f24e-3800-7029-8000-000000000000' WHERE b.alt_account_id = 14;
    UPDATE ac_txn b SET alt_account_uuid = '0194f774-9400-702a-8000-000000000000' WHERE b.alt_account_id = 15;
    UPDATE ac_txn b SET alt_account_uuid = '0194fc9a-f000-702b-8000-000000000000' WHERE b.alt_account_id = 16;
    UPDATE ac_txn b SET alt_account_uuid = '019501c1-4c00-702c-8000-000000000000' WHERE b.alt_account_id = 17;
    UPDATE ac_txn b SET alt_account_uuid = '019506e7-a800-702d-8000-000000000000' WHERE b.alt_account_id = 18;
    UPDATE ac_txn b SET alt_account_uuid = '01950c0e-0400-702e-8000-000000000000' WHERE b.alt_account_id = 19;
    UPDATE ac_txn b SET alt_account_uuid = '01951134-6000-702f-8000-000000000000' WHERE b.alt_account_id = 20;
------------------
create index on ac_txn(alt_account_id, alt_account_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET alt_account_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.alt_account_id
              AND a.transaction_enabled
              AND i.alt_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE alt_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where alt_account_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR AC_TXN BRANCH_ID STARTS' as msg;
create index on ac_txn (branch_id, branch_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET branch_uuid = a.uuid_id
            FROM branch a
            WHERE a.id = i.branch_id
              AND i.branch_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE branch_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where branch_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR AC_TXN BRANCH_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR AC_TXN VOUCHER_ID STARTS' as msg;
create index on ac_txn (voucher_id, voucher_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET voucher_uuid = a.session
            FROM voucher a
            WHERE a.id = i.voucher_id
              AND i.voucher_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE voucher_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where voucher_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR AC_TXN VOUCHER_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR AC_TXN VOUCHER_TYPE_ID STARTS' as msg;
CREATE INDEX ON ac_txn (voucher_type_id);
    UPDATE ac_txn b SET voucher_type_uuid = '01955427-0c00-703c-8000-000000000000' WHERE b.voucher_type_id = 1;
    UPDATE ac_txn b SET voucher_type_uuid = '0195594d-6800-703d-8000-000000000000' WHERE b.voucher_type_id = 2;
    UPDATE ac_txn b SET voucher_type_uuid = '01955e73-c400-703e-8000-000000000000' WHERE b.voucher_type_id = 3;
    UPDATE ac_txn b SET voucher_type_uuid = '0195639a-2000-703f-8000-000000000000' WHERE b.voucher_type_id = 4;
    UPDATE ac_txn b SET voucher_type_uuid = '019568c0-7c00-7040-8000-000000000000' WHERE b.voucher_type_id = 5;
    UPDATE ac_txn b SET voucher_type_uuid = '01956de6-d800-7041-8000-000000000000' WHERE b.voucher_type_id = 6;
    UPDATE ac_txn b SET voucher_type_uuid = '0195730d-3400-7042-8000-000000000000' WHERE b.voucher_type_id = 7;
    UPDATE ac_txn b SET voucher_type_uuid = '01957833-9000-7043-8000-000000000000' WHERE b.voucher_type_id = 8;
    UPDATE ac_txn b SET voucher_type_uuid = '01957d59-ec00-7044-8000-000000000000' WHERE b.voucher_type_id = 9;
    UPDATE ac_txn b SET voucher_type_uuid = '01958280-4800-7045-8000-000000000000' WHERE b.voucher_type_id = 10;
    UPDATE ac_txn b SET voucher_type_uuid = '019587a6-a400-7046-8000-000000000000' WHERE b.voucher_type_id = 17;
    UPDATE ac_txn b SET voucher_type_uuid = '01958ccd-0000-7047-8000-000000000000' WHERE b.voucher_type_id = 21;
    UPDATE ac_txn b SET voucher_type_uuid = '019591f3-5c00-7048-8000-000000000000' WHERE b.voucher_type_id = 23;
------------------
create index on ac_txn (voucher_type_id, voucher_type_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET voucher_type_uuid = a.uuid_id
            FROM voucher_type a
            WHERE a.id = i.voucher_type_id
              AND i.voucher_type_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE voucher_type_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where voucher_type_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR AC_TXN VOUCHER_TYPE_ID ENDS' as msg;
------------------
--## AC_TXN

--## INV_TXN
select now() as time, 'UUID_CHANGES FOR INV_TXN STARTS' as msg;
-- inv_txn field related changes
alter table inv_txn drop column if exists section_id;
alter table inv_txn drop column if exists manufacturer_id;
--
alter table inv_txn
    add if not exists sno                      int,
    add if not exists qty                      float,
    add if not exists unit_id                  uuid,
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
    add if not exists customer_id              uuid,
    add if not exists sales_person_id          uuid,
    add if not exists dummy                    bool,
    add if not exists section_id               uuid,
    add if not exists manufacturer_id          uuid,
    add if not exists vendor_uuid              uuid;
    -- add if not exists udf_drug_classifications int[];
--##
update inv_txn t
set sno                 = i.sno,
    qty                 = i.qty,
    rate                = i.rate,
    unit_id             = uc.conversion_unit_id,
    unit_conv           = case when i.is_retail_qty then 1 else inv.retail_qty end,
    rate_tax_inclusive  = true,
    gst_tax             = i.gst_tax,
    disc_mode1          = i.disc_mode,
    discount1           = i.discount,
    hsn_code            = i.hsn_code,
    cess_on_qty         = i.cess_on_qty,
    cess_on_val         = i.cess_on_val,
    batch_no            = b.batch_no,
    vendor_uuid         = b.vendor_uuid,
    section_id          = inv.section_id,
    manufacturer_id     = inv.manufacturer_id
from credit_note_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.id = i.batch_id
where t.id = i.id;
--##
UPDATE inv_txn t
SET customer_id = a.uuid_id
FROM credit_note b
LEFT JOIN account a ON a.id = b.customer_id
    WHERE t.voucher_id = b.voucher_id
  AND b.customer_id IS NOT NULL;
--##
update inv_txn t
set sno                 = i.sno,
    qty                 = i.qty,
    rate                = i.rate,
    unit_id             = uc.conversion_unit_id,
    unit_conv           = case when i.is_retail_qty then 1 else inv.retail_qty end,
    gst_tax             = i.gst_tax,
    disc_mode1          = i.disc1_mode,
    discount1           = i.discount1,
    disc_mode2          = i.disc2_mode,
    discount2           = i.discount2,
    rate_tax_inclusive  = false,
    hsn_code            = i.hsn_code,
    cess_on_qty         = i.cess_on_qty,
    cess_on_val         = i.cess_on_val,
    batch_no            = b.batch_no,
    vendor_uuid         = b.vendor_uuid,
    section_id          = inv.section_id,
    manufacturer_id     = inv.manufacturer_id
from debit_note_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.id = i.batch_id
where t.id = i.id;
--##
update inv_txn t
set vendor_uuid = a.uuid_id,
    vendor_name = b.vendor_name
from debit_note b
    left join account a on a.id = b.vendor_id
where b.vendor_id is not null
  and t.voucher_id = b.voucher_id;
--##
update inv_txn t
set sno               = i.sno,
    qty               = i.qty,
    rate              = i.cost,
    unit_id           = uc.conversion_unit_id,
    unit_conv         = case when i.is_retail_qty then 1 else inv.retail_qty end,
    gst_tax           = i.gst_tax,
    hsn_code          = i.hsn_code,
    cess_on_qty       = i.cess_on_qty,
    cess_on_val       = i.cess_on_val,
    batch_no          = b.batch_no,
    vendor_uuid       = b.vendor_uuid,
    section_id        = inv.section_id,
    manufacturer_id   = inv.manufacturer_id
from personal_use_purchase_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.id = i.batch_id
where t.id = i.id;
--##
update inv_txn t
set sno              = i.sno,
    qty              = i.qty,
    rate             = i.rate,
    p_rate           = i.rate,
    unit_id          = uc.conversion_unit_id,
    unit_conv        = case when i.is_retail_qty then 1 else inv.retail_qty end,
    gst_tax          = i.gst_tax,
    disc_mode1       = i.disc1_mode,
    discount1        = i.discount1,
    disc_mode2       = i.disc2_mode,
    discount2        = i.discount2,
    hsn_code         = i.hsn_code,
    cess_on_qty      = i.cess_on_qty,
    cess_on_val      = i.cess_on_val,
    batch_no         = b.batch_no,
    vendor_uuid      = b.vendor_uuid,
    section_id       = inv.section_id,
    manufacturer_id  = inv.manufacturer_id
from purchase_bill_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.txn_id = i.id
where t.id = i.id;
--##
update inv_txn t
set vendor_uuid    = vid.uuid_id,
    vendor_name   = b.vendor_name,
    customer_id   = cid.uuid_id
from purchase_bill b
    left join account cid on cid.id = b.customer_id
    left join account vid on vid.id = b.vendor_id
where t.voucher_id = b.voucher_id;
--##
--##
update inv_txn t
set sno                      = i.sno,
    qty                      = i.qty,
    rate                     = i.rate,
    unit_id                  = uc.conversion_unit_id,
    unit_conv                = case when i.is_retail_qty then 1 else inv.retail_qty end,
    gst_tax                  = i.gst_tax,
    disc_mode1               = i.disc_mode,
    discount1                = i.discount,
    hsn_code                 = i.hsn_code,
    cess_on_qty              = i.cess_on_qty,
    cess_on_val              = i.cess_on_val,
    sales_person_id          = sp.uuid_id,
    -- udf_drug_classifications = i.drug_classifications,
    batch_no                 = b.batch_no,
    vendor_uuid              = b.vendor_uuid,
    section_id               = inv.section_id,
    manufacturer_id          = inv.manufacturer_id
from sale_bill_inv_item i
    left join inventory inv on inv.id = i.inventory_id
    left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
    left join batch b on b.id = i.batch_id
    left join sales_person sp on sp.id = i.s_inc_id
where t.id = i.id;
--##
update inv_txn t
set customer_id   = cid.uuid_id
from sale_bill b
    left join account cid on cid.id = b.customer_id
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
--##
update inv_txn t
set sno               = i.sno,
    qty               = i.qty,
    rate              = i.rate,
    unit_id           = uc.conversion_unit_id,
    unit_conv         = case when i.is_retail_qty then 1 else inv.retail_qty end,
    barcode           = i.barcode,
    asset_amount      = i.asset_amount,
    batch_no          = b.batch_no,
    vendor_uuid       = b.vendor_uuid,
    section_id        = inv.section_id,
    manufacturer_id   = inv.manufacturer_id
from stock_journal_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.id = i.batch_id
where t.id = i.id;
--##
update inv_txn t
set sno               = i.sno,
    unit_id           = uc.conversion_unit_id,
    unit_conv         = case when i.is_retail_qty then 1 else inv.retail_qty end,
    qty               = i.qty,
    rate              = i.rate,
    asset_amount      = i.asset_amount,
    batch_no          = b.batch_no,
    vendor_uuid       = b.vendor_uuid,
    section_id        = inv.section_id,
    manufacturer_id   = inv.manufacturer_id
from inventory_opening i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.txn_id = i.id
where t.id = i.id;
--##
alter table inv_txn
    alter column sno set not null,
    alter column qty set not null,
    alter column unit_id set not null,
    alter column unit_conv set not null,
    alter column rate set not null,
    alter column inward set not null,
    alter column outward set not null;
-- inv_txn uuid related changes
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
-- ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS udf_drug_classifications_uuid uuid[];
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN VENDOR_ID STARTS' as msg;
create index on inv_txn (vendor_id, vendor_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET vendor_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.vendor_id
              AND a.account_type_id = 19
              AND i.vendor_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE vendor_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where vendor_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN VENDOR_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN BRANCH_ID STARTS' as msg;
create index on inv_txn (branch_id, branch_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET branch_uuid = a.uuid_id
            FROM branch a
            WHERE a.id = i.branch_id
              AND i.branch_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE branch_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where branch_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN BRANCH_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN INVENTORY_ID STARTS' as msg;
create index on inv_txn (inventory_id, inventory_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET inventory_uuid = a.uuid_id
            FROM inventory a
            WHERE a.id = i.inventory_id
              AND i.inventory_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE inventory_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where inventory_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN INVENTORY_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN VOUCHER_ID STARTS' as msg;
create index on inv_txn (voucher_id, voucher_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET voucher_uuid = a.session
            FROM voucher a
            WHERE a.id = i.voucher_id
              AND i.voucher_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE voucher_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where voucher_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN VOUCHER_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN VOUCHER_TYPE_ID STARTS' as msg;
----------------------
create index on inv_txn (voucher_type_id);
    UPDATE inv_txn b SET voucher_type_uuid = '01955427-0c00-703c-8000-000000000000' WHERE b.voucher_type_id = 1;
    UPDATE inv_txn b SET voucher_type_uuid = '0195594d-6800-703d-8000-000000000000' WHERE b.voucher_type_id = 2;
    UPDATE inv_txn b SET voucher_type_uuid = '01955e73-c400-703e-8000-000000000000' WHERE b.voucher_type_id = 3;
    UPDATE inv_txn b SET voucher_type_uuid = '0195639a-2000-703f-8000-000000000000' WHERE b.voucher_type_id = 4;
    UPDATE inv_txn b SET voucher_type_uuid = '019568c0-7c00-7040-8000-000000000000' WHERE b.voucher_type_id = 5;
    UPDATE inv_txn b SET voucher_type_uuid = '01956de6-d800-7041-8000-000000000000' WHERE b.voucher_type_id = 6;
    UPDATE inv_txn b SET voucher_type_uuid = '0195730d-3400-7042-8000-000000000000' WHERE b.voucher_type_id = 7;
    UPDATE inv_txn b SET voucher_type_uuid = '01957833-9000-7043-8000-000000000000' WHERE b.voucher_type_id = 8;
    UPDATE inv_txn b SET voucher_type_uuid = '01957d59-ec00-7044-8000-000000000000' WHERE b.voucher_type_id = 9;
    UPDATE inv_txn b SET voucher_type_uuid = '01958280-4800-7045-8000-000000000000' WHERE b.voucher_type_id = 10;
    UPDATE inv_txn b SET voucher_type_uuid = '019587a6-a400-7046-8000-000000000000' WHERE b.voucher_type_id = 17;
    UPDATE inv_txn b SET voucher_type_uuid = '01958ccd-0000-7047-8000-000000000000' WHERE b.voucher_type_id = 21;
    UPDATE inv_txn b SET voucher_type_uuid = '019591f3-5c00-7048-8000-000000000000' WHERE b.voucher_type_id = 23;
----------------------
create index on inv_txn (voucher_type_id, voucher_type_uuid, id);

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET voucher_type_uuid = a.uuid_id
            FROM voucher_type a
            WHERE a.id = i.voucher_type_id
              AND i.voucher_type_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE voucher_type_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where voucher_type_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN VOUCHER_TYPE_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN WAREHOUSE_ID STARTS' as msg;
create index on inv_txn (warehouse_id, warehouse_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET warehouse_uuid = a.uuid_id
            FROM warehouse a
            WHERE a.id = i.warehouse_id
              AND i.warehouse_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE warehouse_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where warehouse_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN WAREHOUSE_ID ENDS' as msg;
------------------
/*
select now() as time, 'UUID_CHANGES FOR INV_TXN DRUG_CLASSIFICATION_ID STARTS' as msg;
UPDATE inv_txn t
        SET udf_drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.udf_drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.udf_drug_classifications IS NOT NULL;
select now() as time, 'UUID_CHANGES FOR INV_TXN DRUG_CLASSIFICATION_ID ENDS' as msg;
*/
------------------
select now() as time, 'UUID_CHANGES FOR INV_TXN BATCH_ID STARTS' as msg;
create index on inv_txn (batch_id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET batch_no     = a.batch_no,
                s_rate       = a.s_rate,
                mrp          = a.mrp,
                vendor_id    = a.vendor_id,
                expiry       = a.expiry,
                nlc          = a.nlc,
                landing_cost = a.landing_cost,
                cost         = a.cost,
                dummy        = true
            FROM batch a
            WHERE a.id = i.batch_id
              AND i.batch_id IN (SELECT batch_id
                           FROM inv_txn
                           WHERE dummy is null
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where dummy is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
alter table inv_txn alter column batch_no set not null;
select now() as time, 'UUID_CHANGES FOR INV_TXN BATCH_ID ENDS' as msg;
--## INV_TXN

-------------------------------------------------------------------------------------------------
---- INDEX RESTORE
-------------------------------------------------------------------------------------------------
--## ac_txn
    create index on ac_txn (voucher_id);
    create index on ac_txn (date);
    create index on ac_txn (account_id);
    create index on ac_txn (branch_id);
--## account
    create index on account (val_name);
    create index on account (transaction_enabled);
--## bank_txn
    create index on bank_txn (date);
    create index on bank_txn (ac_txn_id);
    create index on bank_txn (account_id);
    create index on bank_txn (voucher_id);
--## batch
    create index on batch (barcode);
    create index on batch (inventory_id, branch_id, warehouse_id);
--## bill_allocation
    create index on bill_allocation (eff_date);
    create index on bill_allocation (ac_txn_id);
    create index on bill_allocation (account_id);
    create index on bill_allocation (voucher_id);
    create index on bill_allocation (branch_id, account_id, ref_no);
--## inv_txn
    create index on inv_txn (voucher_id);
    create index on inv_txn (date);
    create index on inv_txn (inventory_id);
    create index on inv_txn (branch_id);
    create index on inv_txn (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
--## inventory
    create index on inventory (val_name);
--## voucher
    create index on voucher (date);
    create index on voucher (voucher_no);
    create index on voucher (branch_id);
    create index on voucher (base_voucher_type);

--## last query
delete from unit_conversion where conversion = 1;

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN, EXPRESSION, DEFAULT
-------------------------------------------------------------------------------------------------
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
    alter table inv_txn drop column if exists division_id;
    alter table inv_txn drop column if exists division_name;
    alter table inv_txn drop column if exists party_id;
    alter table inv_txn drop column if exists party_name;
    alter table inv_txn drop column if exists vendor_name;
    alter table inv_txn drop column if exists reorder_inventory_id;
    alter table inv_txn drop column if exists inventory_hsn;
    alter table inv_txn drop column if exists manufacturer_name;
    alter table inv_txn drop column if exists is_opening;
    alter table inv_txn drop column if exists inventory_voucher_id;
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
    alter table account drop column if exists alternate_mobile;
    alter table account drop column if exists telephone;
    alter table account drop column if exists contact_person;
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
-- BANK --
    alter table bank drop column if exists created_at;
    alter table bank drop column if exists updated_at;
-- BANK_BENEFICIARY --
    alter table bank_beneficiary drop column if exists bank_name;
    alter table bank_beneficiary drop column if exists bank_code;
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
    alter table bank_txn drop column if exists emailed;
-- BATCH --
    alter table batch alter column p_rate drop expression;
    alter table batch alter column closing drop expression;
    alter table batch drop column if exists sno;
    alter table batch drop column if exists reorder_inventory_id;
    alter table batch drop column if exists inventory_hsn;
    alter table batch drop column if exists branch_name;
    alter table batch drop column if exists warehouse_name;
    alter table batch drop column if exists division_id;
    alter table batch drop column if exists division_name;
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
    alter table batch drop column if exists category1_name;
    alter table batch drop column if exists category2_id;
    alter table batch drop column if exists category2_name;
    alter table batch drop column if exists category3_id;
    alter table batch drop column if exists category3_name;
-- BILL_ALLOCATION --
    alter table bill_allocation drop column if exists base_account_types;
--     alter table bill_allocation drop column if exists pending;
    alter table bill_allocation drop column if exists is_approved;
    alter table bill_allocation drop column if exists due_date;
    alter table bill_allocation drop column if exists account_type_name;
    alter table bill_allocation drop column if exists bill_date;
-- INVENTORY --
    alter table inventory alter column val_name drop expression;
    alter table inventory drop column if exists cess;
    alter table inventory drop column if exists division_id;
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
    alter table inventory_branch_detail drop column if exists preferred_vendor_name;
    alter table inventory_branch_detail drop column if exists last_vendor_name;
    alter table inventory_branch_detail drop column if exists s_customer_disc;
    alter table inventory_branch_detail drop column if exists p_rate_tax_inc;
    alter table inventory_branch_detail drop column if exists reorder_inventory_id;
    alter table inventory_branch_detail drop column if exists val_name;
    alter table inventory_branch_detail drop column if exists division_id;
-- MEMBER --
    alter table member drop column if exists remote_access;
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
-- changed_at removal --
    alter table account                 drop if exists changed_at;
    alter table account_type            drop if exists changed_at;
    alter table batch                   drop if exists changed_at;
    alter table branch                  drop if exists changed_at;
    alter table country                 drop if exists changed_at;
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
    drop table if exists device;
    drop table if exists display_rack;
    drop table if exists division;
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
    drop table if exists pos_counter_session;
    drop table if exists pos_counter;
    drop table if exists pos_counter_settlement;
    drop table if exists pos_server;
    drop table if exists power_bi;
    drop table if exists price_list_condition;
    drop table if exists price_list;
    drop table if exists wanted_note;
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

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN AND RENAME THE REQUIRED ONE
-------------------------------------------------------------------------------------------------
-- ACCOUNT
    alter table account drop column if exists id;
    alter table account rename column uuid_id to id;
    alter table account alter column id set not null;
    ALTER TABLE account ADD CONSTRAINT account_pkey PRIMARY KEY (id);
        --
        alter table ac_txn drop column if exists account_id;
        alter table ac_txn rename column account_uuid to account_id;
        alter table ac_txn alter column account_id set not null;
        --
        alter table ac_txn drop column if exists alt_account_id;
        alter table ac_txn rename column alt_account_uuid to alt_account_id;
        --
        alter table account_daily_summary drop column if exists account_id;
        alter table account_daily_summary rename column account_uuid to account_id;
        alter table account_daily_summary alter column account_id set not null;
        --
        alter table bank_txn drop column if exists account_id;
        alter table bank_txn rename column account_uuid to account_id;
        alter table bank_txn alter column account_id set not null;
        --
        alter table bank_txn drop column if exists alt_account_id;
        alter table bank_txn rename column alt_account_uuid to alt_account_id;
        --
        alter table branch drop column if exists account_id;
        alter table branch rename column account_uuid to account_id;
        alter table branch alter column account_id set not null;
        alter table branch add unique (account_id);
        --
        alter table bill_allocation drop column if exists account_id;
        alter table bill_allocation rename column account_uuid to account_id;
        alter table bill_allocation alter column account_id set not null;
        --
        alter table batch drop column if exists vendor_id;
        alter table batch rename column vendor_uuid to vendor_id;
        --
        alter table inventory drop column if exists sale_account_id;
        alter table inventory rename column sale_account_uuid to sale_account_id;
        alter table inventory alter column sale_account_id set not null;
        --
        alter table inventory drop column if exists purchase_account_id;
        alter table inventory rename column purchase_account_uuid to purchase_account_id;
        alter table inventory alter column purchase_account_id set not null;
        --
        alter table tds_nature_of_payment drop column if exists tds_account_id;
        alter table tds_nature_of_payment rename column tds_account_uuid to tds_account_id;
        alter table tds_nature_of_payment alter column tds_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists party_account_id;
        alter table tds_on_voucher rename column party_account_uuid to party_account_id;
        alter table tds_on_voucher alter column party_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists tds_account_id;
        alter table tds_on_voucher rename column tds_account_uuid to tds_account_id;
        alter table tds_on_voucher alter column tds_account_id set not null;
        --
        alter table inv_txn drop column if exists vendor_id;
        alter table inv_txn rename column vendor_uuid to vendor_id;
        --
        alter table inventory_branch_detail drop column if exists preferred_vendor_id;
        alter table inventory_branch_detail rename column preferred_vendor_uuid to preferred_vendor_id;
        --
        alter table inventory_branch_detail drop column if exists last_vendor_id;
        alter table inventory_branch_detail rename column last_vendor_uuid to last_vendor_id;
        --
        -- alter table udm_vendor_bill_map drop column if exists vendor_id;
        -- alter table udm_vendor_bill_map rename column vendor_uuid to vendor_id;
        -- alter table udm_vendor_bill_map alter column vendor_id set not null;
        -- alter table udm_vendor_bill_map add constraint udm_vendor_bill_map_pkey PRIMARY KEY (vendor_id);
        --
        -- alter table udm_vendor_item_map drop column if exists vendor_id;
        -- alter table udm_vendor_item_map rename column vendor_uuid to vendor_id;
        -- alter table udm_vendor_item_map alter column vendor_id set not null;
        -- alter table udm_vendor_item_map add constraint udm_vendor_item_map_pkey PRIMARY KEY (vendor_id, vendor_inventory);
-- ACCOUNT_TYPE
    alter table account_type drop column if exists id;
    alter table account_type rename column uuid_id to id;
    alter table account_type alter column id set not null;
    ALTER TABLE account_type ADD CONSTRAINT account_type_pkey PRIMARY KEY (id);
    alter table account_type drop column if exists parent_id;
    alter table account_type rename column parent_uuid to parent_id;
        --
        alter table ac_txn drop column if exists account_type_id;
        alter table ac_txn rename column account_type_uuid to account_type_id;
        alter table ac_txn alter column account_type_id set not null;
        --
        alter table account drop column if exists account_type_id;
        alter table account rename column account_type_uuid to account_type_id;
        alter table account alter column account_type_id set not null;
        --
        alter table bill_allocation drop column if exists account_type_id;
        alter table bill_allocation rename column account_type_uuid to account_type_id;
        alter table bill_allocation alter column account_type_id set not null;
-- BANK
    alter table bank drop column if exists id;
    alter table bank rename column uuid_id to id;
    alter table bank alter column id set not null;
    ALTER TABLE bank ADD CONSTRAINT bank_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists bank_id;
        alter table account rename column bank_uuid to bank_id;
        --
        alter table bank_beneficiary drop column if exists bank_id;
        alter table bank_beneficiary rename column bank_uuid to bank_id;
        alter table bank_beneficiary alter column bank_id set not null;
-- BANK_BENEFICIARY
    alter table bank_beneficiary drop column if exists id;
    alter table bank_beneficiary rename column uuid_id to id;
    alter table bank_beneficiary alter column id set not null;
    ALTER TABLE bank_beneficiary ADD CONSTRAINT bank_beneficiary_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists bank_beneficiary_id;
        alter table account rename column bank_beneficiary_uuid to bank_beneficiary_id;
-- BRANCH
    alter table branch alter column members drop not null;
    alter table branch drop column if exists id;
    alter table branch rename column uuid_id to id;
    alter table branch alter column id set not null;
    ALTER TABLE branch ADD CONSTRAINT branch_pkey PRIMARY KEY (id);
    alter table branch alter column misc type jsonb using misc::jsonb;
    alter table branch alter column configuration type jsonb using configuration::jsonb;
        --
        alter table ac_txn drop column if exists branch_id;
        alter table ac_txn rename column branch_uuid to branch_id;
        alter table ac_txn alter column branch_id set not null;
        --
        alter table account_daily_summary drop column if exists branch_id;
        alter table account_daily_summary rename column branch_uuid to branch_id;
        alter table account_daily_summary alter column branch_id set not null;
        ALTER TABLE account_daily_summary ADD CONSTRAINT account_daily_summary_pkey PRIMARY KEY (account_id, branch_id, date);
        --
        alter table bank_txn drop column if exists branch_id;
        alter table bank_txn rename column branch_uuid to branch_id;
        alter table bank_txn alter column branch_id set not null;
        --
        alter table batch drop column if exists branch_id;
        alter table batch rename column branch_uuid to branch_id;
        alter table batch alter column branch_id set not null;
        --
        alter table bill_allocation drop column if exists branch_id;
        alter table bill_allocation rename column branch_uuid to branch_id;
        alter table bill_allocation alter column branch_id set not null;
        --
        alter table inv_txn drop column if exists branch_id;
        alter table inv_txn rename column branch_uuid to branch_id;
        alter table inv_txn alter column branch_id set not null;
        --
        alter table inventory_branch_detail drop column if exists branch_id;
        alter table inventory_branch_detail rename column branch_uuid to branch_id;
        alter table inventory_branch_detail alter column branch_id set not null;
        --
        alter table tds_on_voucher drop column if exists branch_id;
        alter table tds_on_voucher rename column branch_uuid to branch_id;
        alter table tds_on_voucher alter column branch_id set not null;
        --
        alter table voucher_numbering drop column if exists branch_id;
        alter table voucher_numbering rename column branch_uuid to branch_id;
        --
        alter table voucher drop column if exists branch_id;
        alter table voucher rename column branch_uuid to branch_id;
        alter table voucher alter column branch_id set not null;
-- GST_REGISTRATION
    alter table gst_registration drop column if exists id;
    alter table gst_registration rename column uuid_id to id;
    alter table gst_registration alter column id set not null;
    ALTER TABLE gst_registration ADD CONSTRAINT gst_registration_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists gst_registration_id;
        alter table branch rename column gst_registration_uuid to gst_registration_id;
-- INVENTORY
    alter table inventory drop column if exists id;
    alter table inventory rename column uuid_id to id;
    alter table inventory alter column id set not null;
    ALTER TABLE inventory ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists inventory_id;
        alter table batch rename column inventory_uuid to inventory_id;
        alter table batch alter column inventory_id set not null;
        --
        alter table bill_of_material drop column if exists inventory_id;
        alter table bill_of_material rename column inventory_uuid to inventory_id;
        alter table bill_of_material alter column inventory_id set not null;
        --
        alter table inv_txn drop column if exists inventory_id;
        alter table inv_txn rename column inventory_uuid to inventory_id;
        alter table inv_txn alter column inventory_id set not null;
        --
        alter table inventory_branch_detail drop column if exists inventory_id;
        alter table inventory_branch_detail rename column inventory_uuid to inventory_id;
        alter table inventory_branch_detail alter column inventory_id set not null;
        alter table inventory_branch_detail add constraint inventory_branch_detail_pkey primary key (branch_id, inventory_id);
        --
        -- alter table udm_vendor_item_map drop column if exists inventory_id;
        -- alter table udm_vendor_item_map rename column inventory_uuid to inventory_id;
        -- alter table udm_vendor_item_map alter column inventory_id set not null;
-- MANUFACTURER
    alter table manufacturer drop column if exists id;
    alter table manufacturer rename column uuid_id to id;
    alter table manufacturer alter column id set not null;
    ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);
-- SALES_PERSON
    alter table sales_person drop column if exists id;
    alter table sales_person rename column uuid_id to id;
    alter table sales_person alter column id set not null;
    ALTER TABLE sales_person ADD CONSTRAINT sales_person_pkey PRIMARY KEY (id);
-- TDS_NATURE_OF_PAYMENT
    alter table tds_nature_of_payment drop column if exists id;
    alter table tds_nature_of_payment rename column uuid_id to id;
    alter table tds_nature_of_payment alter column id set not null;
    ALTER TABLE tds_nature_of_payment ADD CONSTRAINT tds_nature_of_payment_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists tds_nature_of_payment_id;
        alter table account rename column tds_nature_of_payment_uuid to tds_nature_of_payment_id;
        --
        alter table tds_on_voucher drop column if exists tds_nature_of_payment_id;
        alter table tds_on_voucher rename column tds_nature_of_payment_uuid to tds_nature_of_payment_id;
        alter table tds_on_voucher alter column tds_nature_of_payment_id set not null;
-- UNIT
        --
        alter table batch drop column if exists unit_id;
        --
        alter table batch rename column unit_uuid to unit_id;
        --
        alter table batch alter column unit_id set not null;
        --
        alter table inv_txn alter column unit_id set not null;
        --
        alter table inventory drop column if exists unit_id;
        alter table inventory rename column unit_uuid to unit_id;
        alter table inventory alter column unit_id set not null;
        --
        alter table inventory drop column if exists sale_unit_id;
        alter table inventory rename column sale_unit_uuid to sale_unit_id;
        --
        alter table inventory drop column if exists purchase_unit_id;
        alter table inventory rename column purchase_unit_uuid to purchase_unit_id;
-- VOUCHER
    alter table voucher drop column if exists id;
    alter table voucher rename column session to id;
    alter table voucher alter column id set not null;
    ALTER TABLE voucher ADD CONSTRAINT voucher_pkey PRIMARY KEY (id);
    alter table voucher drop constraint voucher_session_key;
        --
        alter table ac_txn drop column if exists voucher_id;
        alter table ac_txn rename column voucher_uuid to voucher_id;
        --
        alter table bank_txn drop column if exists voucher_id;
        alter table bank_txn rename column voucher_uuid to voucher_id;
        alter table bank_txn alter column voucher_id set not null;
        --
        alter table batch drop column if exists voucher_id;
        alter table batch rename column voucher_uuid to voucher_id;
        --
        alter table bill_allocation drop column if exists voucher_id;
        alter table bill_allocation rename column voucher_uuid to voucher_id;
        --
        alter table inv_txn drop column if exists voucher_id;
        alter table inv_txn rename column voucher_uuid to voucher_id;
        --
        alter table tds_on_voucher drop column if exists voucher_id;
        alter table tds_on_voucher rename column voucher_uuid to voucher_id;
        alter table tds_on_voucher alter column voucher_id set not null;
-- VOUCHER_TYPE
    alter table voucher_type drop column if exists id;
    alter table voucher_type rename column uuid_id to id;
    alter table voucher_type alter column id set not null;
    ALTER TABLE voucher_type ADD CONSTRAINT voucher_type_pkey PRIMARY KEY (id);
    alter table voucher_type drop column if exists sequence_id;
    alter table voucher_type rename column sequence_uuid to sequence_id;
        --
        alter table ac_txn drop column if exists voucher_type_id;
        alter table ac_txn rename column voucher_type_uuid to voucher_type_id;
        --
        alter table inv_txn drop column if exists voucher_type_id;
        alter table inv_txn rename column voucher_type_uuid to voucher_type_id;
        --
        alter table voucher_numbering drop column if exists voucher_type_id;
        alter table voucher_numbering rename column voucher_type_uuid to voucher_type_id;
         --
        alter table voucher drop column if exists voucher_type_id;
        alter table voucher rename column voucher_type_uuid to voucher_type_id;
        alter table voucher alter column voucher_type_id set not null;
-- WAREHOUSE
    alter table warehouse drop column if exists id;
    alter table warehouse rename column uuid_id to id;
    alter table warehouse alter column id set not null;
    ALTER TABLE warehouse ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists warehouse_id;
        alter table batch rename column warehouse_uuid to warehouse_id;
        alter table batch alter column warehouse_id set not null;
        alter table batch drop column if exists id;
        --
        alter table inv_txn drop column if exists warehouse_id;
        alter table inv_txn rename column warehouse_uuid to warehouse_id;
        alter table inv_txn alter column warehouse_id set not null;
-- MEMBER
    alter table member drop column if exists id;
    alter table member rename column uuid_id to id;
    alter table member alter column id set not null;
    ALTER TABLE member ADD CONSTRAINT member_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists members;
        alter table branch rename column members_uuid to members;
        alter table branch alter column members set not null;
-- FINANCIAL_YEAR
    alter table financial_year drop column if exists id;
    alter table financial_year rename column uuid_id to id;
    alter table financial_year alter column id set not null;
    ALTER TABLE financial_year ADD CONSTRAINT financial_year_pkey PRIMARY KEY (id);
        --
        alter table voucher_numbering drop column if exists f_year_id;
        alter table voucher_numbering rename column f_year_uuid to f_year_id;
        alter table voucher_numbering ADD CONSTRAINT voucher_numbering_pkey PRIMARY KEY (branch_id, f_year_id, voucher_type_id);
-- BILL_OF_MATERIAL
    alter table bill_of_material drop column if exists id;
    alter table bill_of_material rename column uuid_id to id;
    alter table bill_of_material alter column id set not null;
    ALTER TABLE bill_of_material ADD CONSTRAINT bill_of_material_pkey PRIMARY KEY (id);
-- BATCH
    alter table batch add unique (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
-- PRINT_TEMPLATE
    alter table print_template drop column if exists id;
    alter table print_template rename column uuid_id to id;
    alter table print_template alter column id set not null;
    ALTER TABLE print_template ADD CONSTRAINT print_template_pkey PRIMARY KEY (id);
    /*
-- UDM_DOCTOR
    alter table udm_doctor drop column if exists id;
    alter table udm_doctor rename column uuid_id to id;
    alter table udm_doctor alter column id set not null;
    ALTER TABLE udm_doctor ADD CONSTRAINT udm_doctor_pkey PRIMARY KEY (id);
-- UDM_DRUG_CLASSIFICATION
    alter table udm_drug_classification drop column if exists id;
    alter table udm_drug_classification rename column uuid_id to id;
    alter table udm_drug_classification alter column id set not null;
    ALTER TABLE udm_drug_classification ADD CONSTRAINT udm_drug_classification_pkey PRIMARY KEY (id);
        --
        alter table inv_txn drop column if exists udf_drug_classifications;
        alter table inv_txn rename column udf_drug_classifications_uuid to udf_drug_classifications;
        --
        alter table udm_inventory_composition drop column if exists drug_classifications;
        alter table udm_inventory_composition rename column drug_classifications_uuid to drug_classifications;
-- UDM_INVENTORY_COMPOSITION
    alter table udm_inventory_composition drop column if exists id;
    alter table udm_inventory_composition rename column uuid_id to id;
    alter table udm_inventory_composition alter column id set not null;
    ALTER TABLE udm_inventory_composition ADD CONSTRAINT udm_inventory_composition_pkey PRIMARY KEY (id);
        --
        alter table inventory drop column if exists udf_compositions;
        alter table inventory rename column udf_compositions_uuid to udf_compositions;
    */

-------------------------------------------------------------------------------------------------
---- DROP TEMP INDEX
-------------------------------------------------------------------------------------------------
-- AC_TXN
DROP INDEX if exists ac_txn_account_id_account_uuid_id_idx;
DROP INDEX if exists ac_txn_alt_account_id_alt_account_uuid_id_idx;
DROP INDEX if exists ac_txn_branch_id_branch_uuid_id_idx;
DROP INDEX if exists ac_txn_voucher_id_voucher_uuid_id_idx;
DROP INDEX if exists ac_txn_voucher_type_id_voucher_type_uuid_id_idx;
DROP INDEX if exists ac_txn_voucher_type_id_idx;
-- BATCH
DROP INDEX if exists batch_vendor_id_vendor_uuid_id_idx;
DROP INDEX if exists batch_branch_id_branch_uuid_id_idx;
DROP INDEX if exists batch_inventory_id_inventory_uuid_id_idx;
DROP INDEX if exists batch_voucher_id_voucher_uuid_id_idx;
DROP INDEX if exists batch_warehouse_id_warehouse_uuid_id_idx;
-- -- INV_TXN
DROP INDEX if exists inv_txn_vendor_id_vendor_uuid_id_idx;
DROP INDEX if exists inv_txn_customer_id_customer_uuid_id_idx;
DROP INDEX if exists inv_txn_branch_id_branch_uuid_id_idx;
DROP INDEX if exists inv_txn_inventory_id_inventory_uuid_id_idx;
DROP INDEX if exists inv_txn_sales_person_id_sales_person_uuid_id_idx;
DROP INDEX if exists inv_txn_voucher_id_voucher_uuid_id_idx;
DROP INDEX if exists inv_txn_voucher_type_id_voucher_type_uuid_id_idx;
DROP INDEX if exists inv_txn_warehouse_id_warehouse_uuid_id_idx;
DROP INDEX if exists inv_txn_batch_id_idx;
DROP INDEX if exists inv_txn_voucher_type_id_idx;
-- VOUCHER
DROP INDEX if exists voucher_vendor_id_vendor_uuid_id_idx;
DROP INDEX if exists voucher_customer_id_customer_uuid_id_idx;
DROP INDEX if exists voucher_branch_id_branch_uuid_id_idx;
DROP INDEX if exists voucher_sales_person_id_sales_person_uuid_id_idx;
DROP INDEX if exists voucher_vocher_type_id_vocher_type_uuid_id_idx;
DROP INDEX if exists voucher_warehouse_id_warehouse_uuid_id_idx;