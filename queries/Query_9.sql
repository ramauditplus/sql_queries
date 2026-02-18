SELECT DISTINCT ON ("branch_id", "inventory_id")
    "batch"."branch_id",
    "batch"."branch_name",
    "batch"."inventory_id",
    "batch"."inventory_name",
    "batch"."vendor_id",
    "batch"."vendor_name",
    "batch"."entry_date",
    "batch"."cost",
    "batch"."nlc",
    "batch"."p_rate",
    "batch"."s_rate",
    "batch"."mrp",
    "batch"."voucher_no",
    "batch"."inventory_voucher_id"
FROM "batch"
WHERE "batch"."vendor_id" IS NOT NULL
ORDER BY
        "batch"."branch_id" ASC,
        "batch"."inventory_id" ASC,
        "batch"."cost" ASC NULLS LAST,
        "batch"."cost" ASC,
        "batch"."entry_date" DESC;

select * from pos_server;

SELECT DISTINCT ON ("branch_id", "inventory_id") "batch"."branch_id", "batch"."branch_name", "batch"."inventory_id", "batch"."inventory_name", "batch"."vendor_id", "batch"."vendor_name", "batch"."entry_date", "batch"."cost", "batch"."nlc", "batch"."p_rate", "batch"."s_rate", "batch"."mrp", "batch"."voucher_no", "batch"."inventory_voucher_id" FROM "batch" WHERE "batch"."vendor_id" IS NOT NULL ORDER BY "batch"."branch_id" ASC, "batch"."inventory_id" ASC, "batch"."cost" ASC NULLS LAST, "batch"."cost" ASC, "batch"."entry_date" DESC;