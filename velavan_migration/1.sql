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

--ADD OR MODIFY COLUMN--

-- AC_TXN --
--##
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
-- AC_TXN --

-- BATCH --
--
update batch
set batch_no = coalesce(nullif(upper(regexp_replace(batch_no, '\s+', '', 'g')), ''), '1');
--##
alter table batch
    alter batch_no set not null;
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
alter table batch rename column category1_id to section_id;
alter table batch alter column unit_conv set not null;
alter table batch alter column batch_no set not null;
-- BATCH --

-- INV_TXN --
--##
alter table inv_txn
    add if not exists sno                      int,
    add if not exists qty                      float,
    add if not exists unit_id                  int,
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
    add if not exists disc_mode1                text,
    add if not exists discount1                 float,
    add if not exists disc_mode2                text,
    add if not exists discount2                 float,
    add if not exists disc_mode3                text,
    add if not exists discount3                 float,
    add if not exists hsn_code                 text,
    add if not exists cess_on_qty              float,
    add if not exists cess_on_val              float,
    add if not exists customer_id              int,
    add if not exists sales_person_id          int,
    add if not exists dummy                    bool,
    add if not exists udf_drug_classifications int[];
--##
alter table inv_txn rename column category1_id to section_id;
--##
update inv_txn t
set sno         = i.sno,
    qty         = i.qty,
    rate        = i.rate,
    unit_id     = i.unit_id,
    unit_conv   = i.unit_conv,
    rate_tax_inclusive = true,
    gst_tax     = i.gst_tax,
    disc_mode1  = i.disc_mode,
    discount1   = i.discount,
    hsn_code    = i.hsn_code,
    cess_on_qty = i.cess_on_qty,
    cess_on_val = i.cess_on_val
from credit_note_inv_item i
where t.id = i.id;
--##
update inv_txn t
set customer_id = b.customer_id
from credit_note b
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
--##
update inv_txn t
set sno         = i.sno,
    qty         = i.qty,
    rate        = i.rate,
    unit_id     = i.unit_id,
    unit_conv   = i.unit_conv,
    gst_tax     = i.gst_tax,
    disc_mode1  = i.disc1_mode,
    discount1   = i.discount1,
    disc_mode2  = i.disc2_mode,
    discount2   = i.discount2,
    rate_tax_inclusive = false,
    hsn_code    = i.hsn_code,
    cess_on_qty = i.cess_on_qty,
    cess_on_val = i.cess_on_val
from debit_note_inv_item i
where t.id = i.id;
--##
update inv_txn t
set vendor_id   = b.vendor_id,
    vendor_name = b.vendor_name
from debit_note b
where b.vendor_id is not null
  and t.voucher_id = b.voucher_id;
--##
update inv_txn t
set sno               = i.sno,
    qty               = i.qty,
    rate              = i.cost,
    unit_id           = i.unit_id,
    unit_conv         = i.unit_conv,
    gst_tax           = i.gst_tax,
    hsn_code          = i.hsn_code,
    cess_on_qty       = i.cess_on_qty,
    cess_on_val       = i.cess_on_val
from personal_use_purchase_inv_item i
where t.id = i.id;
--##
update inv_txn t
set sno                   = i.sno,
    qty                   = i.qty,
    rate                  = i.rate,
    p_rate                = i.rate,
    unit_id               = i.unit_id,
    unit_conv             = i.unit_conv,
    gst_tax               = i.gst_tax,
    disc_mode1            = i.disc1_mode,
    discount1             = i.discount1,
    disc_mode2            = i.disc2_mode,
    discount2             = i.discount2,
    hsn_code              = i.hsn_code,
    cess_on_qty           = i.cess_on_qty,
    cess_on_val           = i.cess_on_val
from purchase_bill_inv_item i
where t.id = i.id;
--##
update inv_txn t
set vendor_id     = b.vendor_id,
    vendor_name   = b.vendor_name,
    customer_id   = b.customer_id
from purchase_bill b
where t.voucher_id = b.voucher_id;
--##
--##
update inv_txn t
set sno                      = i.sno,
    qty                      = i.qty,
    rate                     = i.rate,
    unit_id                  = i.unit_id,
    unit_conv                = i.unit_conv,
    gst_tax                  = i.gst_tax,
    disc_mode1               = i.disc_mode,
    discount1                = i.discount,
    hsn_code                 = i.hsn_code,
    cess_on_qty              = i.cess_on_qty,
    cess_on_val              = i.cess_on_val,
    sales_person_id          = i.s_inc_id,
    udf_drug_classifications = i.drug_classifications
