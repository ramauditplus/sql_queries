-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN, EXPRESSION, DEFAULT
-------------------------------------------------------------------------------------------------
-- AC_TXN --
    alter table ac_txn alter column amount drop expression;
    alter table ac_txn drop column if exists is_opening;
    alter table ac_txn drop column if exists voucher_prefix;
    alter table ac_txn drop column if exists voucher_fy;
    alter table ac_txn drop column if exists voucher_seq;
    alter table ac_txn drop column if exists eft_reconciliation_voucher_id;
    alter table ac_txn drop column if exists account_type_name;
    alter table ac_txn drop column if exists alt_account_name;
    alter table ac_txn drop column if exists inst_no;
    alter table ac_txn drop column if exists base_account_types;
-- INV_TXN --
    alter table inv_txn drop column if exists division_id;
    alter table inv_txn drop column if exists division_name;
    alter table inv_txn drop column if exists party_id;
    alter table inv_txn drop column if exists party_name;
    alter table inv_txn drop column if exists vendor_name;
    alter table inv_txn drop column if exists reorder_inventory_id;
    alter table inv_txn drop column if exists inventory_hsn;
    alter table inv_txn drop column if exists manufacturer_name;
    alter table inv_txn drop column if exists is_opening;
    alter table inv_txn drop column if exists inventory_voucher_id;
    alter table inv_txn drop column if exists category1_name;
    alter table inv_txn drop column if exists category2_id;
    alter table inv_txn drop column if exists category2_name;
    alter table inv_txn drop column if exists category3_id;
    alter table inv_txn drop column if exists category3_name;
    alter table inv_txn drop column if exists doctor_id;
    alter table inv_txn drop column if exists doctor_name;
    alter table inv_txn drop column if exists sale_taxable_amount;
    alter table inv_txn drop column if exists sale_tax_amount;
    alter table inv_txn drop column if exists pos_id;
    alter table inv_txn drop if exists batch_id;
    alter table inv_txn drop if exists dummy;
-- VOUCHER --
    alter table voucher drop column if exists branch_gst;
    alter table voucher drop column if exists party_gst;
    alter table voucher drop column if exists party_id;
    alter table voucher drop column if exists party_name;
    alter table voucher drop column if exists pos_counter_code;
    alter table voucher drop column if exists approval_state;
    alter table voucher drop column if exists require_no_of_approval;
    alter table voucher drop column if exists pos_counter_session_id;
    alter table voucher drop column if exists pos_counter_settlement_id;
-- ACCOUNT_DAILY_SUMMARY --
    alter table account_daily_summary alter column amount drop expression;
-- ACCOUNT --
    alter table account alter column val_name drop expression;
    alter table account drop column if exists contact_type;
    alter table account drop column if exists hide;
    alter table account drop column if exists short_name;
    alter table account drop column if exists gst_type;
    alter table account drop column if exists cheque_in_favour_of;
    alter table account drop column if exists description;
    alter table account drop column if exists is_commission_discounted;
    alter table account drop column if exists commission;
    alter table account drop column if exists aadhar_no;
    alter table account drop column if exists alternate_mobile;
    alter table account drop column if exists telephone;
    alter table account drop column if exists contact_person;
    alter table account drop column if exists category1;
    alter table account drop column if exists category2;
    alter table account drop column if exists category3;
    alter table account drop column if exists category4;
    alter table account drop column if exists category5;
    alter table account drop column if exists agent_id;
    alter table account drop column if exists commission_account_id;
    alter table account drop column if exists delivery_address;
    alter table account drop column if exists enable_loyalty_point;
    alter table account drop column if exists loyalty_point;
    alter table account drop column if exists tags;
    alter table account drop column if exists e_banking_enabled;
    alter table account drop column if exists transport_detail;
    alter table account drop column if exists service_charge_gst_account_id;
    alter table account drop column if exists service_charge_non_gst_account_id;
    alter table account drop column if exists itc_ineligible;
    alter table account drop column if exists secondary_emails;
-- BANK --
    alter table bank drop column if exists created_at;
    alter table bank drop column if exists updated_at;
-- BANK_BENEFICIARY --
    alter table bank_beneficiary drop column if exists bank_name;
    alter table bank_beneficiary drop column if exists bank_code;
