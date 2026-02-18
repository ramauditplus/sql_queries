SELECT "account_type"."id"                                         AS "id",
       "account_type"."allow_sub_type"                             AS "allow_sub_type",
       JSON_BUILD_OBJECT('allow_account', "parent_type"."allow_account", 'allow_sub_type',
                         "parent_type"."allow_sub_type", 'base_types', "parent_type"."base_types", 'created_at',
                         "parent_type"."created_at", 'default_name', "parent_type"."default_name", 'description',
                         "parent_type"."description", 'id', "parent_type"."id", 'name', "parent_type"."name",
                         'updated_at', "parent_type"."updated_at") AS "parent",
       "account_type"."updated_at"                                 AS "updated_at",
       "account_type"."default_name"                               AS "default_name",
       "account_type"."description"                                AS "description",
       "account_type"."created_at"                                 AS "created_at",
       "account_type"."base_types"                                 AS "base_types",
       "account_type"."name"                                       AS "name",
       "account_type"."allow_account"                              AS "allow_account"
FROM "account_type"
         LEFT JOIN "account_type" AS "parent_type" ON "account_type"."parent_id" = "parent_type"."id"
WHERE "account_type"."id" = 23;

SELECT "account_type"."name"                                       AS "name",
       "account_type"."allow_account"                              AS "allow_account",
       "account_type"."updated_at"                                 AS "updated_at",
       "account_type"."id"                                         AS "id",
       "account_type"."created_at"                                 AS "created_at",
       "account_type"."base_types"                                 AS "base_types",
       JSON_BUILD_OBJECT('allow_account', "parent_type"."allow_account", 'allow_sub_type',
                         "parent_type"."allow_sub_type", 'base_types', "parent_type"."base_types", 'created_at',
                         "parent_type"."created_at", 'default_name', "parent_type"."default_name", 'description',
                         "parent_type"."description", 'id', "parent_type"."id", 'name', "parent_type"."name",
                         'updated_at', "parent_type"."updated_at") AS "parent",
       "account_type"."description"                                AS "description",
       "account_type"."default_name"                               AS "default_name",
       "account_type"."allow_sub_type"                             AS "allow_sub_type"
FROM "account_type"
         LEFT JOIN "account_type" AS "parent_type" ON "account_type"."parent_id" = "parent_type"."id"
WHERE "account_type"."id" = 23;

SELECT "account_type"."allow_sub_type"                             AS "allow_sub_type",
       JSON_BUILD_OBJECT('allow_account', "parent_type"."allow_account", 'allow_sub_type',
                         "parent_type"."allow_sub_type", 'base_types', "parent_type"."base_types", 'created_at',
                         "parent_type"."created_at", 'default_name', "parent_type"."default_name", 'description',
                         "parent_type"."description", 'id', "parent_type"."id", 'name', "parent_type"."name",
                         'updated_at', "parent_type"."updated_at") AS "parent",
       "account_type"."allow_account"                              AS "allow_account",
       "account_type"."name"                                       AS "name",
       "account_type"."default_name"                               AS "default_name",
       "account_type"."description"                                AS "description",
       "account_type"."updated_at"                                 AS "updated_at",
       "account_type"."base_types"                                 AS "base_types",
       "account_type"."id"                                         AS "id",
       "account_type"."created_at"                                 AS "created_at"
FROM "account_type"
         LEFT JOIN "account_type" AS "parent_type" ON "account_type"."parent_id" = "parent_type"."id"
WHERE "account_type"."id" = 24