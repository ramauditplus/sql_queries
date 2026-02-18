alter table license
    add constraint license_created_by_fkey foreign key (created_by) references "user";
alter table organization
    add constraint organization_created_by_fkey foreign key (created_by) references "user";