from sale_bill_inv_item i
where t.id = i.id;
--##
update inv_txn t
set customer_id   = b.customer_id
from sale_bill b
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
--##
update inv_txn t
set sno               = i.sno,
    qty               = i.qty,
    rate              = i.rate,
    unit_id           = i.unit_id,
    unit_conv         = i.unit_conv,
    barcode           = i.barcode,
    asset_amount      = i.asset_amount
from stock_journal_inv_item i
where t.id = i.id;
--##
update inv_txn t
set sno               = i.sno,
    unit_id           = i.unit_id,
    unit_conv         = i.unit_conv,
    qty               = i.qty,
    rate              = i.rate,
    asset_amount      = i.asset_amount
from inventory_opening i
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
-- INV_TXN --

-- VOUCHER --
--##
alter table voucher
    add if not exists metadata                     jsonb,
    add if not exists branch_gst_reg_type          text,
    add if not exists branch_gst_location_id       text,
    add if not exists branch_gst_no                text,
    add if not exists party_gst_reg_type           text,
    add if not exists party_gst_location_id        text,
    add if not exists party_gst_no                 text,
    add if not exists gst_location_type            text,
    add if not exists vendor_id                    int,
    add if not exists vendor_name                  text,
    add if not exists customer_id                  int,
    add if not exists customer_name                text,
    add if not exists warehouse_id                 int,
    add if not exists warehouse_name               text,
    add if not exists rounded_off                  float,
    add if not exists disc_mode                    text,
    add if not exists discount                     float,
    add if not exists sales_person_id              int,
    add if not exists sale_value                   float,
    add if not exists profit_value                 float,
    add if not exists nlc_value                    float,
    add if not exists valid_provisional_profit     bool,
    add if not exists udf_alt_branch_id            int,
    add if not exists udf_alt_warehouse_id         int,
    add if not exists udf_transfer_voucher_id      int,
    add if not exists udf_approved                 bool,
    add if not exists udf_doctor_id                int;
--##
update voucher v
set branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = b.warehouse_id,
    warehouse_name         = b.warehouse_name,
    vendor_id              = b.vendor_id,
    vendor_name            = b.vendor_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off
from debit_note b
where v.id = b.voucher_id;
--##
update voucher v
set branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = b.warehouse_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = b.customer_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = b.s_inc_id
from credit_note b
where v.id = b.voucher_id;
--##
update voucher v
set warehouse_id            = b.warehouse_id,
    warehouse_name          = b.warehouse_name,
    udf_alt_branch_id       = b.alt_branch_id,
    udf_alt_warehouse_id    = b.alt_warehouse_id,
    udf_transfer_voucher_id = b.transfer_voucher_id,
    udf_approved            = b.approved
from stock_journal b
where v.id = b.voucher_id;
--##
update voucher v
set warehouse_id   = b.warehouse_id,
    warehouse_name = b.warehouse_name,
    vendor_id      = b.vendor_id,
    vendor_name    = b.vendor_name
from goods_inward_note b
where v.id = b.voucher_id;
--##
update voucher v
set branch_gst_reg_type     = b.branch_gst ->> 'reg_type',
    branch_gst_location_id  = b.branch_gst ->> 'location_id',
    branch_gst_no           = b.branch_gst ->> 'gst_no',
    warehouse_id            = b.warehouse_id,
    warehouse_name          = b.warehouse_name
from personal_use_purchase b
where v.id = b.voucher_id;
--##
update voucher v
set branch_gst_reg_type          = b.branch_gst ->> 'reg_type',
    branch_gst_location_id       = b.branch_gst ->> 'location_id',
    branch_gst_no                = b.branch_gst ->> 'gst_no',
    party_gst_reg_type           = b.party_gst ->> 'reg_type',
    party_gst_location_id        = b.party_gst ->> 'location_id',
    party_gst_no                 = b.party_gst ->> 'gst_no',
    warehouse_id                 = b.warehouse_id,
    warehouse_name               = b.warehouse_name,
    vendor_id                    = b.vendor_id,
    vendor_name                  = b.vendor_name,
    customer_id                  = b.customer_id,
    customer_name                = b.customer_name,
    rounded_off                  = b.rounded_off,
    disc_mode                    = b.discount_mode,
    discount                     = b.discount_amount,
    sale_value                   = b.sale_value,
    profit_value                 = b.profit_value,
    nlc_value                    = b.nlc_value,
    valid_provisional_profit     = b.valid_provisional_profit
