alter table stock_deduction_inv_item
 add column testing_column int;

with a as (select id, voucher_id from stock_deduction)
update stock_deduction_inv_item b
set testing_column = a.voucher_id
from a
where b.voucher_id = a.id;