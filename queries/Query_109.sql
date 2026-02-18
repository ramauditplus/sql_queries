    WITH limited_vouchers AS (
        SELECT *
        FROM voucher v
        WHERE v.date BETWEEN '2024-05-01' AND '2024-05-31'
          AND v.base_voucher_type = 'SALE'
        ORDER BY v.created_at DESC
        LIMIT 1000
    )
    SELECT
        TO_CHAR(v.date::date, 'YYYYMMDD') AS date,
        TO_CHAR(v.eff_date::date, 'YYYYMMDD') AS bill_date,
        v.ref_no,
        v.voucher_no,
        v.base_voucher_type,
        v.description,
        v.rcm,
        v.lut,
        t.account_id,
        t.account_name,
        t.base_account_types,
        (t.credit - t.debit) AS amount
    FROM limited_vouchers v
    JOIN LATERAL (
        SELECT
            txn.base_voucher_type,
            txn.account_id,
            txn.account_name,
            txn.base_account_types,
            txn.credit,
            txn.debit
        FROM ac_txn txn
        WHERE txn.voucher_id = v.id
          AND NOT ('STOCK' = ANY(txn.base_account_types))
    ) t ON TRUE
    ORDER BY v.created_at;