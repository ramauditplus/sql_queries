--## VOUCHER
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
UPDATE voucher b SET udf_alt_branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.udf_alt_branch_id;
------------------
UPDATE voucher b SET udf_transfer_voucher_uuid = a.session FROM voucher a WHERE a.id = b.udf_transfer_voucher_id;
------------------
UPDATE voucher b SET udf_alt_warehouse_uuid = a.uuid_id FROM warehouse a WHERE a.id = b.udf_alt_warehouse_id;
------------------
UPDATE voucher b SET udf_doctor_uuid = a.uuid_id FROM udm_doctor a WHERE a.id = b.udf_doctor_id;
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
--## VOUCHER