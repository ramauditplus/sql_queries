ALTER TABLE account_type
    ADD COLUMN IF NOT EXISTS at_id uuid DEFAULT uuidv7();
--##
UPDATE account_type
SET at_id = uuidv7()
WHERE at_id IS NULL;
--##
ALTER TABLE ac_txn
    ADD COLUMN IF NOT EXISTS ac_txn_at_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET ac_txn_at_id = a.at_id
            FROM account_type a
            WHERE a.id = i.account_type_id
              AND a.at_id IS NOT NULL
              AND i.ac_txn_at_id IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE ac_txn_at_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM ac_txn
            WHERE ac_txn_at_id IS NULL;

            RAISE NOTICE 'ac_txn.account_type_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--##
ALTER TABLE account
    ADD COLUMN IF NOT EXISTS account_at_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE account i
            SET account_at_id = a.at_id
            FROM account_type a
            WHERE a.id = i.account_type_id
              AND a.at_id IS NOT NULL
              AND i.account_at_id IS NULL
              AND i.id IN (SELECT id
                           FROM account
                           WHERE account_at_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM account
            WHERE account_at_id IS NULL;

            RAISE NOTICE 'account.account_type_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--##
ALTER TABLE bill_allocation
    ADD COLUMN IF NOT EXISTS bill_allocation_at_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE bill_allocation i
            SET bill_allocation_at_id = a.at_id
            FROM account_type a
            WHERE a.id = i.account_type_id
              AND a.at_id IS NOT NULL
              AND i.bill_allocation_at_id IS NULL
              AND i.id IN (SELECT id
                           FROM bill_allocation
                           WHERE bill_allocation_at_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM bill_allocation
            WHERE bill_allocation_at_id IS NULL;

            RAISE NOTICE 'bill_allocation.account_type_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;


-- SELECT COUNT(*)
-- FROM table_name
-- WHERE new_uuid_column IS NULL
--   AND old_id_column IS NOT NULL;