from purchase_bill b
where v.id = b.voucher_id;
--##
update voucher v
set branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = b.warehouse_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = b.customer_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = b.s_inc_id,
    udf_doctor_id          = b.doctor_id
from sale_bill b
where v.id = b.voucher_id;
--##
--##
update voucher v
set branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = b.warehouse_id,
    warehouse_name         = b.warehouse_name,
    customer_id            = b.customer_id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = b.s_inc_id
from sale_quotation b
where v.id = b.voucher_id;
--##
alter table voucher
    alter column mode set not null,
    alter column e_invoice_details type jsonb using e_invoice_details::jsonb,
    alter column eway_bill_details type jsonb using eway_bill_details::jsonb;
-- VOUCHER --

-- BANK_TXN
alter table bank_txn alter column sno type integer using sno::integer;
alter table bank_txn alter column is_memo set not null;
-- BANK_TXN

-- BANK_BENEFICIARY --
alter table bank_beneficiary rename beneficiary_code to code;
alter table bank_beneficiary alter column bank_account_type set not null;
-- BANK_BENEFICIARY --

-- BILL_ALLOCATION --
--##
alter table bill_allocation rename meta_data to metadata;
alter table bill_allocation alter column metadata type jsonb using metadata::jsonb;
alter table bill_allocation alter column sno type int using sno::int;
--##
-- BILL_ALLOCATION --

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

-- INVENTORY --
--##
alter table inventory
    add if not exists cess_qty    float,
    add if not exists cess_value    float;
alter table inventory rename column category1_id to section_id;
alter table inventory rename column compositions to udf_compositions;
--##
update inventory
set
  cess_qty   = (cess ->> 'on_quantity')::double precision,
  cess_value = (cess ->> 'on_value')::double precision;
--##
alter table inventory add column code integer;
update inventory set code = id;
alter table inventory alter column code set not null;
-- INVENTORY --

-- INVENTORY_BRANCH_DETAIL --
--##
alter table inventory_branch_detail
    add if not exists s_disc_percentage float;
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
alter table inventory_branch_detail
    alter column reorder_mode drop not null;
--##
alter table inventory_branch_detail
    alter column reorder_level drop not null;
--##
alter table inventory_branch_detail rename reorder_mode to udf_reorder_mode;
alter table inventory_branch_detail rename reorder_level to udf_reorder_level;
alter table inventory_branch_detail rename min_order to udf_min_order;
alter table inventory_branch_detail rename max_order to udf_max_order;
-- INVENTORY_BRANCH_DETAIL --

-- Account
alter table account
    alter column transaction_enabled set not null;
alter table account
    ADD column code int;
update account
SET code = id;
alter table account
    alter column code SET NOT NULL;
alter table account
    alter column e_banking_info type jsonb using e_banking_info::jsonb;
-- Account

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

-- ORGANIZATION --
--##
alter table organization
    add if not exists created_by int,
    add if not exists updated_by int;
--##
alter table organization
    alter column configuration type jsonb using configuration::jsonb,
    alter column license_claims type jsonb using license_claims::jsonb;
--##
UPDATE organization o
SET
    created_by = m.id,
    updated_by = m.id,
    id = '0194244f-d800-7001-8000-000000000000'
FROM member m
WHERE m.id = 1;
-- ORGANIZATION --

-- TDS_NATURE_OF_PAYMENT --
    --##
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
        --##
    --##
-- TDS_NATURE_OF_PAYMENT --



-- BILL ALLOCATION IMP --
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
-- BILL ALLOCATION IMP --

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

-- UNIT
alter table unit alter column precision type int using precision::int;
-- UNIT

-- MODIFY TABLE
alter table vendor_bill_map rename to udm_vendor_bill_map;
alter table vendor_item_map rename to udm_vendor_item_map;
alter table doctor rename to udm_doctor;
    alter table udm_doctor drop if exists display_name;
    alter table udm_doctor drop if exists alias_name;
    alter table udm_doctor drop if exists age;
alter table if exists drug_classification rename to udm_drug_classification;
alter table if exists inventory_composition rename to udm_inventory_composition;
-- MODIFY TABLE

--NEW TABLE--

-- SEQUENCE --
create table sequence (
    model_name text not null,
    seq integer not null,
    constraint sequence_pkey primary key (model_name)
);

insert into sequence (model_name, seq)
select 'account', coalesce(max(code), 0)
from account
on conflict (model_name)
do update set seq = excluded.seq;

