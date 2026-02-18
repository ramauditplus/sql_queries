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

-- UPDATE member m
-- SET perms = (SELECT array_agg(DISTINCT val)
--              FROM (SELECT CASE
--                               -- 'credit_note' mappings
--                               WHEN elem = 'create_sale_return_bill' THEN 'create_credit_note'
--                               WHEN elem = 'update_sale_return_bill' THEN 'update_credit_note'
--                               WHEN elem = 'cancel_sale_return_bill' THEN 'cancel_credit_note'
--                               WHEN elem = 'delete_sale_return_bill' THEN 'delete_credit_note'
--
--                               -- 'debit_note' mappings
--                               WHEN elem = 'create_purchase_return_bill' THEN 'create_debit_note'
--                               WHEN elem = 'update_purchase_return_bill' THEN 'update_debit_note'
--                               WHEN elem = 'delete_purchase_return_bill' THEN 'delete_debit_note'
--                               WHEN elem = 'cancel_purchase_return_bill' THEN 'cancel_debit_note'
--
--                               -- 'tally_export' mappings
--                               WHEN elem = 'tally_export' THEN ('set_tally_account_map', 'get_tally_account_map',
--                                                                'tally_export_data', 'tally_export_master',
--                                                                'tally_export_voucher', 'tally_export_b2c_sale_voucher')
--
--                               -- remove old redundant StockLocationWiseBranchStock
--                               WHEN elem = 'stock_location_wise_branch_stock'
--                                   THEN ('get_stock_location_wise_branch_stock', 'get_batch_detail_with_stock_location')
--
--                               -- 'preferred_vendor'
--                               WHEN elem = 'preferred_vendor' THEN ('list_inventory_branch_preferred_vendor',
--                                                                    'set_inventory_branch_preferred_vendor',
--                                                                    'set_bulk_inventory_branch_preferred_vendor')
--
--                               -- keep everything else as-is
--                               ELSE elem
--                               END AS val
--                    from unnest(m.perms) as elem) t
--              where val is not null);

UPDATE member m
SET perms = (
    SELECT array_agg(DISTINCT val)
    FROM (
        SELECT unnest(
            CASE
                -- credit note mappings
                WHEN elem = 'create_sale_return_bill' THEN ARRAY['create_credit_note']
                WHEN elem = 'update_sale_return_bill' THEN ARRAY['update_credit_note']
                WHEN elem = 'cancel_sale_return_bill' THEN ARRAY['cancel_credit_note']
                WHEN elem = 'delete_sale_return_bill' THEN ARRAY['delete_credit_note']

                -- debit note mappings
                WHEN elem = 'create_purchase_return_bill' THEN ARRAY['create_debit_note']
                WHEN elem = 'update_purchase_return_bill' THEN ARRAY['update_debit_note']
                WHEN elem = 'delete_purchase_return_bill' THEN ARRAY['delete_debit_note']
                WHEN elem = 'cancel_purchase_return_bill' THEN ARRAY['cancel_debit_note']

                -- tally export mappings → expands into 6 new ones
                WHEN elem = 'tally_export' THEN ARRAY[
                    'set_tally_account_map',
                    'get_tally_account_map',
                    'tally_export_data',
                    'tally_export_master',
                    'tally_export_voucher',
                    'tally_export_b2c_sale_voucher'
                ]

                -- stock_location_wise_branch_stock
                WHEN elem = 'stock_location_wise_branch_stock' THEN ARRAY[
                    'get_stock_location_wise_branch_stock',
                    'get_batch_detail_with_stock_location'
                ]

                -- preferred_vendor
                WHEN elem = 'preferred_vendor' THEN ARRAY[
                    'list_inventory_branch_preferred_vendor',
                    'set_inventory_branch_preferred_vendor',
                    'set_bulk_inventory_branch_preferred_vendor'
                ]

                -- everything else stays the same
                ELSE ARRAY[elem]
            END
        ) AS val
        FROM unnest(m.perms) AS elem
    ) t
);

