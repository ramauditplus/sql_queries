ALTER TABLE bank
    ADD COLUMN IF NOT EXISTS bk_id uuid DEFAULT uuidv7();
--##
UPDATE bank
SET bk_id = uuidv7()
WHERE bk_id IS NULL;
--##
ALTER TABLE account
    ADD COLUMN IF NOT EXISTS account_bk_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE account i
            SET account_bk_id = a.bk_id
            FROM bank a
            WHERE a.id = i.bank_id
              AND a.bk_id IS NOT NULL
              AND i.account_bk_id IS NULL
              AND i.id IN (SELECT id
                           FROM account
                           WHERE account_bk_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM account
            WHERE account_bk_id IS NULL;

            RAISE NOTICE 'account.bank_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
--##
ALTER TABLE bank_beneficiary
    ADD COLUMN IF NOT EXISTS bank_beneficiary_bk_id uuid;

DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE bank_beneficiary i
            SET bank_beneficiary_bk_id = a.bk_id
            FROM bank a
            WHERE a.id = i.bank_id
              AND a.bk_id IS NOT NULL
              AND i.bank_beneficiary_bk_id IS NULL
              AND i.id IN (SELECT id
                           FROM bank_beneficiary
                           WHERE bank_beneficiary_bk_id IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;

            SELECT COUNT(1)
            INTO v_remaining
            FROM bank_beneficiary
            WHERE bank_beneficiary_bk_id IS NULL;

            RAISE NOTICE 'bank_beneficiary.bank_id Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;

            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;


-- SELECT COUNT(*)
-- FROM table_name
-- WHERE new_uuid_column IS NULL
--   AND old_id_column IS NOT NULL;
