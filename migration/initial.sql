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
alter table vendor_bill_map rename to udm_vendor_bill_map;
alter table vendor_item_map rename to udm_vendor_item_map;
--
-- drop table if exists doctor;
alter table doctor rename to udm_doctor;
    alter table udm_doctor drop if exists display_name;
    alter table udm_doctor drop if exists alias_name;
    alter table udm_doctor drop if exists age;
alter table if exists drug_classification rename to udm_drug_classification;
alter table if exists inventory_composition rename to udm_inventory_composition;
--
alter table organization
    add if not exists created_by uuid,
    add if not exists updated_by uuid;
--
alter table organization
    alter column configuration type jsonb using configuration::jsonb,
    alter column license_claims type jsonb using license_claims::jsonb;
--## f_key
alter table udm_vendor_bill_map
    rename constraint vendor_bill_map_pkey to udm_vendor_bill_map_pkey;
alter table udm_vendor_item_map
    rename constraint vendor_item_map_pkey to udm_vendor_item_map_pkey;
alter table udm_doctor
    rename constraint doctor_pkey to udm_doctor_pkey;
alter table udm_drug_classification
    rename constraint drug_classification_pkey to udm_drug_classification_pkey;
alter table udm_inventory_composition
    rename constraint inventory_composition_pkey to udm_inventory_composition_pkey;
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
    UPDATE voucher_type SET name = 'Stock Journal' WHERE id = 10;
    UPDATE voucher_type SET base_type = 'STOCK_JOURNAL' WHERE id = 10;
    UPDATE voucher_type SET uuid_id = '019587a6-a400-7046-8000-000000000000' WHERE id = 17;
    UPDATE voucher_type SET uuid_id = '01958ccd-0000-7047-8000-000000000000' WHERE id = 21;
    UPDATE voucher_type SET uuid_id = '019591f3-5c00-7048-8000-000000000000' WHERE id = 23;
    UPDATE voucher_type
    SET config = (SELECT jsonb_object_agg(
                                 key,
                                 value_cleaned
                         )
                  FROM jsonb_each(config::jsonb) t(key, value)
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
                      ) AS cleaned(value_cleaned))::json;
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
    ALTER TABLE udm_doctor ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_doctor ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;

ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE print_template ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_doctor ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

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
ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
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
alter table inventory rename column compositions to udf_compositions;
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
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS udf_compositions_uuid uuid[];
------------------
    UPDATE inventory b SET sale_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sale_account_id and a.transaction_enabled;
    UPDATE inventory b SET purchase_account_uuid = a.uuid_id FROM account a WHERE a.id = b.purchase_account_id and a.transaction_enabled;
    UPDATE inventory b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    UPDATE inventory b SET section_uuid = a.id FROM section a WHERE a.old_id = b.section_id;
    UPDATE inventory b
    SET unit_uuid          = (select id from unit where symbol = '1'),
        sale_unit_uuid     = (select id from unit where symbol = '1'),
        purchase_unit_uuid = (select id from unit where symbol = '1');
    UPDATE inventory t
        SET udf_compositions_uuid =
                (SELECT array_agg(udm_inventory_composition.uuid_id)
                 FROM unnest(t.udf_compositions) AS u(class_id)
                          JOIN udm_inventory_composition
                               ON udm_inventory_composition.id = u.class_id)
        WHERE t.udf_compositions IS NOT NULL;
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
alter table inventory_branch_detail alter column reorder_mode drop not null;
--##
alter table inventory_branch_detail alter column reorder_level drop not null;
--##
alter table inventory_branch_detail rename reorder_mode to udf_reorder_mode;
alter table inventory_branch_detail rename reorder_level to udf_reorder_level;
alter table inventory_branch_detail rename min_order to udf_min_order;
alter table inventory_branch_detail rename max_order to udf_max_order;
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

--
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
--

---------------------------------------------------------------------------
--## BILL_OF_MATERIAL
select now() as time, 'UUID_CHANGES FOR BILL_OF_MATERIAL STARTS' as msg;
ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE bill_of_material b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
select now() as time, 'UUID_CHANGES FOR BILL_OF_MATERIAL ENDS' as msg;
--## BILL_OF_MATERIAL
---------------------------------------------------------------------------

--
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
--

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
alter table gstr_2b drop column IF EXISTS id;
alter table gstr_2b rename column gst_no to ctin;
alter table gstr_2b rename column supplier_name to trdnm;
alter table gstr_2b rename column invoice_no to inum;
alter table gstr_2b rename column invoice_date to dt;
alter table gstr_2b rename column total_invoice_value to val;
alter table gstr_2b rename column total_taxable_amount to txval;
alter table gstr_2b rename column integrated_tax_amount to igst;
alter table gstr_2b rename column central_tax_amount to cgst;
alter table gstr_2b rename column state_tax_amount to sgst;
alter table gstr_2b rename column cess_amount to cess;
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