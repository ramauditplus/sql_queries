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
            SET inventory_uuid = a.uuid_id
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
--##
--     UPDATE batch b
-- SET
--     unit_uuid = CASE
--                     WHEN b.is_retail_qty
--                         THEN a.primary_unit_id
--                     ELSE a.conversion_unit_id
--                 END,
--     unit_conv = CASE
--                     WHEN b.is_retail_qty
--                         THEN 1
--                     ELSE inv.retail_qty
--                 END,
--     section_id = inv.section_id,
--     manufacturer_id = inv.manufacturer_id
-- FROM inventory inv
-- LEFT JOIN unit_conversion a
--       ON a.primary_unit_id = inv.unit_uuid;
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
-- voucher uuid related changes
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS customer_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS udf_alt_branch_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS udf_transfer_voucher_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS udf_alt_warehouse_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS udf_doctor_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE voucher ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER VENDOR_ID STARTS' as msg;
create index on voucher (vendor_id, vendor_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET vendor_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.vendor_id
              AND i.vendor_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE vendor_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where vendor_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER VENDOR_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER CUSTOMER_ID STARTS' as msg;
create index on voucher (customer_id, customer_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET customer_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.customer_id
              AND i.customer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE customer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where customer_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER CUSTOMER_ID ENDS' as msg;
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
UPDATE voucher b SET udf_alt_branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.udf_alt_branch_id;
------------------
UPDATE voucher b SET udf_transfer_voucher_uuid = a.session FROM voucher a WHERE a.id = b.udf_transfer_voucher_id;
------------------
UPDATE voucher b SET udf_alt_warehouse_uuid = a.uuid_id FROM warehouse a WHERE a.id = b.udf_alt_warehouse_id;
------------------
UPDATE voucher b SET udf_doctor_uuid = a.uuid_id FROM udm_doctor a WHERE a.id = b.udf_doctor_id;
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER SALES_PERSON_ID STARTS' as msg;
create index on voucher (sales_person_id, sales_person_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET sales_person_uuid = a.uuid_id
            FROM sales_person a
            WHERE a.id = i.sales_person_id
              AND i.sales_person_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE sales_person_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where sales_person_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER SALES_PERSON_ID ENDS' as msg;
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER VOUCHER_TYPE_ID STARTS' as msg;
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
------------------
select now() as time, 'UUID_CHANGES FOR VOUCHER WAREHOUSE_ID STARTS' as msg;
create index on voucher (warehouse_id, warehouse_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET warehouse_uuid = a.uuid_id
            FROM warehouse a
            WHERE a.id = i.warehouse_id
              AND i.warehouse_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE warehouse_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from voucher
            where warehouse_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
select now() as time, 'UUID_CHANGES FOR VOUCHER WAREHOUSE_ID ENDS' as msg;
select now() as time, 'UUID_CHANGES FOR VOUCHER ENDS' as msg;
------------------
--## VOUCHER