-- BANK_TXN --
    alter table bank_txn alter column credit drop expression;
    alter table bank_txn alter column debit drop expression;
    alter table bank_txn drop column if exists in_favour_of;
    alter table bank_txn drop column if exists base_account_types;
    alter table bank_txn drop column if exists alt_account_name;
    alter table bank_txn drop column if exists bank_beneficiary_id;
    alter table bank_txn drop column if exists epayment_tran_ref;
    alter table bank_txn drop column if exists epayment_req_ref;
    alter table bank_txn drop column if exists epayment_status;
    alter table bank_txn drop column if exists bank_ref_no;
    alter table bank_txn drop column if exists bank_particulars;
    alter table bank_txn drop column if exists emailed;
-- BATCH --
    alter table batch alter column p_rate drop expression;
    alter table batch alter column closing drop expression;
    alter table batch drop column if exists sno;
    alter table batch drop column if exists reorder_inventory_id;
    alter table batch drop column if exists inventory_hsn;
    alter table batch drop column if exists branch_name;
    alter table batch drop column if exists warehouse_name;
    alter table batch drop column if exists division_id;
    alter table batch drop column if exists division_name;
    alter table batch drop column if exists txn_id;
    alter table batch drop column if exists inventory_voucher_id;
    alter table batch drop column if exists opening_p_rate;
    alter table batch drop column if exists label_qty;
    alter table batch drop column if exists retail_qty;
    alter table batch drop column if exists is_retail_qty;
    alter table batch drop column if exists unit_name;
    alter table batch drop column if exists source_batch_id;
    alter table batch drop column if exists manufacturer_name;
    alter table batch drop column if exists vendor_name;
    alter table batch drop column if exists category1_name;
    alter table batch drop column if exists category2_id;
    alter table batch drop column if exists category2_name;
    alter table batch drop column if exists category3_id;
    alter table batch drop column if exists category3_name;
-- BILL_ALLOCATION --
    alter table bill_allocation drop column if exists base_account_types;
    alter table bill_allocation drop column if exists pending;
    alter table bill_allocation drop column if exists is_approved;
    alter table bill_allocation drop column if exists due_date;
    alter table bill_allocation drop column if exists account_type_name;
    alter table bill_allocation drop column if exists bill_date;
-- INVENTORY --
    alter table inventory alter column val_name drop expression;
    alter table inventory drop column if exists cess;
    alter table inventory drop column if exists division_id;
    alter table inventory drop column if exists inventory_type;
    alter table inventory drop column if exists retail_qty;
    alter table inventory drop column if exists reorder_inventory_id;
    alter table inventory drop column if exists bulk_inventory_id;
    alter table inventory drop column if exists distribution_qty;
    alter table inventory drop column if exists purchase_config;
    alter table inventory drop column if exists sale_config;
    alter table inventory drop column if exists tags;
    alter table inventory drop column if exists description;
    alter table inventory drop column if exists manufacturer_name;
    alter table inventory drop column if exists vendor_id;
    alter table inventory drop column if exists vendor_name;
    alter table inventory drop column if exists vendors;
    alter table inventory drop column if exists set_rate_values_via_purchase;
    alter table inventory drop column if exists apply_s_rate_from_master_for_sale;
    alter table inventory drop column if exists fitting_charge;
    alter table inventory drop column if exists itc_ineligible;
    alter table inventory drop column if exists category2_id;
    alter table inventory drop column if exists category3_id;
    alter table inventory drop column if exists category1_name;
    alter table inventory drop column if exists category2_name;
    alter table inventory drop column if exists category3_name;
    alter table inventory drop column if exists incentive_applicable;
    alter table inventory drop column if exists incentive_range_id;
    alter table inventory drop column if exists incentive_type;
-- INVENTORY_BRANCH_DETAIL --
    alter table inventory_branch_detail drop column if exists inventory_name;
    alter table inventory_branch_detail drop column if exists branch_name;
    alter table inventory_branch_detail drop column if exists inventory_barcodes;
    alter table inventory_branch_detail drop column if exists s_disc;
    alter table inventory_branch_detail drop column if exists discount_1;
    alter table inventory_branch_detail drop column if exists discount_2;
    alter table inventory_branch_detail drop column if exists preferred_vendor_name;
    alter table inventory_branch_detail drop column if exists last_vendor_name;
    alter table inventory_branch_detail drop column if exists s_customer_disc;
    alter table inventory_branch_detail drop column if exists p_rate_tax_inc;
    alter table inventory_branch_detail drop column if exists reorder_inventory_id;
    alter table inventory_branch_detail drop column if exists val_name;
    alter table inventory_branch_detail drop column if exists division_id;
