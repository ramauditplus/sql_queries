WITH "cte" AS (SELECT "batch"."vendor_id"                           AS "vendor_id",
                      "batch"."warehouse_id"                        AS "warehouse_id",
                      "batch"."inventory_id"                        AS "inventory_id",
                      "batch"."nlc"                                 AS "nlc",
                      "batch"."closing"                             AS "closing",
                      sum("inv_txn"."inward" - "inv_txn"."outward") AS "as_on_closing",
                      "batch"."branch_id"                           AS "branch_id",
                      "batch"."landing_cost"                        AS "landing_cost",
                      "batch"."manufacturer_id"                     AS "manufacturer_id",
                      "batch"."voucher_id"                          AS "voucher_id"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
               WHERE "batch"."inventory_id" IN (1, 2, 3)
                 AND "batch"."manufacturer_id" IN (1, 2, 3)
                 AND "batch"."vendor_id" IN (1, 2, 3)
                 AND "batch"."warehouse_id" IN (5, 6, 7)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id")
SELECT sum("cte"."as_on_closing" * "cte"."landing_cost") AS "landing_value",
       min("x"."name")                                   AS "name",
       "cte"."vendor_id"                                 AS "id"
FROM "cte"
         LEFT JOIN "account" AS "x" ON "cte"."vendor_id" = "x"."id"
WHERE "cte"."as_on_closing" <> 0
GROUP BY "vendor_id"
ORDER BY "id" ASC