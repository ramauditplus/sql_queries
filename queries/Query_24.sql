create or replace function fn_notify_doctor() returns trigger as $$
declare
    data text := row_to_json(coalesce(new,old))::text;
begin
    perform pg_notify('pos_sync', concat('{"operation":"',TG_OP,'","table":"doctor","data":',data,'}'));
    return coalesce(new, old);
end;
$$ language plpgsql;
--##
create or replace trigger tg_notify_doctor
after insert or update or delete on doctor
    for each row execute function fn_notify_doctor();
--##



select * from doctor where id = 5503;

update doctor set name = 'HARI GODWIN' where id = 5503;