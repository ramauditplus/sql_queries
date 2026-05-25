select now() as time, 'PART - II - MIGRATION START' as msg;
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
    UPDATE bank_txn b SET account_oid = a.id FROM account a WHERE a.old_id = b.account_id;
    UPDATE bank_txn b SET alt_account_oid = a.id FROM account a WHERE a.old_id = b.alt_account_id;
    UPDATE bank_txn b SET branch_oid = a.id FROM branch a WHERE a.old_id = b.branch_id;
    UPDATE bank_txn b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
    UPDATE bank_txn b SET ac_txn_oid = a.oid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
select now() as time, 'OID_CHANGES FOR BANK_TXN ENDS' as msg;
--## BANK_TXN
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--## VOUCHER
select now() as time, 'OID_CHANGES FOR VOUCHER STARTS' as msg;
-- voucher field related changes
alter table voucher rename column party_name to particulars;
--
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
    add if not exists udf_pos_counter_settlement_id text,
    add if not exists udf_customer_mobile          text,
    add if not exists udf_reminder_date            date,
    add if not exists udf_doctor_id                text;
--##
alter table voucher rename pos_counter_code to udf_pos_counter_code;
--##
UPDATE voucher v
set udf_pos_counter_session_id = b.id
from udm_pos_session b
where v.pos_counter_session_id = b.old_id;
--##
UPDATE voucher v
set udf_pos_counter_settlement_id = b.id
from udm_pos_counter_settlement b
where v.pos_counter_settlement_id = b.old_id;
--##
UPDATE voucher a
SET gst_location_type = CASE
    WHEN g.gst_location_type = 'LOCAL' THEN 'INTRA'
    WHEN g.gst_location_type = 'INTER_STATE' THEN 'INTER'
END
FROM gst_txn g
WHERE a.id = g.voucher_id
  AND g.gst_location_type IN ('LOCAL', 'INTER_STATE');
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.id,
    warehouse_name         = b.warehouse_name,
    vendor_id              = a.id,
    vendor_name            = b.vendor_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    branch_oid             = br.id,
    voucher_type_oid       = vt.id,
    particulars            = COALESCE(b.vendor_name, v.particulars)
FROM debit_note b
    LEFT JOIN warehouse w ON b.warehouse_id = w.old_id
    LEFT JOIN account a   ON b.vendor_id = a.old_id
    LEFT JOIN branch br ON b.branch_id = br.old_id
    LEFT JOIN voucher_type vt on b.voucher_type_id = vt.old_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.id,
    branch_oid             = br.id,
    voucher_type_oid       = vt.id,
    particulars            = COALESCE(b.customer_name, v.particulars)
FROM credit_note b
    LEFT JOIN warehouse w ON w.old_id = b.warehouse_id
    LEFT JOIN account a   ON a.old_id = b.customer_id
    LEFT JOIN sales_person sp on b.s_inc_id = sp.old_id
    LEFT JOIN branch br ON b.branch_id = br.old_id
    LEFT JOIN voucher_type vt on b.voucher_type_id = vt.old_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id            = w.id,
    warehouse_name          = b.warehouse_name,
    udf_alt_branch_id       = altbr.id,
    udf_alt_warehouse_id    = altw.id,
    udf_transfer_voucher_id = tv.oid_id,
    udf_approved            = b.approved,
    branch_oid              = br.id,
    voucher_type_oid        = vt.id
FROM stock_journal b
    LEFT JOIN warehouse w ON w.old_id = b.warehouse_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
    LEFT JOIN warehouse altw ON altw.old_id = b.alt_warehouse_id
    LEFT JOIN branch altbr ON altbr.old_id = b.alt_branch_id
    LEFT JOIN voucher tv  ON tv.id = b.transfer_voucher_id
    LEFT JOIN voucher_type vt on vt.old_id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET warehouse_id   = w.id,
    warehouse_name = b.warehouse_name,
    vendor_id      = a.id,
    vendor_name    = b.vendor_name,
    branch_oid     = br.id,
    particulars    = b.vendor_name
FROM goods_inward_note b
    LEFT JOIN warehouse w ON w.old_id = b.warehouse_id
    LEFT JOIN account a   ON a.old_id = b.vendor_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    warehouse_id           = w.id,
    warehouse_name         = b.warehouse_name,
    branch_oid            = br.id,
    voucher_type_oid      = vt.id
