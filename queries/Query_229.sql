select ac_txn.taxable_amount, voucher.amount from ac_txn left join voucher on ac_txn.voucher_id = voucher.id;


SELECT min("ac_txn"."voucher_mode")      AS "voucher_mode",
       "ac_txn"."taxable_amount"         AS "taxable",
       sum("ac_txn"."cess_amount")       AS "cess",
       min("ac_txn"."voucher_no")        AS "inv_no",
       sum("ac_txn"."igst_amount")       AS "igst",
       sum("ac_txn"."sgst_amount")       AS "sgst",
       "ac_txn"."amount"                 AS "inv_amt",
       'N'                               AS "rev_charge",
       "voucher"."party_gst_no"          AS "gst_no",
       "ac_txn"."voucher_id"             AS "id",
       "voucher"."party_gst_location_id" AS "pos",
       "ac_txn"."base_voucher_type"      AS "voucher_type",
       "ac_txn"."date"                   AS "date",
       sum("ac_txn"."cgst_amount")       AS "cgst"
FROM "ac_txn"
         LEFT JOIN "voucher" ON "ac_txn"."voucher_id" = "voucher"."id"
WHERE "ac_txn"."base_voucher_type" = 'sale'
  AND ("ac_txn"."date" >= '2025-01-01' AND "ac_txn"."date" <= '2025-10-12')
  AND "ac_txn"."gst_tax" NOT IN ('gstna', 'gstexempt', 'gstngs')
  AND "voucher"."branch_gst_no" = '36AAACH7409R1Z2'
  AND "voucher"."party_gst_no" IS NOT NULL
  AND "voucher"."party_gst_reg_type" IN ('regular', 'special_economic_zone')
GROUP BY "ac_txn"."voucher_id"