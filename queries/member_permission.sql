--## create table if not exists
create table if not exists member_permission
(
    name text not null primary key
);

--## add value to table
INSERT INTO member_permission (name)
VALUES ('view_branch'),
       ('create_branch'),
       ('update_branch'),
       ('delete_branch'),
       ('view_device'),
       ('create_device'),
       ('update_device'),
       ('delete_device'),
       ('generate_device_token'),
       ('view_pos_terminal'),
       ('create_pos_terminal'),
       ('update_pos_terminal'),
       ('deactivate_pos_terminal'),
       ('delete_pos_terminal'),
       ('generate_pos_terminal_token'),
       ('view_gst_registration'),
       ('create_gst_registration'),
       ('update_gst_registration'),
       ('delete_gst_registration'),
       ('view_member'),
       ('create_member'),
       ('update_member'),
       ('delete_member'),
       ('view_division'),
       ('create_division'),
       ('update_division'),
       ('delete_division'),
       ('view_drug_classification'),
       ('create_drug_classification'),
       ('update_drug_classification'),
       ('delete_drug_classification'),
       ('view_inventory_composition'),
       ('create_inventory_composition'),
       ('update_inventory_composition'),
       ('delete_inventory_composition'),
       ('view_area'),
       ('create_area'),
       ('update_area'),
       ('delete_area'),
       ('view_tag'),
       ('create_tag'),
       ('update_tag'),
       ('delete_tag'),
       ('view_approval_tag'),
       ('create_approval_tag'),
       ('update_approval_tag'),
       ('delete_approval_tag'),
       ('view_voucher_type'),
       ('create_voucher_type'),
       ('update_voucher_type'),
       ('delete_voucher_type'),
       ('view_category_option'),
       ('create_category_option'),
       ('update_category_option'),
       ('delete_category_option'),
       ('view_pos_counter'),
       ('create_pos_counter'),
       ('update_pos_counter'),
       ('delete_pos_counter'),
       ('view_role'),
       ('create_role'),
       ('update_role'),
       ('delete_role'),
       ('view_bank_beneficiary'),
       ('create_bank_beneficiary'),
       ('update_bank_beneficiary'),
       ('delete_bank_beneficiary'),
       ('view_dispatch_address'),
       ('create_dispatch_address'),
       ('update_dispatch_address'),
       ('delete_dispatch_address'),
       ('view_goods_inward_note'),
       ('create_goods_inward_note'),
       ('update_goods_inward_note'),
       ('delete_goods_inward_note'),
       ('view_gift_voucher'),
       ('create_gift_voucher'),
       ('delete_gift_voucher'),
       ('view_transport'),
       ('create_transport'),
       ('update_transport'),
       ('delete_transport'),
       ('view_offer_management'),
       ('create_offer_management'),
       ('update_offer_management'),
       ('delete_offer_management'),
       ('view_pos_server'),
       ('create_pos_server'),
       ('update_pos_server'),
       ('deactivate_pos_server'),
       ('generate_pos_server_token'),
       ('view_pos_offline_voucher'),
       ('submit_pos_offline_vouchers'),
       ('view_nature_of_payment'),
       ('create_nature_of_payment'),
       ('update_nature_of_payment'),
       ('delete_nature_of_payment'),
       ('view_account'),
       ('create_account'),
       ('update_account'),
       ('delete_account'),
       ('view_account_type'),
       ('create_account_type'),
       ('update_account_type'),
       ('delete_account_type'),
       ('view_payment'),
       ('create_payment'),
       ('update_payment'),
       ('delete_payment'),
       ('review_payment'),
       ('cancel_payment'),
       ('view_customer_advance'),
       ('create_customer_advance'),
       ('update_customer_advance'),
       ('delete_customer_advance'),
       ('view_eft_reconciliation_voucher'),
       ('create_eft_reconciliation_voucher'),
       ('update_eft_reconciliation_voucher'),
       ('delete_eft_reconciliation_voucher'),
       ('view_sales_emi_reconciliation_voucher'),
       ('create_sales_emi_reconciliation_voucher'),
       ('update_sales_emi_reconciliation_voucher'),
       ('delete_sales_emi_reconciliation_voucher'),
       ('view_memo'),
       ('create_memo'),
       ('update_memo'),
       ('delete_memo'),
       ('review_memo'),
       ('cancel_memo'),
       ('view_receipt'),
       ('create_receipt'),
       ('update_receipt'),
       ('delete_receipt'),
       ('review_receipt'),
       ('cancel_receipt'),
       ('view_contra'),
       ('create_contra'),
       ('update_contra'),
       ('delete_contra'),
       ('cancel_contra'),
       ('view_journal'),
       ('create_journal'),
       ('update_journal'),
       ('delete_journal'),
       ('cancel_journal'),
       ('view_inventory'),
       ('create_inventory'),
       ('update_inventory'),
       ('delete_inventory'),
       ('view_manufacturer'),
       ('create_manufacturer'),
       ('update_manufacturer'),
       ('delete_manufacturer'),
       ('view_pincode_distance'),
       ('create_pincode_distance'),
       ('update_pincode_distance'),
       ('delete_pincode_distance'),
       ('view_price_list'),
       ('create_price_list'),
       ('update_price_list'),
       ('delete_price_list'),
       ('view_unit'),
       ('create_unit'),
       ('update_unit'),
       ('delete_unit'),
       ('view_warehouse'),
       ('create_warehouse'),
       ('update_warehouse'),
       ('delete_warehouse'),
       ('view_sales_person'),
       ('create_sales_person'),
       ('update_sales_person'),
       ('delete_sales_person'),
       ('view_incentive_range'),
       ('create_incentive_range'),
       ('update_incentive_range'),
       ('delete_incentive_range'),
       ('view_bill_of_material'),
       ('create_bill_of_material'),
       ('update_bill_of_material'),
       ('delete_bill_of_material'),
       ('view_sale'),
       ('create_sale'),
       ('update_sale'),
       ('delete_sale'),
       ('cancel_sale'),
       ('view_sale_bill'),
       ('create_sale_bill'),
       ('update_sale_bill'),
       ('update_sale_bill_info'),
       ('delete_sale_bill'),
       ('cancel_sale_bill'),
       ('create_pos_offline_sale_bill'),
       ('view_delivery_note'),
       ('create_delivery_note'),
       ('update_delivery_note'),
       ('delete_delivery_note'),
       ('cancel_delivery_note'),
       ('view_delivery_receipt'),
       ('create_delivery_receipt'),
       ('update_delivery_receipt'),
       ('delete_delivery_receipt'),
       ('cancel_delivery_receipt'),
       ('create_sale_package'),
       ('verify_sale_package'),
       ('delete_sale_package'),
       ('view_shipment'),
       ('create_shipment'),
       ('update_shipment'),
       ('delete_shipment'),
       ('cancel_shipment'),
       ('view_vendor'),
       ('create_vendor'),
       ('update_vendor'),
       ('delete_vendor'),
       ('view_customer'),
       ('create_customer'),
       ('update_customer'),
       ('delete_customer'),
       ('view_doctor'),
       ('create_doctor'),
       ('update_doctor'),
       ('delete_doctor'),
       ('view_purchase'),
       ('create_purchase'),
       ('update_purchase'),
       ('delete_purchase'),
       ('cancel_purchase'),
       ('import_purchase'),
       ('view_purchase_bill'),
       ('create_purchase_bill'),
       ('update_purchase_bill'),
       ('delete_purchase_bill'),
       ('cancel_purchase_bill'),
       ('view_sale_quotation'),
       ('create_sale_quotation'),
       ('update_sale_quotation'),
       ('delete_sale_quotation'),
       ('view_credit_note'),
       ('create_credit_note'),
       ('update_credit_note'),
       ('delete_credit_note'),
       ('cancel_credit_note'),
       ('view_sale_return_bill'),
       ('create_sale_return_bill'),
       ('update_sale_return_bill'),
       ('delete_sale_return_bill'),
       ('cancel_sale_return_bill'),
       ('view_purchase_return_bill'),
       ('create_purchase_return_bill'),
       ('update_purchase_return_bill'),
       ('delete_purchase_return_bill'),
       ('cancel_purchase_return_bill'),
       ('view_debit_note'),
       ('create_debit_note'),
       ('update_debit_note'),
       ('delete_debit_note'),
       ('cancel_debit_note'),
       ('view_personal_use_purchase'),
       ('create_personal_use_purchase'),
       ('update_personal_use_purchase'),
       ('delete_personal_use_purchase'),
       ('cancel_personal_use_purchase'),
       ('view_manufacturing_journal'),
       ('create_manufacturing_journal'),
       ('update_manufacturing_journal'),
       ('delete_manufacturing_journal'),
       ('cancel_manufacturing_journal'),
       ('view_stock_journal'),
       ('create_stock_journal'),
       ('update_stock_journal'),
       ('delete_stock_journal'),
       ('view_stock_location'),
       ('create_stock_location'),
       ('update_stock_location'),
       ('delete_stock_location'),
       ('view_display_rack'),
       ('create_display_rack'),
       ('update_display_rack'),
       ('delete_display_rack'),
       ('batch_label'),
       ('tally_export'),
       ('rack_label'),
       ('cheque_book'),
       ('set_stock_value'),
       ('view_offline_voucher'),
       ('update_offline_voucher'),
       ('pos_counter_denomination'),
       ('pos_counter_settlement'),
       ('bill_wise_adjustment'),
       ('update_bill_due_date'),
       ('view_gate_entry'),
       ('create_gate_entry'),
       ('update_gate_entry'),
       ('exit_gate_entry'),
       ('delete_gate_entry'),
       ('account_book'),
       ('account_summary'),
       ('financial_report'),
       ('account_outstanding'),
       ('account_category_report'),
       ('account_transaction_history'),
       ('voucher_register'),
       ('sale_register'),
       ('purchase_register'),
       ('pos_counter_register'),
       ('stock_journal_register'),
       ('memorandum'),
       ('sale_incentive'),
       ('inventory_book'),
       ('inventory_transaction_history'),
       ('inventory_information'),
       ('reorder_analysis'),
       ('sales_by_tag'),
       ('scheduled_drug_report'),
       ('sale_reminder'),
       ('stock_analysis'),
       ('expiry_analysis'),
       ('negative_stock_analysis'),
       ('stock_closing_report'),
       ('non_movement_analysis'),
       ('sale_analysis'),
       ('bank_reconciliation'),
       ('bank_collection_summary'),
       ('payment_advice'),
       ('e_payment'),
       ('provisional_profit'),
       ('best_vendor'),
       ('set_inventory_branch_value'),
       ('comparative_voucher_analysis'),
       ('day_book'),
       ('day_summary'),
       ('gst_tax_breakup'),
       ('view_gst_r1'),
       ('gst_r1_save'),
       ('view_gst_r2'),
       ('gst_r2_save'),
       ('get_gstr_3b'),
       ('tds_summary'),
       ('update_hsn'),
       ('inventory_tagged_voucher'),
       ('approve_voucher'),
       ('category_mapping'),
       ('print_template'),
       ('financial_year'),
       ('vault'),
       ('account_opening'),
       ('inventory_opening'),
       ('inventory_price_config'),
       ('inventory_assign_stock_locations'),
       ('inventory_unit_conversion'),
       ('inventory_merge'),
       ('stock_location_wise_branch_stock'),
       ('apply_incentive_range'),
       ('update_batch'),
       ('preferred_vendor'),
       ('vendor_item_mapping'),
       ('customer_group'),
       ('delivery_address'),
       ('voucher_approval_status'),
       ('send_mail'),
       ('power_bi_report'),
       ('organization_email_config'),
       ('organization_aws_config'),
       ('organization_wanted_note_config'),
       ('view_wanted_note'),
       ('create_wanted_note'),
       ('update_wanted_note'),
       ('delete_wanted_note'),
       ('set_wanted_note_status'),
       ('branch_config'),
       ('aws_upload')
