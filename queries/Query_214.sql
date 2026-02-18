create table new_relation_metadata as table relation_metadata;
select * from new_relation_metadata;

update new_relation_metadata set name = to_model || '_' || to_field;