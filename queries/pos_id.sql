--##
alter table inv_txn
    add if not exists pos_id int;
--##
drop trigger if exists tg_update_batch on batch;
--##
create or replace function tgf_insert_inv_txn()
    returns trigger as
$$
declare
    _batch batch;
    _allow_negative_stock bool := (select a.allow_negative_stock
                                   from inventory a
                                   where a.id = new.inventory_id);
begin
    update batch
        set inward = batch.inward + new.inward,
            outward = batch.outward + new.outward,
            changed_at = current_timestamp
    where id = new.batch_id returning batch.* into _batch;
        if new.pos_id is null and _batch.closing < 0 and not _allow_negative_stock then
            raise exception 'Insufficient Stock % %', _batch.inventory_name, coalesce(_batch.batch_no, '');
        end if;
    return new;
end;
$$ language plpgsql security definer;
--##
create or replace function tgf_update_inv_txn()
    returns trigger as
$$
declare
    _batch batch;
    _allow_negative_stock bool := (select a.allow_negative_stock
                                   from inventory a
                                   where a.id = new.inventory_id);
begin
    update batch
    set inward  = batch.inward + new.inward - old.inward,
        outward = batch.outward + new.outward - old.outward,
        changed_at = current_timestamp
    where id = new.batch_id returning batch.* into _batch;
        if old.pos_id is null and _batch.closing < 0 and not _allow_negative_stock then
            raise exception 'Insufficient Stock % %', _batch.inventory_name, coalesce(_batch.batch_no, '');
        end if;
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
    _allow_negative_stock bool := (select a.allow_negative_stock
                                   from inventory a
                                   where a.id = new.inventory_id);
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
                                category2_name, category3_id, category3_name, created_by, updated_by, created_at, updated_at)
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
    if old.pos_id is null and _batch.closing < 0 and not _allow_negative_stock then
        raise exception 'Insufficient Stock % %', _batch.inventory_name, coalesce(_batch.batch_no, '');
    end if;
    return old;
end;
$$ language plpgsql security definer;
--##