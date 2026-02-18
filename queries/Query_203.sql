SELECT json_build_object('id', branch.id, 'mobile', branch.mobile, 'gst', g.name) as branch,
       row_to_json(g)                                                             as gst,
       row_to_json(c)                                                             as country,
       row_to_json(s)                                                             as state
-- json_agg(row_to_json(b.*)) as branch,
-- json_agg(row_to_json(g.*)) as gst,
-- json_agg(row_to_json(c.*)) as country,
-- json_agg(row_to_json(s.*)) as state
FROM "branch"
         LEFT JOIN "gst_registration" AS "g" ON "branch"."gst_registration_id" = "g"."id"
         LEFT JOIN "country" AS "c" ON "branch"."country_id" = "c"."id"
         LEFT JOIN "country" AS "s" ON "branch"."state_id" = "s"."id"
WHERE "branch"."id" = 5;

SELECT JSON_BUILD_OBJECT('branch_name', "branch"."name", 'gst_name', "gst"."name") AS "result"
FROM "branch"
         LEFT JOIN "gst_registration" AS "gst" ON "branch"."gst_registration_id" = "gst"."id"
WHERE "branch"."id" = 5;

SELECT row_to_json("g") AS "g"
FROM "branch"
         LEFT JOIN "gst_registration" AS "g" ON "branch"."gst_registration_id" = "g"."id"
WHERE "branch"."id" = 5;

SELECT row_to_json("branch") AS "branch", row_to_json("g") AS "gst_registration"
FROM "branch"
         LEFT JOIN "gst_registration" AS "g" ON "branch"."gst_registration_id" = "g"."id"
WHERE "branch"."id" = 5;

SELECT row_to_json("branch") AS "branch", row_to_json("g") AS "gst_registration"
FROM "branch"
         LEFT JOIN "gst_registration" AS "g" ON "branch"."gst_registration_id" = "g"."id"
WHERE "branch"."id" = 5;


-- with fields no $
SELECT JSON_BUILD_OBJECT('country_name', 'country.name', 'branch_name', 'branch.name', 'gst_name',
                         'gst_registration.name') AS "branch"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

-- with fields and $
SELECT JSON_BUILD_OBJECT('gst_name', "gst_registration"."name", 'country_name', "country"."name", 'branch_name',
                         "branch"."name") AS "branch"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

-- without fields
SELECT row_to_json("branch")           AS "branch",
       row_to_json("gst_registration") AS "gst_registration",
       row_to_json("country")          AS "country",
       row_to_json("state")            AS "state",
       row_to_json("account")          AS "account"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

SELECT JSON_BUILD_OBJECT(
               'address', "branch"."address",
               'state', "state",
               'members', "branch"."members",
               'city', "branch"."city",
               'name', "branch"."name",
               'country', "country",
               'id', "branch"."id",
               'state_id', "branch"."state_id",
               'country_id', "branch"."country_id",
               'gst_registration', "gst_registration",
               'misc', "branch"."misc",
               'voucher_no_prefix', "branch"."voucher_no_prefix") AS "branch"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

SELECT row_to_json("member") AS "member"
FROM "member"
WHERE "name" = 'admin'
  AND "pass" = '1';

SELECT row_to_json("member")
FROM "member"
WHERE "name" = 'admin'
  AND "pass" = '1';

SELECT "gst_registration"                                                                          AS "gst_registration",
       "branch"."id"                                                                               AS "id",
       JSON_BUILD_OBJECT('gst_id', "gst_registration"."id", 'gst_name', "gst_registration"."name") AS "branch_gst"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

SELECT "branch"."city"                                                                     AS "city",
       "branch"."misc"                                                                     AS "misc",
       "branch"."voucher_no_prefix"                                                        AS "voucher_no_prefix",
       "branch"."id"                                                                       AS "id",
       "branch"."members"                                                                  AS "members",
       JSON_BUILD_OBJECT('id', "gst_registration"."id", 'name', "gst_registration"."name") AS "gst_registration",
       "branch"."address"                                                                  AS "address",
       "branch"."name"                                                                     AS "name"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5;

