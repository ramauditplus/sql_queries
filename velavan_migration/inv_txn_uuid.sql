--## INV_TXN
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS customer_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS section_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS unit_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS udf_drug_classifications_uuid uuid[];
------------------
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
------------------
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
create index on inv_txn (manufacturer_id, manufacturer_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET manufacturer_uuid = a.uuid_id
            FROM manufacturer a
            WHERE a.id = i.manufacturer_id
              AND a.uuid_id IS NOT NULL
              AND i.manufacturer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE manufacturer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where manufacturer_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
create index on inv_txn (section_id, section_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET section_uuid = a.uuid_id
            FROM section a
            WHERE a.id = i.section_id
              AND a.uuid_id IS NOT NULL
              AND i.section_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE inv_txn.section_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where inv_txn.section_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on inv_txn (unit_id, unit_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET unit_uuid = a.uuid_id
            FROM unit a
            WHERE a.id = i.unit_id
              AND a.uuid_id IS NOT NULL
              AND i.unit_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE unit_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from inv_txn
            where unit_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
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
              AND a.uuid_id IS NOT NULL
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
------------------
UPDATE inv_txn t
        SET udf_drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.udf_drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.udf_drug_classifications IS NOT NULL;
------------------
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
--## INV_TXN