on conflict (name) do nothing;

--## add perm column to member table
alter table member
    add if not exists perms text[];

--## add ui_perms column to member table
alter table member
    add if not exists ui_perms text[];

--## set perms column value with member_role column name
update member
set ui_perms = member_role.perms
from member_role
where member_role.name = member.role_id;

update member
set perms = member_role.perms
from member_role
where member_role.name = member.role_id;

--## remove foreign key reference from the member table
alter table member
    drop constraint if exists member_role_id_fkey;

--## rename role_id to description
alter table member
    rename column role_id to description;

--## drop not null
alter table member
    alter column description drop not null;

--## drop member_role table if exists
drop table if exists member_role;

UPDATE member m
SET perms = (SELECT array_agg(DISTINCT val)
             FROM (SELECT CASE
                              -- remove unwanted
                              when elem in (
                                            'create_customer',
                                            'create_vendor',
                                            'create_transport',
                                            'update_customer',
                                            'update_vendor',
                                            'update_transport',
                                            'delete_customer',
                                            'delete_vendor',
                                            'delete_transport',
                                            'view_member',
                                            'create_pos_offline_sale_bill',
                                            'view_purchase',
                                            'view_account',
                                            'view_inventory',
                                            'update_pincode_distance'
                                  ) then null
                              -- other individual mappings
                              when elem = 'delivery_address' then 'set_delivery_address'
                              when elem = 'view_device' then 'get_device'
                              when elem = 'deactivate_pos_server' then 'deactivate_device'
                              when elem = 'financial_report' then 'opening_balance_difference'
                              when elem = 'sale_register' then 'sale_register_by_inventory'
                              when elem = 'view_gst_r1' then 'get_gst_r1'
                              when elem = 'get_gstr_3b' then 'get_gstr3b' -- check
                              when elem = 'inventory_price_config' then 'set_inventory_branch_price_configuration'
                              when elem = 'inventory_assign_stock_locations' then 'set_inventory_branch_stock_location'
                              when elem = 'rack_label' then 'get_inventory_branch_stock_location_label'
                              when elem = 'best_vendor' then 'get_best_vendor'
                              when elem = 'create_payment' then 'convert_memo_to_payment'
                              when elem = 'update_sale_bill_info' then 'update_sale_bill_information'
                              when elem = 'batch_label' then 'get_batch_label'
                              when elem = 'create_gift_voucher' then 'issue_gift_voucher'
                              when elem = 'view_wanted_note' then 'get_wanted_note'
                              when elem = 'inventory_unit_conversion' then 'set_unit_conversion'
                              when elem in ('create_pincode_distance', 'update_pincode_distance')
                                  then 'set_pincode_distance'

                              -- credit note mappings
                              when elem = 'create_sale_return_bill' then 'create_credit_note'
                              when elem = 'update_sale_return_bill' then 'update_credit_note'
                              when elem = 'cancel_sale_return_bill' then 'cancel_credit_note'
                              when elem = 'delete_sale_return_bill' then 'delete_credit_note'
                              -- debit note mappings
                              when elem = 'create_purchase_return_bill' then 'create_debit_note'
                              when elem = 'update_purchase_return_bill' then 'update_debit_note'
                              when elem = 'delete_purchase_return_bill' then 'delete_debit_note'
                              when elem = 'cancel_purchase_return_bill' then 'cancel_debit_note'
                              -- tally export mappings → expands into 6 new ones
                              when elem = 'tally_export' then array [
                                  'set_tally_account_map',
                                  'get_tally_account_map',
                                  'tally_export_data',
                                  'tally_export_master',
                                  'tally_export_voucher',
                                  'tally_export_b2c_sale_voucher'
                                  ]
                              -- stock_location_wise_branch_stock
                              when elem = 'stock_location_wise_branch_stock' then array [
                                  'get_stock_location_wise_branch_stock',
                                  'get_batch_detail_with_stock_location'
                                  ]
                              -- preferred_vendor
                              when elem = 'preferred_vendor' then array [
                                  'list_inventory_branch_preferred_vendor',
                                  'set_inventory_branch_preferred_vendor',
                                  'set_bulk_inventory_branch_preferred_vendor'
                                  ]
                              -- gst_r2_save
                              when elem = 'gst_r2_save' then array [
                                  'pull_gstr2b',
                                  'reconcile_gstr2b'
                                  ]
                              -- view_gst_r2
                              when elem = 'view_gst_r2' then array [
                                  'get_gstr2b',
                                  'upload_gstr2b',
                                  'import_gstr2b'
                                  ]
                              -- tds_summary
                              when elem = 'tds_summary' then array [
                                  'tds_section_breakup',
                                  'tds_detail',
                                  'tds_detail_summary'
                                  ]
                              -- inventory_book
                              when elem = 'inventory_book' then array [
                                  'inventory_book_summary',
                                  'inventory_book_detail',
                                  'inventory_book_group'
                                  ]
                              -- inventory_transaction_history
                              when elem = 'inventory_transaction_history' then array [
                                  'inventory_transaction_history_detail',
                                  'inventory_transaction_history_group'
                                  ]
                              -- view_stock_journal
                              when elem = 'view_stock_journal' then array [
                                  'get_stock_journal',
                                  'list_stock_journal'
                                  ]
                              -- view_pos_server
                              when elem = 'view_pos_server' then array [
                                  'get_pos_server',
                                  'list_pos_server'
                                  ]
                              -- view_pos_offline_voucher
                              when elem = 'view_pos_offline_voucher' then array [
                                  'get_pos_offline_voucher',
                                  'list_pos_offline_voucher'
                                  ]
                              -- view_gate_entry
                              when elem = 'view_gate_entry' then array [
                                  'get_gate_entry',
                                  'list_gate_entry'
                                  ]
                              -- aws_upload
                              when elem = 'aws_upload' then array [
                                  'upload_file',
                                  'download_file',
                                  'delete_file'
                                  ]
                              -- stock_journal_register
                              when elem = 'stock_journal_register' then array [
                                  'stock_journal_group',
                                  'stock_journal_summary'
                                  ]
                              -- voucher_register
                              when elem = 'voucher_register' then array [
                                  'voucher_register_detail',
                                  'voucher_register_group'
                                  ]
                              -- account_transaction_history
                              when elem = 'account_transaction_history' then array [
                                  'account_transaction_history_detail',
                                  'account_transaction_history_group'
                                  ]
                              -- account_category_report
                              when elem = 'account_category_report' then array [
                                  'account_category_summarized',
                                  'account_category_breakup',
                                  'account_category_detail',
                                  'account_category_group',
                                  'account_category_summary'
                                  ]
                              -- print_template
                              when elem = 'print_template' then array [
                                  'create_print_template',
                                  'update_print_template',
                                  'reset_print_template',
                                  'delete_print_template'
                                  ]
                              -- inventory_information
                              when elem = 'inventory_information' then array [
                                  'inventory_batch_detail',
                                  'partywise_detail'
                                  ]
                              -- provisional_profit
                              when elem = 'provisional_profit' then array [
                                  'provisional_profit_detail',
                                  'provisional_profit_group',
                                  'provisional_profit_summary'
                                  ]
                              -- bank_reconciliation
                              when elem = 'bank_reconciliation' then array [
                                  'get_bank_reconciliation',
                                  'set_bank_reconciliation'
                                  ]
                              -- account_book
                              when elem = 'account_book' then array [
                                  'account_book_summary',
                                  'account_book_memo_closing',
                                  'account_book_detail',
                                  'account_book_group'
                                  ]
                              -- set_stock_value
                              when elem = 'set_stock_value' then array [
                                  'set_stock_value_opening',
                                  'delete_stock_value_opening'
                                  ]
                              -- pos_counter_settlement
                              when elem = 'pos_counter_settlement' then array [
                                  'update_pos_counter_session',
                                  'pos_counter_settlement_create',
                                  'get_pos_counter_settlement',
                                  'list_pos_counter_settlement'
                                  ]
                              -- pos_counter_register
                              when elem = 'pos_counter_register' then array [
                                  'pos_counter_register_detail',
                                  'pos_counter_register_summary',
                                  'pos_counter_voucher_transaction_summary'
                                  ]
                              -- memorandum
                              when elem = 'memorandum' then array [
                                  'memorandum_list',
                                  'memorandum_book'
                                  ]
                              -- view_sale_bill
                              when elem = 'view_sale_bill' then array [
                                  'get_sale_reminder',
                                  'list_sale_reminder',
                                  'sale_register_detail',
                                  'sales_by_tag'
                                  ]
                              -- view_sale
                              when elem = 'view_sale' then array [
                                  'sale_register_detail',
                                  'sales_by_tag'
                                  ]
                              -- payment_advice
                              when elem = 'payment_advice' then array [
                                  'get_payment_advice',
                                  'update_email_payment_advice'
                                  ]
                              -- reorder_analysis
                              when elem = 'reorder_analysis' then array [
                                  'set_dynamic_order',
                                  'set_order_level',
                                  'get_order_level',
                                  'get_order_summary'
                                  ]
                              -- account_opening
                              when elem = 'account_opening' then array [
                                  'get_account_opening',
                                  'set_account_opening'
                                  ]
                              -- inventory_opening
                              when elem = 'inventory_opening' then array [
                                  'get_inventory_opening',
                                  'set_inventory_opening'
                                  ]
                              -- view_purchase_bill
                              when elem = 'view_purchase_bill' then array [
                                  'purchase_register_detail',
                                  'purchase_register_group',
                                  'purchase_register_summary',
                                  'get_vendor_bill_map',
                                  'get_vendor_item_map'
                                  ]
                              -- create_purchase_bill -- add if exists
                              when elem = 'create_purchase_bill' then
                                  array ['set_vendor_bill_map', 'set_vendor_item_map', 'remove_vendor_item_map', 'inventory_recent_purchase'] ||
                                  ARRAY [elem]
                              -- update_purchase_bill -- add if exists
                              when elem = 'update_purchase_bill' then
                                  array ['set_vendor_bill_map', 'set_vendor_item_map', 'remove_vendor_item_map'] ||
                                  array [elem]
                              -- create_price_list -- add if exists
                              when elem = 'create_price_list' then
                                  array ['create_price_list_condition','update_price_list_condition','delete_price_list_condition'] ||
                                  array [elem]
                              -- update_price_list -- add if exists
                              when elem = 'update_price_list' then
                                  array ['create_price_list_condition','update_price_list_condition','delete_price_list_condition'] ||
                                  array [elem]

                              -- everything else stays the same
                              ELSE elem
                              END AS val
                   FROM unnest(m.perms) AS elem) t
             where val is not null);