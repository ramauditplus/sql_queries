select id, voucher_no, base_voucher_type,e_invoice_details, eway_bill_details from voucher order by created_at desc;
select id, voucher_no, base_voucher_type, voucher_type_id, created_at from voucher order by created_at desc;
select * from voucher where id = 2284293;
select * from ac_txn where voucher_id = 2284293;
select * from debit_note where voucher_id = 437140;
select * from debit_note_inv_item where voucher_id = 437140;
select * from purchase_bill where voucher_id = 437139;

select * from account where account_type_id = 14;

select * from eft_reconciliation_voucher order by created_at desc;

select id, voucher_no, base_voucher_type, voucher_type_id from voucher where voucher_type_id = 24;

select *
from ac_txn
where not ('STOCK' = any(base_account_types));

select * from voucher where party_name = 'Cash' and branch_id = 1 order by created_at desc;

select * from voucher where voucher_no = 'DP252669197';

select * from voucher where voucher_no = 'DP252683556';

select * from voucher where voucher_type_id = 5 and date between '2025-08-22' and '2025-08-22';

SELECT * from ac_txn where voucher_id = 2588194;

SELECT * from ac_txn where voucher_id = 2588177;

SELECT * from ac_txn where voucher_id = 2588166;

select * from voucher_type where id = 5;

select * from voucher where created_at between '2025-09-01' and '2025-09-02' and base_voucher_type = 'SALE' order by created_at desc;

select base_account_types from ac_txn where base_voucher_type = 'SALE';

select * from ac_txn where voucher_no = 'DP252683558';

select * from ac_txn
where 'INDIRECT_INCOME' = any(base_account_types);

select * from voucher where voucher_no = 'DP252683575';

select * from ac_txn where voucher_no = 'DP252683578';




