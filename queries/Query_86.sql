create table if not exists inventory_composition
(
    id         int       not null generated always as identity primary key,
    name       text      not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    created_by int       not null references member,
    updated_by int       not null references member
);
--##
create table if not exists drug_classification
(
    id         int       not null generated always as identity primary key,
    name       text      not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    created_by int       not null references member,
    updated_by int       not null references member
);
--##
alter table inventory
    add if not exists drug_classifications int[],
    add if not exists compositions         int[];
--##
alter table wanted_note
    add if not exists reason text;
--##
alter table stock_addition_inv_item
    add if not exists opening_p_rate float;
--##
create table if not exists sale_quotation
(
    id                int       not null generated always as identity primary key,
    voucher_id        int       not null,
    date              date      not null,
    eff_date          date      not null,
    branch_id         int       not null,
    branch_name       text      not null,
    warehouse_id      int       not null,
    warehouse_name    text      not null,
    base_voucher_type text      not null,
    voucher_type_id   int       not null,
    voucher_no        text      not null,
    voucher_prefix    text      not null,
    voucher_fy        int       not null,
    voucher_seq       int       not null,
    lut               boolean,
    customer_id       int,
    customer_name     text,
    description       text,
    ref_no            text,
    amount            float     not null,
    discount_mode     char(1),
    discount_amount   float,
    rounded_off       float,
    branch_gst        json,
    party_gst         json,
    delivery_date     date,
    delivery_address  json,
    dispatch_address  json,
    inv_items         jsonb     not null,
    s_inc_id          int,
    created_by        int       not null,
    updated_by        int       not null,
    created_at        timestamp not null,
    updated_at        timestamp not null
);
--##
alter table sale_quotation
    add constraint sale_quotation_voucher_id_fkey foreign key (voucher_id) references voucher,
    add constraint sale_quotation_branch_id_fkey foreign key (branch_id) references branch,
    add constraint sale_quotation_warehouse_id_fkey foreign key (warehouse_id) references warehouse,
    add constraint sale_quotation_voucher_type_id_fkey foreign key (voucher_type_id) references voucher_type,
    add constraint sale_quotation_customer_id_fkey foreign key (customer_id) references account,
    add constraint sale_quotation_s_inc_id_fkey foreign key (s_inc_id) references sales_person,
    add constraint sale_quotation_created_by_fkey foreign key (created_by) references member,
    add constraint sale_quotation_updated_by_fkey foreign key (updated_by) references member;
--##
create table if not exists organization_old
(
    id            uuid      not null primary key,
    name          text      not null unique,
    full_name     text      not null,
    country       text      not null,
    book_begin    date      not null,
    fp_code       int       not null,
    status        text      not null,
    plan_type     text      not null,
    branch        smallint  not null,
    pos_counter   smallint  not null,
    voucher       int       not null,
    disk_serial   text,
    configuration json,
    serial_no     int,
    serial_key    text,
    license_token text,
    gst_no        text,
    expiry_at     timestamp,
    created_at    timestamp not null,
    updated_at    timestamp not null
);
--##
insert into organization_old (
    id, name, full_name, country, book_begin, fp_code, status, plan_type, branch, pos_counter, voucher, disk_serial,
    configuration, serial_no, serial_key, license_token, gst_no, expiry_at, created_at, updated_at
)
select
    id, name, full_name, country, book_begin, fp_code, status, plan_type, branch, pos_counter, voucher, disk_serial,
    configuration, serial_no, serial_key, license_token, gst_no, expiry_at,
    created_at::timestamp, updated_at::timestamp
from organization;
--##
alter table organization
    add if not exists license_claims json,
    add if not exists owned_by text not null default 'admin',
    add if not exists reason text,
    add if not exists token_validity timestamp,
    add if not exists last_sync timestamp,
    drop if exists plan_type,
    drop if exists branch,
    drop if exists pos_counter,
    drop if exists voucher,
    drop if exists disk_serial,
    drop if exists serial_no,
    drop if exists serial_key,
    drop if exists expiry_at;
