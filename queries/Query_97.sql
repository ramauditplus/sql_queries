alter table stock_deduction_inv_item
    add if not exists voucher_id int,
    add constraint stock_deduction_inv_item_voucher_id_fkey foreign key (voucher_id) references voucher;
--##
with a as (select id, voucher_id from stock_deduction)
update stock_deduction_inv_item b
set voucher_id = a.voucher_id
from a
where b.stock_deduction_id = a.id;
--##
alter table stock_deduction_inv_item
    alter voucher_id set not null;
--##
alter table stock_deduction_inv_item
    drop stock_deduction_id;
--##