
-- BANK_BENEFICIARY --
alter table bank_beneficiary rename beneficiary_code to code;
alter table bank_beneficiary alter column bank_account_type set not null;
-- BANK_BENEFICIARY --

-- BILL_ALLOCATION --
--##
alter table bill_allocation rename meta_data to metadata;
--##
-- BILL_ALLOCATION --

-- GSTR_2B --
--##
alter table gstr_2b drop column IF EXISTS id;
alter table gstr_2b rename column gst_no to ctin;
alter table gstr_2b rename column supplier_name to trdnm;
alter table gstr_2b rename column invoice_no to inum;
alter table gstr_2b rename column invoice_date to dt;
alter table gstr_2b rename column total_invoice_value to val;
alter table gstr_2b rename column total_taxable_amount to txval;
alter table gstr_2b rename column integrated_tax_amount to igst;
alter table gstr_2b rename column central_tax_amount to cgst;
alter table gstr_2b rename column state_tax_amount to sgst;
alter table gstr_2b rename column cess_amount to cess;
-- GSTR_2B --

-- INVENTORY --
--##
alter table inventory
    add if not exists cess_qty    float,
    add if not exists cess_value    float;
alter table inventory
    rename column category1_id to section_id;
alter table inventory
    rename column compositions to udf_compositions;
alter table inventory
    drop column if exists incentive_applicable;
alter table inventory
    drop column if exists incentive_range_id;
--##
update inventory
set
  cess_qty   = (cess ->> 'on_quantity')::double precision,
  cess_value = (cess ->> 'on_value')::double precision;
--##
alter table inventory
    drop column if exists cess;
-- INVENTORY --

-- INVENTORY_BRANCH_DETAIL --
--##
alter table inventory_branch_detail
    add if not exists s_disc_percentage float;
--##
update inventory_branch_detail x
set s_disc_percentage = y.value
from price_list_condition y
where x.inventory_id = y.inventory_id
  and (x.branch_id = any (y.branches) or y.branches is null or array_length(y.branches, 1) = 0);
--##
alter table inventory_branch_detail
    alter column reorder_mode drop not null;
--##
alter table inventory_branch_detail
    alter column reorder_level drop not null;
--##
-- INVENTORY_BRANCH_DETAIL --

-- MEMBER --
--##
alter table member
    add if not exists perms text[],
    add if not exists ui_perms jsonb;
--##
update member m
set
    perms    = coalesce(mr.perms, '{}'::text[]),
    ui_perms = coalesce(to_jsonb(mr.perms), '[]'::jsonb)
from member_role mr
where mr.name = m.role_id;
-- MEMBER --

-- ORGANIZATION --
--##
alter table organization
    add if not exists created_by int,
    add if not exists updated_by int;
--##
alter table organization
    alter column configuration type jsonb using configuration::jsonb,
    alter column license_claims type jsonb using license_claims::jsonb;
--##
UPDATE organization o
SET
    created_by = m.id,
    updated_by = m.id
FROM member m
WHERE m.id = 1;
-- ORGANIZATION --

-- TDS_NATURE_OF_PAYMENT --
    --##
        alter table tds_nature_of_payment
            add if not exists tds_account_id int;
        --##
        WITH a AS (SELECT id, tds_nature_of_payment_id, tds_deductee_type
                   FROM account
                   WHERE tds_nature_of_payment_id IS NOT NULL)
        UPDATE tds_nature_of_payment t
        SET tds_account_id = a.id
        FROM a
        WHERE a.tds_nature_of_payment_id = t.id
          and tds_account_id is null;
        --##
        --##
        update tds_nature_of_payment
        set tds_account_id = coalesce((select id
                                       from account
                                       where tds_nature_of_payment_id is not null
                                       limit 1), 1)
        where tds_account_id is null;
        --##
        alter table tds_nature_of_payment
            alter tds_account_id set not null;
        --##
    --##
-- TDS_NATURE_OF_PAYMENT --

--DROP OR MODIFY COLUMN--

-- AC_TXN --
    -- ====== generated ======
        alter table ac_txn alter column amount drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table ac_txn drop if exists is_opening;
        alter table ac_txn drop if exists voucher_prefix;
        alter table ac_txn drop if exists voucher_fy;
        alter table ac_txn drop if exists voucher_seq;
        alter table ac_txn drop if exists eft_reconciliation_voucher_id;
        alter table ac_txn drop if exists account_type_name;
        alter table ac_txn drop if exists alt_account_name;
        alter table ac_txn drop if exists inst_no;
        alter table ac_txn drop if exists base_account_types;
    -- ====== columns ======
-- AC_TXN --

