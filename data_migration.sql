--## merge inventory based on reorder_inventory_id
with a as (select coalesce(reorder_inventory_id, id)                              as inv_id,
                  array_agg(id) filter ( where reorder_inventory_id is not null ) as inv_ids
           from inventory
           group by inv_id
           having count(1) > 1),
     b as (update batch
         set inventory_id = a.inv_id
         from a
         where inventory_id = any (a.inv_ids)),
     c as (update inv_txn
         set inventory_id = a.inv_id
         from a
         where inventory_id = any (a.inv_ids)),
     d as (delete
         from inventory_branch_detail
             where inventory_id = any (a.inv_ids))
delete
from inventory
where id = any (a.inv_ids);
--## set batch_no 1 if batch_no is null and also remove space with UPPER Case
update batch
set batch_no = coalesce(nullif(upper(regexp_replace(batch_no, '\s+', '', 'g')), ''), '1');
--##
alter table batch
    alter batch_no set not null;
--## duplicate batch_no fixed, with concat batch_no, - , id
with a as
         (select array_agg(id) as ids
          from batch
          group by branch_id, warehouse_id, inventory_id, vendor_id, batch_no
          having count(1) > 1)
update batch b
set batch_no = b.batch_no || '-' || b.id::text
from a
where b.id = any (a.ids);
--##
drop table if exists unit;
--##
create table if not exists unit
(
    id         serial primary key,
    name       text      not null,
    uqc        text      not null,
    symbol     text      not null,
    precision  integer   not null,
    created_by integer   not null,
    updated_by integer   not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    changed_at timestamp not null
);
--##
drop table if exists unit_conversion;
--##
create table if not exists unit_conversion
(
    primary_unit_id    int   not null,
    conversion_unit_id int   not null,
    conversion         float not null,
    dummy_unit_name    text,
    primary key (primary_unit_id, conversion)
);
--##
with a as (select distinct retail_qty as x
           from batch
           order by retail_qty),
     b as (insert
         into unit (name, uqc, symbol, precision, created_at, updated_at, changed_at, created_by, updated_by)
             select case when a.x = 1 then 'PCS' else a.x::text || 'S' end,
                    'OTH',
                    case when a.x = 1 then 'PCS' else a.x::text || 'S' end,
                    a.x,
                    now(),
                    now(),
                    now(),
                    1,
                    1
             from a returning unit.*)
insert
into unit_conversion(primary_unit_id, conversion_unit_id, conversion, dummy_unit_name)
select 1, b.id, b.precision, b.name
from b;
--##
update batch b
set unit_conv = u.conversion,
    unit_id   = u.conversion_unit_id,
    unit_name = u.dummy_unit_name
from unit_conversion u
where u.conversion = b.retail_qty
  and not b.is_retail_qty;
--##
alter table unit_conversion
    drop if exists dummy_unit_name;
--##
update batch
set unit_conv = 1,
    unit_id   = 1
where is_retail_qty;
--##
update inv_txn i
set batch_no  = b.batch_no,
    vendor_id = b.vendor_id
from batch b
where i.batch_id = b.id;
--##
alter table inv_txn
    alter batch_no set not null;