FROM personal_use_purchase b
    LEFT JOIN warehouse w ON w.old_id = b.warehouse_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
    LEFT JOIN voucher_type vt on vt.old_id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type      = b.branch_gst ->> 'reg_type',
    branch_gst_location_id   = b.branch_gst ->> 'location_id',
    branch_gst_no            = b.branch_gst ->> 'gst_no',
    party_gst_reg_type       = b.party_gst ->> 'reg_type',
    party_gst_location_id    = b.party_gst ->> 'location_id',
    party_gst_no             = b.party_gst ->> 'gst_no',
    warehouse_id             = w.id,
    warehouse_name           = b.warehouse_name,
    vendor_id                = a.id,
    vendor_name              = b.vendor_name,
    customer_id              = ac.id,
    customer_name            = b.customer_name,
    rounded_off              = b.rounded_off,
    disc_mode                = b.discount_mode,
    discount                 = b.discount_amount,
    sale_value               = b.sale_value,
    profit_value             = b.profit_value,
    nlc_value                = b.nlc_value,
    valid_provisional_profit = b.valid_provisional_profit,
    branch_oid               = br.id,
    voucher_type_oid         = vt.id,
    particulars              = COALESCE(b.vendor_name, v.particulars)
FROM purchase_bill b
    LEFT JOIN warehouse w ON b.warehouse_id = w.old_id
    LEFT JOIN account a   ON b.vendor_id = a.old_id
    LEFT JOIN account ac  ON b.customer_id = ac.old_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
    LEFT JOIN voucher_type vt on vt.old_id = b.voucher_type_id
WHERE v.id = b.voucher_id;
--##
UPDATE voucher v
SET branch_gst_reg_type    = b.branch_gst ->> 'reg_type',
    branch_gst_location_id = b.branch_gst ->> 'location_id',
    branch_gst_no          = b.branch_gst ->> 'gst_no',
    party_gst_reg_type     = b.party_gst ->> 'reg_type',
    party_gst_location_id  = b.party_gst ->> 'location_id',
    party_gst_no           = b.party_gst ->> 'gst_no',
    warehouse_id           = w.id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.id,
    branch_oid             = br.id,
    voucher_type_oid       = vt.id,
    udf_customer_mobile    = a.mobile,
    udf_reminder_date      = b.date + b.reminder_days,
    udf_doctor_id          = ud.id,
    particulars            = COALESCE(b.customer_name, v.particulars)
FROM sale_bill b
    LEFT JOIN warehouse w     ON w.old_id = b.warehouse_id
    LEFT JOIN account a       ON a.old_id = b.customer_id
    LEFT JOIN sales_person sp ON sp.old_id = b.s_inc_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
    LEFT JOIN voucher_type vt on vt.old_id = b.voucher_type_id
    LEFT JOIN udm_doctor ud   ON ud.old_id = b.doctor_id
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
    warehouse_id           = w.id,
    warehouse_name         = b.warehouse_name,
    customer_id            = a.id,
    customer_name          = b.customer_name,
    disc_mode              = b.discount_mode,
    discount               = b.discount_amount,
    rounded_off            = b.rounded_off,
    sales_person_id        = sp.id,
    branch_oid             = br.id,
    voucher_type_oid       = vt.id,
    particulars            = COALESCE(b.customer_name, v.particulars)
FROM sale_quotation b
    LEFT JOIN warehouse w     ON w.old_id = b.warehouse_id
    LEFT JOIN account a       ON a.old_id = b.customer_id
    LEFT JOIN sales_person sp ON sp.old_id = b.s_inc_id
    LEFT JOIN branch br   ON br.old_id = b.branch_id
    LEFT JOIN voucher_type vt on vt.old_id = b.voucher_type_id
WHERE v.id = b.voucher_id;

--##
alter table voucher
    alter column mode set not null,
    alter column e_invoice_details type jsonb using e_invoice_details::jsonb,
    alter column eway_bill_details type jsonb using eway_bill_details::jsonb;