-- MEMBER --
    alter table member drop column if exists remote_access;
    alter table member drop column if exists user_id;
    alter table member drop column if exists role_id;
-- VOUCHER_TYPE --
    alter table voucher_type drop column if exists approve1_id;
    alter table voucher_type drop column if exists approve2_id;
    alter table voucher_type drop column if exists approve3_id;
    alter table voucher_type drop column if exists approve4_id;
    alter table voucher_type drop column if exists approve5_id;
-- TDS_ON_VOUCHER --
    alter table tds_on_voucher alter column amount_after_tds_deduction drop expression;
    alter table tds_on_voucher drop column if exists branch_name;
    alter table tds_on_voucher drop column if exists pending_id;
-- UNIT --
    alter table unit drop column conversions;
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
    drop table if exists category_option;
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
    drop table if exists shipment;
    drop table if exists stock_journal;
    drop table if exists stock_journal_inv_item;
    drop table if exists stock_value;
    drop table if exists stock_value_opening;
    drop table if exists sales_emi_reconciliation_voucher;
    drop table if exists tag;
    drop table if exists tally_account_map;
    drop table if exists vault;
    drop table if exists seaql_migrations;

-------------------------------------------------------------------------------------------------
---- DROP UNWANTED COLUMN AND RENAME THE REQUIRED ONE
-------------------------------------------------------------------------------------------------
-- AC_TXN
    alter table ac_txn drop column if exists id;
    alter table ac_txn rename column uuid_id to id;
    alter table ac_txn alter column id set not null;
    ALTER TABLE ac_txn ADD CONSTRAINT ac_txn_pkey PRIMARY KEY (id);
        --
        alter table bank_txn drop column if exists ac_txn_id;
        alter table bank_txn rename column ac_txn_uuid to ac_txn_id;
        alter table bank_txn alter column ac_txn_id set not null;
        --
        alter table bill_allocation drop column if exists ac_txn_id;
        alter table bill_allocation rename column ac_txn_uuid to ac_txn_id;
        alter table bill_allocation alter column ac_txn_id set not null;
