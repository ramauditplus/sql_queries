SELECT *
FROM member
    WHERE 'purchase_register_detail' = ANY(perms);

select * from member_permission where name = 'view_inventory';

select * from member_permission;

SELECT DISTINCT unnest(perms) AS perm
FROM member
ORDER BY perm;


select * from account where id = 1;