------------------
select now() as time, 'OID_CHANGES FOR VOUCHER BRANCH_ID STARTS' as msg;
create index on voucher (branch_id, branch_oid);
UPDATE voucher b SET branch_oid = a.id FROM branch a WHERE a.old_id = b.branch_id and branch_oid is null;
select now() as time, 'OID_CHANGES FOR VOUCHER BRANCH_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR VOUCHER VOUCHER_TYPE_ID ENDS' as msg;
create index on voucher (voucher_type_id, voucher_type_oid);
UPDATE voucher b SET voucher_type_oid = a.id FROM voucher_type a WHERE a.old_id = b.voucher_type_id and voucher_type_oid is null;
--##
UPDATE voucher v
SET party_gst_no          = a.gst_no,
    party_gst_location_id = a.gst_location_id,
    party_gst_reg_type    = a.gst_reg_type
FROM account a
WHERE v.vendor_id = a.id
  AND v.base_voucher_type = 'PURCHASE'
  AND v.party_gst_no IS NULL;
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
    add if not exists qty               float,
    add if not exists gst_description   text,
    add if not exists hsn_code          text,
    add if not exists uqc               text,
    add if not exists gst_tax           text,
    add if not exists gst_ratio         float,
    add if not exists taxable_amount    float,
    add if not exists cgst_amount       float,
    add if not exists sgst_amount       float,
    add if not exists igst_amount       float,
    add if not exists cess_amount       float;
--##
UPDATE ac_txn a
SET qty             = g.qty,
    gst_description = g.item_name,
    gst_tax         = g.gst_tax,
    gst_ratio       = g.tax_ratio,
    hsn_code        = g.hsn_code,
    uqc             = g.uqc,
    taxable_amount  = g.taxable_amount,
    cgst_amount     = g.cgst_amount,
    sgst_amount     = g.sgst_amount,
    igst_amount     = g.igst_amount,
    cess_amount     = g.cess_amount
FROM gst_txn g
WHERE a.id = g.ac_txn_id;
--##
alter table ac_txn
    alter column is_memo set not null,
    alter column metadata type jsonb using metadata::jsonb,
    alter column sno type integer using sno::integer;
--#
UPDATE ac_txn
SET metadata = jsonb_set(
        COALESCE(metadata, '{}'::jsonb),
        '{has_extra_account_adjustments}',
        'true'::jsonb,
        true
               )
WHERE account_id IN (12, 13, 14)
  AND base_voucher_type IN (
                            'SALE',
                            'PURCHASE',
                            'CREDIT_NOTE',
                            'DEBIT_NOTE'
    );
-- ac_txn text related changes
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_oid text;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_oid text;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID STARTS' as msg;
UPDATE ac_txn b SET account_oid = a.id, account_type_oid = a.account_type_id FROM account a WHERE a.old_id = b.account_id;
select now() as time, 'OID_CHANGES FOR AC_TXN ACCOUNT_TYPE_ID AND ACCOUNT_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID STARTS' as msg;
UPDATE ac_txn b SET alt_account_oid = a.id FROM account a WHERE a.old_id = b.alt_account_id;
select now() as time, 'OID_CHANGES FOR AC_TXN ALT_ACCOUNT_ID ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN VOUCHER_ID, voucher_type_oid, branch_oid STARTS' as msg;
UPDATE ac_txn b SET voucher_oid = a.oid_id, voucher_type_oid = a.voucher_type_oid, branch_oid = a.branch_oid  FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR AC_TXN VOUCHER_ID, voucher_type_oid, branch_oid ENDS' as msg;
--##
select now() as time, 'OID_CHANGES FOR AC_TXN BRANCH_ID STARTS' as msg;
create index on ac_txn (branch_id, branch_oid);
UPDATE ac_txn b SET branch_oid = a.id FROM branch a WHERE a.old_id = b.branch_id and branch_oid is null;
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
    add if not exists division_oid            text,
    add if not exists udf_reminder_date        date,
    add if not exists udf_drug_classifications text[];
--##
select now() as time, 'inv_txn set udf_reminder_date from sale_bill STARTS' as msg;
update inv_txn t
set udf_reminder_date = i.date + i.reminder_days
from sale_bill i
    where i.voucher_id = t.voucher_id
    and i.reminder_days is not null;
