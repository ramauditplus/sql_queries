alter table batch
    add constraint p_key primary key (id);

WITH "cte" AS (SELECT sum("inv_txn"."inward" - "inv_txn"."outward") AS "as_on_closing",
                      "batch"."manufacturer_id"                     AS "manufacturer_id",
                      "batch"."vendor_id"                           AS "vendor_id",
                      "batch"."landing_cost"                        AS "landing_cost",
                      "batch"."closing"                             AS "closing",
                      "batch"."inventory_id"                        AS "inventory_id",
                      "batch"."warehouse_id"                        AS "warehouse_id",
                      "batch"."branch_id"                           AS "branch_id",
                      "batch"."voucher_id"                          AS "voucher_id",
                      "batch"."nlc"                                 AS "nlc",
                      "batch"."p_rate"                              AS "p_rate"
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
SELECT sum("cte"."as_on_closing" * "cte"."p_rate")       AS "cost_value",
       "cte"."inventory_id"                              AS "id",
       min("x"."name")                                   AS "name",
       sum("cte"."as_on_closing" * "cte"."landing_cost") AS "landing_value",
       sum("cte"."as_on_closing" * "cte"."nlc")          AS "nlc_value"
FROM "cte"
         LEFT JOIN "inventory" AS "x" ON "cte"."inventory_id" = "x"."id"
WHERE "cte"."as_on_closing" <> 0
GROUP BY "inventory_id"
ORDER BY "id" ASC;

WITH "cte" AS (SELECT sum("inv_txn"."inward" - "inv_txn"."outward") AS "as_on_closing",
                      batch.warehouse_id AS "warehouse_id",
                      batch.inventory_id,
                      batch.branch_id,
                      batch.manufacturer_id,
                      batch.nlc,
                      batch.landing_cost,
                      batch.closing                                 as current_closing
               FROM "inv_txn"
                        LEFT JOIN "batch" ON "batch"."batch_no" = "inv_txn"."batch_no" AND
                                             "batch"."branch_id" = "inv_txn"."branch_id" AND
                                             "batch"."inventory_id" = "inv_txn"."inventory_id"
               WHERE "inv_txn"."date" >= '2025-12-01'
                 AND "inv_txn"."date" <= '2025-12-12'
               GROUP BY "batch"."id")
SELECT sum("cte"."as_on_closing" * cte.landing_cost) as landing_value,
       "cte"."warehouse_id"                          AS "id",
       min(w.name)                                   as name
FROM "cte"
         left join warehouse w on w.id = cte.warehouse_id
where as_on_closing <> 0
GROUP BY "warehouse_id"
ORDER BY "id" ASC

