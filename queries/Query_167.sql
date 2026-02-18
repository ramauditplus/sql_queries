select id as value, batch_no as display_name from batch where batch_no is not null order by batch_no desc;

select id as value, batch_no as display_name from batch where batch_no is null;