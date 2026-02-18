--##
create table if not exists customer_permission
(
    id           int       not null generated always as identity primary key,
    mobile       text      not null unique,
    acc_ids      int[]     not null default array []::int[],
    allow_online boolean   not null,
    created_at   timestamp not null,
    updated_at   timestamp not null,
    created_by   int       not null,
    updated_by   int       not null
);
--##
alter table if exists account
    add column if not exists allow_online boolean default false;
--## Trigger Function
create or replace function delete_if_acc_ids_empty()
    returns trigger as
$$
begin
    -- Check if acc_ids is empty
    if new.acc_ids = '{}' then
        delete from customer_permission where id = new.id;
        return null; -- stop insert/update (row already deleted)
    end if;

    return new; -- keep row
end;
$$ language plpgsql security definer;
--## Trigger
create trigger tg_delete_if_acc_ids_empty
    after insert or update
    on customer_permission
    for each row
execute function delete_if_acc_ids_empty();
--##