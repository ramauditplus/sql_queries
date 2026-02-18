SELECT *
FROM member_role
    WHERE 'tally_export_data' = ANY(perms);

select * from member_permission where name = 'view_inventory';