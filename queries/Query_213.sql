SELECT sum("ac_txn"."credit", "ac_txn"."debit") AS "credit"
FROM "ac_txn"
WHERE "date" >= '2024-01-01';
-- GROUP BY "account_id"

SELECT "ac_txn"."debit" - "ac_txn"."credit" AS "$sum", sum("ac_txn"."credit") AS "credit"
FROM "ac_txn"
WHERE "date" >= '2024-01-01'
GROUP BY "account_id", "ac_txn"."debit", "ac_txn"."credit";

SELECT sum("ac_txn"."debit" - "ac_txn"."credit") AS "total", sum("ac_txn"."credit") AS "credit"
FROM "ac_txn"
WHERE "date" >= '2024-01-01'
GROUP BY "account_id", "ac_txn"."debit", "ac_txn"."credit"