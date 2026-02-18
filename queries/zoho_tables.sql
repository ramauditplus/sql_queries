-- ======================================================================================== --
-- Member table --

create table if not exists member
(
    id            int       not null generated always as identity primary key,
    name          text      not null unique,
    created_at    timestamp not null,
    updated_at    timestamp not null,
    created_by    int,
    updated_by    int
);

-- ======================================================================================== --
-- Division table --

create table if not exists division
(
    id         int       not null generated always as identity primary key,
    name       text      not null,
    created_at timestamp not null,
    updated_at timestamp not null,
    created_by int       not null,
    updated_by int       not null,
    changed_at timestamp not null
);

alter table division
    add constraint division_created_by_fkey foreign key (created_by) references member;

alter table division
    add constraint division_updated_by_fkey foreign key (updated_by) references member;


-- ======================================================================================== --
-- Inventory table --

create table if not exists inventory
(
    id                                int       not null generated always as identity primary key,
    name                              text      not null,
    division_id                       int       not null,
    created_at                        timestamp not null,
    updated_at                        timestamp not null,
    created_by                        int       not null,
    updated_by                        int       not null
);

alter table inventory
    add constraint inventory_division_id_fkey foreign key (division_id) references division;

alter table inventory
    add constraint inventory_created_by_fkey foreign key (created_by) references member;

alter table inventory
    add constraint inventory_updated_by_fkey foreign key (updated_by) references member;

-- ======================================================================================== --
-- Inventory Transaction table --

create table if not exists inv_txn
(
    id                   uuid not null primary key,
    date                 date not null,
    division_id          int  not null,
    inventory_id         int  not null,
    inventory_name       text not null,
    inward               float   default 0,
    outward              float   default 0,
    created_at           timestamp not null,
    updated_at           timestamp not null,
    created_by           int       not null,
    updated_by           int       not null
);

alter table inv_txn
    add constraint inv_txn_inventory_id_fkey foreign key (inventory_id) references inventory;

-- alter table inv_txn
--     add constraint inv_txn_division_id_fkey foreign key (division_id) references division;

alter table inv_txn
    add constraint inv_txn_created_by_fkey foreign key (created_by) references member;

alter table inv_txn
    add constraint inv_txn_updated_by_fkey foreign key (updated_by) references member;

