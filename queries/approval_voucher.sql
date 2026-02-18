--is_approved=false
select id, date, voucher_no, base_voucher_type, voucher_type_id, require_no_of_approval, approval_state
from voucher
where require_no_of_approval > 0
  and require_no_of_approval <> approval_state;

--is_approved=true
select id, date, voucher_no, base_voucher_type, voucher_type_id, require_no_of_approval, approval_state
from voucher
where require_no_of_approval > 0
  and require_no_of_approval=approval_state;

select * from approval_tag;

select * from voucher_type where id=111;


select * from voucher;

select distinct approval_state from voucher;

select distinct voucher.require_no_of_approval from voucher;

select * from voucher where id = 716;

--input: {is_approved: Option<bool>, date: NaiveDate, branch_id: Option<NumberFilter<i32>>, base_voucher_type: Option<TextFilter> }

--is_approved=false
select id, date, voucher_no, base_voucher_type, voucher_type_id, require_no_of_approval, approval_state
from voucher
where require_no_of_approval > 0
  and require_no_of_approval <> approval_state;

--is_approved=true
select id, date, voucher_no, base_voucher_type, voucher_type_id, require_no_of_approval, approval_state
from voucher
where require_no_of_approval > 0
  and require_no_of_approval=approval_state;

select * from approval_tag;

select * from voucher_type where id=111;

select branch_id
from voucher
where require_no_of_approval > 0
  and require_no_of_approval = approval_state;


SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" > "approval_state";

SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" = "approval_state";

SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" = "approval_state";

SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" = "approval_state";

--false
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" <> "approval_state"
  AND ("branch_id" = 3 AND "base_voucher_type" = 'GOODS_INWARD_NOTE');

--baseVoucherType
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" = "approval_state"
  AND ("branch_id" = 1 AND "base_voucher_type" = 'RECEIPT');

--no_baseVoucherType
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."date" >= '2025-01-01'
  AND "require_no_of_approval" = "approval_state"
  AND "branch_id" = 1;

select count(*) from voucher where require_no_of_approval = approval_state;
select count(*) from voucher where require_no_of_approval <> approval_state;
select count(*) from voucher;

-- true
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2023-01-01'
  AND ("branch_id" IN (1, 2, 3) AND "base_voucher_type" IN ('RECEIPT', 'GOODS_INWARD_NOTE', 'PURCHASE'))
  AND "require_no_of_approval" = "approval_state";

-- false
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2023-01-01'
  AND ("branch_id" IN (1, 2, 3) AND "base_voucher_type" IN ('RECEIPT', 'GOODS_INWARD_NOTE', 'PURCHASE'))
  AND "require_no_of_approval" <> "approval_state";

-- no_is_approved
SELECT
    "voucher"."id",
    "voucher"."date",
    "voucher"."voucher_no",
    "voucher"."base_voucher_type",
    "voucher"."voucher_type_id",
    "voucher"."require_no_of_approval",
    "voucher"."approval_state"
FROM "voucher"
WHERE "voucher"."require_no_of_approval" > 0
  AND "voucher"."date" >= '2023-01-01'
  AND ("branch_id" IN (1, 2, 3) AND "base_voucher_type" IN ('RECEIPT', 'GOODS_INWARD_NOTE', 'PURCHASE'))