-- ACCOUNT
    alter table account drop column if exists id;
    alter table account rename column uuid_id to id;
    alter table account alter column id set not null;
    ALTER TABLE account ADD CONSTRAINT account_pkey PRIMARY KEY (id);
        --
        alter table ac_txn drop column if exists account_id;
        alter table ac_txn rename column account_uuid to account_id;
        alter table ac_txn alter column account_id set not null;
        --
        alter table ac_txn drop column if exists alt_account_id;
        alter table ac_txn rename column alt_account_uuid to alt_account_id;
        --
        alter table account_daily_summary drop column if exists account_id;
        alter table account_daily_summary rename column account_uuid to account_id;
        alter table account_daily_summary alter column account_id set not null;
        --
        alter table bank_txn drop column if exists account_id;
        alter table bank_txn rename column account_uuid to account_id;
        alter table bank_txn alter column account_id set not null;
        --
        alter table bank_txn drop column if exists alt_account_id;
        alter table bank_txn rename column alt_account_uuid to alt_account_id;
        --
        alter table branch drop column if exists account_id;
        alter table branch rename column account_uuid to account_id;
        alter table branch alter column account_id set not null;
        alter table branch add unique (account_id);
        --
        alter table bill_allocation drop column if exists account_id;
        alter table bill_allocation rename column account_uuid to account_id;
        alter table bill_allocation alter column account_id set not null;
        --
        alter table batch drop column if exists vendor_id;
        alter table batch rename column vendor_uuid to vendor_id;
        --
        alter table inventory drop column if exists sale_account_id;
        alter table inventory rename column sale_account_uuid to sale_account_id;
        alter table inventory alter column sale_account_id set not null;
        --
        alter table inventory drop column if exists purchase_account_id;
        alter table inventory rename column purchase_account_uuid to purchase_account_id;
        alter table inventory alter column purchase_account_id set not null;
        --
        alter table tds_nature_of_payment drop column if exists tds_account_id;
        alter table tds_nature_of_payment rename column tds_account_uuid to tds_account_id;
        alter table tds_nature_of_payment alter column tds_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists party_account_id;
        alter table tds_on_voucher rename column party_account_uuid to party_account_id;
        alter table tds_on_voucher alter column party_account_id set not null;
        --
        alter table tds_on_voucher drop column if exists tds_account_id;
        alter table tds_on_voucher rename column tds_account_uuid to tds_account_id;
        alter table tds_on_voucher alter column tds_account_id set not null;
        --
        alter table inv_txn drop column if exists vendor_id;
        alter table inv_txn rename column vendor_uuid to vendor_id;
        --
        alter table inv_txn drop column if exists customer_id;
        alter table inv_txn rename column customer_uuid to customer_id;
        --
        alter table voucher drop column if exists vendor_id;
        alter table voucher rename column vendor_uuid to vendor_id;
        --
        alter table voucher drop column if exists customer_id;
        alter table voucher rename column customer_uuid to customer_id;
        --
        alter table inventory_branch_detail drop column if exists preferred_vendor_id;
        alter table inventory_branch_detail rename column preferred_vendor_uuid to preferred_vendor_id;
        --
        alter table inventory_branch_detail drop column if exists last_vendor_id;
        alter table inventory_branch_detail rename column last_vendor_uuid to last_vendor_id;
        --
        alter table gst_tax drop column if exists cgst_payable_account_id;
        alter table gst_tax rename column cgst_payable_account_uuid to cgst_payable_account_id;
        alter table gst_tax alter column cgst_payable_account_id set not null;
        --
        alter table gst_tax drop column if exists sgst_payable_account_id;
        alter table gst_tax rename column sgst_payable_account_uuid to sgst_payable_account_id;
        alter table gst_tax alter column sgst_payable_account_id set not null;
        --
        alter table gst_tax drop column if exists igst_payable_account_id;
        alter table gst_tax rename column igst_payable_account_uuid to igst_payable_account_id;
        alter table gst_tax alter column igst_payable_account_id set not null;
        --
        alter table gst_tax drop column if exists cgst_receivable_account_id;
        alter table gst_tax rename column cgst_receivable_account_uuid to cgst_receivable_account_id;
        alter table gst_tax alter column cgst_receivable_account_id set not null;
        --
        alter table gst_tax drop column if exists sgst_receivable_account_id;
        alter table gst_tax rename column sgst_receivable_account_uuid to sgst_receivable_account_id;
        alter table gst_tax alter column sgst_receivable_account_id set not null;
        --
        alter table gst_tax drop column if exists igst_receivable_account_id;
        alter table gst_tax rename column igst_receivable_account_uuid to igst_receivable_account_id;
        alter table gst_tax alter column igst_receivable_account_id set not null;
        --
        alter table udm_vendor_bill_map drop column if exists vendor_id;
        alter table udm_vendor_bill_map rename column vendor_uuid to vendor_id;
        alter table udm_vendor_bill_map alter column vendor_id set not null;
        alter table udm_vendor_bill_map add constraint udm_vendor_bill_map_pkey PRIMARY KEY (vendor_id);
        --
        alter table udm_vendor_item_map drop column if exists vendor_id;
        alter table udm_vendor_item_map rename column vendor_uuid to vendor_id;
        alter table udm_vendor_item_map alter column vendor_id set not null;
        alter table udm_vendor_item_map add constraint udm_vendor_item_map_pkey PRIMARY KEY (vendor_id, vendor_inventory);
-- ACCOUNT_TYPE
    alter table account_type drop column if exists id;
    alter table account_type rename column uuid_id to id;
    alter table account_type alter column id set not null;
    ALTER TABLE account_type ADD CONSTRAINT account_type_pkey PRIMARY KEY (id);
    alter table account_type drop column if exists parent_id;
    alter table account_type rename column parent_uuid to parent_id;
        --
        alter table ac_txn drop column if exists account_type_id;
        alter table ac_txn rename column account_type_uuid to account_type_id;
        alter table ac_txn alter column account_type_id set not null;
        --
        alter table account drop column if exists account_type_id;
        alter table account rename column account_type_uuid to account_type_id;
        alter table account alter column account_type_id set not null;
        --
        alter table bill_allocation drop column if exists account_type_id;
        alter table bill_allocation rename column account_type_uuid to account_type_id;
        alter table bill_allocation alter column account_type_id set not null;
-- BANK
    alter table bank drop column if exists id;
    alter table bank rename column uuid_id to id;
    alter table bank alter column id set not null;
    ALTER TABLE bank ADD CONSTRAINT bank_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists bank_id;
        alter table account rename column bank_uuid to bank_id;
        --
        alter table bank_beneficiary drop column if exists bank_id;
        alter table bank_beneficiary rename column bank_uuid to bank_id;
        alter table bank_beneficiary alter column bank_id set not null;
