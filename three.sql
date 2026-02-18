-- PRINT_LAYOUT --
--##
alter table print_layout
    add column if not exists is_default boolean default true;
--##
alter table print_layout
    alter column is_default set not null;
--##
update print_layout
set id = 'STOCK_JOURNAL'
where id = 'STOCK_DEDUCTION';
--##
alter table print_layout
    alter column is_default drop default;
--##
alter table print_layout
    rename column type to mode;
-- PRINT_LAYOUT --

-- PRINT_TEMPLATE --
update print_template
set layout = 'STOCK_JOURNAL'
where layout = 'STOCK_DEDUCTION';
--##
alter table print_template
    rename column type to mode;
-- PRINT_TEMPLATE --

--NO CHANGES--

    -- account_daily_summary
    -- account_type
    -- bill_of_material
    -- branch
    -- country
    -- financial_year
    -- gst_registration
    -- hsn_code
    -- manufacturer
    -- organization
    -- warehouse
    -- voucher_numbering
    -- stock_location
    -- tds_nature_of_payment

--NEW TABLE--

-- BASE_VOUCHER_TYPE --
--##
create table if not exists base_voucher_type
(
    base_type text  not null primary key,
    name text       not null,
    is_default bool not null
);
--##
insert into base_voucher_type (base_type, name, is_default)
values ('PAYMENT', 'Payment', true),
       ('RECEIPT', 'Receipt', true),
       ('CONTRA', 'Contra', true),
       ('JOURNAL', 'Journal', true),
       ('SALE', 'Sale', true),
       ('CREDIT_NOTE', 'Credit Note', true),
       ('PURCHASE', 'Purchase', true),
       ('DEBIT_NOTE', 'Debit Note', true),
       ('SALE_QUOTATION', 'Sale Quotation', true),
       ('STOCK_JOURNAL', 'Stock Journal', true),
       ('GOODS_INWARD_NOTE', 'Goods Inward Note', true),
       ('DELIVERY_NOTE', 'Delivery Note', true),
       ('DELIVERY_RECEIPT', 'Delivery Receipt', true);
--##
-- BASE_VOUCHER_TYPE --

-- GST_TAX --
--##
create table if not exists gst_tax
(
    name                       text  primary key,
    display_name               text  not null,
    igst                       float not null,
    cgst                       float not null,
    sgst                       float not null,
    cgst_payable_account_id    int   not null,
    sgst_payable_account_id    int   not null,
    igst_payable_account_id    int   not null,
    cgst_receivable_account_id int   not null,
    sgst_receivable_account_id int   not null,
    igst_receivable_account_id int   not null
);
--##
insert into gst_tax
(name, display_name, igst, cgst, sgst, cgst_payable_account_id, sgst_payable_account_id, igst_payable_account_id,
 cgst_receivable_account_id, sgst_receivable_account_id, igst_receivable_account_id)