--##
alter table pos_server drop column member_id;
--##
alter table member drop column is_pos_server;
--##
delete from member where role_id='pos_server';
--##
delete from member_role where name='pos_server';
--##
alter table organization alter owned_by drop default;
--##
alter table account_type
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table account
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table approval_tag
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table batch
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table branch
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table country
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table category
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table category_option
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table division
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table doctor
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table gst_registration
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table inventory
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table inventory_branch_detail
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table member
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table member_role
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table organization
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table offer_management
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table pos_counter
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table print_template
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table print_layout
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table price_list
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table price_list_condition
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table sales_person
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table unit
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table voucher_type
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table warehouse
    add if not exists changed_at timestamp not null default current_timestamp;
--##
alter table account_type
    alter changed_at drop default;
--##
alter table account
    alter changed_at drop default;
--##
alter table approval_tag
    alter changed_at drop default;
--##
alter table batch
    alter changed_at drop default;
--##
alter table branch
    alter changed_at drop default;
--##
alter table country
    alter changed_at drop default;
--##
alter table category_option
    alter changed_at drop default;
--##
alter table category
    alter changed_at drop default;
--##
alter table division
    alter changed_at drop default;
--##
alter table doctor
    alter changed_at drop default;
--##
alter table gst_registration
    alter changed_at drop default;
--##
alter table inventory
    alter changed_at drop default;
--##
alter table inventory_branch_detail
    alter changed_at drop default;
--##
alter table member
    alter changed_at drop default;
--##
alter table member_role
    alter changed_at drop default;
--##
alter table organization
    alter changed_at drop default;
--##
alter table offer_management
    alter changed_at drop default;
--##
alter table pos_counter
    alter changed_at drop default;
--##
alter table print_template
    alter changed_at drop default;
--##
alter table print_layout
    alter changed_at drop default;
--##
alter table price_list
    alter changed_at drop default;
--##
alter table price_list_condition
    alter changed_at drop default;
--##
alter table sales_person
    alter changed_at drop default;
--##
alter table unit
    alter changed_at drop default;
--##
alter table voucher_type
    alter changed_at drop default;
--##
alter table warehouse
    alter changed_at drop default;
--##
create table if not exists delete_log
(
    table_name  text      not null primary key,
    p_keys      jsonb     not null
);
--##
create or replace function tgf_insert_inv_txn()
    returns trigger as
$$
begin
    update batch
    set inward     = batch.inward + new.inward,
        outward    = batch.outward + new.outward,
        changed_at = current_timestamp
    where id = new.batch_id;
    return new;
end;
$$ language plpgsql security definer;
--##
create or replace function tgf_update_inv_txn()
    returns trigger as
$$
begin
    update batch
    set inward     = batch.inward + new.inward - old.inward,
        outward    = batch.outward + new.outward - old.outward,
        changed_at = current_timestamp
    where id = new.batch_id;
    return new;
end;
$$ language plpgsql security definer;
--##
create or replace function tgf_delete_inv_txn()
    returns trigger as
$$
declare
    _batch   batch;
    _op_date date := (select book_begin - 1
                      from organization
                      limit 1);