select now() as time, 'inv_txn set udf_reminder_date from sale_bill ENDS' as msg;
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
    vendor_oid                  = b.vendor_id,
    inventory_oid               = b.inventory_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from credit_note_inv_item i
         left join batch b on b.old_id = i.batch_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
where t.id = i.id;
select now() as time, 'inv_txn set data from credit_note_inv_item END' as msg;
--##
select now() as time, 'inv_txn set customer from credit_note STARTS' as msg;
UPDATE inv_txn t
SET customer_id = a.id
FROM credit_note b
LEFT JOIN account a ON a.old_id = b.customer_id
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
    inventory_oid               = b.inventory_id,
    vendor_oid                  = b.vendor_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from debit_note_inv_item i
         left join batch b on b.old_id = i.batch_id
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
    vendor_oid                  = b.vendor_id,
    inventory_oid               = b.inventory_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from personal_use_purchase_inv_item i
         left join batch b on b.old_id = i.batch_id
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
    inventory_oid               = b.inventory_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id,
    free_qty                    = i.free_qty,
    batch_no                    = b.batch_no,
    vendor_oid                  = b.vendor_id,
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
    sales_person_id             = sp.id,
    batch_no                    = b.batch_no,
    vendor_oid                  = b.vendor_id,
    inventory_oid               = b.inventory_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    manufacturer_id             = b.manufacturer_id
from sale_bill_inv_item i
    left join batch b on b.old_id = i.batch_id
    left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else b.inv_retail_qty end
    left join sales_person sp on sp.old_id = i.s_inc_id
where t.id = i.id;
--##
--/*
select now() as time, 'inv_txn set drug_classifications from sale_bill_inv_item start' as msg;
WITH a AS (
    SELECT drug_classifications, id
    FROM sale_bill_inv_item
    WHERE date > '2026-02-01'
      AND array_length(drug_classifications, 1) > 0
)
UPDATE inv_txn t
SET udf_drug_classifications = (
        SELECT array_agg(d.id)
        FROM udm_drug_classification d
        WHERE d.old_id = ANY(a.drug_classifications)
    )
FROM a
WHERE t.id = a.id;
select now() as time, 'inv_txn set drug_classifications from sale_bill_inv_item end' as msg;
--*/
--##
select now() as time, 'inv_txn set data from sale_bill_inv_item end' as msg;
--##
select now() as time, 'inv_txn set customer from sale_bill start' as msg;
update inv_txn t
set customer_id   = cid.id
from sale_bill b
    left join account cid on cid.old_id = b.customer_id
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
--##
select now() as time, 'inv_txn set customer from sale_bill end' as msg;
--##
select now() as time, 'inv_txn set data from stock_journal_inv_item start' as msg;
create index on batch (old_id);
update inv_txn t
set sno                         = i.sno,
    qty                         = i.qty,
    rate                        = i.rate,
    unit_id                     = uc.conversion_unit_id,
    unit_conv                   = case when i.is_retail_qty then 1 else b.inv_retail_qty end,
    barcode                     = i.barcode,
    asset_amount                = i.asset_amount,
    batch_no                    = b.batch_no,
    vendor_oid                  = b.vendor_id,
    s_rate                      = b.s_rate,
    mrp                         = b.mrp,
    expiry                      = b.expiry,
    nlc                         = b.nlc,
    landing_cost                = b.landing_cost,
    cost                        = b.cost,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
    inventory_oid               = b.inventory_id,
    manufacturer_id             = b.manufacturer_id
