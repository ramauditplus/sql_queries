create table if not exists doctor
(
    id         int  not null generated always as identity primary key,
    first_name text not null,
    last_name  text,
    full_name  text
);