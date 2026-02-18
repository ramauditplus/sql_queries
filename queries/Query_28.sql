create table if not exists print_template
(
    id           int       not null generated always as identity primary key,
    name         text      not null,
    config       json,
    layout       text      not null,
    voucher_mode text,
    created_at   timestamp not null,
    updated_at   timestamp not null,
    created_by   int       not null,
    updated_by   int       not null
);
--##
create table if not exists print_layout
(
  id            text not null unique,
  template      text not null,
  sample_data   text not null
);