SELECT
    "batch"."batch_no",
    "batch"."nlc",
    "batch"."closing",
    "batch"."retail_qty",
    "batch"."expiry",
    "batch"."inventory_id",
    "batch"."inventory_name",
    "batch"."branch_name",
    "batch"."manufacturer_name",
    "batch"."division_name",
    ("closing" / "retail_qty") * "nlc" AS "value"
FROM "batch"
WHERE
    "batch"."closing" > 0
  AND "batch"."expiry" >= '2024-02-10'
  AND "batch"."expiry" <= '2025-03-10'
  AND TRUE LIMIT 25 OFFSET 0;