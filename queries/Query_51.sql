drop table if exists organization;

--## only in postgres database
create table if not exists organization
(
    id          uuid      not null primary key,
    name        text      not null unique,
    full_name   text      not null,
    country     text      not null,
    book_begin  date      not null,
    fp_code     smallint  not null,
    status      text      not null,
    plan_type   text      not null,
    branch      smallint  not null,
    pos_counter smallint  not null,
    voucher     int       not null,
    disk_serial text,
    serial_no   int,
    serial_key  text,
    license_token  text,
    gst_no      text,
    expiry_at      timestamp,
    created_at  timestamp not null,
    updated_at  timestamp not null,
    owned_by    text      not null
);
--##
insert into organization (id, name, full_name, country, book_begin, fp_code, status, plan_type, branch, pos_counter,
                          voucher, gst_no, serial_key, serial_no, expiry_at, created_at, updated_at, owned_by)
values (gen_random_uuid(), 'ambelaar', 'Ambelaar', 'INDIA', '2024-04-01', 4, 'ACTIVE', 'PREMIUM', 2, 1,
        5000, '33DBWPK7525L1ZY', 'yGkYX3UqCT4KH2NRu7Vmw', 1, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'auditplustech', 'Auditplus Technologies', 'INDIA', '2024-04-01', 4, 'ACTIVE', 'DEMO', 1, 1,
        1000, '33ABOFA5872B1ZJ', 'GvmQOdxUGiHVEaP1fXLzB', 2, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'mamedicals', 'MA Medicals', 'INDIA', '2023-04-01', 4, 'ACTIVE', 'PREMIUM', 15, 15,
        50000, '33ANEPA4609G3ZI', 'VhGbQORVE4Y70TdcBKoaI', 3, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'nrkstores', 'NRK STORES', 'INDIA', '2024-04-01', 4, 'ACTIVE', 'DEMO', 1, 1,
        1000, '33NRKST0000REZR', 'S6W9yocngyt7fwX8QVpUm', 4, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'rkmedicals', 'RK Medicals', 'INDIA', '2021-04-01', 4, 'ACTIVE', 'PREMIUM', 1, 1,
        5000, '33AFLPM9453K2ZW', '7v6rbwFZsyoECh4gtmWMj', 5, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'smagencies', 'S.M.Agencies', 'INDIA', '2024-04-01', 4, 'ACTIVE', 'DEMO', 1, 1,
        1000, '33ATGPM9683C1ZI', 'KPXGeREz3DUsJ0pYVWvA2', 6, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'testorg', 'Test Organization', 'INDIA', '2024-04-01', 4, 'ACTIVE', 'PREMIUM', 20, 20,
        10000, '29AABCT1332L000', 'L4hpuIoQWnVMdkHgA6c0T', 7, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'ttgold', 'TT GOLD', 'INDIA', '2022-04-01', 4, 'ACTIVE', 'PREMIUM', 5, 1,
        1000, '33AUYPM7448N1ZK', 'QswXpMLJcgbxYeFktRAN9', 8, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'ttgoldpalace', 'TT Gold Palace', 'INDIA', '2020-04-01', 4, 'ACTIVE', 'PREMIUM', 2, 1,
        1000, '33VNDOR0001AAZA', 'zDP4YXmEBx76H9KAcNjrG', 9, null, current_timestamp, current_timestamp, 'admin'),
       (gen_random_uuid(), 'tthangaraj', 'T Thangaraj', 'INDIA', '2019-04-01', 4, 'ACTIVE', 'DEMO', 1, 1,
        1000, '33TTGLD0001AAZH', 'x91NaUMMZsKoLYT5e0A2q', 10, null, current_timestamp, current_timestamp, 'admin');
--##