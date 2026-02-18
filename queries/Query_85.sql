alter table print_template
    drop constraint if exists print_template_layout_fkey;
--##
update print_layout
set id = 'SCHEDULED_DRUG'
where id = 'SALES_BY_TAG';
--##
update print_template
set layout = 'SCHEDULED_DRUG'
--     name   = 'default scheduled drug'
where layout = 'SALES_BY_TAG';
--##
alter table print_template
    add constraint print_template_layout_fkey foreign key (layout) references print_layout;
--##
do
$$
    begin
        IF current_database() LIKE '%medical%' THEN
            UPDATE inventory
            SET drug_classifications = (SELECT array_agg(tag)
                                        FROM unnest(tags) AS tag
                                        WHERE tag IN (1, 2, 3)),
                compositions         = (SELECT array_agg(tag)
                                        FROM unnest(tags) AS tag
                                        WHERE tag NOT IN (1, 2, 3))
            WHERE array_length(tags, 1) > 0;
--##
            insert into drug_classification(id, name, created_at, updated_at, created_by, updated_by)
                overriding system value (select t.id,
                                                t.name,
                                                t.created_at,
                                                t.updated_at,
                                                t.created_by,
                                                t.updated_by
                                         from tag t
                                         where id < 4)
            on conflict (id) do update set name = excluded.name;
--##
            insert into inventory_composition(id, name, created_at, updated_at, created_by, updated_by)
                overriding system value (select t.id,
                                                t.name,
                                                t.created_at,
                                                t.updated_at,
                                                t.created_by,
                                                t.updated_by
                                         from tag t
                                         where id > 3)
            on conflict (id) do update set name = excluded.name;
--##
            perform setval('inventory_composition_id_seq', COALESCE((SELECT MAX(id) FROM inventory_composition), 1));
--##
            perform setval('drug_classification_id_seq', COALESCE((SELECT MAX(id) FROM drug_classification), 1));
        end if;
    end;
$$;
