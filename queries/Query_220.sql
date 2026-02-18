WITH "s1" AS (SELECT sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing",
                     "batch"."inventory_name"                      AS "name",
                     "batch"."inventory_id"                        AS "id"
              FROM "inv_txn"
                       LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                            "batch"."branch_id" = "inv_txn"."branch_id" AND
                                            "batch"."inventory_id" = "inv_txn"."inventory_id"
              GROUP BY "batch"."id", "batch".inventory_name, "batch".inventory_id)
SELECT min("s1"."name") AS "name", "s1"."id" AS "id", sum("s1"."closing") AS "closing"
FROM "s1"
GROUP BY "id"
ORDER BY "id" ASC;

WITH "s1" AS (SELECT "batch"."inventory_name"                      AS "name",
                     "batch"."inventory_id"                        AS "id",
                     sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
              FROM "inv_txn"
                       LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                            "batch"."branch_id" = "inv_txn"."branch_id" AND
                                            "batch"."inventory_id" = "inv_txn"."inventory_id"
              GROUP BY "batch"."id", "batch"."inventory_id", "batch"."inventory_name")
SELECT min("s1"."name") AS "name", sum("s1"."closing") AS "closing", "s1"."id" AS "id"
FROM "s1"
GROUP BY "id"
ORDER BY "id" ASC;
with "s1" as (select * from inventory),
     "cte" AS (SELECT s1.id as id, s1.name as name, sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
                        left join s1 on s1.id = batch.inventory_id
               WHERE "batch"."inventory_id" IN (1, 2, 3)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", s1.id, s1.name)
SELECT "cte"."id" AS "id", sum("cte"."closing") AS "closing", "cte".name as name
FROM "cte"
GROUP BY "id", name
ORDER BY "id" ASC;

WITH "cte" AS (SELECT "batch"."branch_id" AS "id", sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
               WHERE "batch"."inventory_id" IN (1, 2, 3)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", "batch"."branch_id")
SELECT sum("cte"."closing") AS "closing", "cte"."id" AS "id"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;

WITH "cte_1" AS (SELECT "inventory"."id" AS "id", "inventory"."name" AS "name"
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
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", "cte_1"."id", "cte_1"."name")
SELECT min("cte"."name") AS "name", sum("cte"."closing") AS "closing", "cte"."id" AS "id"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC;

WITH "cte_1" AS (SELECT "branch"."name" AS "name", "branch"."id" AS "id" FROM "branch" WHERE TRUE),
     "cte" AS (SELECT "cte_1"."id"                                  AS "id",
                      "cte_1"."name"                                AS "name",
                      sum("inv_txn"."inward" - "inv_txn"."outward") AS "closing"
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
                        LEFT JOIN "cte_1" ON "cte_1"."id" = "batch"."branch_id"
               WHERE "batch"."branch_id" IN (1, 2, 3)
                 AND ("inv_txn"."date" >= '2025-01-01' AND "inv_txn"."date" <= '2025-10-12')
               GROUP BY "batch"."id", "cte_1"."id", "cte_1"."name")
SELECT sum("cte"."closing") AS "closing", "cte"."id" AS "id", min("cte"."name") AS "name"
FROM "cte"
GROUP BY "id"
ORDER BY "id" ASC

