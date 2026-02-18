--## remove foreign key reference from organization and license table
alter table organization
    drop constraint if exists organization_created_by_fkey;
--##
alter table license
    drop constraint if exists license_created_by_fkey;

--## add required columns for organization and license table
alter table organization
    add if not exists user_full_name text;
--##
alter table organization
    add if not exists user_email text;
--##
alter table organization
    add if not exists user_mobile text;
--##
alter table license
    add if not exists user_full_name text;
--##
alter table license
    add if not exists user_email text;
--##
alter table license
    add if not exists user_mobile text;

-- For organization to update with existing user data
UPDATE organization org
SET user_full_name = u.full_name, user_email = u.email, user_mobile = u.mobile
FROM "user" u
WHERE org.created_by = u.id;

-- For license to update with existing user data
UPDATE license lic
SET user_full_name = u.full_name, user_email = u.email, user_mobile = u.mobile
FROM "user" u
WHERE lic.created_by = u.id;


--## set columns to not null in organization and license table
alter table "organization"
    alter column "user_full_name" set not null;
--##
alter table "organization"
    alter column "user_email" set not null;
--##
alter table "organization"
    alter column "user_mobile" set not null;
--## set columns to not null in license table
alter table "license"
    alter column "user_full_name" set not null;
--##
alter table "license"
    alter column "user_email" set not null;
--##
alter table "license"
    alter column "user_mobile" set not null;

--## remove unwanted columns from user table
alter table "user"
    drop column if exists email;
--##
alter table "user"
    drop column if exists mobile;
--##
alter table "user"
    drop column if exists password;
--##
alter table "user"
    drop column if exists address;
--##
alter table "user"
    drop column if exists email_verified;
--##