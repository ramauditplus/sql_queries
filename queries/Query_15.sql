select round(sum(ac_txn.debit - ac_txn.credit)::numeric, 2)::float  as "opening", account_id from ac_txn where is_opening = true and branch_id in (1, 2, 3) group by account_id;

select * from ac_txn where branch_id = 2;

select * from ac_txn where account_id = 16 and is_opening = true;