-- BANK_BENEFICIARY
    alter table bank_beneficiary drop column if exists id;
    alter table bank_beneficiary rename column uuid_id to id;
    alter table bank_beneficiary alter column id set not null;
    ALTER TABLE bank_beneficiary ADD CONSTRAINT bank_beneficiary_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists bank_beneficiary_id;
        alter table account rename column bank_beneficiary_uuid to bank_beneficiary_id;
-- BRANCH
    alter table branch alter column members drop not null;
    alter table branch drop column if exists id;
    alter table branch rename column uuid_id to id;
    alter table branch alter column id set not null;
    ALTER TABLE branch ADD CONSTRAINT branch_pkey PRIMARY KEY (id);
    alter table branch alter column misc type jsonb using misc::jsonb;
    alter table branch alter column configuration type jsonb using configuration::jsonb;
        --
        alter table ac_txn drop column if exists branch_id;
        alter table ac_txn rename column branch_uuid to branch_id;
        alter table ac_txn alter column branch_id set not null;
        --
        alter table account_daily_summary drop column if exists branch_id;
        alter table account_daily_summary rename column branch_uuid to branch_id;
        alter table account_daily_summary alter column branch_id set not null;
        ALTER TABLE account_daily_summary ADD CONSTRAINT account_daily_summary_pkey PRIMARY KEY (account_id, branch_id, date);
        --
        alter table bank_txn drop column if exists branch_id;
        alter table bank_txn rename column branch_uuid to branch_id;
        alter table bank_txn alter column branch_id set not null;
        --
        alter table batch drop column if exists branch_id;
        alter table batch rename column branch_uuid to branch_id;
        alter table batch alter column branch_id set not null;
        --
        alter table bill_allocation drop column if exists branch_id;
        alter table bill_allocation rename column branch_uuid to branch_id;
        alter table bill_allocation alter column branch_id set not null;
        --
        alter table inv_txn drop column if exists branch_id;
        alter table inv_txn rename column branch_uuid to branch_id;
        alter table inv_txn alter column branch_id set not null;
        --
        alter table inventory_branch_detail drop column if exists branch_id;
        alter table inventory_branch_detail rename column branch_uuid to branch_id;
        alter table inventory_branch_detail alter column branch_id set not null;
        --
        alter table tds_on_voucher drop column if exists branch_id;
        alter table tds_on_voucher rename column branch_uuid to branch_id;
        alter table tds_on_voucher alter column branch_id set not null;
        --
        alter table voucher_numbering drop column if exists branch_id;
        alter table voucher_numbering rename column branch_uuid to branch_id;
        --
        alter table voucher drop column if exists branch_id;
        alter table voucher rename column branch_uuid to branch_id;
        alter table voucher alter column branch_id set not null;
        --
        alter table voucher drop column if exists udf_alt_branch_id;
        alter table voucher rename column udf_alt_branch_uuid to udf_alt_branch_id;
-- GST_REGISTRATION
    alter table gst_registration drop column if exists id;
    alter table gst_registration rename column uuid_id to id;
    alter table gst_registration alter column id set not null;
    ALTER TABLE gst_registration ADD CONSTRAINT gst_registration_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists gst_registration_id;
        alter table branch rename column gst_registration_uuid to gst_registration_id;
-- INVENTORY
    alter table inventory drop column if exists id;
    alter table inventory rename column uuid_id to id;
    alter table inventory alter column id set not null;
    ALTER TABLE inventory ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists inventory_id;
        alter table batch rename column inventory_uuid to inventory_id;
        alter table batch alter column inventory_id set not null;
        --
        alter table bill_of_material drop column if exists inventory_id;
        alter table bill_of_material rename column inventory_uuid to inventory_id;
        alter table bill_of_material alter column inventory_id set not null;
        --
        alter table inv_txn drop column if exists inventory_id;
        alter table inv_txn rename column inventory_uuid to inventory_id;
        alter table inv_txn alter column inventory_id set not null;
        --
        alter table inventory_branch_detail drop column if exists inventory_id;
        alter table inventory_branch_detail rename column inventory_uuid to inventory_id;
        alter table inventory_branch_detail alter column inventory_id set not null;
        alter table inventory_branch_detail add constraint inventory_branch_detail_pkey primary key (branch_id, inventory_id);
        --
        alter table udm_vendor_item_map drop column if exists inventory_id;
        alter table udm_vendor_item_map rename column inventory_uuid to inventory_id;
        alter table udm_vendor_item_map alter column inventory_id set not null;
