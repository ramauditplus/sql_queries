select * from approval_tag;

select * from voucher_type where id=111;

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

select * from voucher where approval_state > 0;