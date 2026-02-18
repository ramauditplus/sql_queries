select * from gst_txn;
select * from gst_registration;
--##"eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSIsImtpZCI6IjMwNGZmM2UwLTAJjMi1iODNkLTQ4ZTgtYjk0Ny1hOWRhM2ViZDJjNzkiLCJzZXNzaW9uX2tleSI6IkhkQUNueDNCS1ZFeWJTU1lCUWlfaVVJS0JyV2paVzY5azl1NVNVcDRqczNRMFlzTSIsInNlcmlhbF9ubyI6NzQxMTA5NTUsInNlcmlhbF9rZXkiOiJNM0RVS1JOSUIwTEZJUEZQVzdOMUNLTUoiLCJicmFuY2hfbGltaXQiOjMwLCJ2b3VjaGVyX2xpbWl0IjoxMDAwMDAwMCwicG9zX2NvdW50ZXJfbGltaXQiOjEwMCwiaXNfYWN0aXZlIjp0cnVlLCJpc3UiOjE3NTM5NDAwNDMsImV4cCI6MTc1NTY2ODA0MywiY3JlYXRlZF9hdCI6IjIwMjUtMDctMjRUMTE6NTc6MzguOTIwNDM0IiwidXBkYXRlZF9hdCI6IjIwMjUtMDctMjRUMTI6MTk6MTIuMTg3MzI5OTAwIn0".TGR6YXer8XzosaBY7e3VzQGxhymupIgPBeVwuykdgspFfx55SM0fDWDu0o8_MEw8lX5bT3sAVFMFr-drTNMnDw

select * from gst_registration;
select * from branch;

select id, voucher_no, e_invoice_details, eway_bill_details from voucher order by created_at desc;

--##0cb66738593a4ffa8d3c9ee9d1eb22cb
select * from voucher where voucher_no = 'BN25266277';

select * from branch where id = 9;

select * from voucher where id = 437076;

alter table stock_deduction_inv_item
    rename stock_deduction_id to voucher_id;
--##

select * from voucher order by created_at desc;

WITH "item" AS (
    SELECT
        "voucher_id",
        "inventory_id",
        "unit_id",
        "qty",
        "rate",
        "taxable_amount",
        "igst_amount",
        "sgst_amount",
        "cgst_amount",
        "cess_amount",
        "gst_tax"
    FROM "sale_bill_inv_item"

    UNION ALL

    SELECT
        "voucher_id",
        "inventory_id",
        "unit_id",
        "qty",
        "rate",
        "taxable_amount",
        "igst_amount",
        "sgst_amount",
        "cgst_amount",
        "cess_amount",
        "gst_tax"
    FROM "credit_note_inv_item"

    UNION ALL

    SELECT
        "voucher_id",
        "inventory_id",
        "unit_id",
        "qty",
        "rate",
        "taxable_amount",
        "igst_amount",
        "sgst_amount",
        "cgst_amount",
        "cess_amount",
        "gst_tax"
    FROM "debit_note_inv_item"

    UNION ALL

    SELECT
        "voucher_id",
        "inventory_id",
        "unit_id",
        "qty",
        "cost" AS "rate",
        "asset_amount" AS "taxable_amount",
        NULL AS "igst_amount",
        NULL AS "sgst_amount",
        NULL AS "cgst_amount",
        NULL AS "cess_amount",
        NULL AS "gst_tax"
    FROM "stock_deduction_inv_item"
)

SELECT
    "inventory"."hsn_code" AS "hsn_code",
    "inventory"."name" AS "product_name",
    "taxable_amount",
    "cgst_amount",
    "sgst_amount",
    "igst_amount",
    "cess_amount",
    "qty" AS "quantity",
    "taxable_amount" AS "total_amount",
    CAST(
        ROUND(
            CAST(
                ("taxable_amount" + "igst_amount" + "cgst_amount" + "sgst_amount" + "cess_amount") AS numeric
            ),
            2
        ) AS float
    ) AS "total_item_value",
    (
        CASE
            WHEN ("item"."gst_tax" IN ('gstexempt', 'gstngs', 'gstna'))
                THEN 0
            ELSE REPLACE(REPLACE(item.gst_tax, 'gst', ''), 'p', '.')::float
        END
    ) AS "gst_rate",
    "uqc" AS "qty_unit"
FROM "item"
LEFT JOIN "inventory" ON "inventory"."id" = "item"."inventory_id"
LEFT JOIN "unit" ON "unit"."id" = "item"."unit_id"
WHERE "voucher_id" = 437069;
