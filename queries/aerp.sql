-- drop table if exists field_metadata;
-- drop table if exists model_metadata;
-- drop table if exists tbl_account;
-- drop table if exists udf_account_type;
-- drop table if exists function_metadata;

--## model_metadata
create table if not exists model_metadata
(
    name        text      not null primary key,
    permissions json      not null,
    created_at  timestamp not null,
    updated_at  timestamp not null
);
--##
--## field_metadata
create table if not exists field_metadata
(
    name         text      not null,
    model        text      not null,
    kind         text      not null,
    required     boolean   not null,
    is_computed  boolean   not null,
    value        text,
    assert       text,
    permissions  json      not null,
    created_at   timestamp not null,
    updated_at   timestamp not null,
    primary key (model, name)
);
--## field_metadata foreign keys
alter table field_metadata
    add constraint field_metadata_model_fkey foreign key (model) references model_metadata;
--##
create table if not exists function_metadata
(
    name       text      not null primary key,
    body       text      not null,
    is_async   boolean   not null,
    permission json      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--
select * from field_metadata where model = 'manufacturer';

select * from model_metadata;
select * from field_metadata;
select * from tbl_batch;
select * from tbl_manufacturer;
select * from udm_account;
select * from udm_account_type;
select * from tbl_member;
select * from function_metadata;

update tbl_account set name = 'krishna' where id = 1;

-- let a = await delete globalThis.db; "db deleted";
--     let c = await db.select('member',null,{'id':{'$eq':member_id}}); c[0].name;
--     let a = await delete globalThis.db; "db deleted";

--     let a = await delete globalThis.db; "db deleted";


-- ALTER TABLE account
--     ADD COLUMN IF NOT EXISTS first_name text;

-- "ALTER TABLE \"account\" ADD COLUMN IF NOT EXISTS \"first_name\" text"
-- insert into tbl_account (first_name, last_name) VALUES ('Ram', 'Raj');
-- alter table tbl_account add column  full_name text default concat(first_name,last_name);

--drop database if exists aerp_test;

-- DEFINE ASYNC FUNCTION getData AS "async function(a, b) { return a + b; };" ;
--
-- {method: "Execute", name: "getData", args: [1, "2"]}

--  SELECT * FROM tbl_account_type WHERE tbl_account_type.name = 'sundry_creditor';

-- let a = await db.select('member',null,{'id':{'$eq':member_id}}); a[0].pass;

-- local a = async function() return await(db:delete( 'udf_account_type', { ufd_id = { ['$eq'] = 2 } })) end