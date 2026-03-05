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
              AND a.uuid_id IS NOT NULL
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
    add if not exists section_id               uuid,
    add if not exists manufacturer_id          uuid,
    add if not exists vendor_uuid              uuid,
    add if not exists udf_drug_classifications int[];
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
update inv_txn t
set customer_id = b.customer_id
from credit_note b
where b.customer_id is not null
  and t.voucher_id = b.voucher_id;
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
    unit_id                  = uc.conversion_unit_id,
    unit_conv                = case when i.is_retail_qty then 1 else inv.retail_qty end,
    gst_tax                  = i.gst_tax,
    disc_mode1               = i.disc_mode,
    discount1                = i.discount,
    hsn_code                 = i.hsn_code,
    cess_on_qty              = i.cess_on_qty,
    cess_on_val              = i.cess_on_val,
    sales_person_id          = i.s_inc_id,
    udf_drug_classifications = i.drug_classifications,
    batch_no                 = b.batch_no,
    vendor_uuid      = b.vendor_uuid,
    section_id               = inv.section_id,
    manufacturer_id          = inv.manufacturer_id
from sale_bill_inv_item i
    left join inventory inv on inv.id = i.inventory_id
         left join unit_conversion uc on uc.conversion = case when i.is_retail_qty then 1 else inv.retail_qty end
         left join batch b on b.id = i.batch_id
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
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS customer_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS udf_drug_classifications_uuid uuid[];
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
select now() as time, 'UUID_CHANGES FOR INV_TXN CUSTOMER_ID STARTS' as msg;
create index on inv_txn (customer_id, customer_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET customer_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.customer_id
              AND i.customer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE customer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where customer_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN CUSTOMER_ID ENDS' as msg;
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
select now() as time, 'UUID_CHANGES FOR INV_TXN SALES_PERSON_ID STARTS' as msg;
create index on inv_txn (sales_person_id, sales_person_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET sales_person_uuid = a.uuid_id
            FROM sales_person a
            WHERE a.id = i.sales_person_id
              AND i.sales_person_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE sales_person_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where sales_person_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR INV_TXN SALES_PERSON_ID ENDS' as msg;
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
select now() as time, 'UUID_CHANGES FOR INV_TXN DRUG_CLASSIFICATION_ID STARTS' as msg;
UPDATE inv_txn t
        SET udf_drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.udf_drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.udf_drug_classifications IS NOT NULL;
select now() as time, 'UUID_CHANGES FOR INV_TXN DRUG_CLASSIFICATION_ID ENDS' as msg;
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