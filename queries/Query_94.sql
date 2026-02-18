WITH "item" AS (SELECT "voucher_id",
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
    FROM "stock_deduction_inv_item")
SELECT
    "inventory"."hsn_code" AS "hsn_code",
    "inventory"."name" AS "product_name",
    "stock_deduction_inv_item"."asset_amount" AS "taxable_amount",
    NULL AS "cgst_amount",
    NULL AS "sgst_amount",
    NULL AS "igst_amount",
    NULL AS "cess_amount",
    "stock_deduction_inv_item"."qty" AS "quantity",
    "stock_deduction_inv_item"."asset_amount" AS "total_amount",

    CAST(ROUND(CAST("stock_deduction_inv_item"."asset_amount" AS numeric), 2) AS float) AS "total_item_value",

    0 AS "gst_rate",  -- No GST applied for stock deduction items
    "unit"."uqc" AS "qty_unit"
FROM "stock_deduction_inv_item"
LEFT JOIN "inventory" ON "inventory"."id" = "stock_deduction_inv_item"."inventory_id"
LEFT JOIN "unit" ON "unit"."id" = "stock_deduction_inv_item"."unit_id"
WHERE "stock_deduction_inv_item"."voucher_id" = 437076;

alter table public.stock_deduction_inv_item
    add constraint stock_deduction_inv_item_voucher_id_fkey
        foreign key (voucher_id) references public.stock_deduction (voucher_id);

SELECT voucher_id, COUNT(*) AS occurrences
FROM stock_deduction
GROUP BY voucher_id
HAVING COUNT(*) > 1;