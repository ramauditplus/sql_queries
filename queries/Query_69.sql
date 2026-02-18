alter table udm_member
    add constraint udm_member_member_code_unique UNIQUE (member_code);

SELECT * FROM "udm_member" WHERE "member_code" = '1234'