-- MANUFACTURER
    alter table manufacturer drop column if exists id;
    alter table manufacturer rename column uuid_id to id;
    alter table manufacturer alter column id set not null;
    ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists manufacturer_id;
        alter table batch rename column manufacturer_uuid to manufacturer_id;
        --
        alter table inv_txn drop column if exists manufacturer_id;
        alter table inv_txn rename column manufacturer_uuid to manufacturer_id;
        --
        alter table inventory drop column if exists manufacturer_id;
        alter table inventory rename column manufacturer_uuid to manufacturer_id;
-- SALES_PERSON
    alter table sales_person drop column if exists id;
    alter table sales_person rename column uuid_id to id;
    alter table sales_person alter column id set not null;
    ALTER TABLE sales_person ADD CONSTRAINT sales_person_pkey PRIMARY KEY (id);
        --
        alter table inv_txn drop column if exists sales_person_id;
        alter table inv_txn rename column sales_person_uuid to sales_person_id;
        --
        alter table voucher drop column if exists sales_person_id;
        alter table voucher rename column sales_person_uuid to sales_person_id;
-- SECTION
    alter table section drop column if exists id;
    alter table section rename column uuid_id to id;
    alter table section alter column id set not null;
    ALTER TABLE section ADD CONSTRAINT section_pkey PRIMARY KEY (id);
        --
        alter table inventory drop column if exists section_id;
        alter table inventory rename column section_uuid to section_id;
        --
        alter table batch drop column if exists section_id;
        alter table batch rename column section_uuid to section_id;
        --
        alter table inv_txn drop column if exists section_id;
        alter table inv_txn rename column section_uuid to section_id;
-- TDS_NATURE_OF_PAYMENT
    alter table tds_nature_of_payment drop column if exists id;
    alter table tds_nature_of_payment rename column uuid_id to id;
    alter table tds_nature_of_payment alter column id set not null;
    ALTER TABLE tds_nature_of_payment ADD CONSTRAINT tds_nature_of_payment_pkey PRIMARY KEY (id);
        --
        alter table account drop column if exists tds_nature_of_payment_id;
        alter table account rename column tds_nature_of_payment_uuid to tds_nature_of_payment_id;
        --
        alter table tds_on_voucher drop column if exists tds_nature_of_payment_id;
        alter table tds_on_voucher rename column tds_nature_of_payment_uuid to tds_nature_of_payment_id;
        alter table tds_on_voucher alter column tds_nature_of_payment_id set not null;
-- UNIT
    alter table unit drop column if exists id;
    alter table unit rename column uuid_id to id;
    alter table unit alter column id set not null;
    ALTER TABLE unit ADD CONSTRAINT unit_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists unit_id;
        alter table batch rename column unit_uuid to unit_id;
        alter table batch alter column unit_id set not null;
        --
        alter table inv_txn drop column if exists unit_id;
        alter table inv_txn rename column unit_uuid to unit_id;
        alter table inv_txn alter column unit_id set not null;
        --
        alter table inventory drop column if exists unit_id;
        alter table inventory rename column unit_uuid to unit_id;
        alter table inventory alter column unit_id set not null;
        --
        alter table inventory drop column if exists sale_unit_id;
        alter table inventory rename column sale_unit_uuid to sale_unit_id;
        --
        alter table inventory drop column if exists purchase_unit_id;
        alter table inventory rename column purchase_unit_uuid to purchase_unit_id;
-- VOUCHER
    alter table voucher drop column if exists id;
    alter table voucher rename column session to id;
    alter table voucher alter column id set not null;
    ALTER TABLE voucher ADD CONSTRAINT voucher_pkey PRIMARY KEY (id);
    alter table voucher drop constraint voucher_session_key;
    --
    alter table voucher drop column if exists udf_transfer_voucher_id;
    alter table voucher rename column udf_transfer_voucher_uuid to udf_transfer_voucher_id;
        --
        alter table ac_txn drop column if exists voucher_id;
        alter table ac_txn rename column voucher_uuid to voucher_id;
        --
        alter table bank_txn drop column if exists voucher_id;
        alter table bank_txn rename column voucher_uuid to voucher_id;
        alter table bank_txn alter column voucher_id set not null;
        --
        alter table batch drop column if exists voucher_id;
        alter table batch rename column voucher_uuid to voucher_id;
        --
        alter table bill_allocation drop column if exists voucher_id;
        alter table bill_allocation rename column voucher_uuid to voucher_id;
        --
        alter table inv_txn drop column if exists voucher_id;
        alter table inv_txn rename column voucher_uuid to voucher_id;
        --
        alter table tds_on_voucher drop column if exists voucher_id;
        alter table tds_on_voucher rename column voucher_uuid to voucher_id;
        alter table tds_on_voucher alter column voucher_id set not null;
