WITH "cte" AS (SELECT "inventory"."name"                            AS "name",
                      sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing",
                      "inventory"."id"                              AS "id"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
                        LEFT JOIN "inventory" ON "inventory"."id" = "batch"."inventory_id"
               WHERE "batch"."inventory_id" IN (1, 2, 3)
                 AND "batch"."manufacturer_id" IN (1, 2, 3)
                 AND "batch"."vendor_id" IN (1, 2, 3)
                 AND "batch"."warehouse_id" IN (5, 6, 7)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", "inventory"."id", "inventory"."name")
SELECT sum("cte"."closing") AS "closing", min("cte"."name") AS "name", "cte"."id" AS "id"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;