SELECT JSON_BUILD_OBJECT(
               'email', gst_registration.email,
               'gst_no', gst_registration.gst_no,
               'id', gst_registration.id,
               'name', gst_registration.name,
               'reg_type', gst_registration.reg_type,
               'state_id', gst_registration.state_id,
               'username', gst_registration.username
       )                                   AS gst_registration,

       branch.pincode                      AS pincode,
       branch.voucher_no_prefix            AS voucher_no_prefix,
       branch.name                         AS name,
       branch.mobile                       AS mobile,
       branch.address                      AS address,
       branch.telephone                    AS telephone,
       branch.email                        AS email,
       branch.contact_person               AS contact_person,
       branch.city                         AS city,
       branch.updated_at                   AS updated_at,

       JSON_BUILD_OBJECT(
               'country_id', state.country_id,
               'id', state.id,
               'name', state.name
       )                                   AS state,

       branch.created_at                   AS created_at,

       JSON_BUILD_OBJECT(
               'country_id', country.country_id,
               'id', country.id,
               'name', country.name
       )                                   AS country,

       branch.id                           AS id,
       branch.misc                         AS misc,
       branch.alternate_mobile             AS alternate_mobile,

       (SELECT json_agg(
                       jsonb_build_object(
                               'id', m.id,
                               'name', m.name,
                               'is_root', m.is_root
                       )
               )
        FROM member AS m
        WHERE m.id = ANY (branch.members)) AS members

FROM branch
         LEFT JOIN gst_registration
                   ON branch.gst_registration_id = gst_registration.id
         LEFT JOIN country
                   ON branch.country_id = country.id
         LEFT JOIN country AS state
                   ON branch.state_id = state.id
         LEFT JOIN account
                   ON branch.account_id = account.id
WHERE branch.id = 5;


SELECT "branch"."mobile"                                                                                       AS "mobile",
       "branch"."id"                                                                                           AS "id",
       "branch"."pincode"                                                                                      AS "pincode",
       JSON_BUILD_OBJECT('account_type_id', "account"."account_type_id", 'account_type_name',
                         "account"."account_type_name", 'alias_name', "account"."alias_name", 'base_account_types',
                         "account"."base_account_types", 'bill_wise_detail', "account"."bill_wise_detail",
                         'contact_person', "account"."contact_person", 'email', "account"."email", 'id', "account"."id",
                         'mobile', "account"."mobile", 'name', "account"."name", 'sac_code', "account"."sac_code",
                         'tds_nature_of_payment_id', "account"."tds_nature_of_payment_id", 'telephone',
                         "account"."telephone", 'transaction_enabled',
                         "account"."transaction_enabled")                                                      AS "account",
       JSON_BUILD_OBJECT('email', "gst_registration"."email", 'gst_no', "gst_registration"."gst_no", 'id',
                         "gst_registration"."id", 'name', "gst_registration"."name", 'reg_type',
                         "gst_registration"."reg_type", 'state_id', "gst_registration"."state_id", 'username',
                         "gst_registration"."username")                                                        AS "gst_registration",
       (SELECT json_agg(jsonb_build_object('id', "member"."id", 'is_root', "member"."is_root", 'name', "member"."name"))
        FROM "member"
        WHERE 'member.id' = ANY ("branch"."members"))                                                          AS "members",
       "branch"."name"                                                                                         AS "name",
       "branch"."contact_person"                                                                               AS "contact_person",
       "branch"."address"                                                                                      AS "address",
       "branch"."created_at"                                                                                   AS "created_at",
       "branch"."voucher_no_prefix"                                                                            AS "voucher_no_prefix",
       "branch"."alternate_mobile"                                                                             AS "alternate_mobile",
       "branch"."telephone"                                                                                    AS "telephone",
       "branch"."updated_at"                                                                                   AS "updated_at",
       JSON_BUILD_OBJECT('country_id', "country"."country_id", 'id', "country"."id", 'name',
                         "country"."name")                                                                     AS "country",
       "branch"."email"                                                                                        AS "email",
       "branch"."misc"                                                                                         AS "misc",
       JSON_BUILD_OBJECT('country_id', "state"."country_id", 'id', "state"."id", 'name',
                         "state"."name")                                                                       AS "state",
       "branch"."city"                                                                                         AS "city"
FROM "branch"
         LEFT JOIN "gst_registration" ON "branch"."gst_registration_id" = "gst_registration"."id"
         LEFT JOIN "country" ON "branch"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "branch"."state_id" = "state"."id"
         LEFT JOIN "account" ON "branch"."account_id" = "account"."id"
WHERE "branch"."id" = 5


