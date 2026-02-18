WITH "cte_1" AS (SELECT "inventory"."name" AS "name", "inventory"."id" AS "id"
                 FROM "inventory"
                 WHERE "id" IN (1, 2, 3)),
     "cte" AS (SELECT "cte_1"."id"                                  AS "id",
                      "cte_1"."name"                                AS "name",
                      sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
                        LEFT JOIN "cte_1" ON "cte_1"."id" = "batch"."inventory_id"
               WHERE "batch"."inventory_id" IN (1, 2, 3)
                 AND "batch"."manufacturer_id" IN (1, 2, 3)
                 AND "batch"."vendor_id" IN (1, 2, 3)
                 AND "batch"."warehouse_id" IN (5, 6, 7)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", "cte_1"."id", "cte_1"."name")
SELECT "cte"."id" AS "id", min("cte"."name") AS "name", sum("cte"."closing") AS "closing"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;

WITH "cte" AS (SELECT sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing",
                      "inventory"."name"                            AS "name",
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
SELECT min("cte"."name") AS "name", "cte"."id" AS "id", sum("cte"."closing") AS "closing"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;

WITH "cte" AS (SELECT "inventory"."id"                              AS "id",
                      "inventory"."name"                            AS "name",
                      sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
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
               GROUP BY "batch"."id", "inventory"."id", "inventory"."name"
               HAVING CAST(round(CAST(sum("inv_txn"."inward" - "inv_txn"."outward") AS numeric), 4) AS float) <> 0)
SELECT "cte"."id" AS "id", min("cte"."name") AS "name", sum("cte"."closing") AS "closing"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;

SELECT sum("inward")                             AS "inward",
       CAST(DATE_TRUNC('month', "date") AS date) AS "particulars",
       sum("outward")                            AS "outward"
FROM "inv_txn"
WHERE "branch_id" IN (1)
  AND ("date" >= '2025-11-01' AND "date" <= '2025-12-31')
  AND "inventory_id" = 1
  AND "warehouse_id" IN (1)
GROUP BY "particulars"
ORDER BY "particulars" ASC