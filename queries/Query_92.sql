alter table inventory
    add if not exists category1_id        int,
    add if not exists category2_id        int,
    add if not exists category3_id        int,
    add if not exists category1_name      text,
    add if not exists category2_name      text,
    add if not exists category3_name      text,
    add if not exists sale_account_id     int,
    add if not exists purchase_account_id int;
--##
update inventory
set category1_id        = category1[1],
    category2_id        = category2[1],
    category3_id        = category3[1],
    category1_name      = case
                              when category1[1] is not null
                                  then (select name from category_option where id = category1[1]) end,
    category2_name      = case
                              when category2[1] is not null
                                  then (select name from category_option where id = category2[1]) end,
    category3_name      = case
                              when category3[1] is not null
                                  then (select name from category_option where id = category3[1]) end,
    sale_account_id     = 2,
    purchase_account_id = 3,
    inventory_type      = 'GOODS';
--##
alter table inventory
    drop if exists category1,
    drop if exists category2,
    drop if exists category3,
    drop if exists category4,
    drop if exists category5,
    drop if exists category5,
    drop if exists category6,
    drop if exists category7,
    drop if exists category8,
    drop if exists category9,
    drop if exists category10;
--##
alter table inventory
    add constraint inventory_category1_id_fkey foreign key (category1_id) references category_option,
    add constraint inventory_category2_id_fkey foreign key (category2_id) references category_option,
    add constraint inventory_category3_id_fkey foreign key (category3_id) references category_option,
    add constraint inventory_sale_account_id_fkey foreign key (sale_account_id) references account,
    add constraint inventory_purchase_account_id_fkey foreign key (purchase_account_id) references account;
--##
alter table inventory
    alter sale_account_id set not null,
    alter purchase_account_id set not null;
--##
alter table purchase_bill_inv_item
    drop if exists category1_id,
    drop if exists category2_id,
    drop if exists category3_id,
    drop if exists category4_id,
    drop if exists category5_id,
    drop if exists category5_id,
    drop if exists category6_id,
    drop if exists category7_id,
    drop if exists category8_id,
    drop if exists category9_id,
    drop if exists category10_id;
--##
alter table material_conversion_inv_item
    drop if exists target_category1_id,
    drop if exists target_category2_id,
    drop if exists target_category3_id,
    drop if exists target_category4_id,
    drop if exists target_category5_id,
    drop if exists target_category5_id,
    drop if exists target_category6_id,
    drop if exists target_category7_id,
    drop if exists target_category8_id,
    drop if exists target_category9_id,
    drop if exists target_category10_id;
--##
alter table stock_addition_inv_item
    drop if exists category1_id,
    drop if exists category2_id,
    drop if exists category3_id,
    drop if exists category4_id,
    drop if exists category5_id,
    drop if exists category5_id,
    drop if exists category6_id,
    drop if exists category7_id,
    drop if exists category8_id,
    drop if exists category9_id,
    drop if exists category10_id;
--##
alter table inv_txn
    drop if exists category4_id,
    drop if exists category5_id,
    drop if exists category5_id,
    drop if exists category6_id,
    drop if exists category7_id,
    drop if exists category8_id,
    drop if exists category9_id,
    drop if exists category10_id;
--##
alter table batch
    drop if exists category4_id,
    drop if exists category5_id,
    drop if exists category5_id,
    drop if exists category6_id,
    drop if exists category7_id,
    drop if exists category8_id,
    drop if exists category9_id,
    drop if exists category10_id;
--##
alter table price_list_condition
    drop if exists category4_id,
    drop if exists category5_id,
    drop if exists category5_id,
    drop if exists category6_id,
    drop if exists category7_id,
    drop if exists category8_id,
    drop if exists category9_id,
    drop if exists category10_id;
--##
delete
from category_option
where category_id in ('INV_CAT4', 'INV_CAT5', 'INV_CAT6', 'INV_CAT7', 'INV_CAT8', 'INV_CAT9', 'INV_CAT10');
--##
delete
from category
where id in ('INV_CAT4', 'INV_CAT5', 'INV_CAT6', 'INV_CAT7', 'INV_CAT8', 'INV_CAT9', 'INV_CAT10');
--##
update account_type
set allow_account = true
where id in (5, 8);
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
                                category2_name, category3_id, category3_name, created_by, updated_by, created_at,
                                updated_at)
            values (old.id, _op_date, old.branch_id, old.division_id, old.division_name, old.branch_name,
                    old.warehouse_id, old.warehouse_name, old.party_id, old.party_name, old.vendor_id, old.vendor_name,
                    old.batch_id, old.inventory_id, old.reorder_inventory_id, old.inventory_name, old.inventory_hsn,
                    old.manufacturer_id, old.manufacturer_name, 0, 0, old.ref_no, true, old.category1_id,
                    old.category1_name, old.category2_id, old.category2_name, old.category3_id, old.category3_name,
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
update power_bi
set query = 'select id, inventory_id, closing, batch_no, mrp, s_rate, expiry, branch_id, warehouse_id, p_rate, opening_p_rate, cost, nlc, landing_cost, is_retail_qty, entry_date, entry_type, category1_id, category2_id, category3_id, category1_name, category2_name, category3_name from batch;'
where id = 9;
--##
update power_bi
set query = 'select id, name, retail_qty, reorder_inventory_id, hsn_code, manufacturer_id, category1_id, category1_name, category2_id, category2_name, category3_id, category3_name FROM inventory;'
where id = 8;
--##
UPDATE inventory
SET purchase_config = (
    purchase_config::jsonb
    - 'disc_1_editable'
    - 'disc_2_editable'
    || '{"disc1_editable": true, "disc2_editable": true}'::jsonb
)::json;
--##
alter table inventory alter sale_config drop default;
--##
alter table inventory alter purchase_config drop default;
--##
update batch set opening_p_rate = coalesce(landing_cost, nlc) where opening_p_rate is null;
--##
