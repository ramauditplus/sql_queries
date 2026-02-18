SELECT *
FROM member
    WHERE 'update_sale_bill_information' = ANY(perms);

select * from member_permission where name = 'view_inventory';
