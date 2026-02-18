select *
from branch as b
         left join member as m on m.id = any (b.members);
select *
from member as m
         right join branch as b on m.id = any (b.members);

SELECT "gst_registration"."username"                                                                     AS "username",
       "gst_registration"."created_at"                                                                   AS "created_at",
       "gst_registration"."id"                                                                           AS "id",
       "gst_registration"."updated_at"                                                                   AS "updated_at",
       "gst_registration"."e_password"                                                                   AS "e_password",
       "gst_registration"."gst_no"                                                                       AS "gst_no",
       "gst_registration"."reg_type"                                                                     AS "reg_type",
       "gst_registration"."trade_name"                                                                   AS "trade_name",
       "gst_registration"."name"                                                                         AS "name",
       "gst_registration"."email"                                                                        AS "email",
       JSON_BUILD_OBJECT('country_id', "state"."country_id", 'id', "state"."id", 'name', "state"."name") AS "state",
       "gst_registration"."e_invoice_username"                                                           AS "e_invoice_username"
FROM "gst_registration"
         LEFT JOIN "country" AS "state" ON "gst_registration"."state_id" = "state"."name"
WHERE "gst_registration"."id" = 1;

SELECT act.*,
       (SELECT row_to_json(pat.*)
        FROM account_type AS pat
        WHERE pat.id = act.parent_id) AS parent
FROM account_type AS act
WHERE act.id = 22;

SELECT "warehouse"."address"                                                                                   AS "address",
       "warehouse"."telephone"                                                                                 AS "telephone",
       "warehouse"."city"                                                                                      AS "city",
       "warehouse"."id"                                                                                        AS "id",
       "warehouse"."email"                                                                                     AS "email",
       "warehouse"."pincode"                                                                                   AS "pincode",
       JSON_BUILD_OBJECT('country_id', "state"."country_id", 'id', "state"."id", 'name',
                         "state"."name")                                                                       AS "state",
       "warehouse"."name"                                                                                      AS "name",
       "warehouse"."updated_at"                                                                                AS "updated_at",
       "warehouse"."mobile"                                                                                    AS "mobile",
       JSON_BUILD_OBJECT('country_id', "country"."country_id", 'id', "country"."id", 'name',
                         "country"."name")                                                                     AS "country",
       "warehouse"."created_at"                                                                                AS "created_at"
FROM "warehouse"
         LEFT JOIN "country" ON "warehouse"."country_id" = "country"."id"
         LEFT JOIN "country" AS "state" ON "warehouse"."state_id" = "state"."id"


