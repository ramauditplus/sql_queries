UPDATE member_role r
SET perms = (
    SELECT array_agg(DISTINCT COALESCE(m.new_perm, p))
    FROM unnest(r.perms) AS p
    LEFT JOIN (
        VALUES

-- account
('view_account','account_get'),
('create_account','account_create'),
('update_account','account_update'),
('delete_account','account_delete'),

-- account type
('view_account_type','account_type_get'),
('create_account_type','account_type_create'),
('update_account_type','account_type_update'),
('delete_account_type','account_type_delete'),

-- bank beneficiary
('view_bank_beneficiary','bank_beneficiary_get'),
('create_bank_beneficiary','bank_beneficiary_create'),
('update_bank_beneficiary','bank_beneficiary_update'),
('delete_bank_beneficiary','bank_beneficiary_delete'),

-- branch
('view_branch','branch_get'),
('create_branch','branch_create'),
('update_branch','branch_update'),
('delete_branch','branch_delete'),

-- customer
('view_customer','account_get'),
('create_customer','account_create'),
('update_customer','account_update'),
('delete_customer','account_delete'),

-- vendor
('view_vendor','account_get'),
('create_vendor','account_create'),
('update_vendor','account_update'),
('delete_vendor','account_delete'),

-- doctor
('view_doctor','doctor_get'),
('create_doctor','doctor_create'),
('update_doctor','doctor_update'),
('delete_doctor','doctor_delete'),

-- member
('view_member','member_get'),
('create_member','member_create'),
('update_member','member_update'),

-- inventory
('view_inventory','inventory_get'),
('create_inventory','inventory_create'),
('update_inventory','inventory_update'),
('delete_inventory','inventory_delete'),

-- manufacturer
('view_manufacturer','manufacturer_get'),
('create_manufacturer','manufacturer_create'),
('update_manufacturer','manufacturer_update'),
('delete_manufacturer','manufacturer_delete'),

-- warehouse
('view_warehouse','warehouse_get'),
('create_warehouse','warehouse_create'),
('update_warehouse','warehouse_update'),
('delete_warehouse','warehouse_delete'),

-- unit
('view_unit','unit_get'),
('create_unit','unit_create'),
('update_unit','unit_update'),
('delete_unit','unit_delete'),

-- stock location
('view_stock_location','stock_location_get'),
('create_stock_location','stock_location_create'),
('update_stock_location','stock_location_update'),
('delete_stock_location','stock_location_delete'),

-- voucher type
('view_voucher_type','voucher_type_get'),
('create_voucher_type','voucher_type_create'),
('update_voucher_type','voucher_type_update'),
('delete_voucher_type','voucher_type_delete'),

-- voucher generic
('create_voucher','voucher_create'),
('update_voucher','voucher_update'),
('view_voucher','voucher_get'),
('delete_voucher','voucher_delete'),
('cancel_voucher','voucher_cancel'),

-- GST
('view_gst_registration','gst_registration_get'),
('create_gst_registration','gst_registration_create'),
('update_gst_registration','gst_registration_update'),
('delete_gst_registration','gst_registration_delete'),

-- reports
('account_book','account_book'),
('account_summary','account_summary'),
('financial_report','financial_report'),
('account_outstanding','account_outstanding'),
('account_transaction_history','account_transaction_history'),

-- inventory reports
('inventory_book','inventory_book'),
('inventory_transaction_history','inventory_transaction_history'),

-- stock reports
('stock_analysis','stock_analysis'),
('expiry_analysis','expiry_analysis'),
('negative_stock_analysis','negative_stock_analysis'),
('non_movement_analysis','non_movement_analysis'),

-- sales analysis
('sale_analysis','sale_analysis'),

-- banking
('bank_collection_summary','bank_collection'),
('bank_reconciliation','bank_reconciliation'),

-- day
('day_book','day_book'),

-- GST returns
('view_gst_r1','gst_r1'),

-- batch
('batch_label','batch_label'),

-- opening
('account_opening','account_opening'),
('inventory_opening','inventory_opening'),

-- email / organization
('organization_email_config','organization_update'),
('organization_aws_config','organization_update'),

-- wanted items
('view_wanted_note','wanted_item_configuration'),
('create_wanted_note','wanted_item_configuration'),
('update_wanted_note','wanted_item_configuration'),
('delete_wanted_note','wanted_item_configuration'),
('set_wanted_note_status','wanted_item_status')

    ) AS m(old_perm, new_perm)
    ON m.old_perm = p
);