-- INV_TXN --
    alter table inv_txn drop if exists division_id;
    alter table inv_txn drop if exists division_name;
    alter table inv_txn drop if exists party_id;
    alter table inv_txn drop if exists party_name;
    alter table inv_txn drop if exists vendor_name;
    alter table inv_txn drop if exists batch_id;
    alter table inv_txn drop if exists reorder_inventory_id;
    alter table inv_txn drop if exists inventory_hsn;
    alter table inv_txn drop if exists manufacturer_name;
    alter table inv_txn drop if exists is_opening;
    alter table inv_txn drop if exists inventory_voucher_id;
    alter table inv_txn drop if exists category1_id;
    alter table inv_txn drop if exists category1_name;
    alter table inv_txn drop if exists category2_id;
    alter table inv_txn drop if exists category2_name;
    alter table inv_txn drop if exists category3_id;
    alter table inv_txn drop if exists category3_name;
    alter table inv_txn drop if exists doctor_id;
    alter table inv_txn drop if exists doctor_name;
    alter table inv_txn drop if exists sale_taxable_amount;
    alter table inv_txn drop if exists sale_tax_amount;
    alter table inv_txn drop if exists pos_id;
-- INV_TXN --

-- VOUCHER --
    alter table voucher drop if exists branch_gst;
    alter table voucher drop if exists party_gst;
    alter table voucher drop if exists party_id;
    alter table voucher drop if exists party_name;
    alter table voucher drop if exists pos_counter_code;
    alter table voucher drop if exists approval_state;
    alter table voucher drop if exists require_no_of_approval;
    alter table voucher drop if exists pos_counter_session_id;
    alter table voucher drop if exists pos_counter_settlement_id;
-- VOUCHER --

-- ACCOUNT_DAILY_SUMMARY --
    alter table account_daily_summary alter column amount drop expression;
-- ACCOUNT_DAILY_SUMMARY --

-- ACCOUNT --
--##
    -- ====== generated ======
        alter table account alter column val_name drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table account drop if exists contact_type;
        alter table account drop if exists hide;
        alter table account drop if exists short_name;
        alter table account drop if exists gst_type;
        alter table account drop if exists cheque_in_favour_of;
        alter table account drop if exists description;
        alter table account drop if exists is_commission_discounted;
        alter table account drop if exists commission;
        alter table account drop if exists aadhar_no;
        alter table account drop if exists alternate_mobile;
        alter table account drop if exists telephone;
        alter table account drop if exists contact_person;
        alter table account drop if exists category1;
        alter table account drop if exists category2;
        alter table account drop if exists category3;
        alter table account drop if exists category4;
        alter table account drop if exists category5;
        alter table account drop if exists agent_id;
        alter table account drop if exists commission_account_id;
        alter table account drop if exists delivery_address;
        alter table account drop if exists enable_loyalty_point;
        alter table account drop if exists loyalty_point;
        alter table account drop if exists tags;
        alter table account drop if exists e_banking_enabled;
        alter table account drop if exists transport_detail;
        alter table account drop if exists service_charge_gst_account_id;
        alter table account drop if exists service_charge_non_gst_account_id;
        alter table account drop if exists itc_ineligible;
        alter table account drop if exists secondary_emails;
        alter table account alter column transaction_enabled set not null;
    -- ====== columns ======
--##
-- ACCOUNT --

-- BANK --
    alter table bank drop if exists created_at;
    alter table bank drop if exists updated_at;
-- BANK --

-- BANK_BENEFICIARY --
    alter table bank_beneficiary drop if exists bank_name;
    alter table bank_beneficiary drop if exists bank_code;
-- BANK_BENEFICIARY --

-- BANK_TXN --
--##
    -- ====== generated ======
        alter table bank_txn alter column credit drop expression;
        alter table bank_txn alter column debit drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table bank_txn drop if exists in_favour_of;
        alter table bank_txn drop if exists base_account_types;
        alter table bank_txn drop if exists alt_account_name;
        alter table bank_txn drop if exists bank_beneficiary_id;
        alter table bank_txn drop if exists epayment_tran_ref;
        alter table bank_txn drop if exists epayment_req_ref;
        alter table bank_txn drop if exists epayment_status;
        alter table bank_txn drop if exists bank_ref_no;
        alter table bank_txn drop if exists bank_particulars;
        alter table bank_txn drop if exists emailed;
        alter table bank_txn alter column sno type integer using sno::integer;
        alter table bank_txn alter column is_memo set not null;
    -- ====== columns ======
--##
-- BANK_TXN --

