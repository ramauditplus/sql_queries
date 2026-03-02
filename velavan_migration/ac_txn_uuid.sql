--## AC_TXN
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
------------------
CREATE INDEX ON ac_txn (account_type_id);
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 1 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 2 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 3 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 4 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 5 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 6 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 7 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 8 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 9 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 10 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 11 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 12 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 13 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 14 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 15 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 16 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 17 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 18 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 19 AND a.transaction_enabled;
    UPDATE ac_txn b SET account_uuid = a.uuid_id, account_type_uuid = a.account_type_uuid FROM account a WHERE a.id = b.account_id AND a.id = 20 AND a.transaction_enabled;
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
            SET account_uuid = a.uuid_id
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
------------------
create index on ac_txn (account_type_id, account_type_uuid, id);
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET account_type_uuid = a.uuid_id
            FROM account_type a
            WHERE a.id = i.account_type_id
              AND a.uuid_id IS NOT NULL
              AND i.account_type_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE account_type_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where account_type_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
------------------
create index on ac_txn(alt_account_id);
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 1 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 2 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 3 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 4 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 5 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 6 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 7 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 8 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 9 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 10 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 11 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 12 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 13 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 14 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 15 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 16 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 17 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 18 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 19 AND a.transaction_enabled;
        UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id AND a.id = 20 AND a.transaction_enabled;
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
------------------
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
------------------
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
------------------
CREATE INDEX ON ac_txn (voucher_type_id);
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 1;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 2;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 3;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 4;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 5;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 6;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 7;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 8;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 9;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 10;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 17;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 21;
    UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id AND a.id = 23;
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
------------------
--## AC_TXN