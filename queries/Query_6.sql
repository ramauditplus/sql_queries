alter table pos_server
    add constraint pos_server_branch_id_fkey foreign key (branch_id) references branch;