-- BATCH --
--##
    -- ====== generated ======
        alter table batch alter column p_rate drop expression;
        alter table batch alter column closing drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table batch drop if exists sno;
        alter table batch drop if exists reorder_inventory_id;
        alter table batch drop if exists inventory_hsn;
        alter table batch drop if exists branch_name;
        alter table batch drop if exists warehouse_name;
        alter table batch drop if exists division_id;
        alter table batch drop if exists division_name;
        alter table batch drop if exists txn_id;
        alter table batch drop if exists inventory_voucher_id;
        alter table batch drop if exists opening_p_rate;
        alter table batch drop if exists label_qty;
        alter table batch drop if exists retail_qty;
        alter table batch drop if exists is_retail_qty;
        alter table batch drop if exists unit_name;
        alter table batch drop if exists source_batch_id;
        alter table batch drop if exists manufacturer_name;
        alter table batch drop if exists vendor_name;
        alter table batch drop if exists category1_id;
        alter table batch drop if exists category1_name;
        alter table batch drop if exists category2_id;
        alter table batch drop if exists category2_name;
        alter table batch drop if exists category3_id;
        alter table batch drop if exists category3_name;
        alter table batch alter column unit_conv set not null;
        update batch set batch_no = '1' where batch_no is null;
        alter table batch alter column batch_no set not null;
    -- ====== columns ======
--##
-- BATCH --

-- BILL_ALLOCATION --
--##
    -- ====== columns ======
        alter table bill_allocation drop if exists base_account_types;
        alter table bill_allocation drop if exists pending;
        alter table bill_allocation drop if exists is_approved;
        alter table bill_allocation drop if exists due_date;
        alter table bill_allocation drop if exists account_type_name;
        alter table bill_allocation drop if exists bill_date;
    -- ====== columns ======
--##
-- BILL_ALLOCATION --

-- INVENTORY --
--##
    -- ====== generated ======
        alter table inventory alter column val_name drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table inventory drop if exists division_id;
        alter table inventory drop if exists inventory_type;
        alter table inventory drop if exists retail_qty;
        alter table inventory drop if exists reorder_inventory_id;
        alter table inventory drop if exists bulk_inventory_id;
        alter table inventory drop if exists distribution_qty;
        alter table inventory drop if exists purchase_config;
        alter table inventory drop if exists sale_config;
        alter table inventory drop if exists tags;
        alter table inventory drop if exists description;
        alter table inventory drop if exists manufacturer_name;
        alter table inventory drop if exists vendor_id;
        alter table inventory drop if exists vendor_name;
        alter table inventory drop if exists vendors;
        alter table inventory drop if exists set_rate_values_via_purchase;
        alter table inventory drop if exists apply_s_rate_from_master_for_sale;
        alter table inventory drop if exists fitting_charge;
        alter table inventory drop if exists itc_ineligible;
        alter table inventory drop if exists category2_id;
        alter table inventory drop if exists category3_id;
        alter table inventory drop if exists category1_name;
        alter table inventory drop if exists category2_name;
        alter table inventory drop if exists category3_name;
    -- ====== columns ======
-- INVENTORY --

-- INVENTORY_BRANCH_DETAIL --
--##
    -- ====== columns ======
        alter table inventory_branch_detail drop if exists inventory_name;
        alter table inventory_branch_detail drop if exists branch_name;
        alter table inventory_branch_detail drop if exists inventory_barcodes;
        alter table inventory_branch_detail drop if exists s_disc;
        alter table inventory_branch_detail drop if exists discount_1;
        alter table inventory_branch_detail drop if exists discount_2;
        alter table inventory_branch_detail drop if exists preferred_vendor_name;
        alter table inventory_branch_detail drop if exists last_vendor_name;
        alter table inventory_branch_detail drop if exists s_customer_disc;
        alter table inventory_branch_detail drop if exists p_rate_tax_inc;
        alter table inventory_branch_detail drop if exists reorder_inventory_id;
        alter table inventory_branch_detail drop if exists val_name;
        alter table inventory_branch_detail drop if exists division_id;
        alter table inventory_branch_detail rename reorder_mode to udf_reorder_mode;
        alter table inventory_branch_detail rename reorder_level to udf_reorder_level;
        alter table inventory_branch_detail rename min_order to udf_min_order;
        alter table inventory_branch_detail rename max_order to udf_max_order;
    -- ====== columns ======
--##
-- INVENTORY_BRANCH_DETAIL --

-- MEMBER --
--##
    -- ====== columns ======
        -- remote_access
            alter table member drop if exists remote_access;
            -- alter table member rename remote_access to udf_remote_access;
        -- user_id
            alter table member drop if exists user_id;
            -- alter table member rename user_id to udf_user_id;
        -- role_id
            alter table member drop if exists role_id;
            -- alter table member rename role_id to udf_role_id;
    -- ====== columns ======
--##
-- MEMBER --

-- VOUCHER_TYPE --
--##
    -- ====== columns ======
        alter table voucher_type drop column IF EXISTS approve1_id;
        alter table voucher_type drop column IF EXISTS approve2_id;
        alter table voucher_type drop column IF EXISTS approve3_id;
        alter table voucher_type drop column IF EXISTS approve4_id;
        alter table voucher_type drop column IF EXISTS approve5_id;
    -- ====== columns ======