insert into sequence (model_name, seq)
select 'inventory', coalesce(max(code), 0)
from inventory
on conflict (model_name)
do update set seq = excluded.seq;

insert into sequence (model_name, seq)
select 'batch', coalesce(max(id), 0)
from batch
on conflict (model_name)
do update set seq = excluded.seq;

-- BASE_VOUCHER_TYPE --
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
-- BASE_VOUCHER_TYPE --

-- GST_TAX --
--##
create table if not exists gst_tax
(
    name                       text  primary key,
    display_name               text  not null,
    igst                       float not null,
    cgst                       float not null,
    sgst                       float not null,
    cgst_payable_account_id    int   not null,
    sgst_payable_account_id    int   not null,
    igst_payable_account_id    int   not null,
    cgst_receivable_account_id int   not null,
    sgst_receivable_account_id int   not null,
    igst_receivable_account_id int   not null
);
--##
insert into gst_tax
(name, display_name, igst, cgst, sgst, cgst_payable_account_id, sgst_payable_account_id, igst_payable_account_id,
 cgst_receivable_account_id, sgst_receivable_account_id, igst_receivable_account_id)
values ('gstna', 'Not Applicable', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gstexempt', 'Exempt', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gstngs', 'Non Gst Supply', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gst0', 'Gst 0%', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gst0p1', 'Gst 0.1%', 0.1, 0.05, 0.05, 4, 5, 6, 8, 9, 10),
       ('gst0p25', 'Gst 0.25%', 0.25, 0.125, 0.125, 4, 5, 6, 8, 9, 10),
       ('gst1', 'Gst 1%', 1.0, 0.5, 0.5, 4, 5, 6, 8, 9, 10),
       ('gst1p5', 'Gst 1.5%', 1.50, 0.75, 0.75, 4, 5, 6, 8, 9, 10),
       ('gst3', 'Gst 3%', 3.0, 1.5, 1.5, 4, 5, 6, 8, 9, 10),
       ('gst5', 'Gst 5%', 5.0, 2.5, 2.5, 4, 5, 6, 8, 9, 10),
       ('gst6', 'Gst 6%', 6.0, 3.0, 3.0, 4, 5, 6, 8, 9, 10),
       ('gst7p5', 'Gst 7.5%', 7.5, 3.75, 3.75, 4, 5, 6, 8, 9, 10),
       ('gst12', 'Gst 12%', 12.0, 6.0, 6.0, 4, 5, 6, 8, 9, 10),
       ('gst18', 'Gst 18%', 18.0, 9.0, 9.0, 4, 5, 6, 8, 9, 10),
       ('gst28', 'Gst 28%', 28.0, 14.0, 14.0, 4, 5, 6, 8, 9, 10),
       ('gst40', 'Gst 40%', 40.0, 20.0, 20.0, 4, 5, 6, 8, 9, 10);
--##
-- GST_TAX --

