--## remove foreign key reference from organization and license table
alter table organization
    drop constraint if exists organization_created_by_fkey;
--##
alter table license
    drop constraint if exists license_created_by_fkey;
--## remove unwanted columns from user table
-- alter table "user"
--     drop column if exists password;
--## drop user table
drop table if exists "user";
--## drop otp_detail table
drop table if exists otp_detail;
--##