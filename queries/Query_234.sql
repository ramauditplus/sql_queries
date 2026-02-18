SELECT min("voucher"."voucher_prefix") || min(CAST("voucher"."voucher_fy" AS text)) ||
       min(CAST("voucher"."voucher_seq" AS text))                                        AS "from",
       count("voucher"."id")                                                             AS "totnum",
       count((CASE WHEN ("voucher"."cancel" = TRUE) THEN 1 END))                         AS "cancel",
       min("voucher"."voucher_prefix") || min(CAST("voucher"."voucher_fy" AS text)) ||
       max(CAST("voucher"."voucher_seq" AS text))                                        AS "to",
       min("voucher"."branch_name")                                                      AS "branch_name",
       (CASE
            WHEN ("voucher"."base_voucher_type" = 'SALE') THEN 'Invoices for outward supply'
            WHEN ("voucher"."base_voucher_type" = 'CREDIT_NOTE') THEN 'Credit Note'
            WHEN ("voucher"."base_voucher_type" = 'PURCHASE') THEN 'Invoices for inward supply from unregistered person'
            WHEN ("voucher"."base_voucher_type" = 'DEBIT_NOTE') THEN 'Debit Note'
            WHEN ("voucher"."base_voucher_type" = 'PAYMENT') THEN 'Payment Voucher'
            WHEN ("voucher"."base_voucher_type" = 'RECEIPT') THEN 'Receipt Voucher' END) AS "doc_typ"
FROM "voucher"
         LEFT JOIN "ac_txn" ON "ac_txn"."voucher_id" = "voucher"."id"
         LEFT JOIN "country" ON "country"."id" = "voucher"."party_gst_location_id"
WHERE ("voucher"."base_voucher_type" IN ('SALE', 'CREDIT_NOTE', 'DEBIT_NOTE', 'PAYMENT', 'RECEIPT') OR
       ("voucher"."base_voucher_type" = 'PURCHASE' AND "voucher"."party_gst_reg_type" <> 'REGULAR'))
  AND "voucher"."branch_gst_no" = '36AAACH7409R1Z2'
  AND ("voucher"."date" >= '2025-01-01' AND "voucher"."date" <= '2025-12-31')
GROUP BY "ac_txn"."hsn_code", "voucher"."id";