from stock_journal_inv_item i
         left join batch b on b.old_id = i.batch_id or b.txn_id = i.id
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
    vendor_oid                  = b.vendor_id,
    s_rate                      = b.s_rate,
    mrp                         = b.mrp,
    expiry                      = b.expiry,
    nlc                         = b.nlc,
    landing_cost                = b.landing_cost,
    cost                        = b.cost,
    inventory_oid               = b.inventory_id,
    section_id                  = b.section_id,
    category_id                 = b.category_id,
    sub_category_id             = b.sub_category_id,
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
UPDATE inv_txn b SET branch_oid = a.id FROM branch a WHERE a.old_id = b.branch_id;
select now() as time, 'OID_CHANGES FOR INV_TXN BRANCH_ID ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN VOUCHER_ID, voucher_type_oid STARTS' as msg;
create index on inv_txn (voucher_id);
UPDATE inv_txn b SET voucher_oid = a.oid_id, voucher_type_oid = a.voucher_type_oid FROM voucher a WHERE a.id = b.voucher_id;
select now() as time, 'OID_CHANGES FOR INV_TXN VOUCHER_ID, voucher_type_oid ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN WAREHOUSE_ID STARTS' as msg;
create index on inv_txn (warehouse_id);
UPDATE inv_txn b SET warehouse_oid = a.id FROM warehouse a WHERE a.old_id = b.warehouse_id;
select now() as time, 'OID_CHANGES FOR INV_TXN WAREHOUSE_ID ENDS' as msg;
------------------
select now() as time, 'OID_CHANGES FOR INV_TXN DIVISION_ID STARTS' as msg;
create index on inv_txn (division_id);
UPDATE inv_txn b SET division_oid = a.id FROM division a WHERE a.old_id = b.division_id;
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
    UPDATE bill_allocation b SET account_oid = a.id, account_type_oid = a.account_type_id FROM account a WHERE a.old_id = b.account_id;
    UPDATE bill_allocation b SET branch_oid = a.id FROM branch a WHERE a.old_id = b.branch_id;
    UPDATE bill_allocation b SET voucher_oid = a.oid_id FROM voucher a WHERE a.id = b.voucher_id;
    UPDATE bill_allocation b SET ac_txn_oid = a.oid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
select now() as time, 'OID_CHANGES FOR BILL_ALLOCATION STARTS' as msg;
--## BILL_ALLOCATION
---------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN, EXPRESSION, DEFAULT
-------------------------------------------------------------------------------------------------
select now() as time, 'DROPPING UNWANTED COLUMN & TABLE START' as msg;
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
-- BILL_ALLOCATION --
    alter table bill_allocation drop column if exists base_account_types;
    -- alter table bill_allocation drop column if exists pending;  -- check_again
    alter table bill_allocation drop column if exists old_ref_no;
    alter table bill_allocation drop column if exists is_approved;
    alter table bill_allocation drop column if exists account_type_name;
    alter table bill_allocation drop column if exists bill_date;
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
    alter table inv_txn drop if exists batch_id; -- check_again
--     alter table inv_txn alter column batch_id drop not null;
    alter table inv_txn drop if exists dummy;
-- VOUCHER --
    alter table voucher drop column if exists branch_gst;
    alter table voucher drop column if exists party_gst;
    alter table voucher drop column if exists party_id;
    alter table voucher drop column if exists pos_counter_code;
    alter table voucher drop column if exists approval_state;
    alter table voucher drop column if exists require_no_of_approval;
    alter table voucher drop column if exists pos_counter_session_id;
    alter table voucher drop column if exists session;
    alter table voucher drop column if exists pos_counter_settlement_id;
--DROP OR MODIFY TABLE--
    drop table if exists credit_note;
    drop table if exists debit_note;
    drop table if exists debit_note_inv_item;
    drop table if exists purchase_bill;
    drop table if exists purchase_bill_inv_item;
    drop table if exists sale_bill;
    drop table if exists sale_bill_inv_item;
    drop table if exists sale_quotation;
    drop table if exists goods_inward_note;
    drop table if exists gst_txn;
    drop table if exists inventory_opening;
    drop table if exists personal_use_purchase_inv_item;
    drop table if exists personal_use_purchase;
    drop table if exists stock_journal;
    drop table if exists stock_journal_inv_item;

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN AND RENAME THE REQUIRED ONE
-------------------------------------------------------------------------------------------------
select now() as time, 'RENAMING AND DROPPING UUID COLUMN START' as msg;
-- ACCOUNT
    alter table account drop column if exists old_id;
        --
        alter table ac_txn drop column if exists account_id;
        alter table ac_txn rename column account_oid to account_id;
        alter table ac_txn alter column account_id set not null;
        --
        alter table ac_txn drop column if exists alt_account_id;
        alter table ac_txn rename column alt_account_oid to alt_account_id;
        --
        alter table bank_txn drop column if exists account_id;
        alter table bank_txn rename column account_oid to account_id;
        alter table bank_txn alter column account_id set not null;
        --
        alter table bank_txn drop column if exists alt_account_id;
        alter table bank_txn rename column alt_account_oid to alt_account_id;
        --
        alter table bill_allocation drop column if exists account_id;
        alter table bill_allocation rename column account_oid to account_id;
        alter table bill_allocation alter column account_id set not null;
        --
        alter table inv_txn drop column if exists vendor_id;
        alter table inv_txn rename column vendor_oid to vendor_id;
        --
