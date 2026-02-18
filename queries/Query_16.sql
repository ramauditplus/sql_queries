select sum(amount) from bill_allocation
where pending = '04607d6a-2c17-4d89-be33-227df27b94d9'
and account_id=26038 and is_memo=false and is_approved=true
group by pending;