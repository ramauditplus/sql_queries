select id, voucher_no, base_voucher_type, e_invoice_details, eway_bill_details from voucher order by created_at desc;
select * from voucher order by created_at desc;
select * from voucher where id = 437125;
select voucher.created_at,branch_gst, party_gst from voucher where base_voucher_type = 'DEBIT_NOTE' order by created_at desc;