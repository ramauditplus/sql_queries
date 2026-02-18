create or replace function fn_notify_pos_sync() returns trigger as $$
declare
data text := row_to_json(coalesce(new,old))::text;
begin
    perform pg_notify('pos_sync', concat('{"operation":"',TG_OP,'","table":',tg_argv[0],',"data":',data,'}'));
return coalesce(new, old);
end;
$$ language plpgsql;
--##
   do
$$
    declare
table_name  text;
        table_names text[] = array ['division', 'doctor', 'member', 'sales_person',
                                    'gst_registration', 'unit', 'print_template',
                                    'account', 'branch', 'batch', 'voucher_type', 'inventory', 'inventory_branch_detail'];
begin
        foreach table_name in array table_names
            loop
                raise info '% start..', table_name;
execute format('create or replace trigger tg_notify_%1$s
                                after insert or update or delete on %1$s
                                for each row execute function fn_notify_pos_sync(''%1$s'');', table_name);
raise info '% end..', table_name;
end loop;
end;
$$;
--##