-- SECTION --
--##
create table if not exists section
(
    id         serial primary key,
    name       text      not null,
    created_by int       not null,
    updated_by int       not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
INSERT INTO section (id, name, created_by, updated_by, created_at, updated_at)
SELECT id, name, created_by, updated_by, created_at, updated_at
FROM category_option;
--##
SELECT setval('section_id_seq', (select max(id) from section));
-- SECTION --

-- UNIT_CONVERSION --
--##
create table if not exists unit_conversion
(
    primary_unit_id    uuid       not null,
    conversion_unit_id uuid       not null,
    conversion         float     not null,
    primary key (primary_unit_id, conversion)
);
--##
-- UNIT_CONVERSION --

-- UQC --
--##
create table if not exists uqc
(
    id   text primary key,
    name text not null
);
--##
-- UQC --

--## permissions
create table if not exists permission
(
    name       text primary key,
    created_by int      not null,
    updated_by int      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
------------------------------
--## permission insert
--##
insert into permission (name, created_by, updated_by, created_at, updated_at)
values
    --account
    ('account_create', 1, 1, current_timestamp, current_timestamp),
    ('account_update', 1, 1, current_timestamp, current_timestamp),
    ('account_get', 1, 1, current_timestamp, current_timestamp),
    ('account_list', 1, 1, current_timestamp, current_timestamp),
    ('account_delete', 1, 1, current_timestamp, current_timestamp),
    --account_type
    ('account_type_create', 1, 1, current_timestamp, current_timestamp),
    ('account_type_update', 1, 1, current_timestamp, current_timestamp),
    ('account_type_get', 1, 1, current_timestamp, current_timestamp),
    ('account_type_list', 1, 1, current_timestamp, current_timestamp),
    ('account_type_delete', 1, 1, current_timestamp, current_timestamp),
    --bank_beneficiary
    ('bank_beneficiary_create', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_update', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_get', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_list', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_delete', 1, 1, current_timestamp, current_timestamp),
    --base_voucher_type
    ('base_voucher_type_create', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_get', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_list', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_delete', 1, 1, current_timestamp, current_timestamp),
    --batch
    ('batch_label', 1, 1, current_timestamp, current_timestamp),
    ('batch_list', 1, 1, current_timestamp, current_timestamp),
    ('batch_update', 1, 1, current_timestamp, current_timestamp),
    --bill_allocation_breakup
    ('bill_allocation_breakup', 1, 1, current_timestamp, current_timestamp),
    --bill_of_material
    ('bill_of_material_create', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_update', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_get', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_list', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_delete', 1, 1, current_timestamp, current_timestamp),
    --branch
    ('branch_create', 1, 1, current_timestamp, current_timestamp),
    ('branch_update', 1, 1, current_timestamp, current_timestamp),
    ('branch_get', 1, 1, current_timestamp, current_timestamp),
    ('branch_list', 1, 1, current_timestamp, current_timestamp),
    ('branch_delete', 1, 1, current_timestamp, current_timestamp),
    --gst_registration
    ('gst_registration_create', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_update', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_get', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_list', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_delete', 1, 1, current_timestamp, current_timestamp),
    --gst_tax
    ('gst_tax_update', 1, 1, current_timestamp, current_timestamp),
    --gstr_2b
    ('gstr_2b_get', 1, 1, current_timestamp, current_timestamp),
    ('gstr_2b_reconcile', 1, 1, current_timestamp, current_timestamp),
    ('gstr_2b_upload', 1, 1, current_timestamp, current_timestamp),
    --section
    ('section_create', 1, 1, current_timestamp, current_timestamp),
    ('section_update', 1, 1, current_timestamp, current_timestamp),
    ('section_get', 1, 1, current_timestamp, current_timestamp),
    ('section_list', 1, 1, current_timestamp, current_timestamp),
    ('section_delete', 1, 1, current_timestamp, current_timestamp),
    --inventory
    ('inventory_create', 1, 1, current_timestamp, current_timestamp),
    ('inventory_update', 1, 1, current_timestamp, current_timestamp),
    ('inventory_get', 1, 1, current_timestamp, current_timestamp),
    ('inventory_list', 1, 1, current_timestamp, current_timestamp),
    ('inventory_delete', 1, 1, current_timestamp, current_timestamp),
    --inventory_opening
    ('inventory_opening', 1, 1, current_timestamp, current_timestamp),
    --unit_conversion
    ('unit_conversion_set', 1, 1, current_timestamp, current_timestamp),
    --unit
    ('unit_create', 1, 1, current_timestamp, current_timestamp),
    ('unit_update', 1, 1, current_timestamp, current_timestamp),
    ('unit_get', 1, 1, current_timestamp, current_timestamp),
    ('unit_list', 1, 1, current_timestamp, current_timestamp),
    ('unit_delete', 1, 1, current_timestamp, current_timestamp),
    --financial_report
    ('financial_report', 1, 1, current_timestamp, current_timestamp),
    ('opening_balance_difference', 1, 1, current_timestamp, current_timestamp),
    --financial_year
    ('financial_year_add', 1, 1, current_timestamp, current_timestamp),
    ('financial_year_get', 1, 1, current_timestamp, current_timestamp),
    ('financial_year_list', 1, 1, current_timestamp, current_timestamp),
    --manufacturer
    ('manufacturer_create', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_update', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_get', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_list', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_delete', 1, 1, current_timestamp, current_timestamp),
    --warehouse
    ('warehouse_create', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_update', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_get', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_list', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_delete', 1, 1, current_timestamp, current_timestamp),
    --member
    ('member_create', 1, 1, current_timestamp, current_timestamp),
    ('member_update', 1, 1, current_timestamp, current_timestamp),
    ('member_get', 1, 1, current_timestamp, current_timestamp),
    ('member_list', 1, 1, current_timestamp, current_timestamp),
    --permission
    ('permission_create', 1, 1, current_timestamp, current_timestamp),
    ('permission_update', 1, 1, current_timestamp, current_timestamp),
    ('permission_get', 1, 1, current_timestamp, current_timestamp),
    ('permission_list', 1, 1, current_timestamp, current_timestamp),
    ('permission_delete', 1, 1, current_timestamp, current_timestamp),
    --tds_nature_of_payment
    ('tds_nature_of_payment_create', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_update', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_get', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_list', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_delete', 1, 1, current_timestamp, current_timestamp),
    --tds_section_breakup
    ('tds_section_breakup', 1, 1, current_timestamp, current_timestamp),
    --print_layout
    ('print_layout_get', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_list', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_create', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_update', 1, 1, current_timestamp, current_timestamp),
    --print_template
    ('print_template_create', 1, 1, current_timestamp, current_timestamp),
    ('print_template_reset', 1, 1, current_timestamp, current_timestamp),
    ('print_template_get', 1, 1, current_timestamp, current_timestamp),
    ('print_template_cancel', 1, 1, current_timestamp, current_timestamp),
    ('print_template_delete', 1, 1, current_timestamp, current_timestamp),
    --stock_location
    ('stock_location_create', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_update', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_get', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_list', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_delete', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_assign', 1, 1, current_timestamp, current_timestamp),
    --set_inventory_branch_price_configuration
    ('price_configuration_set', 1, 1, current_timestamp, current_timestamp),
    --organization
    ('organization_get', 1, 1, current_timestamp, current_timestamp),
    ('organization_update', 1, 1, current_timestamp, current_timestamp),
    --voucher_register
    ('voucher_register_detail', 1, 1, current_timestamp, current_timestamp),
    ('voucher_register_group', 1, 1, current_timestamp, current_timestamp),
    --voucher_type
    ('voucher_type_create', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_update', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_get', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_list', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_delete', 1, 1, current_timestamp, current_timestamp),
    --voucher
    ('voucher_create', 1, 1, current_timestamp, current_timestamp),
    ('voucher_update', 1, 1, current_timestamp, current_timestamp),
    ('voucher_get', 1, 1, current_timestamp, current_timestamp),
    ('voucher_cancel', 1, 1, current_timestamp, current_timestamp),
    ('voucher_delete', 1, 1, current_timestamp, current_timestamp),
    --report and other
    ('account_book', 1, 1, current_timestamp, current_timestamp),
    ('account_outstanding', 1, 1, current_timestamp, current_timestamp),
    ('account_transaction_history', 1, 1, current_timestamp, current_timestamp),
    ('bill_outstanding', 1, 1, current_timestamp, current_timestamp),
    ('bank_collection', 1, 1, current_timestamp, current_timestamp),
    ('bank_list', 1, 1, current_timestamp, current_timestamp),
    ('gst_r1', 1, 1, current_timestamp, current_timestamp),
    ('day_book', 1, 1, current_timestamp, current_timestamp),
    ('bank_reconciliation', 1, 1, current_timestamp, current_timestamp),
    ('sale_analysis', 1, 1, current_timestamp, current_timestamp),
    ('stock_analysis', 1, 1, current_timestamp, current_timestamp),
    ('expiry_analysis', 1, 1, current_timestamp, current_timestamp),
    ('negative_stock_analysis', 1, 1, current_timestamp, current_timestamp),
    ('non_movement_analysis', 1, 1, current_timestamp, current_timestamp),
    ('inventory_batch', 1, 1, current_timestamp, current_timestamp),
    ('inventory_book', 1, 1, current_timestamp, current_timestamp),
    ('inventory_transaction_history', 1, 1, current_timestamp, current_timestamp),
    ('memorandum', 1, 1, current_timestamp, current_timestamp),
    ('partywise_detail', 1, 1, current_timestamp, current_timestamp),
    ('get_batch_detail_with_stock_location', 1, 1, current_timestamp, current_timestamp),
    ('get_inventory_branch_stock_location_label', 1, 1, current_timestamp, current_timestamp),
    ('get_stock_location_wise_branch_stock', 1, 1, current_timestamp, current_timestamp),
    ('get_transfer_pending', 1, 1, current_timestamp, current_timestamp),
    ('account_opening', 1, 1, current_timestamp, current_timestamp),
    ('tds_detail', 1, 1, current_timestamp, current_timestamp);
--##
-------------
--##
alter table udm_doctor
    rename constraint doctor_pkey to udm_doctor_pkey;
alter table udm_drug_classification
    rename constraint drug_classification_pkey to udm_drug_classification_pkey;
alter table udm_inventory_composition
    rename constraint inventory_composition_pkey to udm_inventory_composition_pkey;
--## uqc
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