--##
-- VOUCHER_TYPE --

-- TDS_ON_VOUCHER --
--##
    -- ====== generated ======
        -- amount_after_tds_deduction
            alter table tds_on_voucher alter column amount_after_tds_deduction drop expression;
    -- ====== generated ======
    -- ====== columns ======
        alter table tds_on_voucher drop column IF EXISTS branch_name;
        alter table tds_on_voucher drop column IF EXISTS pending_id;
    -- ====== columns ======
--##
-- TDS_ON_VOUCHER -

-- UNIT --
--##
    -- ====== columns ======
        alter table unit drop column IF EXISTS conversions;
    -- ====== columns ======
--##
-- UNIT --

-- changed_at removal --
    alter table account                 drop if exists changed_at;
    alter table account_type            drop if exists changed_at;
    alter table batch                   drop if exists changed_at;
    alter table branch                  drop if exists changed_at;
    alter table country                 drop if exists changed_at;
    alter table gst_registration        drop if exists changed_at;
    alter table inventory               drop if exists changed_at;
    alter table inventory_branch_detail drop if exists changed_at;
    alter table member                  drop if exists changed_at;
    alter table organization            drop if exists changed_at;
    alter table print_layout            drop if exists changed_at;
    alter table print_template          drop if exists changed_at;
    alter table sales_person            drop if exists changed_at;
    alter table unit                    drop if exists changed_at;
    alter table voucher_type            drop if exists changed_at;
    alter table warehouse               drop if exists changed_at;
    alter table doctor                  drop if exists changed_at;
    alter table drug_classification     drop if exists changed_at;
-- changed_at removal --

--DROP OR MODIFY TABLE--
    drop table if exists acc_cat_txn;
    drop table if exists account_opening;
    drop table if exists approval_log;
    drop table if exists approval_tag;
    drop table if exists pincode_distance;
    drop table if exists dispatch_address;
    drop table if exists area;
    drop table if exists bill_of_material_component;
    drop table if exists category;
    drop table if exists credit_note;
    drop table if exists credit_note_inv_item;
    drop table if exists customer_advance;
    drop table if exists debit_note;
    drop table if exists debit_note_inv_item;
    drop table if exists purchase_bill;
    drop table if exists purchase_bill_inv_item;
    drop table if exists sale_bill_reminder_inv_item;
    drop table if exists sale_bill_reminder;
    drop table if exists sale_bill;
    drop table if exists sale_bill_inv_item;
    drop table if exists sale_package;
    drop table if exists sale_quotation;
    drop table if exists delete_log;
    drop table if exists delivery_note;
    drop table if exists delivery_note_inv_item;
    drop table if exists delivery_receipt;
    drop table if exists device;
    drop table if exists display_rack;
    drop table if exists division;
    drop table if exists e_banking_log;
    drop table if exists eft_reconciliation_voucher;
    drop table if exists environment;
    drop table if exists exchange;
    drop table if exists exchange_adjustment;
    drop table if exists gate_entry;
    drop table if exists gift_coupon;
    drop table if exists gift_voucher;
    drop table if exists goods_inward_note;
    drop table if exists gst_txn;
    drop table if exists incentive_range;
    drop table if exists inventory_opening;
    drop table if exists material_conversion;
    drop table if exists material_conversion_inv_item;
    drop table if exists member_role;
    drop table if exists offer_management;
    drop table if exists organization_old;
    drop table if exists personal_use_purchase_inv_item;
    drop table if exists personal_use_purchase;
    drop table if exists pos_offline_voucher;
    drop table if exists pos_counter_session;
    drop table if exists pos_counter;
    drop table if exists pos_counter_settlement;
    drop table if exists pos_server;
    drop table if exists power_bi;
    drop table if exists price_list_condition;
    drop table if exists price_list;
    drop table if exists wanted_note;
    drop table if exists permission;
    drop table if exists shipment;
    drop table if exists stock_journal;
    drop table if exists stock_journal_inv_item;
    drop table if exists stock_value;
    drop table if exists stock_value_opening;
    drop table if exists tag;
    drop table if exists tally_account_map;
    drop table if exists vault;
    drop table if exists vendor_bill_map;
    drop table if exists vendor_item_map;
    -- drop table if exists doctor;
    alter table if exists doctor rename to udm_doctor;
        alter table udm_doctor drop if exists display_name;
        alter table udm_doctor drop if exists alias_name;
        alter table udm_doctor drop if exists age;
    alter table if exists drug_classification rename to udm_drug_classification;
    alter table if exists inventory_composition rename to udm_inventory_composition;
    alter table if exists vendor_bill_map rename to udm_vendor_bill_map;
    alter table if exists vendor_item_map rename to udm_vendor_item_map;
    drop table if exists seaql_migrations;