alter table public.stock_deduction_inv_item
    rename column voucher_id to stock_deduction_id;

--##
alter table stock_deduction_inv_item
    add voucher_id int;
--##
alter table stock_deduction_inv_item
    add constraint stock_deduction_inv_item_voucher_id_fkey foreign key (voucher_id) references stock_deduction (voucher_id);
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
alter table public.stock_deduction_inv_item
    drop constraint stock_deduction_inv_item_stock_deduction_id_fkey;