--## create table if not exists
create table if not exists member_permission
(
    name text not null primary key
);

--## add value to table
INSERT INTO member_permission (name)
VALUES ('view_branch'),
       ('create_branch'),                           --ep
       ('update_branch'),                           --ep
       ('delete_branch'),                           --ep
       ('view_device'),                             --
       ('create_device'),                           --ep
       ('update_device'),                           --ep
       ('delete_device'),                           --ep
       ('generate_device_token'),                   --ep
       ('view_pos_terminal'),
       ('create_pos_terminal'),
       ('update_pos_terminal'),
       ('deactivate_pos_terminal'),
       ('delete_pos_terminal'),
       ('generate_pos_terminal_token'),
       ('view_gst_registration'),
       ('create_gst_registration'),                 --ep
       ('update_gst_registration'),                 --ep
       ('delete_gst_registration'),                 --ep
       ('view_member'),                             --
       ('create_member'),                           --ep
       ('update_member'),                           --ep
       ('delete_member'),                           --ep
       ('view_division'),
       ('create_division'),                         --ep
       ('update_division'),                         --ep
       ('delete_division'),                         --ep
       ('view_drug_classification'),
       ('create_drug_classification'),              --ep
       ('update_drug_classification'),              --ep
       ('delete_drug_classification'),              --ep
       ('view_inventory_composition'),
       ('create_inventory_composition'),            --ep
       ('update_inventory_composition'),            --ep
       ('delete_inventory_composition'),            --ep
       ('view_area'),
       ('create_area'),                             --ep
       ('update_area'),                             --ep
       ('delete_area'),                             --ep
       ('view_tag'),
       ('create_tag'),                              --ep
       ('update_tag'),                              --ep
       ('delete_tag'),                              --ep
       ('view_approval_tag'),
       ('create_approval_tag'),                     --ep
       ('update_approval_tag'),                     --ep
       ('delete_approval_tag'),                     --ep
       ('view_voucher_type'),
       ('create_voucher_type'),                     --ep
       ('update_voucher_type'),                     --ep
       ('delete_voucher_type'),                     --ep
       ('view_category_option'),
       ('create_category_option'),                  --ep
       ('update_category_option'),                  --ep
       ('delete_category_option'),                  --ep
       ('view_pos_counter'),
       ('create_pos_counter'),                      --ep
       ('update_pos_counter'),                      --ep
       ('delete_pos_counter'),                      --ep
       ('view_role'),
       ('create_role'),
       ('update_role'),
       ('delete_role'),
       ('view_bank_beneficiary'),
       ('create_bank_beneficiary'),                 --ep
       ('update_bank_beneficiary'),                 --ep
       ('delete_bank_beneficiary'),                 --ep
       ('view_dispatch_address'),
       ('create_dispatch_address'),                 --ep
       ('update_dispatch_address'),                 --ep
       ('delete_dispatch_address'),                 --ep
       ('view_goods_inward_note'),
       ('create_goods_inward_note'),                --ep
       ('update_goods_inward_note'),                --ep
       ('delete_goods_inward_note'),                --ep
       ('view_gift_voucher'),
       ('create_gift_voucher'),                     --
       ('delete_gift_voucher'),                     --ep
       ('view_transport'),
       ('create_transport'),                        --
       ('update_transport'),                        --
       ('delete_transport'),                        --
       ('view_offer_management'),
       ('create_offer_management'),                 --ep
       ('update_offer_management'),                 --ep
       ('delete_offer_management'),                 --ep
       ('view_pos_server'),                         --
       ('create_pos_server'),                       --ep
       ('update_pos_server'),                       --ep
       ('deactivate_pos_server'),                   --ep
       ('generate_pos_server_token'),               --ep
       ('view_pos_offline_voucher'),                --
       ('submit_pos_offline_vouchers'),             --ep
       ('view_nature_of_payment'),
       ('create_nature_of_payment'),
       ('update_nature_of_payment'),
       ('delete_nature_of_payment'),
       ('view_account'),                            --
       ('create_account'),                          --ep
       ('update_account'),                          --ep
       ('delete_account'),                          --ep
       ('view_account_type'),
       ('create_account_type'),                     --ep
       ('update_account_type'),                     --ep
       ('delete_account_type'),                     --ep
       ('view_payment'),
       ('create_payment'),                          --
       ('update_payment'),
       ('delete_payment'),
       ('review_payment'),
       ('cancel_payment'),
       ('view_customer_advance'),
       ('create_customer_advance'),                 --ep
       ('update_customer_advance'),                 --ep
       ('delete_customer_advance'),                 --ep
       ('view_eft_reconciliation_voucher'),
       ('create_eft_reconciliation_voucher'),       --ep
       ('update_eft_reconciliation_voucher'),
       ('delete_eft_reconciliation_voucher'),       --ep
       ('view_sales_emi_reconciliation_voucher'),
       ('create_sales_emi_reconciliation_voucher'), --ep
       ('update_sales_emi_reconciliation_voucher'),
       ('delete_sales_emi_reconciliation_voucher'), --ep
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
       ('view_inventory'),                          --
       ('create_inventory'),                        --ep
       ('update_inventory'),                        --ep
       ('delete_inventory'),                        --ep
       ('view_manufacturer'),
       ('create_manufacturer'),                     --ep
       ('update_manufacturer'),                     --ep
       ('delete_manufacturer'),                     --ep
       ('view_pincode_distance'),
       ('create_pincode_distance'),                 --
       ('update_pincode_distance'),                 --
       ('delete_pincode_distance'),                 --ep
       ('view_price_list'),
       ('create_price_list'),                       --ep
       ('update_price_list'),                       --ep
       ('delete_price_list'),                       --ep
       ('view_unit'),
       ('create_unit'),                             --ep
       ('update_unit'),                             --ep
       ('delete_unit'),                             --ep
       ('view_warehouse'),
       ('create_warehouse'),                        --ep
       ('update_warehouse'),                        --ep
       ('delete_warehouse'),                        --ep
       ('view_sales_person'),
       ('create_sales_person'),                     --ep
       ('update_sales_person'),                     --ep
       ('delete_sales_person'),                     --ep
       ('view_incentive_range'),
       ('create_incentive_range'),                  --ep
       ('update_incentive_range'),                  --ep
       ('delete_incentive_range'),                  --ep
       ('view_bill_of_material'),
       ('create_bill_of_material'),                 --ep
       ('update_bill_of_material'),                 --ep
       ('delete_bill_of_material'),                 --ep
       ('view_sale'),                               --
       ('create_sale'),
       ('update_sale'),
       ('delete_sale'),
       ('cancel_sale'),
       ('view_sale_bill'),                          --
       ('create_sale_bill'),                        --ep
       ('update_sale_bill'),                        --ep
       ('update_sale_bill_info'),                   --
       ('delete_sale_bill'),                        --ep
       ('cancel_sale_bill'),                        --ep
       ('create_pos_offline_sale_bill'),            --
       ('view_delivery_note'),
       ('create_delivery_note'),                    --ep
       ('update_delivery_note'),                    --ep
       ('delete_delivery_note'),                    --ep
       ('cancel_delivery_note'),
       ('view_delivery_receipt'),
       ('create_delivery_receipt'),                 --ep
       ('update_delivery_receipt'),                 --ep
       ('delete_delivery_receipt'),                 --ep
       ('cancel_delivery_receipt'),
       ('create_sale_package'),                     --ep
       ('verify_sale_package'),                     --ep
       ('delete_sale_package'),                     --ep
       ('view_shipment'),
       ('create_shipment'),                         --ep
       ('update_shipment'),                         --ep
       ('delete_shipment'),                         --ep
       ('cancel_shipment'),
       ('view_vendor'),
       ('create_vendor'),                           --
       ('update_vendor'),                           --
       ('delete_vendor'),                           --
       ('view_customer'),
       ('create_customer'),                         --
       ('update_customer'),                         --
       ('delete_customer'),                         --
       ('view_doctor'),
       ('create_doctor'),                           --ep
       ('update_doctor'),                           --ep
       ('delete_doctor'),                           --ep
       ('view_purchase'),                           --
       ('create_purchase'),
       ('update_purchase'),
       ('delete_purchase'),
       ('cancel_purchase'),
       ('import_purchase'),
       ('view_purchase_bill'),                      --
       ('create_purchase_bill'),                    --ep
       ('update_purchase_bill'),                    --ep
       ('delete_purchase_bill'),                    --ep
       ('cancel_purchase_bill'),                    --ep
       ('view_sale_quotation'),
       ('create_sale_quotation'),                   --ep
       ('update_sale_quotation'),                   --ep
       ('delete_sale_quotation'),                   --ep
       ('view_credit_note'),
       ('create_credit_note'),                      --ep
       ('update_credit_note'),                      --ep
       ('delete_credit_note'),                      --ep
       ('cancel_credit_note'),                      --ep
       ('view_sale_return_bill'),
       ('create_sale_return_bill'),                 --
       ('update_sale_return_bill'),                 --
       ('delete_sale_return_bill'),                 --
       ('cancel_sale_return_bill'),                 --
       ('view_purchase_return_bill'),
       ('create_purchase_return_bill'),             --
       ('update_purchase_return_bill'),             --
       ('delete_purchase_return_bill'),             --
       ('cancel_purchase_return_bill'),             --
       ('view_debit_note'),
       ('create_debit_note'),                       --ep
       ('update_debit_note'),                       --ep
       ('delete_debit_note'),                       --ep
       ('cancel_debit_note'),                       --ep
       ('view_personal_use_purchase'),
       ('create_personal_use_purchase'),            --ep
       ('update_personal_use_purchase'),            --ep
       ('delete_personal_use_purchase'),            --ep
       ('cancel_personal_use_purchase'),
       ('view_manufacturing_journal'),
       ('create_manufacturing_journal'),
       ('update_manufacturing_journal'),
       ('delete_manufacturing_journal'),
       ('cancel_manufacturing_journal'),
       ('view_stock_journal'),                      --
       ('create_stock_journal'),                    --ep
       ('update_stock_journal'),                    --ep
       ('delete_stock_journal'),                    --ep
       ('view_stock_location'),
       ('create_stock_location'),                   --ep
       ('update_stock_location'),                   --ep
       ('delete_stock_location'),                   --ep
       ('view_display_rack'),
       ('create_display_rack'),                     --ep
       ('update_display_rack'),                     --ep
       ('delete_display_rack'),                     --ep
       ('batch_label'),                             --
       ('tally_export'),                            --
       ('rack_label'),                              --
       ('cheque_book'),
       ('set_stock_value'),                         --ep
       ('view_offline_voucher'),
       ('update_offline_voucher'),
       ('pos_counter_denomination'),
       ('pos_counter_settlement'),                  --
       ('bill_wise_adjustment'),                    --ep
       ('update_bill_due_date'),                    --ep
       ('view_gate_entry'),                         --
       ('create_gate_entry'),                       --ep
       ('update_gate_entry'),                       --ep
       ('exit_gate_entry'),                         --ep
       ('delete_gate_entry'),                       --ep
       ('account_book'),                            --
       ('account_summary'),
       ('financial_report'),                        --
       ('account_outstanding'),                     --ep
       ('account_category_report'),                 --
       ('account_transaction_history'),             --
       ('voucher_register'),                        --
       ('sale_register'),                           --
       ('purchase_register'),
       ('pos_counter_register'),                    --
       ('stock_journal_register'),                  --
       ('memorandum'),                              --
       ('sale_incentive'),
       ('inventory_book'),                          --
       ('inventory_transaction_history'),           --
       ('inventory_information'),                   --
       ('reorder_analysis'),                        --
       ('sales_by_tag'),                            --ep
       ('scheduled_drug_report'),                   --ep
       ('sale_reminder'),
       ('stock_analysis'),                          --ep
       ('expiry_analysis'),                         --ep
       ('negative_stock_analysis'),                 --ep
       ('stock_closing_report'),                    --ep
       ('non_movement_analysis'),                   --ep
       ('sale_analysis'),                           --ep
       ('bank_reconciliation'),                     --
       ('bank_collection_summary'),                 --ep
       ('payment_advice'),                          --
       ('e_payment'),
       ('provisional_profit'),                      --
       ('best_vendor'),                             --
       ('set_inventory_branch_value'),              --ep
       ('comparative_voucher_analysis'),
       ('day_book'),                                --ep
       ('day_summary'),                             --ep
       ('gst_tax_breakup'),                         --ep
       ('view_gst_r1'),                             --
       ('gst_r1_save'),
       ('view_gst_r2'),                             --
       ('gst_r2_save'),                             --
       ('get_gstr_3b'),                             --
       ('tds_summary'),                             --
       ('update_hsn'),                              --ep
       ('inventory_tagged_voucher'),
       ('approve_voucher'),                         --ep
       ('category_mapping'),
       ('print_template'),                          --
       ('financial_year'),
       ('vault'),
       ('account_opening'),                         --
       ('inventory_opening'),                       --
       ('inventory_price_config'),                  --
       ('inventory_assign_stock_locations'),        --
       ('inventory_unit_conversion'),               --
       ('inventory_merge'),
       ('stock_location_wise_branch_stock'),        --
       ('apply_incentive_range'),                   --ep
       ('update_batch'),                            --ep
       ('preferred_vendor'),                        --
       ('vendor_item_mapping'),
       ('customer_group'),
       ('delivery_address'),                        --
       ('voucher_approval_status'),                 --ep
       ('send_mail'),                               --ep
       ('power_bi_report'),
       ('organization_email_config'),
       ('organization_aws_config'),
       ('organization_wanted_note_config'),
       ('view_wanted_note'),                        --
       ('create_wanted_note'),                      --ep
       ('update_wanted_note'),                      --ep
       ('delete_wanted_note'),                      --ep
       ('set_wanted_note_status'),                  --ep
       ('branch_config'),
       ('aws_upload')                               --
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
             FROM (SELECT unnest(
                                  CASE
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
                                                    'view_inventory'
                                          ) then null

                                      -- replace with single value
                                      -- other individual mappings
                                      when elem = 'delivery_address' then array ['set_delivery_address']
                                      when elem = 'view_device' then array ['get_device']
                                      when elem = 'financial_report' then array ['opening_balance_difference']
                                      when elem = 'sale_register' then array ['sale_register_by_inventory']
                                      when elem = 'view_gst_r1' then array ['get_gst_r1']
                                      when elem = 'get_gstr_3b' then array ['get_gstr3b']
                                      when elem = 'inventory_price_config' then array ['set_inventory_branch_price_configuration']
                                      when elem = 'inventory_assign_stock_locations' then array ['set_inventory_branch_stock_location']
                                      when elem = 'rack_label' then array ['get_inventory_branch_stock_location_label']
                                      when elem = 'best_vendor' then array ['get_best_vendor']
                                      when elem = 'create_payment' then array ['convert_memo_to_payment']
                                      when elem = 'update_sale_bill_info' then array ['update_sale_bill_information']
                                      when elem = 'batch_label' then array ['get_batch_label']
                                      when elem = 'create_gift_voucher' then array ['issue_gift_voucher']
                                      when elem = 'view_wanted_note' then array ['get_wanted_note']
                                      when elem = 'inventory_unit_conversion' then array ['set_unit_conversion']
                                      when elem = 'view_sale_quotation' then array ['get_sale_quotation']
                                      when elem = 'category_mapping' then array ['set_category']
                                      when elem = 'create_nature_of_payment' then array ['create_tds_nature_of_payment']
                                      when elem = 'update_nature_of_payment' then array ['update_tds_nature_of_payment']
                                      when elem = 'delete_nature_of_payment' then array ['delete_tds_nature_of_payment']
                                      when elem = 'financial_year' then array ['create_financial_year']
                                      when elem = 'inventory_merge' then array ['merge_inventory']
                                      when elem = 'sale_incentive' then array ['sales_incentive_rangewise']
                                      when elem = 'sale_reminder' then array ['generate_sale_reminder_order']
                                      when elem = 'create_sale_return_bill' then array ['create_credit_note']
                                      when elem = 'update_sale_return_bill' then array ['update_credit_note']
                                      when elem = 'cancel_sale_return_bill' then array ['cancel_credit_note']
                                      when elem = 'delete_sale_return_bill' then array ['delete_credit_note']
                                      when elem = 'create_purchase_return_bill' then array ['create_debit_note']
                                      when elem = 'update_purchase_return_bill' then array ['update_debit_note']
                                      when elem = 'delete_purchase_return_bill' then array ['delete_debit_note']
                                      when elem = 'cancel_purchase_return_bill' then array ['cancel_debit_note']
                                      when elem in ('create_pincode_distance', 'update_pincode_distance')
                                          then array ['set_pincode_distance']
                                      when elem in ('organization_email_config', 'organization_aws_config',
                                                    'organization_wanted_note_config')
                                          then array ['update_organization_config']

                                      -- replace with multiple value
                                      when elem = 'tally_export' then array [
                                          'set_tally_account_map',
                                          'get_tally_account_map',
                                          'tally_export_data',
                                          'tally_export_master',
                                          'tally_export_voucher',
                                          'tally_export_b2c_sale_voucher'
                                          ]
                                      when elem = 'stock_location_wise_branch_stock' then array [
                                          'get_stock_location_wise_branch_stock',
                                          'get_batch_detail_with_stock_location'
                                          ]
                                      when elem = 'preferred_vendor' then array [
                                          'list_inventory_branch_preferred_vendor',
                                          'set_inventory_branch_preferred_vendor',
                                          'set_bulk_inventory_branch_preferred_vendor'
                                          ]
                                      when elem = 'gst_r2_save' then array [
                                          'pull_gstr2b',
                                          'reconcile_gstr2b'
                                          ]
                                      when elem = 'view_gst_r2' then array [
                                          'get_gstr2b',
                                          'upload_gstr2b',
                                          'import_gstr2b'
                                          ]
                                      when elem = 'tds_summary' then array [
                                          'tds_section_breakup',
                                          'tds_detail',
                                          'tds_detail_summary'
                                          ]
                                      when elem = 'inventory_book' then array [
                                          'inventory_book_summary',
                                          'inventory_book_detail',
                                          'inventory_book_group'
                                          ]
                                      when elem = 'inventory_transaction_history' then array [
                                          'inventory_transaction_history_detail',
                                          'inventory_transaction_history_group',
                                          'fetch_member_condensed'
                                          ]
                                      when elem = 'view_stock_journal' then array [
                                          'get_stock_journal',
                                          'list_stock_journal'
                                          ]
                                      when elem = 'view_pos_server' then array [
                                          'get_pos_server',
                                          'list_pos_server'
                                          ]
                                      when elem = 'view_pos_offline_voucher' then array [
                                          'get_pos_offline_voucher',
                                          'list_pos_offline_voucher'
                                          ]
                                      when elem = 'view_gate_entry' then array [
                                          'get_gate_entry',
                                          'list_gate_entry'
                                          ]
                                      when elem = 'aws_upload' then array [
                                          'upload_file',
                                          'download_file',
                                          'delete_file'
                                          ]
                                      when elem = 'stock_journal_register' then array [
                                          'stock_journal_group',
                                          'stock_journal_summary'
                                          ]
                                      when elem = 'voucher_register' then array [
                                          'voucher_register_detail',
                                          'voucher_register_group'
                                          ]
                                      when elem = 'account_transaction_history' then array [
                                          'account_transaction_history_detail',
                                          'account_transaction_history_group',
                                          'fetch_member_condensed'
                                          ]
                                      when elem = 'account_category_report' then array [
                                          'account_category_summarized',
                                          'account_category_breakup',
                                          'account_category_detail',
                                          'account_category_group',
                                          'account_category_summary'
                                          ]
                                      when elem = 'print_template' then array [
                                          'create_print_template',
                                          'update_print_template',
                                          'reset_print_template',
                                          'delete_print_template'
                                          ]
                                      when elem = 'inventory_information' then array [
                                          'inventory_batch_detail',
                                          'partywise_detail'
                                          ]
                                      when elem = 'provisional_profit' then array [
                                          'provisional_profit_detail',
                                          'provisional_profit_group',
                                          'provisional_profit_summary'
                                          ]
                                      when elem = 'bank_reconciliation' then array [
                                          'get_bank_reconciliation',
                                          'set_bank_reconciliation'
                                          ]
                                      when elem = 'account_book' then array [
                                          'account_book_summary',
                                          'account_book_memo_closing',
                                          'account_book_detail',
                                          'account_book_group'
                                          ]
                                      when elem = 'pos_counter_settlement' then array [
                                          'update_pos_counter_session',
                                          'pos_counter_settlement_create',
                                          'get_pos_counter_settlement',
                                          'list_pos_counter_settlement'
                                          ]
                                      when elem = 'pos_counter_register' then array [
                                          'pos_counter_register_detail',
                                          'pos_counter_register_summary',
                                          'pos_counter_voucher_transaction_summary'
                                          ]
                                      when elem = 'memorandum' then array [
                                          'memorandum_list',
                                          'memorandum_book'
                                          ]
                                      when elem = 'view_sale_bill' then array [
                                          'get_sale_reminder',
                                          'list_sale_reminder',
                                          'sale_register_detail',
                                          'sales_by_tag'
                                          ]
                                      when elem = 'view_sale' then array [
                                          'sale_register_detail',
                                          'sales_by_tag'
                                          ]
                                      when elem = 'payment_advice' then array [
                                          'get_payment_advice',
                                          'update_email_payment_advice'
                                          ]
                                      when elem = 'reorder_analysis' then array [
                                          'set_dynamic_order',
                                          'set_order_level',
                                          'get_order_level',
                                          'get_order_summary'
                                          ]
                                      when elem = 'account_opening' then array [
                                          'get_account_opening',
                                          'set_account_opening'
                                          ]
                                      when elem = 'inventory_opening' then array [
                                          'get_inventory_opening',
                                          'set_inventory_opening'
                                          ]
                                      when elem = 'view_purchase_bill' then array [
                                          'purchase_register_detail',
                                          'purchase_register_group',
                                          'purchase_register_summary',
                                          'get_vendor_bill_map',
                                          'get_vendor_item_map'
                                          ]
                                      -- add additional
                                      when elem = 'create_purchase_bill' then
                                          array ['set_vendor_bill_map', 'set_vendor_item_map', 'remove_vendor_item_map', 'inventory_recent_purchase'] ||
                                          array [elem]
                                      when elem = 'update_purchase_bill' then
                                          array ['set_vendor_bill_map', 'set_vendor_item_map', 'remove_vendor_item_map'] ||
                                          array [elem]
                                      when elem = 'create_price_list' then
                                          array ['create_price_list_condition','update_price_list_condition','delete_price_list_condition'] ||
                                          array [elem]
                                      when elem = 'update_price_list' then
                                          array ['create_price_list_condition','update_price_list_condition','delete_price_list_condition'] ||
                                          array [elem]
                                      when elem = 'deactivate_pos_server' then array ['deactivate_device'] || array [elem]
                                      when elem = 'set_stock_value' then
                                          array ['set_stock_value_opening','delete_stock_value_opening'] || array [elem]
                                      when elem = 'account_outstanding' then
                                          array ['bill_allocation_breakup','account_type_outstanding'] || array [elem]
                                      when elem = 'stock_closing_report' then array ['stock_closing_summary'] || array [elem]
                                      when elem = 'negative_stock_analysis'
                                          then array ['negative_stock_analysis_summary'] || array [elem]
                                      when elem = 'expiry_analysis' then array ['expiry_analysis_summary'] || array [elem]
                                      when elem = 'non_movement_analysis'
                                          then array ['non_movement_analysis_summary'] || array [elem]
                                      when elem = 'bank_collection_summary'
                                          then array ['bank_collection_status'] || array [elem]
                                      when elem = 'create_eft_reconciliation_voucher'
                                          then array ['eft_reconciliation'] || array [elem]
                                      when elem = 'create_sales_emi_reconciliation_voucher'
                                          then array ['sales_emi_reconciliation'] || array [elem]
                                      when elem = 'submit_pos_offline_vouchers'
                                          then array ['delete_pos_offline_vouchers'] || array [elem]
                                      -- everything else stays the same
                                      ELSE array [elem]
                                      END
                          ) AS val
                   FROM unnest(m.perms) AS elem) t
             WHERE val IS NOT NULL);