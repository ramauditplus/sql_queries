insert into member_role (name, perms, ui_perms, created_at, updated_at, created_by, updated_by)
values ('pos_server', array ['create_account','create_sale_bill','view_pos_server'],
        '[
          "inv.cus.vw",
          "inv.cus.cr",
          "inv.sal.vw",
          "inv.sal.cr"
        ]'::jsonb, current_timestamp, current_timestamp, 1, 1)
on conflict (name) do update set perms = excluded.perms, ui_perms = excluded.ui_perms;
--##
alter table member add if not exists is_pos_server bool not null default false;
--##
drop table if exists pos_server;
--##
create table if not exists pos_server
(
    id           int       not null generated always as identity primary key,
    access_key   text      not null unique,
    name         text      not null unique,
    branch_id    int       not null,
    member_id    int       not null,
    session      text,
    reg_code     int,
    reg_iat      timestamp,
    is_active    boolean   not null default false,
    created_at   timestamp not null,
    updated_at   timestamp not null
);
--##
alter table pos_server
    add constraint pos_server_branch_id_fkey foreign key (branch_id) references branch;
--##
alter table pos_server
    add constraint pos_server_member_id_fkey foreign key (member_id) references member;
--##
drop table if exists pos_offline_voucher;
--##
create table if not exists pos_offline_voucher
(
    id                int       not null generated always as identity primary key,
    pos_id            int       not null,
    pos_txn_id        uuid      not null unique,
    api_data          json      not null,
    ui_data           json      not null,
    pos_voucher_no    text      not null,
    error_reason      text,
    created_by        int       not null, --at pos server end
    created_at        timestamp not null, --at pos server end
    received_at       timestamp not null  --at tenant api end
);
--##
alter table pos_offline_voucher
    add constraint pos_offline_voucher_pos_id_fkey foreign key (pos_id) references pos_server;
--##
alter table pos_offline_voucher
    add constraint pos_offline_voucher_created_by_fkey foreign key (created_by) references member;
--##
create or replace function fn_notify_pos_sync() returns trigger as
$$
declare
	data text := row_to_json(coalesce(new, old))::text;
begin
    raise notice 'Payload size: %', length(concat('{"operation":"', TG_OP, '","table":"', TG_TABLE_NAME, '","data":', data, '}'));
	perform pg_notify('pos_sync', concat('{"operation":"', TG_OP, '","table":"', TG_TABLE_NAME, '","data":', data, '}'));
	return coalesce(new, old);
end;
$$ language plpgsql;
--##
do
$$
	declare
		_table_name  text;
		_table_names text[] = array ['account', 'account_type', 'batch', 'branch', 'category_option', 'division', 'doctor','gst_registration','inventory', 'inventory_branch_detail', 'member', 'pos_counter', 'price_list', 'price_list_condition', 'sales_person', 'unit', 'voucher_type', 'warehouse'];
	begin
		foreach _table_name in array _table_names
			loop
				raise info '% start..', _table_name;
                execute format('drop trigger if exists tg_notify_%1$s on %1$s',_table_name);
				execute format('create or replace trigger tg_notify_%1$s
                                after insert or update or delete on %1$s
                                for each row execute function fn_notify_pos_sync();', _table_name);
				raise info '% end..', _table_name;
			end loop;
	end;
$$;
