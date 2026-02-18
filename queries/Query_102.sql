--##
alter table gst_registration
    add if not exists eway_username text,
    add if not exists eway_password text;
--##
alter table voucher
    alter column e_invoice_details type json using e_invoice_details::json;
--##
alter table voucher
    add column if not exists eway_bill_details json;
--##
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
    drop if exists stock_deduction_id;
--##