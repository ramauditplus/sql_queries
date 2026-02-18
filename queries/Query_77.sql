select count(*) as "branch_count" from branch;
select count(*) as "pos_count" from pos_counter;
select count(*) as "voucher_count" from voucher where date between '2025-07-01' and '2025-07-14';

update organization set license_token = null, license_claims = null, token_validity = null, last_sync = null;