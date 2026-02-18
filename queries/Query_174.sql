WITH "base" AS (SELECT "inventory_name", "batch_no", "mrp", "s_rate", "p_rate", "nlc", "closing"
                FROM "batch"
                WHERE "closing" > 0)
SELECT *
FROM "base"
WHERE "entry_date" <= '2025-10-01'
LIMIT 10 OFFSET 0;

select batch.inward + batch.outward as "add" from batch where (batch.inward + batch.outward) > 10;

WITH base AS (SELECT id, inventory_name, inward * outward AS multi_value, branch_name FROM batch ORDER BY id ASC)
SELECT *
FROM base
WHERE multi_value = $1
LIMIT $2 OFFSET $3;

WITH "base" AS (SELECT "id", "inventory_name", "inward" * "outward" AS "multi_value", "branch_name"
                FROM "batch"
                ORDER BY "id" ASC)
SELECT *
FROM "base"
WHERE "multi_value" = 576
LIMIT 300 OFFSET 0;

SELECT id, inventory_name, inward * outward AS multi_value, branch_name
FROM batch
WHERE $eq = $1
ORDER BY id ASC
LIMIT $2 OFFSET $3;

SELECT id, inventory_name, inward * outward AS multi_value, branch_name
FROM batch
WHERE cost == mrp
ORDER BY id ASC
LIMIT 100 OFFSET 0;


SELECT id, inventory_name, inward * outward AS multi_value, branch_name
FROM batch
WHERE cost = 77.21 * 1
ORDER BY id ASC
LIMIT 100 OFFSET 0;

SELECT id, inventory_name, inward * outward AS multi_value, branch_name, cost
FROM batch
WHERE cost = 77.21 * 1
  AND multi_value > 500
ORDER BY id ASC
LIMIT 100 OFFSET 0;

select id, inventory_name, inward * outward as a from batch where a > 100;

WITH base AS (SELECT id, inventory_name, inward * outward AS multi_value, branch_name, cost
              FROM batch
              WHERE cost > $1 * $2
                AND cost > $3
              ORDER BY id ASC)
SELECT *
FROM base
WHERE branch_name = "Main Branch"
  AND multi_value > 100
LIMIT $6 OFFSET $7;

delete from custom_report where name like 'output_model%';

WITH base AS (SELECT id, inventory_name, inward * outward AS multi_value, branch_name, cost
              FROM batch
              WHERE cost > 77.21 * 1
              ORDER BY id ASC)
SELECT *
FROM base
WHERE cost > 77.00 * 1
  AND branch_name = 'Main Branch'
LIMIT 10 OFFSET 0;

WITH base AS (SELECT id, inventory_name, inward * outward AS multi_value, branch_name, cost
              FROM batch
              WHERE cost > 234.52 * 1
              ORDER BY id ASC)
SELECT *
FROM base
WHERE branch_name ILIKE '%main%'
LIMIT 100 OFFSET 0;

SELECT id, inventory_name, closing
FROM batch
WHERE $1
  AND closing > 0
LIMIT $3 OFFSET $4;

SELECT id, inventory_name, expiry, closing
FROM batch
WHERE expiry = '2026-01-30'
  AND closing > 0
LIMIT 100 OFFSET 0