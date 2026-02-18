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
        "cost"::numeric AS "rate",
        "asset_amount"::numeric AS "taxable_amount",
        NULL::numeric AS "igst_amount",
        NULL::numeric AS "sgst_amount",
        NULL::numeric AS "cgst_amount",
        NULL::numeric AS "cess_amount",
        NULL::text AS "gst_tax"
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

    CAST(ROUND(
        COALESCE("taxable_amount", 0)::numeric +
        COALESCE("igst_amount", 0)::numeric +
        COALESCE("cgst_amount", 0)::numeric +
        COALESCE("sgst_amount", 0)::numeric +
        COALESCE("cess_amount", 0)::numeric
    , 2) AS float) AS "total_item_value",

    CASE
        WHEN "item"."gst_tax" IN ('gstexempt', 'gstngs', 'gstna') THEN 0
        ELSE REPLACE(REPLACE("item"."gst_tax", 'gst', ''), 'p', '.')::float
    END AS "gst_rate",

    "uqc" AS "qty_unit"

FROM "item"
LEFT JOIN "inventory" ON "inventory"."id" = "item"."inventory_id"
LEFT JOIN "unit" ON "unit"."id" = "item"."unit_id"
WHERE "voucher_id" = 437082;