UPDATE member_role r
SET perms = (
    SELECT array_agg(DISTINCT m.new_perm)
    FROM unnest(r.perms) AS p
    JOIN (
        VALUES

-- account
('view_account','account_get'),
('create_account','account_create'),
('update_account','account_update'),
('delete_account','account_delete'),

-- account type
('view_account_type','account_type_get'),
('create_account_type','account_type_create'),
('update_account_type','account_type_update'),
('delete_account_type','account_type_delete'),

-- bank beneficiary
('view_bank_beneficiary','bank_beneficiary_get'),
('create_bank_beneficiary','bank_beneficiary_create'),
('update_bank_beneficiary','bank_beneficiary_update'),
('delete_bank_beneficiary','bank_beneficiary_delete'),

-- branch
('view_branch','branch_get'),
('create_branch','branch_create'),
('update_branch','branch_update'),
('delete_branch','branch_delete'),

-- customer
('view_customer','account_get'),
('create_customer','account_create'),
('update_customer','account_update'),
('delete_customer','account_delete'),

-- vendor
('view_vendor','account_get'),
('create_vendor','account_create'),
('update_vendor','account_update'),
('delete_vendor','account_delete'),

-- doctor
('view_doctor','doctor_get'),
('create_doctor','doctor_create'),
('update_doctor','doctor_update'),
('delete_doctor','doctor_delete'),

-- member
('view_member','member_get'),
('create_member','member_create'),
('update_member','member_update'),

-- inventory
('view_inventory','inventory_get'),
('create_inventory','inventory_create'),
('update_inventory','inventory_update'),
('delete_inventory','inventory_delete'),

-- manufacturer
('view_manufacturer','manufacturer_get'),
('create_manufacturer','manufacturer_create'),
('update_manufacturer','manufacturer_update'),
('delete_manufacturer','manufacturer_delete'),

-- warehouse
('view_warehouse','warehouse_get'),
('create_warehouse','warehouse_create'),
('update_warehouse','warehouse_update'),
('delete_warehouse','warehouse_delete'),

-- unit
('view_unit','unit_get'),
('create_unit','unit_create'),
('update_unit','unit_update'),
('delete_unit','unit_delete'),

-- stock location
('view_stock_location','stock_location_get'),
('create_stock_location','stock_location_create'),
('update_stock_location','stock_location_update'),
('delete_stock_location','stock_location_delete'),

-- voucher type
('view_voucher_type','voucher_type_get'),
('create_voucher_type','voucher_type_create'),
('update_voucher_type','voucher_type_update'),
('delete_voucher_type','voucher_type_delete'),

-- voucher generic
('create_voucher','voucher_create'),
('update_voucher','voucher_update'),
('view_voucher','voucher_get'),
('delete_voucher','voucher_delete'),
('cancel_voucher','voucher_cancel'),

-- GST
('view_gst_registration','gst_registration_get'),
('create_gst_registration','gst_registration_create'),
('update_gst_registration','gst_registration_update'),
('delete_gst_registration','gst_registration_delete'),

-- reports
('account_book','account_book'),
('account_summary','account_summary'),
('financial_report','financial_report'),
('account_outstanding','account_outstanding'),
('account_transaction_history','account_transaction_history'),

-- inventory reports
('inventory_book','inventory_book'),
('inventory_transaction_history','inventory_transaction_history'),

-- stock reports
('stock_analysis','stock_analysis'),
('expiry_analysis','expiry_analysis'),
('negative_stock_analysis','negative_stock_analysis'),
('non_movement_analysis','non_movement_analysis'),

-- sales analysis
('sale_analysis','sale_analysis'),

-- banking
('bank_collection_summary','bank_collection'),
('bank_reconciliation','bank_reconciliation'),

-- day
('day_book','day_book'),

-- GST returns
('view_gst_r1','gst_r1'),

-- batch
('batch_label','batch_label'),

-- opening
('account_opening','account_opening'),
('inventory_opening','inventory_opening'),

-- email / organization
('organization_email_config','organization_update'),
('organization_aws_config','organization_update'),

-- wanted items
('view_wanted_note','wanted_item_configuration'),
('create_wanted_note','wanted_item_configuration'),
('update_wanted_note','wanted_item_configuration'),
('delete_wanted_note','wanted_item_configuration'),
('set_wanted_note_status','wanted_item_status')

    ) AS m(old_perm, new_perm)
    ON m.old_perm = p
);