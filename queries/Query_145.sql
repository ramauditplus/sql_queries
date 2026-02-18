select count(distinct mobile) as unique_number, count(mobile) as total_number from account where account_type_id = 16;
select count(mobile) from account where account_type_id = 16;