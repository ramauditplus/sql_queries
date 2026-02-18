SELECT "voucher"."base_voucher_type"     AS "voucher_type", --✅
       "voucher"."id"                    AS "id",           --✅
       "voucher"."party_gst_location_id" AS "pos",          --✅
       min(country.name)                 as pos_name,       --✅
       "voucher"."party_gst_no"          AS "gst_no",       --✅
       "voucher"."amount"                AS "inv_amt",      --✅
       "voucher"."voucher_no"            AS "inv_no",       --✅
       "voucher"."mode"                  AS "voucher_mode", --✅
       ac_txn.gst_tax,
       min(ac_txn.gst_ratio)             as gst_ratio,      --✅
       sum("ac_txn"."igst_amount")       AS "igst",         --✅
       sum("ac_txn"."taxable_amount")    AS "taxable",      --✅
       sum("ac_txn"."sgst_amount")       AS "sgst",         --✅
       sum("ac_txn"."cgst_amount")       AS "cgst",         --✅
       sum("ac_txn"."cess_amount")       AS "cess",         --✅
--        sum("ac_txn"."cess_amount" + ac_txn.taxable_amount) AS "total",
       'N'                               AS "rev_charge"    --✅
FROM "voucher" -- ✅
         LEFT JOIN "ac_txn" ON "ac_txn"."voucher_id" = "voucher"."id" --✅
         LEFT JOIN "country" ON "country"."id" = "voucher"."party_gst_location_id" --✅
WHERE "voucher"."base_voucher_type" = 'PURCHASE'                              --✅
  AND ("voucher"."date" >= '2025-01-01' AND "voucher"."date" <= '2025-12-31') --✅
  AND "ac_txn"."gst_tax" NOT IN ('gstna', 'gstexempt', 'gstngs')              --✅
  AND "voucher"."branch_gst_no" = '33AAHCV7094B1ZB'                           --✅
  AND "voucher"."party_gst_no" IS NOT NULL                                    --✅
  AND "voucher"."party_gst_reg_type" IN ('REGULAR', 'SPECIAL_ECONOMIC_ZONE')  --✅
GROUP BY "voucher"."id", ac_txn.hsn_code;
--✅

-- auto-generated definition
create table bank
(
    id         integer                             not null primary key,
    name       text                                not null unique,
    code       text                                not null
        unique,
    short_name text                                not null,
    e_banking  boolean,
    created_at timestamp default CURRENT_TIMESTAMP not null,
    updated_at timestamp default CURRENT_TIMESTAMP not null
);

alter table bank
    owner to postgres;