--## model_metadata
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('account_type', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('tds_nature_of_payment', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('account', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('country', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('branch', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('gst_registration', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('warehouse', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('organization', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('voucher_type', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('member_role', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('member', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('financial_year', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('unit', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('stock_location', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('manufacturer', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('bill_of_material', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('inventory', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('voucher_numbering', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('voucher', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('ac_txn', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "model_metadata"(name, permissions, created_at, updated_at)
VALUES ('inv_txn', '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
--## model_metadata
------------
--## field_metadata
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'account_type', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'account_type', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('allow_account', 'account_type', 'bool', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('allow_sub_type', 'account_type', 'bool', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('base_types', 'account_type', 'text[]', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('parent_id', 'account_type', 'int', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('default_name', 'account_type', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('description', 'account_type', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'account_type', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'account_type', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'account_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'account_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'account_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'tds_nature_of_payment', 'serial', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'tds_nature_of_payment', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('section', 'tds_nature_of_payment', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('ind_huf_rate', 'tds_nature_of_payment', 'float', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('ind_huf_rate_wo_pan', 'tds_nature_of_payment', 'float', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('other_deductee_rate', 'tds_nature_of_payment', 'float', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('other_deductee_rate_wo_pan', 'tds_nature_of_payment', 'float', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('threshold', 'tds_nature_of_payment', 'float', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'tds_nature_of_payment', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'tds_nature_of_payment', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'tds_nature_of_payment', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'tds_nature_of_payment', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'account', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'account', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('val_name', 'account', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('account_type_id', 'account', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('account_type_name', 'account', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('base_account_types', 'account', 'text[]', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('contact_type', 'account', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('is_default', 'account', 'bool', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('alias_name', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('short_name', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('description', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('sac_code', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_no', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_reg_type', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_location_id', 'account', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('bill_wise_detail', 'account', 'bool', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('transaction_enabled', 'account', 'bool', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('pan_no', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('aadhar_no', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('mobile', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('alternate_mobile', 'account', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('telephone', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('email', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('contact_person', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('address', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('city', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('pincode', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('state_id', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('country_id', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_tax', 'account', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('tds_nature_of_payment_id', 'account', 'int', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('tds_deductee_type', 'account', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'account', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'account', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'account', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'account', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'account', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'country', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'country', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('country_id', 'country', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'country', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'branch', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'branch', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('mobile', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('alternative_mobile', 'branch', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('email', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('telephone', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('contact_person', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('address', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('city', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('pincode', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('state_id', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('country_id', 'branch', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_registration_id', 'branch', 'int', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('misc', 'branch', 'json', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('configuration', 'branch', 'json', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('members', 'branch', 'int[]', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('account_id', 'branch', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_no_prefix', 'branch', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'branch', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'branch', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'branch', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'branch', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'branch', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'gst_registration', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'gst_registration', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('reg_type', 'gst_registration', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_no', 'gst_registration', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('state_id', 'gst_registration', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('username', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('email', 'gst_registration', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('trade_name', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('txn', 'gst_registration', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('e_invoice_username', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('e_password', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('eway_username', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('eway_password', 'gst_registration', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'gst_registration', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'gst_registration', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'gst_registration', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'gst_registration', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'gst_registration', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'warehouse', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'warehouse', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('mobile', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('email', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('telephone', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('address', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('city', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('pincode', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('state_id', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('country_id', 'warehouse', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'warehouse', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'warehouse', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'warehouse', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'warehouse', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'warehouse', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'organization', 'uuid', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'organization', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('full_name', 'organization', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('country', 'organization', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('book_begin', 'organization', 'date', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('fp_code', 'organization', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('status', 'organization', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('owned_by', 'organization', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_no', 'organization', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('configuration', 'organization', 'json', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('license_claims', 'organization', 'json', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('license_token', 'organization', 'text', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('reason', 'organization', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('token_validity', 'organization', 'timestamp', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('last_sync', 'organization', 'timestamp', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'organization', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'organization', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'organization', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'voucher_type', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'voucher_type', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('prefix', 'voucher_type', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('sequence_id', 'voucher_type', 'int', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('is_default', 'voucher_type', 'bool', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('auto_sequence', 'voucher_type', 'bool', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('base_type', 'voucher_type', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('config', 'voucher_type', 'json', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('members', 'voucher_type', 'json', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'voucher_type', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'voucher_type', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'voucher_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'voucher_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'voucher_type', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'member_role', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('perms', 'member_role', 'text[]', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'member_role', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'member_role', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'member_role', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'member_role', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'member_role', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'member', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'member', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('pass', 'member', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('is_root', 'member', 'bool', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('settings', 'member', 'json', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('role_id', 'member', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('nick_name', 'member', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'member', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'member', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'member', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'member', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'member', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'financial_year', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'financial_year', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('fy_start', 'financial_year', 'date', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('fy_end', 'financial_year', 'date', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'financial_year', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'financial_year', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'financial_year', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'financial_year', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'unit', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'unit', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('uqc', 'unit', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('symbol', 'unit', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('precision', 'unit', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'unit', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'unit', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'unit', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'unit', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'unit', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'stock_location', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'stock_location', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'stock_location', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'stock_location', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'stock_location', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'manufacturer', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'manufacturer', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('mobile', 'manufacturer', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('email', 'manufacturer', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('telephone', 'manufacturer', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'manufacturer', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'manufacturer', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'manufacturer', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'manufacturer', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'bill_of_material', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'bill_of_material', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('inventory_id', 'bill_of_material', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'bill_of_material', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'bill_of_material', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'bill_of_material', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'bill_of_material', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'inventory', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('name', 'inventory', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('val_name', 'inventory', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('inventory_type', 'inventory', 'text', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('gst_tax', 'inventory', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('unit_id', 'inventory', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('sale_account_id', 'inventory', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('purchase_account_id', 'inventory', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('sale_unit_id', 'inventory', 'int', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('purchase_unit_id', 'inventory', 'int', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('cess', 'inventory', 'json', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('sale_config', 'inventory', 'json', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('purchase_config', 'inventory', 'json', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('barcodes', 'inventory', 'text[]', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('hsn_code', 'inventory', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('description', 'inventory', 'text', false, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('manufacturer_id', 'inventory', 'int', false,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_by', 'inventory', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_by', 'inventory', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'inventory', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'inventory', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('changed_at', 'inventory', 'timestamp', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('branch_id', 'voucher_numbering', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('f_year_id', 'voucher_numbering', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_type_id', 'voucher_numbering', 'int', true,
        '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('seq', 'voucher_numbering', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'voucher', 'serial', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_prefix', 'voucher', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_fy', 'voucher', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_seq', 'voucher', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_no', 'voucher', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('branch_id', 'voucher', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('voucher_type_id', 'voucher', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('amount', 'voucher', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'ac_txn', 'uuid', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('account_id', 'ac_txn', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('account_name', 'ac_txn', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('credit', 'ac_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('debit', 'ac_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('amount', 'ac_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'ac_txn', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'ac_txn', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('id', 'inv_txn', 'uuid', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('inventory_id', 'inv_txn', 'int', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('inventory_name', 'inv_txn', 'text', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('qty', 'inv_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('rate', 'inv_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('inward', 'inv_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('outward', 'inv_txn', 'float', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}', now(),
        now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('created_at', 'inv_txn', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
INSERT INTO "field_metadata"(name, model, kind, required, permissions, created_at, updated_at)
VALUES ('updated_at', 'inv_txn', 'timestamp', true, '{"create":"Full","delete":"Full","select":"Full","update":"Full"}',
        now(), now());
--## field_metadata
-------------------------
--## relation_metadata
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_unit', 'unit', 'id', 'inventory', 'unit_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_sale_unit', 'unit', 'id', 'inventory', 'sale_unit_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_purchase_unit', 'unit', 'id', 'inventory', 'purchase_unit_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_sale_ac', 'account', 'id', 'inventory', 'sale_account_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_purchase_ac', 'account', 'id', 'inventory', 'purchase_account_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('inv_manufacturer', 'manufacturer', 'id', 'inventory', 'manufacturer_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_type_cr_member', 'member', 'id', 'account_type', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_type_up_member', 'member', 'id', 'account_type', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('tds_pmt_cr_member', 'member', 'id', 'tds_nature_of_payment', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('tds_pmt_up_member', 'member', 'id', 'tds_nature_of_payment', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_ac_type', 'account_type', 'id', 'account', 'account_type_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_country', 'country', 'id', 'account', 'country_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_state', 'country', 'id', 'account', 'state_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_gst_loc', 'country', 'id', 'account', 'gst_location_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_tds_pmt', 'tds_nature_of_payment', 'id', 'account', 'tds_nature_of_payment_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_cr_member', 'member', 'id', 'account', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('ac_up_member', 'member', 'id', 'account', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('branch_gst_reg', 'gst_registration', 'id', 'branch', 'gst_registration_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('branch_ac', 'account', 'id', 'branch', 'account_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('branch_country', 'country', 'id', 'branch', 'country_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('branch_state', 'country', 'id', 'branch', 'state_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('role_cr_member', 'member', 'id', 'member_role', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('role_up_member', 'member', 'id', 'member_role', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('member_role', 'member_role', 'name', 'member', 'role_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('member_cr_member', 'member', 'id', 'member', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('member_up_member', 'member', 'id', 'member', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('gst_reg_state', 'country', 'name', 'gst_registration', 'state_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('gst_reg_cr_member', 'member', 'id', 'gst_registration', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('gst_reg_up_member', 'member', 'id', 'gst_registration', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('warehouse_state', 'country', 'name', 'warehouse', 'state_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('warehouse_country', 'country', 'name', 'warehouse', 'country_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('warehouse_cr_member', 'member', 'id', 'warehouse', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('warehouse_up_member', 'member', 'id', 'warehouse', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('vch_type_cr_member', 'member', 'id', 'voucher_type', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('vch_type_up_member', 'member', 'id', 'voucher_type', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('fin_year_cr_member', 'member', 'id', 'financial_year', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('fin_year_up_member', 'member', 'id', 'financial_year', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('unit_cr_member', 'member', 'id', 'unit', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('unit_up_member', 'member', 'id', 'unit', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('stock_loc_cr_member', 'member', 'id', 'stock_location', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('stock_loc_up_member', 'member', 'id', 'stock_location', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('man_cr_member', 'member', 'id', 'manufacturer', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('man_up_member', 'member', 'id', 'manufacturer', 'updated_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('bom_inv', 'inventory', 'id', 'bill_of_material', 'inventory_id');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('bom_cr_member', 'member', 'id', 'bill_of_material', 'created_by');
INSERT INTO relation_metadata (name, from_model, from_field, to_model, to_field)
VALUES ('bom_up_member', 'member', 'id', 'bill_of_material', 'updated_by');
--## relation_metadata
