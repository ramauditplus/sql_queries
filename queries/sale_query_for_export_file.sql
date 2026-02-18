SELECT
    v.voucher_no,
    v.base_voucher_type,
    v.ref_no,
    TO_CHAR(v.date::date, 'YYYYMMDD') AS date,
    TO_CHAR(v.eff_date::date, 'YYYYMMDD') AS bill_date,
    --t.account::text,
    t.base_voucher_type,
    (t.credit - t.debit) AS amount,
    v.rcm,
    v.lut,
    v.description
FROM voucher v
JOIN LATERAL (
    SELECT
        --txn.acc,
        txn.base_voucher_type,
        txn.credit,
        txn.debit
    FROM ac_txn txn
    WHERE txn.voucher_id = v.id
      AND NOT ('STOCK' = ANY(txn.base_account_types)) AND v.base_voucher_type = 'SALE'
) t ON TRUE
WHERE v.date BETWEEN '2025-08-20' AND '2025-08-28' ORDER BY v.created_at DESC;
  --AND (
       --t.base_voucher_type in ('BANK_ACCOUNT','BANK_OD_ACCOUNT','EFT_ACCOUNT','TRADE_RECEIVABLE','ACCOUNT_RECEIVABLE', 'SALE')
      --OR v.party_gst_reg_type IN ('REGULAR','SPECIAL_ECONOMIC_ZONE','OVERSEAS','DEEMED_EXPORT')
  --) ORDER BY v.created_at desc;

-- sale_register_by_inventory -- for reference of sea_orm

select id, name, tally_name, account_type_id, account_type_name, base_account_types, contact_type from account_map order by id;

select id, name, tally_name, base_type from voucher_type_map order by id;