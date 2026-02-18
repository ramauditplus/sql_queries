SELECT
    "batch"."id",
    "batch"."entry_date",
    "batch"."closing",
    "batch"."branch_id",
    "batch"."branch_name",
    "batch"."inventory_id",
    "batch"."inventory_name",
    "batch"."unit_id",
    "batch"."unit_name",
    "batch"."unit_conv",
    "batch"."vendor_id",
    "batch"."batch_no",
    "batch"."mrp",
    "batch"."s_rate",
    "batch"."p_rate",
    "batch"."landing_cost",
    "batch"."retail_qty",
    "batch"."nlc",
    ("closing" / "retail_qty") * "nlc" AS "value"
FROM "batch"
WHERE
    "batch"."closing" < 0
  AND TRUE
LIMIT 100
    OFFSET 0