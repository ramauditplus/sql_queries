SELECT "state_branch"."name" AS "state_name",
       "udm_account"."name"  AS "account_name",
       "udm_branch"."name"   AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_account"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" ON "udm_branch"."state_id" = "udm_country"."id"
         LEFT JOIN "udm_country" ON "udm_branch"."country_id" = "udm_country"."id";

SELECT "udm_country"."name" AS "state_name",
       "udm_branch"."name"  AS "branch_name",
       "udm_account"."name" AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_account"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" ON "udm_branch"."state_id" = "udm_country"."id"
         LEFT JOIN "udm_country" ON "udm_branch"."country_id" = "udm_country"."id";

SELECT "udm_account"."name" AS "account_name",
       "udm_country"."name" AS "state_name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "udm_account"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "udm_country"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "udm_country"."id";

SELECT "udm_branch"."name"  AS "branch_name",
       "udm_account"."name" AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_account"."id" = "udm_branch"."account_id";

SELECT "udm_branch"."name"  AS "branch_name",
       "udm_country"."name" AS "state_name",
       $1                   AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "a"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_country"."name" AS "state_name",
       "udm_branch"."name"  AS "branch_name",
       "udm_account"."name" AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_account"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "c"."name"          AS "state_name",
       "udm_branch"."name" AS "branch_name",
       "udm_acount"."name" AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_acount"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";


SELECT "udm_branch"."name"  AS "branch_name",
       "c"."name"           AS "state_name",
       "udm_account"."name" AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_branch"."account_id" = "udm_account"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_account"."name" AS "account_name",
       "c"."name"           AS "state_name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" ON "udm_account"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_account"."name" AS "account_name",
       "c"."name"           AS "state_name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "udm_branch"."account_id" = "udm_account"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_account"."name" AS "account_name",
       "udm_branch"."name"  AS "branch_name",
       "c"."name"           AS "state_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "udm_branch"."account_id" = "a"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_account"."name" AS "account_name",
       "c"."name"           AS "state_name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "a"."id" = "a"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_account"."name" AS "account_name",
       "c"."name"           AS "state_name",
       "udm_branch"."name"  AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "udm_branch"."account_id" = "a"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "c"."name"          AS "state_name",
       "a"."name"          AS "account_name",
       "udm_branch"."name" AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "udm_branch"."account_id" = "a"."id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "udm_branch"."name" AS "branch_name",
       "c"."name"          AS "state_name",
       "a"."name"          AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "a"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id";

SELECT "a"."name"          AS "account_name",
       "c"."name"          AS "state_name",
       "udm_branch"."name" AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "a" ON "a"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
WHERE "id" = $1;

SELECT "abb"."name"        AS "account_name",
       "udm_branch"."name" AS "branch_name",
       "c"."name"          AS "state_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS " abb" ON " abb"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
ORDER BY "abb"."id" DESC;

SELECT "udm_branch"."name" AS "branch_name",
       "c"."name"          AS "state_name",
       "abb"."name"        AS "account_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS " abb" ON "abb"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
ORDER BY "abb"."id" DESC;

SELECT "abb"."name"        AS "account_name",
       "c"."name"          AS "state_name",
       "udm_branch"."name" AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "$abb" ON "abb"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
ORDER BY "abb"."id" DESC;

SELECT "udm_branch"."name" AS "branch_name",
       "abb"."name"        AS "account_name",
       "c"."name"          AS "state_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "$$abb" ON "abb"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
ORDER BY "abb"."id" DESC;

SELECT
    "abb"."name" AS "account_name",
    "c"."name" AS "state_name",
    "udm_branch"."name" AS "branch_name"
FROM "udm_branch"
         LEFT JOIN "udm_account" AS "abb" ON "abb"."id" = "udm_branch"."account_id"
         LEFT JOIN "udm_country" AS "b" ON "udm_branch"."state_id" = "b"."id"
         LEFT JOIN "udm_country" AS "c" ON "udm_branch"."country_id" = "c"."id"
ORDER BY "abb"."id" DESC