create table new_relation_metadata as table relation_metadata;
update relation_metadata
set name = to_model || '_' || to_field;

with a as (select id, name from account where account_type_id = 5),
     b as (select * from branch where branch.account_id = a.id)
select b.*
from c;

with a as (select id from account where account_type_id = 20),
     b as (select branch.id, branch.name
           from branch
                    left join a on branch.account_id = a.id)
select id, name
from b;

WITH "a" AS (SELECT "id" AS "id" FROM "account" WHERE "account_type_id" = 20),
     "b" AS (SELECT "br"."id" AS "id", "br"."name" AS "name"
             FROM "branch" AS "br"
                      LEFT JOIN "a" ON "br"."account_id" = "a"."id")
SELECT "b"."name" AS "name", "b"."id" AS "id"
FROM "b";

WITH "a" AS (SELECT "account"."id" AS "id" FROM "account" WHERE "account_type_id" = 20),
     "b" AS (SELECT "branch"."name" AS "name", "branch"."id" AS "id"
             FROM "branch"
                      LEFT JOIN "a" ON "branch"."account_id" = "a"."id")
SELECT "b"."id" AS "id", "b"."name" AS "name"
FROM "b";

with a as (select * from account where account_type_id = 20)
select id, name
from a;

WITH "a" AS (SELECT "id" AS "id" FROM "account" WHERE "account_type_id" = 20),
     "b" AS (SELECT "br"."id" AS "id", "br"."name" AS "name"
             FROM "branch" AS "br"
                      LEFT JOIN "a" ON "br"."account_id" = "a"."id")
SELECT "b"."id" AS "id", "b"."name" AS "name"
FROM "b"