values ('gstna', 'Not Applicable', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gstexempt', 'Exempt', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gstngs', 'Non Gst Supply', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gst0', 'Gst 0%', 0.0, 0.0, 0.0, 4, 5, 6, 8, 9, 10),
       ('gst0p1', 'Gst 0.1%', 0.1, 0.05, 0.05, 4, 5, 6, 8, 9, 10),
       ('gst0p25', 'Gst 0.25%', 0.25, 0.125, 0.125, 4, 5, 6, 8, 9, 10),
       ('gst1', 'Gst 1%', 1.0, 0.5, 0.5, 4, 5, 6, 8, 9, 10),
       ('gst1p5', 'Gst 1.5%', 1.50, 0.75, 0.75, 4, 5, 6, 8, 9, 10),
       ('gst3', 'Gst 3%', 3.0, 1.5, 1.5, 4, 5, 6, 8, 9, 10),
       ('gst5', 'Gst 5%', 5.0, 2.5, 2.5, 4, 5, 6, 8, 9, 10),
       ('gst6', 'Gst 6%', 6.0, 3.0, 3.0, 4, 5, 6, 8, 9, 10),
       ('gst7p5', 'Gst 7.5%', 7.5, 3.75, 3.75, 4, 5, 6, 8, 9, 10),
       ('gst12', 'Gst 12%', 12.0, 6.0, 6.0, 4, 5, 6, 8, 9, 10),
       ('gst18', 'Gst 18%', 18.0, 9.0, 9.0, 4, 5, 6, 8, 9, 10),
       ('gst28', 'Gst 28%', 28.0, 14.0, 14.0, 4, 5, 6, 8, 9, 10),
       ('gst40', 'Gst 40%', 40.0, 20.0, 20.0, 4, 5, 6, 8, 9, 10);
--##
-- GST_TAX --

-- SECTION --
--##
create table if not exists section
(
    id         serial primary key,
    name       text      not null,
    created_by int       not null,
    updated_by int       not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
INSERT INTO section (id, name, created_by, updated_by, created_at, updated_at)
SELECT id, name, created_by, updated_by, created_at, updated_at
FROM category_option;
--##
SELECT setval('section_id_seq', (select max(id) from section));
--##
    -- CATEGORY_OPTION --
        drop table if exists category_option;
    -- CATEGORY_OPTION --
--##
-- SECTION --

-- UNIT_CONVERSION --
--##
create table if not exists unit_conversion
(
    primary_unit_id    uuid       not null,
    conversion_unit_id uuid       not null,
    conversion         float     not null,
    primary key (primary_unit_id, conversion)
);
--##
-- UNIT_CONVERSION --

-- UQC --
--##
create table if not exists uqc
(
    id   text primary key,
    name text not null
);
--##
-- UQC --

--## permissions
create table if not exists permission
(
    name       text primary key,
    created_by int      not null,
    updated_by int      not null,
    created_at timestamp not null,
    updated_at timestamp not null
);
--##
------------------------------
--## permission insert
--##
insert into permission (name, created_by, updated_by, created_at, updated_at)
values
    --account
    ('account_create', 1, 1, current_timestamp, current_timestamp),
    ('account_update', 1, 1, current_timestamp, current_timestamp),
    ('account_get', 1, 1, current_timestamp, current_timestamp),
    ('account_list', 1, 1, current_timestamp, current_timestamp),
    ('account_delete', 1, 1, current_timestamp, current_timestamp),
    --account_type
    ('account_type_create', 1, 1, current_timestamp, current_timestamp),
    ('account_type_update', 1, 1, current_timestamp, current_timestamp),
    ('account_type_get', 1, 1, current_timestamp, current_timestamp),
    ('account_type_list', 1, 1, current_timestamp, current_timestamp),
    ('account_type_delete', 1, 1, current_timestamp, current_timestamp),
    --bank_beneficiary
    ('bank_beneficiary_create', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_update', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_get', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_list', 1, 1, current_timestamp, current_timestamp),
    ('bank_beneficiary_delete', 1, 1, current_timestamp, current_timestamp),
    --base_voucher_type
    ('base_voucher_type_create', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_get', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_list', 1, 1, current_timestamp, current_timestamp),
    ('base_voucher_type_delete', 1, 1, current_timestamp, current_timestamp),
    --batch
    ('batch_label', 1, 1, current_timestamp, current_timestamp),
    ('batch_list', 1, 1, current_timestamp, current_timestamp),
    ('batch_update', 1, 1, current_timestamp, current_timestamp),
    --bill_allocation_breakup
    ('bill_allocation_breakup', 1, 1, current_timestamp, current_timestamp),
    --bill_of_material
    ('bill_of_material_create', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_update', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_get', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_list', 1, 1, current_timestamp, current_timestamp),
    ('bill_of_material_delete', 1, 1, current_timestamp, current_timestamp),
    --branch
    ('branch_create', 1, 1, current_timestamp, current_timestamp),
    ('branch_update', 1, 1, current_timestamp, current_timestamp),
    ('branch_get', 1, 1, current_timestamp, current_timestamp),
    ('branch_list', 1, 1, current_timestamp, current_timestamp),
    ('branch_delete', 1, 1, current_timestamp, current_timestamp),
    --gst_registration
    ('gst_registration_create', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_update', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_get', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_list', 1, 1, current_timestamp, current_timestamp),
    ('gst_registration_delete', 1, 1, current_timestamp, current_timestamp),
    --gst_tax
    ('gst_tax_update', 1, 1, current_timestamp, current_timestamp),
    --gstr_2b
    ('gstr_2b_get', 1, 1, current_timestamp, current_timestamp),
    ('gstr_2b_reconcile', 1, 1, current_timestamp, current_timestamp),
    ('gstr_2b_upload', 1, 1, current_timestamp, current_timestamp),
    --section
    ('section_create', 1, 1, current_timestamp, current_timestamp),
    ('section_update', 1, 1, current_timestamp, current_timestamp),
    ('section_get', 1, 1, current_timestamp, current_timestamp),
    ('section_list', 1, 1, current_timestamp, current_timestamp),
    ('section_delete', 1, 1, current_timestamp, current_timestamp),
    --inventory
    ('inventory_create', 1, 1, current_timestamp, current_timestamp),
    ('inventory_update', 1, 1, current_timestamp, current_timestamp),
    ('inventory_get', 1, 1, current_timestamp, current_timestamp),
    ('inventory_list', 1, 1, current_timestamp, current_timestamp),
    ('inventory_delete', 1, 1, current_timestamp, current_timestamp),
    --inventory_opening
    ('inventory_opening', 1, 1, current_timestamp, current_timestamp),
    --unit_conversion
    ('unit_conversion_set', 1, 1, current_timestamp, current_timestamp),
    --unit
    ('unit_create', 1, 1, current_timestamp, current_timestamp),
    ('unit_update', 1, 1, current_timestamp, current_timestamp),
    ('unit_get', 1, 1, current_timestamp, current_timestamp),
    ('unit_list', 1, 1, current_timestamp, current_timestamp),
    ('unit_delete', 1, 1, current_timestamp, current_timestamp),
    --financial_report
    ('financial_report', 1, 1, current_timestamp, current_timestamp),
    ('opening_balance_difference', 1, 1, current_timestamp, current_timestamp),
    --financial_year
    ('financial_year_add', 1, 1, current_timestamp, current_timestamp),
    ('financial_year_get', 1, 1, current_timestamp, current_timestamp),
    ('financial_year_list', 1, 1, current_timestamp, current_timestamp),
    --manufacturer
    ('manufacturer_create', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_update', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_get', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_list', 1, 1, current_timestamp, current_timestamp),
    ('manufacturer_delete', 1, 1, current_timestamp, current_timestamp),
    --warehouse
    ('warehouse_create', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_update', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_get', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_list', 1, 1, current_timestamp, current_timestamp),
    ('warehouse_delete', 1, 1, current_timestamp, current_timestamp),
    --member
    ('member_create', 1, 1, current_timestamp, current_timestamp),
    ('member_update', 1, 1, current_timestamp, current_timestamp),
    ('member_get', 1, 1, current_timestamp, current_timestamp),
    ('member_list', 1, 1, current_timestamp, current_timestamp),
    --permission
    ('permission_create', 1, 1, current_timestamp, current_timestamp),
    ('permission_update', 1, 1, current_timestamp, current_timestamp),
    ('permission_get', 1, 1, current_timestamp, current_timestamp),
    ('permission_list', 1, 1, current_timestamp, current_timestamp),
    ('permission_delete', 1, 1, current_timestamp, current_timestamp),
    --tds_nature_of_payment
    ('tds_nature_of_payment_create', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_update', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_get', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_list', 1, 1, current_timestamp, current_timestamp),
    ('tds_nature_of_payment_delete', 1, 1, current_timestamp, current_timestamp),
    --tds_section_breakup
    ('tds_section_breakup', 1, 1, current_timestamp, current_timestamp),
    --print_layout
    ('print_layout_get', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_list', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_create', 1, 1, current_timestamp, current_timestamp),
    ('print_layout_update', 1, 1, current_timestamp, current_timestamp),
    --print_template
    ('print_template_create', 1, 1, current_timestamp, current_timestamp),
    ('print_template_reset', 1, 1, current_timestamp, current_timestamp),
    ('print_template_get', 1, 1, current_timestamp, current_timestamp),
    ('print_template_cancel', 1, 1, current_timestamp, current_timestamp),
    ('print_template_delete', 1, 1, current_timestamp, current_timestamp),
    --stock_location
    ('stock_location_create', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_update', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_get', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_list', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_delete', 1, 1, current_timestamp, current_timestamp),
    ('stock_location_assign', 1, 1, current_timestamp, current_timestamp),
    --set_inventory_branch_price_configuration
    ('price_configuration_set', 1, 1, current_timestamp, current_timestamp),
    --organization
    ('organization_get', 1, 1, current_timestamp, current_timestamp),
    ('organization_update', 1, 1, current_timestamp, current_timestamp),
    --voucher_register
    ('voucher_register_detail', 1, 1, current_timestamp, current_timestamp),
    ('voucher_register_group', 1, 1, current_timestamp, current_timestamp),
    --voucher_type
    ('voucher_type_create', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_update', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_get', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_list', 1, 1, current_timestamp, current_timestamp),
    ('voucher_type_delete', 1, 1, current_timestamp, current_timestamp),
    --voucher
    ('voucher_create', 1, 1, current_timestamp, current_timestamp),
    ('voucher_update', 1, 1, current_timestamp, current_timestamp),
    ('voucher_get', 1, 1, current_timestamp, current_timestamp),
    ('voucher_cancel', 1, 1, current_timestamp, current_timestamp),
    ('voucher_delete', 1, 1, current_timestamp, current_timestamp),
    --report and other
    ('account_book', 1, 1, current_timestamp, current_timestamp),
    ('account_outstanding', 1, 1, current_timestamp, current_timestamp),
    ('account_transaction_history', 1, 1, current_timestamp, current_timestamp),
    ('bill_outstanding', 1, 1, current_timestamp, current_timestamp),
    ('bank_collection', 1, 1, current_timestamp, current_timestamp),
    ('bank_list', 1, 1, current_timestamp, current_timestamp),
    ('gst_r1', 1, 1, current_timestamp, current_timestamp),
    ('day_book', 1, 1, current_timestamp, current_timestamp),
    ('bank_reconciliation', 1, 1, current_timestamp, current_timestamp),
    ('sale_analysis', 1, 1, current_timestamp, current_timestamp),
    ('stock_analysis', 1, 1, current_timestamp, current_timestamp),
    ('expiry_analysis', 1, 1, current_timestamp, current_timestamp),
    ('negative_stock_analysis', 1, 1, current_timestamp, current_timestamp),
    ('non_movement_analysis', 1, 1, current_timestamp, current_timestamp),
    ('inventory_batch', 1, 1, current_timestamp, current_timestamp),
    ('inventory_book', 1, 1, current_timestamp, current_timestamp),
    ('inventory_transaction_history', 1, 1, current_timestamp, current_timestamp),
    ('memorandum', 1, 1, current_timestamp, current_timestamp),
    ('partywise_detail', 1, 1, current_timestamp, current_timestamp),
    ('get_batch_detail_with_stock_location', 1, 1, current_timestamp, current_timestamp),
    ('get_inventory_branch_stock_location_label', 1, 1, current_timestamp, current_timestamp),
    ('get_stock_location_wise_branch_stock', 1, 1, current_timestamp, current_timestamp),
    ('get_transfer_pending', 1, 1, current_timestamp, current_timestamp),
    ('account_opening', 1, 1, current_timestamp, current_timestamp),
    ('tds_detail', 1, 1, current_timestamp, current_timestamp);
--##
-------------
--##
alter table udm_doctor
    rename constraint doctor_pkey to udm_doctor_pkey;
alter table udm_drug_classification
    rename constraint drug_classification_pkey to udm_drug_classification_pkey;
alter table udm_inventory_composition
    rename constraint inventory_composition_pkey to udm_inventory_composition_pkey;
--## uqc
insert into uqc (id, name)
values ('BAG', 'BAG-BAGS'),
       ('BAL', 'BAL-BALE'),
       ('BDL', 'BDL-BUNDLES'),
       ('BKL', 'BKL-BUCKLES'),
       ('BOU', 'BOU-BILLION OF UNITS'),
       ('BOX', 'BOX-BOX'),
       ('BTL', 'BTL-BOTTLES'),
       ('BUN', 'BUN-BUNCHES'),
       ('CAN', 'CAN-CANS'),
       ('CBM', 'CBM-CUBIC METERS'),
       ('CCM', 'CCM-CUBIC CENTIMETERS'),
       ('CMS', 'CMS-CENTIMETERS'),
       ('CTN', 'CTN-CARTONS'),
       ('DOZ', 'DOZ-DOZENS'),
       ('DRM', 'DRM-DRUMS'),
       ('GGK', 'GGK-GREAT GROSS'),
       ('GMS', 'GMS-GRAMMES'),
       ('GRS', 'GRS-GROSS'),
       ('GYD', 'GYD-GROSS YARDS'),
       ('KGS', 'KGS-KILOGRAMS'),
       ('KLR', 'KLR-KILOLITRE'),
       ('KME', 'KME-KILOMETRE'),
       ('LTR', 'LTR-LITRES'),
       ('MLT', 'MLT-MILILITRE'),
       ('MTR', 'MTR-METERS'),
       ('MTS', 'MTS-METRIC TON'),
       ('NOS', 'NOS-NUMBERS'),
       ('PAC', 'PAC-PACKS'),
       ('PCS', 'PCS-PIECES'),
       ('PRS', 'PRS-PAIRS'),
       ('QTL', 'QTL-QUINTAL'),
       ('ROL', 'ROL-ROLLS'),
       ('SET', 'SET-SETS'),
       ('SQF', 'SQF-SQUARE FEET'),
       ('SQM', 'SQM-SQUARE METERS'),
       ('SQY', 'SQY-SQUARE YARDS'),
       ('TBS', 'TBS-TABLETS'),
       ('TGM', 'TGM-TEN GROSS'),
       ('THD', 'THD-THOUSANDS'),
       ('TON', 'TON-TONNES'),
       ('TUB', 'TUB-TUBES'),
       ('UGS', 'UGS-US GALLONS'),
       ('UNT', 'UNT-UNITS'),
       ('YDS', 'YDS-YARDS'),
       ('OTH', 'OTH-OTHERS');
--##
------------
    -- voucher, ac_txn, inv_txn, batch
-------------------------------------------------------------------------------------------------

ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;
        UPDATE bank_txn b SET ac_txn_uuid = a.uuid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;
        UPDATE bill_allocation b SET ac_txn_uuid = a.uuid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE account ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
--         UPDATE ac_txn b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        ALTER TABLE ac_txn
            ALTER COLUMN created_by TYPE uuid
            USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
        ALTER TABLE ac_txn
            ALTER COLUMN updated_by TYPE uuid
            USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
        LOOP
            UPDATE ac_txn i
            SET account_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.account_id
              AND a.uuid_id IS NOT NULL
              AND i.account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where account_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
--         UPDATE ac_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id;
DO
$$
    DECLARE
        v_updated   INT;
        v_remaining BIGINT;
    BEGIN
        LOOP
            UPDATE ac_txn i
            SET alt_account_uuid = a.uuid_id
            FROM account a
            WHERE a.id = i.alt_account_id
              AND a.uuid_id IS NOT NULL
              AND i.alt_account_uuid IS NULL
              AND i.id IN (SELECT id
                           FROM ac_txn
                           WHERE alt_account_uuid IS NULL
                           LIMIT 10000);

            GET DIAGNOSTICS v_updated = ROW_COUNT;
            select count(1)
            into v_remaining
            from ac_txn
            where alt_account_uuid is null;
            RAISE NOTICE 'Updated: %', v_updated;
            RAISE NOTICE 'Remaining: %', v_remaining;
            EXIT WHEN v_updated = 0;
        END LOOP;
    END
$$;
    ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS account_uuid uuid;
        UPDATE account_daily_summary b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
        UPDATE bank_txn b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
        UPDATE bank_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id;
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS account_uuid uuid;
        UPDATE branch b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_uuid uuid;
        UPDATE bill_allocation b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
        UPDATE batch b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_account_uuid uuid;
        UPDATE inventory b SET sale_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sale_account_id and a.transaction_enabled;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_account_uuid uuid;
        UPDATE inventory b SET purchase_account_uuid = a.uuid_id FROM account a WHERE a.id = b.purchase_account_id and a.transaction_enabled;
    ALTER TABLE tds_nature_of_payment ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
        UPDATE tds_nature_of_payment b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS party_account_uuid uuid;
        UPDATE tds_on_voucher b SET party_account_uuid = a.uuid_id FROM account a WHERE a.id = b.party_account_id;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
        UPDATE tds_on_voucher b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
        UPDATE inv_txn b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS customer_uuid uuid;
        UPDATE inv_txn b SET customer_uuid = a.uuid_id FROM account a WHERE a.id = b.customer_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
        UPDATE voucher b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS customer_uuid uuid;
        UPDATE voucher b SET customer_uuid = a.uuid_id FROM account a WHERE a.id = b.customer_id;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS preferred_vendor_uuid uuid;
        UPDATE inventory_branch_detail b SET preferred_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.preferred_vendor_id;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS last_vendor_uuid uuid;
        UPDATE inventory_branch_detail b SET last_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.last_vendor_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_payable_account_uuid uuid;
        UPDATE gst_tax b SET cgst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.cgst_payable_account_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_payable_account_uuid uuid;
        UPDATE gst_tax b SET sgst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sgst_payable_account_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_payable_account_uuid uuid;
        UPDATE gst_tax b SET igst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.igst_payable_account_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_receivable_account_uuid uuid;
        UPDATE gst_tax b SET cgst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.cgst_receivable_account_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_receivable_account_uuid uuid;
        UPDATE gst_tax b SET sgst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sgst_receivable_account_id;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_receivable_account_uuid uuid;
        UPDATE gst_tax b SET igst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.igst_receivable_account_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE account_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
        UPDATE ac_txn b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
        UPDATE account b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
        UPDATE bill_allocation b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE bank ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_uuid uuid;
        UPDATE account b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;
    ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS bank_uuid uuid;
        UPDATE bank_beneficiary b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_beneficiary_uuid uuid;
        UPDATE account b SET bank_beneficiary_uuid = a.uuid_id FROM bank_beneficiary a WHERE a.id = b.bank_beneficiary_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE branch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE ac_txn b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE account_daily_summary b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE bank_txn b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE batch b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE bill_allocation b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE inv_txn b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE inventory_branch_detail b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE tds_on_voucher b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE voucher_numbering b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
        UPDATE voucher b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE gst_registration ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS gst_registration_uuid uuid;
        UPDATE branch b SET gst_registration_uuid = a.uuid_id FROM gst_registration a WHERE a.id = b.gst_registration_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE inventory ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
        UPDATE batch b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
    ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
        UPDATE bill_of_material b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
        UPDATE inv_txn b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
        UPDATE inventory_branch_detail b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE manufacturer ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
        UPDATE batch b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
        UPDATE inv_txn b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
        UPDATE inventory b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE sales_person ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
        UPDATE inv_txn b SET sales_person_uuid = a.uuid_id FROM sales_person a WHERE a.id = b.sales_person_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
        UPDATE voucher b SET sales_person_uuid = a.uuid_id FROM sales_person a WHERE a.id = b.sales_person_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE section ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS section_uuid uuid;
        UPDATE inventory b SET section_uuid = a.uuid_id FROM section a WHERE a.id = b.section_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE tds_nature_of_payment  ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
        UPDATE account b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
        UPDATE tds_on_voucher b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE unit ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS unit_uuid uuid;
        UPDATE batch b SET unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.unit_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS unit_uuid uuid;
        UPDATE inv_txn b SET unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.unit_id;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS unit_uuid uuid;
        UPDATE inventory b SET unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.unit_id;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_unit_uuid uuid;
        UPDATE inventory b SET sale_unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.sale_unit_id;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_unit_uuid uuid;
        UPDATE inventory b SET purchase_unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.purchase_unit_id;
--     ALTER TABLE unit_conversion ADD COLUMN IF NOT EXISTS primary_unit_uuid uuid;
--     ALTER TABLE unit_conversion ADD COLUMN IF NOT EXISTS conversion_unit_id uuid;

-------------------------------------------------------------------------------------------------

ALTER TABLE voucher ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE ac_txn b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE bank_txn b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE batch b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE bill_allocation b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE inv_txn b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
        UPDATE tds_on_voucher b SET voucher_uuid = a.uuid_id FROM voucher a WHERE a.id = b.voucher_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
        UPDATE ac_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
        UPDATE inv_txn b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
        UPDATE voucher_numbering b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
        UPDATE voucher b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE warehouse ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
        UPDATE batch b SET warehouse_uuid = a.uuid_id FROM warehouse a WHERE a.id = b.warehouse_id;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
        UPDATE inv_txn b SET warehouse_uuid = a.uuid_id FROM warehouse a WHERE a.id = b.warehouse_id;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
        UPDATE voucher b SET warehouse_uuid = a.uuid_id FROM warehouse a WHERE a.id = b.warehouse_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE member ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE ac_txn ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE gstr_2b ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE permission ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE permission ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE unit ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE unit ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_doctor ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_doctor ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN created_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN updated_by TYPE uuid USING '0195cfbf-ac00-7054-8000-000000000000'::uuid;

-------------------------------------------------------------------------------------------------

ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE batch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE print_template ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

-------------------------------------------------------------------------------------------------

ALTER TABLE if exists udm_doctor ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS udf_doctor_uuid uuid;
        UPDATE voucher SET udf_doctor_uuid = uuid_id FROM udm_doctor WHERE udm_doctor.id = voucher.udf_doctor_id;

-------------------------------------------------------------------------------------------------

ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS udf_drug_classifications_uuid uuid[];
        UPDATE inv_txn t
        SET udf_drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.udf_drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.udf_drug_classifications IS NOT NULL;

    ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS drug_classifications_uuid uuid[];
        UPDATE udm_inventory_composition t
        SET drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.drug_classifications IS NOT NULL;

-------------------------------------------------------------------------------------------------

ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS udf_compositions_uuid uuid[];
        UPDATE inventory t
        SET udf_compositions_uuid =
                (SELECT array_agg(udm_inventory_composition.uuid_id)
                 FROM unnest(t.udf_compositions) AS u(class_id)
                          JOIN udm_inventory_composition
                               ON udm_inventory_composition.id = u.class_id)
        WHERE t.udf_compositions IS NOT NULL;

-------------------------------------------------------------------------------------------------
