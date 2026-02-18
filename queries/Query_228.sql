alter table ac_txn
    drop constraint p_key_id;
alter table voucher
    drop constraint voucher_p_key_id;

alter table ac_txn
    add constraint ac_txn_key_id primary key (id);
alter table voucher
    add constraint voucher_key_id primary key (id);

SELECT 'N'                                                 AS "rev_charge",
       sum("ac_txn"."cess_amount")                         AS "cess",
       "ac_txn"."date"                                     AS "date",
       "ac_txn"."taxable_amount"                           AS "taxable",
       "voucher"."party_gst_no"                            AS "gst_no",
       min("ac_txn"."voucher_no")                          AS "inv_no",
       "ac_txn"."voucher_id"                               AS "id",
       min("ac_txn"."voucher_mode")                        AS "voucher_mode",
       (CASE
            WHEN ("voucher"."party_gst_reg_type" = 'regular') THEN 'Regular B2B'
            ELSE (CASE
                      WHEN ("voucher"."party_gst_reg_type" = 'special_economic_zone') THEN 'SEZ supplies with payment'
                      ELSE (CASE
                                WHEN ("voucher"."party_gst_reg_type" = 'special_economic_zone')
                                    THEN 'SEZ supplies without payment'
                                ELSE 'Null' END) END) END) AS "inv_type",
       "voucher"."party_gst_location_id"                   AS "pos",
       sum("ac_txn"."sgst_amount")                         AS "sgst",
       "ac_txn"."base_voucher_type"                        AS "voucher_type",
       sum("ac_txn"."igst_amount")                         AS "igst",
       sum("ac_txn"."cgst_amount")                         AS "cgst",
       "voucher"."amount"                                  AS "inv_amt"
FROM "ac_txn"
         LEFT JOIN "voucher" ON "ac_txn"."voucher_id" = "voucher"."id"
WHERE "ac_txn"."base_voucher_type" = 'sale'
  AND ("ac_txn"."date" >= '2025-01-01' AND "ac_txn"."date" <= '2025-10-12')
  AND "ac_txn"."gst_tax" NOT IN ('gstna', 'gstexempt', 'gstngs')
  AND "voucher"."branch_gst_no" = '36AAACH7409R1Z2'
  AND "voucher"."party_gst_no" IS NOT NULL
  AND "voucher"."party_gst_reg_type" IN ('regular', 'special_economic_zone')
GROUP BY "ac_txn"."voucher_id";