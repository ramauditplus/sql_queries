WITH "s1" AS
    (SELECT
         "inventory_id" AS "id",
         MIN("inventory_name") AS "name",
         CAST(ROUND(CAST(SUM("inv_txn"."asset_amount") AS numeric), 2) AS float) AS "asset_value",
         CAST(ROUND(CAST(SUM("inv_txn"."outward") AS numeric), 4) AS float) AS "sold",
         CAST(ROUND(CAST(SUM("inv_txn"."taxable_amount") AS numeric), 2) AS float) AS "sale_value",
         CAST(ROUND(CAST(SUM("taxable_amount" - "asset_amount") AS numeric), 2) AS float) AS "profit_value"
     FROM "inv_txn"
     WHERE "inv_txn"."base_voucher_type" = 'SALE'
     GROUP BY "inventory_id")
SELECT *, (CASE
           WHEN (NULL = 'ASSET')
               THEN (CASE
                   WHEN ("asset_value" <> 0)
                       THEN CAST(ROUND(CAST((("profit_value" * 100) / "asset_value") AS numeric), 2) AS float)
                   ELSE 100 END)
           ELSE (CASE WHEN ("sale_value" <> 0)
               THEN CAST(ROUND(CAST((("profit_value" * 100) / "sale_value") AS numeric), 2) AS float)
               ELSE 100 END) END) AS "profit_percentage"
FROM "s1" ORDER BY "id" ASC NULLS FIRST;

select inventory_name from inv_txn where inventory_id = 200;