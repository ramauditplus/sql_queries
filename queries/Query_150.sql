--## add ui_perms column to member table
alter table member
    add if not exists ui_perms text[];