SELECT COALESCE(CAST(ROUND(SUM(CAST((("closing" * "nlc") / "retail_qty") AS numeric)), 4) AS float), 0) AS "value"
FROM "batch"
WHERE
    "batch"."closing" > 0
  AND "batch"."expiry" >= '2024-02-10'
  AND "batch"."expiry" <= '2025-03-10'
  AND TRUE