-- VOUCHER_TYPE
    alter table voucher_type drop column if exists id;
    alter table voucher_type rename column uuid_id to id;
    alter table voucher_type alter column id set not null;
    ALTER TABLE voucher_type ADD CONSTRAINT voucher_type_pkey PRIMARY KEY (id);
    alter table voucher_type drop column if exists sequence_id;
    alter table voucher_type rename column sequence_uuid to sequence_id;
        --
        alter table ac_txn drop column if exists voucher_type_id;
        alter table ac_txn rename column voucher_type_uuid to voucher_type_id;
        --
        alter table inv_txn drop column if exists voucher_type_id;
        alter table inv_txn rename column voucher_type_uuid to voucher_type_id;
        --
        alter table voucher_numbering drop column if exists voucher_type_id;
        alter table voucher_numbering rename column voucher_type_uuid to voucher_type_id;
         --
        alter table voucher drop column if exists voucher_type_id;
        alter table voucher rename column voucher_type_uuid to voucher_type_id;
        alter table voucher alter column voucher_type_id set not null;
-- WAREHOUSE
    alter table warehouse drop column if exists id;
    alter table warehouse rename column uuid_id to id;
    alter table warehouse alter column id set not null;
    ALTER TABLE warehouse ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);
        --
        alter table batch drop column if exists warehouse_id;
        alter table batch rename column warehouse_uuid to warehouse_id;
        alter table batch alter column warehouse_id set not null;
        alter table batch drop column if exists id;
        --
        alter table inv_txn drop column if exists warehouse_id;
        alter table inv_txn rename column warehouse_uuid to warehouse_id;
        alter table inv_txn alter column warehouse_id set not null;
        --
        alter table voucher drop column if exists warehouse_id;
        alter table voucher rename column warehouse_uuid to warehouse_id;
        --
        alter table voucher drop column if exists udf_alt_warehouse_id;
        alter table voucher rename column udf_alt_warehouse_uuid to udf_alt_warehouse_id;
-- MEMBER
    alter table member drop column if exists id;
    alter table member rename column uuid_id to id;
    alter table member alter column id set not null;
    ALTER TABLE member ADD CONSTRAINT member_pkey PRIMARY KEY (id);
        --
        alter table branch drop column if exists members;
        alter table branch rename column members_uuid to members;
        alter table branch alter column members set not null;
-- FINANCIAL_YEAR
    alter table financial_year drop column if exists id;
    alter table financial_year rename column uuid_id to id;
    alter table financial_year alter column id set not null;
    ALTER TABLE financial_year ADD CONSTRAINT financial_year_pkey PRIMARY KEY (id);
        --
        alter table voucher_numbering drop column if exists f_year_id;
        alter table voucher_numbering rename column f_year_uuid to f_year_id;
        alter table voucher_numbering ADD CONSTRAINT voucher_numbering_pkey PRIMARY KEY (branch_id, f_year_id, voucher_type_id);
-- BILL_OF_MATERIAL
    alter table bill_of_material drop column if exists id;
    alter table bill_of_material rename column uuid_id to id;
    alter table bill_of_material alter column id set not null;
    ALTER TABLE bill_of_material ADD CONSTRAINT bill_of_material_pkey PRIMARY KEY (id);
