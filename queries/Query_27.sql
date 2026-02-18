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
    created_at        timestamp not null --at at pos server end
);
--##

alter table pos_offline_voucher
    add constraint pos_offline_voucher_created_by_fkey foreign key (created_by) references member;