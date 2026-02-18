select id, (id + acc_type_id) as sanjai
from udm_account
limit 10;

SELECT "name"               AS "name",
       $1                   AS "date",
       $2 + ($3 * $4)       AS "addition",
       "id" + "acc_type_id" AS "add",
       $5                   AS "datetime",
       $6 <> $7             AS "equal",
       "acc_type_id"        AS "acc_type_id",
       "id"                 AS "id",
       $8                   AS "apple",
       "udm_account"."id"   AS "inv"
FROM "udm_account"
WHERE "id" > $9
  AND "name" = $10
ORDER BY "acc_type_id" DESC
LIMIT $11 OFFSET $12;

SELECT "acc_type_id"           AS "acc_type_id",
       $1                      AS "apple",
       "id" + "acc_type_id"    AS "add",
       $2                      AS "date",
       $3 + ($4 * $5)          AS "addition",
       $6                      AS "datetime",
       "id"                    AS "id",
       "udm_account_type"."id" AS "inv",
       $7 <> $8                AS "equal",
       "name"                  AS "name"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
WHERE "id" > $9
  AND "name" = $10
ORDER BY "acc_type_id" DESC
LIMIT $11 OFFSET $12;

SELECT "acc_type_id"           AS "acc_type_id",
       "name"                  AS "name",
       $1                      AS "datetime",
       $2                      AS "apple",
       "id" + "acc_type_id"    AS "add",
       $3                      AS "date",
       "id"                    AS "id",
       $4 <> $5                AS "equal",
       "udm_account_type"."id" AS "inv",
       $6 + ($7 * $8)          AS "addition"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC
LIMIT $9 OFFSET $10;

SELECT "id" + "acc_type_id"    AS "add",
       "acc_type_id"           AS "acc_type_id",
       $1 + ($2 * $3)          AS "addition",
       $4 <> $5                AS "equal",
       $6                      AS "datetime",
       "udm_account"."name"    AS "name",
       "udm_account_type"."id" AS "inv",
       "id"                    AS "id",
       $7                      AS "date",
       $8                      AS "apple"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC
LIMIT $9 OFFSET $10;

SELECT "udm_account_type"."id" AS "inv",
       "id" + "acc_type_id"    AS "add",
       $1 + ($2 * $3)          AS "addition",
       $4                      AS "date",
       "udm_account"."name"    AS "name",
       "acc_type_id"           AS "acc_type_id",
       $5 <> $6                AS "equal",
       "udm_account"."id"      AS "id",
       $7                      AS "apple",
       $8                      AS "datetime"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC
LIMIT $9 OFFSET $10;

SELECT $1                      AS "datetime",
       $2                      AS "date",
       "id" + "acc_type_id"    AS "add",
       "udm_account_type"."id" AS "inv",
       "acc_type_id"           AS "acc_type_id",
       "udm_account"."name"    AS "name",
       $3 <> $4                AS "equal",
       $5 + ($6 * $7)          AS "addition",
       $8                      AS "apple",
       "udm_account"."id"      AS "id"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC
LIMIT $9 OFFSET $10;

SELECT $1 + ($2 * $3)                                   AS "addition",
       "udm_account_type"."id"                          AS "inv",
       $4                                               AS "apple",
       "udm_account"."id" + "udm_account"."acc_type_id" AS "add",
       "udm_account"."id"                               AS "id",
       $5                                               AS "datetime",
       $6 <> $7                                         AS "equal",
       "udm_account"."name"                             AS "name",
       "acc_type_id"                                    AS "acc_type_id",
       $8                                               AS "date"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC
LIMIT $9 OFFSET $10;

SELECT "udm_account_type"."name" AS "account_type_name",
       "udm_account"."name"      AS "name",
       "udm_branch"."name"       AS "branch_name"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
ORDER BY "udm_account"."id" DESC;

SELECT "udm_account"."name"      AS "name",
       "udm_branch"."name"       AS "branch_name",
       "udm_account_type"."name" AS "account_type_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "name" DESC;

SELECT $1                        AS "test",
       "udm_branch"."name"       AS "branch_name",
       "udm_account_type"."name" AS "account_type_name",
       "udm_account"."name"      AS "name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC;

SELECT 'a'                  AS "test",
       "udm_account"."name" AS "name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
WHERE "udm_account"."name" = 'capital'
ORDER BY "acc_type_id" DESC;

select udm_account.name
from udm_account
         left join udm_account_type on udm_account.acc_type_id = udm_account_type.id
where udm_account.id > 1;

SELECT $1                        AS "test",
       "udm_account"."name"      AS "name",
       "udm_account_type"."name" AS "branch_name"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
WHERE "udm_account"."name" = $2;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

SELECT $1                        AS "test",
       "udm_account_type"."name" AS "branch_name",
       "udm_account"."name"      AS "name"
FROM "udm_account"
         LEFT JOIN "udm_account" ON "udm_account"."acc_type_id" = $2
WHERE "udm_account"."name" = $3;

SELECT "udm_account_type"."name" AS "type_name",
       "udm_account"."name"      AS "name"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" > "udm_account_type"."id";

SELECT "udm_account_type"."name" AS "branch_name",
       "udm_account"."name"      AS "name",
       $1                        AS "test"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
WHERE "udm_account"."name" = $2;

SELECT "udm_account"."name"      AS "name",
       "udm_account_type"."name" AS "branch_name",
       $1                        AS "test"
FROM "udm_account"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
WHERE "udm_account"."name" = $2;

SELECT "udm_branch"."name"  AS "branch_name",
       "udm_account"."name" AS "name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_type_id" = "udm_branch"."id";

SELECT "udm_branch"."name"       AS "branch_name",
       "udm_account_type"."name" AS "account_type_name",
       "udm_account"."name"      AS "name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id";


SELECT "udm_branch"."name"       AS "branch_name",
       "udm_account"."name"      AS "name",
       "udm_account_type"."name" AS "account_type_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC;

SELECT "udm_account_type"."name" AS "account_type_name",
       "udm_account"."name"      AS "name",
       "udm_branch"."name"       AS "branch_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_branch"."id" = "udm_account"."acc_branch_id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC;

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


SELECT "udm_account"."name"      AS "name",
       "udm_branch"."name"       AS "branch_name",
       "udm_account_type"."name" AS "account_type_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_account"."acc_branch_id" = "udm_branch"."id"
ORDER BY "acc_type_id" DESC;


SELECT "udm_branch"."name"       AS "branch_name",
       "udm_account_type"."name" AS "account_type_name",
       "udm_account"."name"      AS "name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_branch"."id" = "udm_account"."acc_branch_id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
ORDER BY "acc_type_id" DESC;

SELECT "udm_account"."name"      AS "name",
       "udm_account_type"."name" AS "account_type_name",
       "udm_branch"."name"       AS "branch_name"
FROM "udm_account"
         LEFT JOIN "udm_branch" ON "udm_branch"."id" = "udm_account"."acc_branch_id"
         LEFT JOIN "udm_account_type" ON "udm_account"."acc_type_id" = "udm_account_type"."id"
WHERE "udm_account"."name" = $1
ORDER BY "acc_type_id" DESC;





























