-- ACCOUNT_TYPE
        --
        alter table ac_txn drop column if exists account_type_id;
        alter table ac_txn rename column account_type_oid to account_type_id;
        alter table ac_txn alter column account_type_id set not null;
        --
        alter table bill_allocation drop column if exists account_type_id;
        alter table bill_allocation rename column account_type_oid to account_type_id;
        alter table bill_allocation alter column account_type_id set not null;
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
-- BRANCH
    alter table branch drop column if exists old_id;
        --
        alter table ac_txn drop column if exists branch_id;
        alter table ac_txn rename column branch_oid to branch_id;
        alter table ac_txn alter column branch_id set not null;
        --
        alter table bank_txn drop column if exists branch_id;
        alter table bank_txn rename column branch_oid to branch_id;
        alter table bank_txn alter column branch_id set not null;
        --
        alter table bill_allocation drop column if exists branch_id;
        alter table bill_allocation rename column branch_oid to branch_id;
        alter table bill_allocation alter column branch_id set not null;
        --
        alter table inv_txn drop column if exists branch_id;
        alter table inv_txn rename column branch_oid to branch_id;
        alter table inv_txn alter column branch_id set not null;
        --
        alter table voucher drop column if exists branch_id;
        alter table voucher rename column branch_oid to branch_id;
        alter table voucher alter column branch_id set not null;
        --
-- DIVISION
    alter table division drop column if exists old_id;
        --
        alter table inv_txn drop column if exists division_id;
        alter table inv_txn rename column division_oid to division_id;
        alter table inv_txn alter column division_id set not null;
        --
-- INVENTORY
        --
        alter table inv_txn drop column if exists inventory_id;
        alter table inv_txn rename column inventory_oid to inventory_id;
        alter table inv_txn alter column inventory_id set not null;
        --
-- SALES_PERSON
    --
    alter table sales_person drop column if exists old_id;
    --
-- UNIT
    --
    alter table inv_txn alter column unit_id set not null;
    --
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
        alter table bill_allocation drop column if exists voucher_id;
        alter table bill_allocation rename column voucher_oid to voucher_id;
        --
        alter table inv_txn drop column if exists voucher_id;
        alter table inv_txn rename column voucher_oid to voucher_id;
        --
-- VOUCHER_TYPE
    alter table voucher_type drop column if exists old_id;
        --
        alter table ac_txn drop column if exists voucher_type_id;
        alter table ac_txn rename column voucher_type_oid to voucher_type_id;
        --
        alter table inv_txn drop column if exists voucher_type_id;
        alter table inv_txn rename column voucher_type_oid to voucher_type_id;
         --
        alter table voucher drop column if exists voucher_type_id;
        alter table voucher rename column voucher_type_oid to voucher_type_id;
        alter table voucher alter column voucher_type_id set not null;
-- WAREHOUSE
    alter table warehouse drop column if exists old_id;
        --
        alter table inv_txn drop column if exists warehouse_id;
        alter table inv_txn rename column warehouse_oid to warehouse_id;
        alter table inv_txn alter column warehouse_id set not null;
        --
-- BATCH
    --
    alter table batch drop column if exists old_id; -- check_again
    alter table batch drop column if exists txn_id;
    alter table batch drop column if exists inv_retail_qty;
    --
-- UDM_DOCTOR
    --
    alter table udm_doctor drop column if exists old_id;
    --
-- UDM_POS_SESSION
    --
    alter table udm_pos_session drop column if exists old_id;
    --
-- UDM_POS_COUNTER_SETTLEMENT
    --
    alter table udm_pos_counter_settlement drop column if exists old_id;
    --
-- UDM_DRUG_CLASSIFICATION
    --
    alter table udm_drug_classification drop column if exists old_id;
    --
select now() as time, 'RENAMING AND DROPPING UUID COLUMN END' as msg;

delete from unit_conversion where conversion = 1;

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

select now() as time, 'PART - II - MIGRATION END' as msg;