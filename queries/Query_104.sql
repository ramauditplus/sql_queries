select * from inventory where incentive_applicable is null;
select * from inventory_opening where branch_id = 9 and inventory_id = 10 and warehouse_id = 1;
select * from batch where inventory_id = 10 and branch_id = 9;
select * from inventory_branch_detail where branch_id = 9 and inventory_id = 10;
select * from inventory_branch_detail where inventory_id = 10;