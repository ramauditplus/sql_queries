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

--ADD DEFAULT--

alter table batch
alter column barcode
set default (currval('batch_id_seq')::text);

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
    add if not exists disc_mode                text,
    add if not exists discount                 float,
    add if not exists hsn_code                 text,
    add if not exists cess_on_qty              float,
    add if not exists cess_on_val              float,
    add if not exists customer_id              int,
    add if not exists sales_person_id          int,
    add if not exists udf_drug_classifications int[];
--##
update inv_txn t
set sno         = i.sno,
    qty         = i.qty,
    rate        = i.rate,
    unit_id     = i.unit_id,
    unit_conv   = i.unit_conv,
    rate_tax_inclusive = true,
    gst_tax     = i.gst_tax,
    disc_mode   = i.disc_mode,
    discount    = i.discount,
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
    disc_mode   = i.disc1_mode,
    discount    = i.discount1,
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
    mrp                   = i.mrp,
    s_rate                = i.s_rate,
    expiry                = i.expiry,
    batch_no              = i.batch_no,
    nlc                   = i.nlc,
    cost                  = i.cost,
    landing_cost          = i.landing_cost,
    unit_id               = i.unit_id,
    unit_conv             = i.unit_conv,
    gst_tax               = i.gst_tax,
    disc_mode             = i.disc1_mode,
    discount              = i.discount1,
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
    disc_mode                = i.disc_mode,
    discount                 = i.discount,
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
    mrp               = i.mrp,
    s_rate            = i.s_rate,
    expiry            = i.expiry,
    batch_no          = i.batch_no,
    nlc               = i.nlc,
    cost              = i.rate,
    landing_cost      = i.landing_cost,
    unit_id           = i.unit_id,
    unit_conv         = i.unit_conv,
    barcode           = i.barcode,
    asset_amount      = i.asset_amount
from stock_journal_inv_item i
where t.id = i.id;
--##
update inv_txn t
set sno               = i.sno,
    branch_id         = i.branch_id,
    inventory_id      = i.inventory_id,
    warehouse_id      = i.warehouse_id,
    unit_id           = i.unit_id,
    unit_conv         = i.unit_conv,
    qty               = i.qty,
    nlc               = i.nlc,
    cost              = i.rate,
    rate              = i.rate,
    landing_cost      = i.landing_cost,
    mrp               = i.mrp,
    s_rate            = i.s_rate,
    batch_no          = i.batch_no,
    expiry            = i.expiry,
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
    alter column batch_no set not null,
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
set customer_id   = b.customer_id,
    customer_name = b.customer_name
from customer_advance b
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