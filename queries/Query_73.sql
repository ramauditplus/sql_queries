select name, permissions, 'current_timestamp' as created_at,'current_timestamp' as updated_at from model_metadata;

INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('account_typee', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}'::json, now(), now());

select name, model, kind, required, permissions, 'current_timestamp' as created_at,'current_timestamp' as updated_at from field_metadata;

select name, from_model, from_field, to_model, to_field from relation_metadata;