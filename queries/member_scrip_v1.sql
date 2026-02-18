--## create table if not exists
create table if not exists member_permission
(
    name text not null primary key
);

--## add value to table
INSERT INTO member_permission (name)
VALUES ('create_division'),                            --good
       ('update_division'),                            --good
       ('delete_division'),                            --good
       ('create_area'),                                --good
       ('update_area'),                                --good
       ('delete_area'),                                --good
       ('create_warehouse'),                           --good
       ('update_warehouse'),                           --good
       ('delete_warehouse'),                           --good
       ('create_manufacturer'),                        --good
       ('update_manufacturer'),                        --good
       ('delete_manufacturer'),                        --good
       ('create_account'),                             --ep
       ('update_account'),                             --ep
       ('delete_account'),                             --ep
       ('set_delivery_address'),                       --ep
       ('create_gst_registration'),                    --good
       ('update_gst_registration'),                    --good
       ('delete_gst_registration'),                    --good
       ('create_stock_location'),                      --good
       ('update_stock_location'),                      --good
       ('delete_stock_location'),                      --good
       ('create_doctor'),                              --good
       ('update_doctor'),                              --good
       ('delete_doctor'),                              --good
       ('create_print_template'),                      --ep
       ('update_print_template'),                      --ep
       ('reset_print_template'),                       --ep
       ('delete_print_template'),                      --ep
       ('create_bank_beneficiary'),                    --good
       ('update_bank_beneficiary'),                    --good
       ('delete_bank_beneficiary'),                    --good
       ('create_account_type'),                        --good
       ('update_account_type'),                        --good
       ('delete_account_type'),                        --good
       ('create_approval_tag'),                        --good
       ('update_approval_tag'),                        --good
       ('delete_approval_tag'),                        --good
       ('set_category'),                               --ep
       ('create_category_option'),                     --good
       ('update_category_option'),                     --good
       ('delete_category_option'),                     --good
       ('create_tds_nature_of_payment'),               --ep
       ('update_tds_nature_of_payment'),               --ep
       ('delete_tds_nature_of_payment'),               --ep
       ('create_display_rack'),                        --good
       ('update_display_rack'),                        --good
       ('delete_display_rack'),                        --good
       ('create_voucher_type'),                        --good
       ('update_voucher_type'),                        --good
       ('delete_voucher_type'),                        --good
       ('create_tag'),                                 --good
       ('update_tag'),                                 --good
       ('delete_tag'),                                 --good
       ('create_financial_year'),                      --ep
       ('create_unit'),                                --good
       ('update_unit'),                                --good
       ('delete_unit'),                                --good
       ('set_unit_conversion'),                        --ep
       ('create_pos_counter'),                         --good
       ('update_pos_counter'),                         --good
       ('delete_pos_counter'),                         --good
       ('update_pos_counter_session'),                 --ep
       ('create_pos_counter_settlement'),              --ep
       ('get_pos_counter_settlement'),                 --ep
       ('list_pos_counter_settlement'),                --ep
       ('create_drug_classification'),                 --good
       ('update_drug_classification'),                 --good
       ('delete_drug_classification'),                 --good
       ('create_inventory_composition'),               --good
       ('update_inventory_composition'),               --good
       ('delete_inventory_composition'),               --good
       ('create_inventory'),                           --good
       ('update_inventory'),                           --good
       ('inventory_batch_detail'),                     --ep
       ('delete_inventory'),                           --good
       ('merge_inventory'),                            --ep
       ('create_bill_of_material'),                    --good
       ('update_bill_of_material'),                    --good
       ('delete_bill_of_material'),                    --good
       ('apply_incentive_range'),                      --good
       ('set_stock_value'),                            --ep
       ('set_stock_value_opening'),                    --ep
       ('delete_stock_value_opening'),                 --ep
       ('set_pincode_distance'),                       --ep
       ('create_sales_person'),                        --good
       ('update_sales_person'),                        --good
       ('delete_sales_person'),                        --good
       ('create_incentive_range'),                     --good
       ('update_incentive_range'),                     --good
       ('delete_incentive_range'),                     --good
       ('create_device'),                              --good
       ('update_device'),                              --good
       ('get_device'),                                 --ep
       ('generate_device_token'),                      --good
       ('delete_device'),                              --good
       ('deactivate_device'),                          --ep
       ('create_branch'),                              --good
       ('update_branch'),                              --good
       ('delete_branch'),                              --good
       ('create_member'),                              --ep
       ('update_member'),                              --ep
       ('fetch_member_condensed'),                     --ep
       ('delete_member'),                              --ep
       ('account_book_summary'),                       --ep
       ('account_book_memo_closing'),                  --ep
       ('account_book_detail'),                        --ep
       ('account_book_group'),                         --ep
       ('opening_balance_difference'),                 --ep
       ('account_category_summarized'),                --ep
       ('account_category_breakup'),                   --ep
       ('account_category_detail'),                    --ep
       ('account_category_group'),                     --ep
       ('account_category_summary'),                   --ep
       ('account_transaction_history_detail'),         --ep
       ('account_transaction_history_group'),          --ep
       ('account_outstanding'),                        --ep
       ('account_type_outstanding'),                   --ep
       ('voucher_register_detail'),                    --ep
       ('voucher_register_group'),                     --ep
       ('purchase_register_detail'),                   --ep
       ('purchase_register_group'),                    --ep
       ('purchase_register_summary'),                  --ep
       ('sale_register_detail'),                       --ep
       ('sales_incentive_rangewise'),                  --ep
       ('pos_counter_register_detail'),                --ep
       ('pos_counter_register_summary'),               --ep
       ('pos_counter_voucher_transaction_summary'),    --ep
       ('memorandum_list'),                            --ep
       ('memorandum_book'),                            --ep
       ('stock_analysis'),                             --good
       ('stock_closing_report'),                       --ep
       ('stock_closing_summary'),                      --ep
       ('negative_stock_analysis'),                    --ep
       ('negative_stock_analysis_summary'),            --ep
       ('expiry_analysis'),                            --ep
       ('expiry_analysis_summary'),                    --ep
       ('non_movement_analysis'),                      --ep
       ('non_movement_analysis_summary'),              --ep
       ('sale_analysis'),                              --good
       ('sale_register_by_inventory'),                 --ep
       ('sales_by_tag'),                               --ep
       ('scheduled_drug_report'),                      --good
       ('get_sale_reminder'),                          --ep
       ('list_sale_reminder'),                         --ep
       ('generate_sale_reminder_order'),               --ep
       ('provisional_profit_detail'),                  --ep
       ('provisional_profit_group'),                   --ep
       ('provisional_profit_summary'),                 --ep
       ('get_bank_reconciliation'),                    --ep
       ('set_bank_reconciliation'),                    --ep
       ('get_payment_advice'),                         --ep
       ('update_email_payment_advice'),                --ep
       ('bank_collection_summary'),                    --ep
       ('bank_collection_status'),                     --ep
       ('day_book'),                                   --good
       ('day_summary'),                                --good
       ('gst_tax_breakup'),                            --good
       ('get_gst_r1'),                                 --ep
       ('update_hsn'),                                 --good
       ('get_gstr3b'),                                 --ep
       ('pull_gstr2b'),                                --ep
       ('reconcile_gstr2b'),                           --ep
       ('get_gstr2b'),                                 --ep
       ('upload_gstr2b'),                              --ep
       ('import_gstr2b'),                              --ep
       ('tds_section_breakup'),                        --ep
       ('tds_detail'),                                 --ep
       ('tds_detail_summary'),                         --ep
       ('inventory_book_summary'),                     --ep
       ('inventory_book_detail'),                      --ep
       ('inventory_book_group'),                       --ep
       ('inventory_transaction_history_detail'),       --ep
       ('inventory_transaction_history_group'),        --ep
       ('set_inventory_branch_price_configuration'),   --ep
       ('list_inventory_branch_preferred_vendor'),     --ep
       ('set_inventory_branch_preferred_vendor'),      --ep
       ('set_bulk_inventory_branch_preferred_vendor'), --ep
       ('set_inventory_branch_stock_location'),        --ep
       ('get_inventory_branch_stock_location_label'),  --ep
       ('get_stock_location_wise_branch_stock'),       --ep
       ('get_batch_detail_with_stock_location'),       --ep
       ('set_inventory_branch_value'),                 --good
       ('get_best_vendor'),                            --ep
       ('set_dynamic_order'),                          --ep
       ('set_order_level'),                            --ep
       ('get_order_level'),                            --ep
       ('get_order_summary'),                          --ep
       ('get_account_opening'),                        --ep
       ('set_account_opening'),                        --ep
       ('get_inventory_opening'),                      --ep
       ('set_inventory_opening'),                      --ep
       ('convert_memo_to_payment'),                    --ep
       ('approve_voucher'),                            --good
       ('create_purchase_bill'),                       --ep
       ('update_purchase_bill'),                       --ep
       ('delete_purchase_bill'),                       --good
       ('cancel_purchase_bill'),                       --good
       ('inventory_recent_purchase'),                  --ep
       ('create_sale_quotation'),                      --ep
       ('update_sale_quotation'),                      --good
       ('get_sale_quotation'),                         --ep
       ('delete_sale_quotation'),                      --good
       ('create_sale_bill'),                           --ep
       ('update_sale_bill'),                           --good
       ('update_sale_bill_information'),               --ep
       ('delete_sale_bill'),                           --good
       ('cancel_sale_bill'),                           --good
       ('create_credit_note'),                         --ep
       ('update_credit_note'),                         --ep
       ('delete_credit_note'),                         --ep
       ('cancel_credit_note'),                         --ep
       ('create_debit_note'),                          --ep
       ('update_debit_note'),                          --ep
       ('delete_debit_note'),                          --ep
       ('cancel_debit_note'),                          --ep
       ('create_price_list'),                          --ep
       ('update_price_list'),                          --ep
       ('delete_price_list'),                          --good
       ('create_price_list_condition'),                --ep
       ('update_price_list_condition'),                --ep
       ('delete_price_list_condition'),                --ep
       ('create_dispatch_address'),                    --good
       ('update_dispatch_address'),                    --good
       ('delete_dispatch_address'),                    --good
       ('partywise_detail'),                           --ep
       ('update_batch'),                               --good
       ('get_batch_label'),                            --ep
       ('set_vendor_bill_map'),                        --ep
       ('get_vendor_bill_map'),                        --ep
       ('set_vendor_item_map'),                        --ep
       ('get_vendor_item_map'),                        --ep
       ('remove_vendor_item_map'),                     --ep
       ('create_sale_package'),                        --good
       ('verify_sale_package'),                        --good
       ('delete_sale_package'),                        --good
       ('create_shipment'),                            --good
       ('update_shipment'),                            --good
       ('delete_shipment'),                            --good
       ('create_offer_management'),                    --good
       ('update_offer_management'),                    --good
       ('delete_offer_management'),                    --good
       ('create_customer_advance'),                    --good
       ('update_customer_advance'),                    --good
       ('delete_customer_advance'),                    --good
       ('create_delivery_receipt'),                    --good
       ('update_delivery_receipt'),                    --good
       ('delete_delivery_receipt'),                    --good
       ('create_delivery_note'),                       --good
       ('update_delivery_note'),                       --good
       ('delete_delivery_note'),                       --good
       ('issue_gift_voucher'),                         --ep
       ('delete_gift_voucher'),                        --good
       ('create_personal_use_purchase'),               --good
       ('update_personal_use_purchase'),               --good
       ('delete_personal_use_purchase'),               --good
       ('bill_wise_adjustment'),                       --good
       ('update_bill_due_date'),                       --good
       ('bill_allocation_breakup'),                    --ep
       ('create_goods_inward_note'),                   --good
       ('update_goods_inward_note'),                   --good
       ('delete_goods_inward_note'),                   --good
       ('create_stock_journal'),                       --good
       ('update_stock_journal'),                       --good
       ('get_stock_journal'),                          --ep
       ('delete_stock_journal'),                       --good
       ('list_stock_journal'),                         --ep
       ('stock_journal_group'),                        --ep
       ('stock_journal_summary'),                      --ep
       ('eft_reconciliation'),                         --ep
       ('create_eft_reconciliation_voucher'),          --ep
       ('delete_eft_reconciliation_voucher'),          --good
       ('sales_emi_reconciliation'),                   --ep
       ('create_sales_emi_reconciliation_voucher'),    --ep
       ('delete_sales_emi_reconciliation_voucher'),    --good
       ('voucher_approval_status'),                    --good
       ('create_pos_server'),                          --good
       ('update_pos_server'),                          --good
       ('generate_pos_server_token'),                  --good
       ('deactivate_pos_server'),                      --ep
       ('get_pos_server'),                             --ep
       ('list_pos_server'),                            --ep
       ('get_pos_offline_voucher'),                    --ep
       ('list_pos_offline_voucher'),                   --ep
       ('delete_pos_offline_vouchers'),                --ep
       ('submit_pos_offline_vouchers'),                --ep
       ('create_gate_entry'),                          --good
       ('update_gate_entry'),                          --good
       ('delete_gate_entry'),                          --good
       ('exit_gate_entry'),                            --good
       ('list_gate_entry'),                            --ep
       ('get_gate_entry'),                             --ep
       ('upload_file'),                                --ep
       ('download_file'),                              --ep
       ('delete_file'),                                --ep
       ('send_mail'),                                  --good
       ('update_organization_config'),                 --ep
       ('create_wanted_note'),                         --good
       ('update_wanted_note'),                         --good
       ('get_wanted_note'),                            --ep
       ('delete_wanted_note'),                         --good
       ('set_wanted_note_status'),                     --good
       ('set_tally_account_map'),                      --ep
       ('get_tally_account_map'),                      --ep
       ('tally_export_data'),                          --ep
       ('tally_export_master'),                        --ep
       ('tally_export_voucher')                        --ep
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
                                      when elem = 'create_pos_offline_sale_bill' then array ['create_sale_bill']
                                      when elem in ('view_inventory', 'view_account') then array ['get_vendor_item_map']
                                      when elem in ('create_pincode_distance', 'update_pincode_distance')
                                          then array ['set_pincode_distance']
                                      when elem in ('organization_email_config', 'organization_aws_config',
                                                    'organization_wanted_note_config')
                                          then array ['update_organization_config']
                                      when elem in ('create_customer', 'create_vendor', 'create_transport') then
                                          array ['create_account']
                                      when elem in ('update_customer', 'update_vendor', 'update_transport') then
                                          array ['update_account']
                                      when elem in ('delete_customer', 'delete_vendor', 'delete_transport') then
                                          array ['delete_account']


                                      -- replace with multiple value
                                      when elem = 'tally_export' then array [
                                          'set_tally_account_map',
                                          'get_tally_account_map',
                                          'tally_export_data',
                                          'tally_export_master',
                                          'tally_export_voucher'
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
                                          'create_pos_counter_settlement',
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
                                      when elem = 'view_purchase' then array [
                                          'purchase_register_detail',
                                          'purchase_register_group',
                                          'purchase_register_summary'
                                          ]
                                      when elem = 'view_member' then array [
                                          'update_member',
                                          'create_member',
                                          'delete_member'
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