begin
    update batch
    set inward     = batch.inward - old.inward,
        outward    = batch.outward - old.outward,
        changed_at = current_timestamp
    where id = old.batch_id
    returning * into _batch;
    if _batch.txn_id = old.id then
        if exists(select id from inv_txn where batch_id = old.batch_id) and _batch.closing = 0 then
            insert into inventory_opening(id, sno, branch_id, inventory_id, warehouse_id, unit_id, unit_conv, qty, nlc,
                                          cost, rate, is_retail_qty, landing_cost, mrp, s_rate, batch_no, expiry,
                                          asset_amount)
            values (old.id, 999, old.branch_id, old.inventory_id, old.warehouse_id, _batch.unit_id,
                    _batch.unit_conv, 0, _batch.nlc, _batch.cost, _batch.p_rate, _batch.is_retail_qty,
                    _batch.landing_cost, _batch.mrp, _batch.s_rate, _batch.batch_no, _batch.expiry, 0);
            update batch
            set (entry_type, voucher_no, voucher_id, inventory_voucher_id, changed_at) = ('OPENING', null, null, null, current_timestamp)
            where id = old.batch_id;
            insert into inv_txn(id, date, branch_id, division_id, division_name, branch_name, warehouse_id,
                                warehouse_name, party_id, party_name, vendor_id, vendor_name, batch_id, inventory_id,
                                reorder_inventory_id, inventory_name, inventory_hsn, manufacturer_id, manufacturer_name,
                                inward, outward, ref_no, is_opening, category1_id, category1_name, category2_id,
                                category2_name, category3_id, category3_name, category4_id, category4_name,
                                category5_id, category5_name, category6_id, category6_name, category7_id,
                                category7_name, category8_id, category8_name, category9_id, category9_name,
                                category10_id, category10_name, created_by, updated_by, created_at, updated_at)
            values (old.id, _op_date, old.branch_id, old.division_id, old.division_name, old.branch_name,
                    old.warehouse_id, old.warehouse_name, old.party_id, old.party_name, old.vendor_id, old.vendor_name,
                    old.batch_id, old.inventory_id, old.reorder_inventory_id, old.inventory_name, old.inventory_hsn,
                    old.manufacturer_id, old.manufacturer_name, 0, 0, old.ref_no, true, old.category1_id,
                    old.category1_name, old.category2_id, old.category2_name, old.category3_id, old.category3_name,
                    old.category4_id, old.category4_name, old.category5_id, old.category5_name, old.category6_id,
                    old.category6_name, old.category7_id, old.category7_name, old.category8_id, old.category8_name,
                    old.category9_id, old.category9_name, old.category10_id, old.category10_name,
                    old.created_by, old.updated_by, old.created_at, current_timestamp);
        else
            delete from batch where id = old.batch_id;
            insert into delete_log(table_name, p_keys)
            values ('batch', to_jsonb(ARRAY [old.batch_id]))
            on conflict (table_name) do update set p_keys = delete_log.p_keys || excluded.p_keys;
        end if;
    end if;
    return old;
end;
$$ language plpgsql security definer;
--##
create or replace function tgf_update_batch()
    returns trigger as
$$
declare
    _allow_negative_stock bool := (select a.allow_negative_stock
                                   from inventory a
                                   where a.id = new.inventory_id);
begin
    if not _allow_negative_stock and new.closing < 0 then
        raise exception 'Insufficient Stock % %', new.inventory_name, coalesce(new.batch_no, '');
    end if;
    insert into inventory_branch_detail (branch_id, branch_name, inventory_id, inventory_name, reorder_inventory_id,
                                         stock, created_at, updated_at, changed_at, created_by, updated_by)
    values (new.branch_id, new.branch_name, new.inventory_id, new.inventory_name, new.reorder_inventory_id,
            (new.closing - old.closing), new.created_at, new.updated_at, current_timestamp, new.created_by,
            new.updated_by)
    on conflict (branch_id, inventory_id) do update set stock      = round((inventory_branch_detail.stock + excluded.stock)::numeric, 4)::float,
                                                        changed_at = excluded.changed_at;
    return new;
end;
$$ language plpgsql security definer;
--##
create or replace function tgf_delete_batch() returns trigger as
$$
begin
    update inventory_branch_detail
    set stock      = round((inventory_branch_detail.stock - old.closing)::numeric, 4)::float,
        changed_at = current_timestamp
    where (inventory_id, branch_id) = (old.inventory_id, old.branch_id);
    insert into delete_log(table_name, p_keys)
    values ('batch', to_jsonb(ARRAY [old.id]))
    on conflict (table_name) do update set p_keys = delete_log.p_keys || excluded.p_keys;
    return old;
end;
$$ language plpgsql security definer;
--##
do
$$
    declare
        _table_name  text;
        _table_names text[] = array ['account', 'account_type', 'approval_tag', 'batch', 'branch', 'country','category', 'category_option',
            'division', 'doctor','gst_registration','inventory', 'inventory_branch_detail', 'member', 'member_role','organization',
            'offer_management', 'pos_counter', 'price_list', 'price_list_condition', 'sales_person', 'unit', 'voucher_type', 'warehouse'];
    begin
        foreach _table_name in array _table_names
            loop
                execute format('drop trigger if exists tg_notify_%1$s on %1$s', _table_name);
                execute format('create or replace trigger tg_notify_%1$s
                                after insert or update or delete on %1$s
                                for each row execute function fn_notify_pos_sync();', _table_name);
            end loop;
    end;
$$;
