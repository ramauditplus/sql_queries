ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;


ALTER TABLE account ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
    ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS account_uuid uuid;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS account_uuid uuid;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_uuid uuid;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_account_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_account_uuid uuid;
    ALTER TABLE tds_nature_of_payment ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS party_account_uuid uuid;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS customer_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS customer_uuid uuid;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS preferred_vendor_uuid uuid;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS last_vendor_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_payable_account_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_payable_account_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_payable_account_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_receivable_account_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_receivable_account_uuid uuid;
    ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_receivable_account_uuid uuid;


ALTER TABLE account_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
    ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
    ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;


ALTER TABLE bank ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_uuid uuid;
    ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS bank_uuid uuid;


ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_beneficiary_uuid uuid;

ALTER TABLE branch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS branch_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;

ALTER TABLE gst_registration ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS gst_registration_uuid uuid;

ALTER TABLE inventory ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
    ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
    ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS inventory_uuid uuid;

ALTER TABLE manufacturer ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;


ALTER TABLE sales_person ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS sales_person_uuid uuid;

ALTER TABLE section ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS section_uuid uuid;

ALTER TABLE tds_nature_of_payment  ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE account ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;

ALTER TABLE unit ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS unit_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS unit_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS unit_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_unit_uuid uuid;
    ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_unit_uuid uuid;
--     ALTER TABLE unit_conversion ADD COLUMN IF NOT EXISTS primary_unit_uuid uuid;
--     ALTER TABLE unit_conversion ADD COLUMN IF NOT EXISTS conversion_unit_id uuid;

ALTER TABLE voucher ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
    ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
    ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
    ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS voucher_uuid uuid;


ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
    ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;


ALTER TABLE warehouse ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    ALTER TABLE batch ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
    ALTER TABLE inv_txn ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;
    ALTER TABLE voucher ADD COLUMN IF NOT EXISTS warehouse_uuid uuid;

ALTER TABLE member ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE batch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE print_template ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE udm_doctor ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();