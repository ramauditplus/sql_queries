select * from account where contact_type is not null;
select * from voucher where voucher_no = 'DP252638167';
select id, voucher_no, base_voucher_type, created_at from voucher order by created_at desc;