-- BATCH
    alter table batch add unique (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
-- PRINT_TEMPLATE
    alter table print_template drop column if exists id;
    alter table print_template rename column uuid_id to id;
    alter table print_template alter column id set not null;
    ALTER TABLE print_template ADD CONSTRAINT print_template_pkey PRIMARY KEY (id);
-- UDM_DOCTOR
    alter table udm_doctor drop column if exists id;
    alter table udm_doctor rename column uuid_id to id;
    alter table udm_doctor alter column id set not null;
    ALTER TABLE udm_doctor ADD CONSTRAINT udm_doctor_pkey PRIMARY KEY (id);
        --
        alter table voucher drop column if exists udf_doctor_id;
        alter table voucher rename column udf_doctor_uuid to udf_doctor_id;
-- UDM_DRUG_CLASSIFICATION
    alter table udm_drug_classification drop column if exists id;
    alter table udm_drug_classification rename column uuid_id to id;
    alter table udm_drug_classification alter column id set not null;
    ALTER TABLE udm_drug_classification ADD CONSTRAINT udm_drug_classification_pkey PRIMARY KEY (id);
        --
        alter table inv_txn drop column if exists udf_drug_classifications;
        alter table inv_txn rename column udf_drug_classifications_uuid to udf_drug_classifications;
        --
        alter table udm_inventory_composition drop column if exists drug_classifications;
        alter table udm_inventory_composition rename column drug_classifications_uuid to drug_classifications;
-- UDM_INVENTORY_COMPOSITION
    alter table udm_inventory_composition drop column if exists id;
    alter table udm_inventory_composition rename column uuid_id to id;
    alter table udm_inventory_composition alter column id set not null;
    ALTER TABLE udm_inventory_composition ADD CONSTRAINT udm_inventory_composition_pkey PRIMARY KEY (id);
        --
        alter table inventory drop column if exists udf_compositions;
        alter table inventory rename column udf_compositions_uuid to udf_compositions;

-------------------------------------------------------------------------------------------------
---- DROP TEMP INDEX
-------------------------------------------------------------------------------------------------
-- AC_TXN
-- DROP INDEX ac_txn_alt_account_id_idx;
-- DROP INDEX ac_txn_alt_voucher_type_id_idx;
-- DROP INDEX ac_txn_alt_account_type_id_idx;
-- DROP INDEX ac_txn_alt_branch_id_idx;
-- -- BATCH
-- DROP INDEX batch_vendor_id_idx;
-- DROP INDEX batch_warehouse_id_idx;
-- DROP INDEX batch_unit_id_idx;
-- DROP INDEX batch_voucher_id_idx;
-- -- INV_TXN
-- DROP INDEX inv_txn_vendor_id_idx;
-- DROP INDEX inv_txn_customer_id_idx;
-- DROP INDEX inv_txn_branch_id_idx;
-- DROP INDEX inv_txn_batch_id_idx;
-- DROP INDEX inv_txn_inventory_id_idx;
-- DROP INDEX inv_txn_manufacturer_id_idx;
-- DROP INDEX inv_txn_sales_person_id_idx;
-- DROP INDEX inv_txn_voucher_id_idx;
-- DROP INDEX inv_txn_unit_id_idx;
-- DROP INDEX inv_txn_voucher_type_id_idx;
-- DROP INDEX inv_txn_warehouse_id_idx;
-- -- VOUCHER
-- DROP INDEX voucher_vendor_id_idx;
-- DROP INDEX voucher_customer_id_idx;
-- DROP INDEX voucher_branch_id_idx;
-- DROP INDEX voucher_sales_person_id_idx;
-- DROP INDEX voucher_voucher_type_id_idx;
-- DROP INDEX voucher_warehouse_id_idx;
--
-- DROP INDEX batch_batch_id_idx;
-- DROP INDEX batch_inventory_id_idx;
-- DROP INDEX batch_manufacturer_id_idx;

-------------------------------------------------------------------------------------------------
---- INDEX RESTORE
-------------------------------------------------------------------------------------------------
--## ac_txn
    create index on ac_txn (voucher_id);
    create index on ac_txn (date);
    create index on ac_txn (account_id);
    create index on ac_txn (branch_id);
--## account
    create index on account (val_name);
    create index on account (transaction_enabled);
--## bank_txn
    create index on bank_txn (date);
    create index on bank_txn (ac_txn_id);
    create index on bank_txn (account_id);
    create index on bank_txn (voucher_id);
--## batch
    create index on batch (barcode);
    create index on batch (inventory_id, branch_id, warehouse_id);
--## bill_allocation
    create index on bill_allocation (eff_date);
    create index on bill_allocation (ac_txn_id);
    create index on bill_allocation (account_id);
    create index on bill_allocation (voucher_id);
    create index on bill_allocation (branch_id, account_id, ref_no);
--## inv_txn
    create index on inv_txn (voucher_id);
    create index on inv_txn (date);
    create index on inv_txn (inventory_id);
    create index on inv_txn (branch_id);
    create index on inv_txn (inventory_id, branch_id, warehouse_id, batch_no, vendor_id);
--## inventory
    create index on inventory (val_name);
--## voucher
    create index on voucher (date);
    create index on voucher (voucher_no);
    create index on voucher (branch_id);
    create index on voucher (base_voucher_type);

--## last query
delete from unit_conversion where conversion = 1;