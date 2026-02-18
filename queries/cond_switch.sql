SELECT min("voucher"."branch_name")                                                      AS "branch_name",
       count("voucher"."id")                                                             AS "totnum",
       count((CASE WHEN ("voucher"."cancel" = TRUE) THEN 1 END))                         AS "cancel",
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
WHERE "ac_txn"."gst_tax" NOT IN ('gstna', 'gstexempt', 'gstngs')
  AND "voucher"."amount" > 100000
  AND "voucher"."base_voucher_type" = 'SALE'
  AND "voucher"."branch_gst_no" = '36AAACH7409R1Z2'
  AND ("voucher"."date" >= '2025-01-01' AND "voucher"."date" <= '2025-12-31')
  AND "voucher"."party_gst_no" IS NULL
  AND "voucher"."party_gst_reg_type" = 'UNREGISTERED'
GROUP BY "ac_txn"."hsn_code", "voucher"."id";

SELECT min("voucher"."branch_name")                                                                   AS "branch_name",
       (CASE
            WHEN ("voucher"."base_voucher_type" = 'SALE') THEN 'Invoices for outward supply'
            ELSE (CASE
                      WHEN ("voucher"."base_voucher_type" = 'CREDIT_NOTE') THEN 'Credit Note'
                      ELSE (CASE
                                WHEN ("voucher"."base_voucher_type" = 'PURCHASE')
                                    THEN 'Invoices for inward supply from unregistered person'
                                ELSE (CASE
                                          WHEN ("voucher"."base_voucher_type" = 'DEBIT_NOTE') THEN 'Debit Note'
                                          ELSE (CASE
                                                    WHEN ("voucher"."base_voucher_type" = 'PAYMENT')
                                                        THEN 'Payment Voucher'
                                                    ELSE (CASE
                                                              WHEN ("voucher"."base_voucher_type" = 'RECEIPT')
                                                                  THEN 'Receipt Voucher'
                                                              ELSE NULL END) END) END) END) END) END) AS "doc_type",
       count("voucher"."id")                                                                          AS "totnum",
       count((CASE WHEN ("voucher"."cancel" = TRUE) THEN 1 END))                                      AS "cancel"
FROM "voucher"
         LEFT JOIN "ac_txn" ON "ac_txn"."voucher_id" = "voucher"."id"
         LEFT JOIN "country" ON "country"."id" = "voucher"."party_gst_location_id"
WHERE "ac_txn"."gst_tax" NOT IN ('gstna', 'gstexempt', 'gstngs')
  AND "voucher"."amount" > 100000
  AND "voucher"."base_voucher_type" = 'SALE'
  AND "voucher"."branch_gst_no" = '36AAACH7409R1Z2'
  AND ("voucher"."date" >= '2025-01-01' AND "voucher"."date" <= '2025-12-31')
  AND "voucher"."party_gst_no" IS NULL
  AND "voucher"."party_gst_reg_type" = 'UNREGISTERED'
GROUP BY "ac_txn"."hsn_code", "voucher"."id"