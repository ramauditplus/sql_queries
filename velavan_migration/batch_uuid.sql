--## BATCH
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS section_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS unit_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE batch
    ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
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
              AND a.uuid_id IS NOT NULL
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
              AND a.uuid_id IS NOT NULL
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
              AND a.uuid_id IS NOT NULL
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
create index on batch (manufacturer_id, manufacturer_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET manufacturer_uuid = a.uuid_id
            FROM manufacturer a
            WHERE a.id = i.manufacturer_id
              AND a.uuid_id IS NOT NULL
              AND i.manufacturer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE manufacturer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where manufacturer_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on batch (section_id, section_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET section_uuid = a.uuid_id
            FROM section a
            WHERE a.id = i.section_id
              AND a.uuid_id IS NOT NULL
              AND i.section_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE section_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where batch.section_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on batch (unit_id, unit_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE batch i
            SET unit_uuid = a.uuid_id
            FROM unit a
            WHERE a.id = i.unit_id
              AND a.uuid_id IS NOT NULL
              AND i.unit_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM batch
                           WHERE unit_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from batch
            where unit_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
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
              AND a.uuid_id IS NOT NULL
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
--## BATCH