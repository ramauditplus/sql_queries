ALTER TABLE account
    ADD COLUMN IF NOT EXISTS acc_id uuid DEFAULT uuidv7();
--##
UPDATE account
SET acc_id = uuidv7()
WHERE acc_id IS NULL;
--## ac_txn -- account_id
ALTER TABLE ac_txn
    ADD COLUMN IF NOT EXISTS ac_txn_acc_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET ac_txn_acc_id = a.acc_id
            FROM account a
            WHERE a.id = i.account_id
              AND a.acc_id IS NOT NULL
              AND i.ac_txn_acc_id IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE ac_txn_acc_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM ac_txn
            WHERE ac_txn_acc_id IS NULL;

            RAISE NOTICE 'ac_txn.account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## ac_txn -- alt_account_id
ALTER TABLE ac_txn
    ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET alt_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.alt_account_id
              AND a.acc_id IS NOT NULL
              AND i.alt_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE alt_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM ac_txn
            WHERE alt_account_uuid IS NULL;

            RAISE NOTICE 'ac_txn.alt_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## branch -- account_id
ALTER TABLE branch
    ADD COLUMN IF NOT EXISTS account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE branch i
            SET account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.account_id
              AND a.acc_id IS NOT NULL
              AND i.account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM branch
                           WHERE account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM branch
            WHERE account_uuid IS NULL;

            RAISE NOTICE 'branch.account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## voucher -- vendor_id
ALTER TABLE voucher
    ADD COLUMN IF NOT EXISTS vendor_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET vendor_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.vendor_id
              AND a.acc_id IS NOT NULL
              AND i.vendor_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE vendor_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM voucher
            WHERE vendor_uuid IS NULL;

            RAISE NOTICE 'voucher.vendor_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## voucher -- customer_id
ALTER TABLE voucher
    ADD COLUMN IF NOT EXISTS customer_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE voucher i
            SET customer_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.customer_id
              AND a.acc_id IS NOT NULL
              AND i.customer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM voucher
                           WHERE customer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM voucher
            WHERE customer_uuid IS NULL;

            RAISE NOTICE 'voucher.customer_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## bank_txn -- alt_account_id
ALTER TABLE bank_txn
    ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE bank_txn i
            SET alt_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.alt_account_id
              AND a.acc_id IS NOT NULL
              AND i.alt_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM bank_txn
                           WHERE alt_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM bank_txn
            WHERE alt_account_uuid IS NULL;

            RAISE NOTICE 'bank_txn.alt_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## inventory -- sale_account_id
ALTER TABLE inventory
    ADD COLUMN IF NOT EXISTS sale_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inventory i
            SET sale_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.sale_account_id
              AND a.acc_id IS NOT NULL
              AND i.sale_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inventory
                           WHERE sale_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM inventory
            WHERE sale_account_uuid IS NULL;

            RAISE NOTICE 'inventory.sale_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## inventory -- purchase_account_id
ALTER TABLE inventory
    ADD COLUMN IF NOT EXISTS purchase_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inventory i
            SET purchase_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.purchase_account_id
              AND a.acc_id IS NOT NULL
              AND i.purchase_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inventory
                           WHERE purchase_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM inventory
            WHERE purchase_account_uuid IS NULL;

            RAISE NOTICE 'inventory.purchase_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## inv_txn -- customer_id
ALTER TABLE inv_txn
    ADD COLUMN IF NOT EXISTS customer_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET customer_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.customer_id
              AND a.acc_id IS NOT NULL
              AND i.customer_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE customer_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM inv_txn
            WHERE customer_uuid IS NULL;

            RAISE NOTICE 'inv_txn.customer_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## inv_txn -- vendor_id
ALTER TABLE inv_txn
    ADD COLUMN IF NOT EXISTS vendor_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE inv_txn i
            SET vendor_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.vendor_id
              AND a.acc_id IS NOT NULL
              AND i.vendor_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM inv_txn
                           WHERE vendor_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM inv_txn
            WHERE vendor_uuid IS NULL;

            RAISE NOTICE 'inv_txn.vendor_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
## tds_nature_of_payment -- tds_account_id
ALTER TABLE tds_nature_of_payment
    ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE tds_nature_of_payment i
            SET tds_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.tds_account_id
              AND a.acc_id IS NOT NULL
              AND i.tds_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM tds_nature_of_payment
                           WHERE tds_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM tds_nature_of_payment
            WHERE tds_account_uuid IS NULL;

            RAISE NOTICE 'tds_nature_of_payment Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## tds_on_voucher -- party_account_id
ALTER TABLE tds_on_voucher
    ADD COLUMN IF NOT EXISTS party_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE tds_on_voucher i
            SET party_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.party_account_id
              AND a.acc_id IS NOT NULL
              AND i.party_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM tds_on_voucher
                           WHERE party_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM tds_on_voucher
            WHERE party_account_uuid IS NULL;

            RAISE NOTICE 'tds_on_voucher.party_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--## tds_on_voucher -- tds_account_id
ALTER TABLE tds_on_voucher
    ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE tds_on_voucher i
            SET tds_account_uuid = a.acc_id
            FROM account a
            WHERE a.id = i.tds_account_id
              AND a.acc_id IS NOT NULL
              AND i.tds_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM tds_on_voucher
                           WHERE tds_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM tds_on_voucher
            WHERE tds_account_uuid IS NULL;

            RAISE NOTICE 'tds_on_voucher.tds_account_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;


-- SELECT COUNT(*)
-- FROM table_name
-- WHERE new_uuid_column IS NULL
--   AND old_id_column IS NOT NULL;
