--## ACCOUNT
ALTER TABLE account ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_uuid uuid;
ALTER TABLE account ADD COLUMN IF NOT EXISTS bank_beneficiary_uuid uuid;
ALTER TABLE account ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
------------------
    UPDATE account b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    UPDATE account b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;
    UPDATE account b SET bank_beneficiary_uuid = a.uuid_id FROM bank_beneficiary a WHERE a.id = b.bank_beneficiary_id;
    UPDATE account b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
--## ACCOUNT

--## BRANCH
ALTER TABLE branch ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE branch ADD COLUMN IF NOT EXISTS gst_registration_uuid uuid;
------------------
    UPDATE branch b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE branch b SET gst_registration_uuid = a.uuid_id FROM gst_registration a WHERE a.id = b.gst_registration_id;
--## BRANCH

--## BANK_BENEFICIARY
ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS bank_uuid uuid;
------------------
    UPDATE bank_beneficiary b SET bank_uuid = a.uuid_id FROM bank a WHERE a.id = b.bank_id;
--## BANK_BENEFICIARY

--## BANK_TXN
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS alt_account_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE bank_txn ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE bank_txn b SET ac_txn_uuid = a.uuid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
    UPDATE bank_txn b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE bank_txn b SET alt_account_uuid = a.uuid_id FROM account a WHERE a.id = b.alt_account_id;
    UPDATE bank_txn b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bank_txn b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
--## BANK_TXN

--## BILL_ALLOCATION
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS ac_txn_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS account_type_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE bill_allocation ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE bill_allocation b SET ac_txn_uuid = a.uuid_id FROM ac_txn a WHERE a.id = b.ac_txn_id;
    UPDATE bill_allocation b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE bill_allocation b SET account_type_uuid = a.uuid_id FROM account_type a WHERE a.id = b.account_type_id;
    UPDATE bill_allocation b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE bill_allocation b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
--## BILL_ALLOCATION

--## INVENTORY
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_account_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_account_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS manufacturer_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS section_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS unit_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS sale_unit_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS purchase_unit_uuid uuid;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS udf_compositions_uuid uuid[];
------------------
    UPDATE inventory b SET sale_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sale_account_id and a.transaction_enabled;
    UPDATE inventory b SET purchase_account_uuid = a.uuid_id FROM account a WHERE a.id = b.purchase_account_id and a.transaction_enabled;
    UPDATE inventory b SET manufacturer_uuid = a.uuid_id FROM manufacturer a WHERE a.id = b.manufacturer_id;
    UPDATE inventory b SET section_uuid = a.uuid_id FROM section a WHERE a.id = b.section_id;
    UPDATE inventory b SET unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.unit_id;
    UPDATE inventory b SET sale_unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.sale_unit_id;
    UPDATE inventory b SET purchase_unit_uuid = a.uuid_id FROM unit a WHERE a.id = b.purchase_unit_id;
    UPDATE inventory t
        SET udf_compositions_uuid =
                (SELECT array_agg(udm_inventory_composition.uuid_id)
                 FROM unnest(t.udf_compositions) AS u(class_id)
                          JOIN udm_inventory_composition
                               ON udm_inventory_composition.id = u.class_id)
        WHERE t.udf_compositions IS NOT NULL;
--## INVENTORY

--## ACCOUNT_DAILY_SUMMARY
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS account_uuid uuid;
ALTER TABLE account_daily_summary ADD COLUMN IF NOT EXISTS branch_uuid uuid;
------------------
    UPDATE account_daily_summary b SET account_uuid = a.uuid_id FROM account a WHERE a.id = b.account_id;
    UPDATE account_daily_summary b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
--## ACCOUNT_DAILY_SUMMARY

--## TDS_NATURE_OF_PAYMENT
ALTER TABLE tds_nature_of_payment ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
------------------
    UPDATE tds_nature_of_payment b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
--## TDS_NATURE_OF_PAYMENT

--## TDS_ON_VOUCHER
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS party_account_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_account_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS tds_nature_of_payment_uuid uuid;
ALTER TABLE tds_on_voucher ADD COLUMN IF NOT EXISTS voucher_uuid uuid;
------------------
    UPDATE tds_on_voucher b SET party_account_uuid = a.uuid_id FROM account a WHERE a.id = b.party_account_id;
    UPDATE tds_on_voucher b SET tds_account_uuid = a.uuid_id FROM account a WHERE a.id = b.tds_account_id;
    UPDATE tds_on_voucher b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE tds_on_voucher b SET tds_nature_of_payment_uuid = a.uuid_id FROM tds_nature_of_payment a WHERE a.id = b.tds_nature_of_payment_id;
    UPDATE tds_on_voucher b SET voucher_uuid = a.session FROM voucher a WHERE a.id = b.voucher_id;
--## TDS_ON_VOUCHER

--## VOUCHER_NUMBERING
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS voucher_type_uuid uuid;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS f_year_uuid uuid;
ALTER TABLE voucher_numbering ADD COLUMN IF NOT EXISTS branch_uuid uuid;
------------------
    UPDATE voucher_numbering b SET voucher_type_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.voucher_type_id;
    UPDATE voucher_numbering SET f_year_uuid = uuid_id FROM financial_year WHERE financial_year.id = voucher_numbering.f_year_id;
    UPDATE voucher_numbering b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
--## VOUCHER_NUMBERING

--## INVENTORY_BRANCH_DETAIL
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS preferred_vendor_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS last_vendor_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS branch_uuid uuid;
ALTER TABLE inventory_branch_detail ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE inventory_branch_detail b SET preferred_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.preferred_vendor_id;
    UPDATE inventory_branch_detail b SET last_vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.last_vendor_id;
    UPDATE inventory_branch_detail b SET branch_uuid = a.uuid_id FROM branch a WHERE a.id = b.branch_id;
    UPDATE inventory_branch_detail b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
--## INVENTORY_BRANCH_DETAIL

--## GST_TAX
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_payable_account_uuid uuid;
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_payable_account_uuid uuid;
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_payable_account_uuid uuid;
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS cgst_receivable_account_uuid uuid;
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS sgst_receivable_account_uuid uuid;
ALTER TABLE gst_tax ADD COLUMN IF NOT EXISTS igst_receivable_account_uuid uuid;
------------------
    UPDATE gst_tax b SET cgst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.cgst_payable_account_id;
    UPDATE gst_tax b SET sgst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sgst_payable_account_id;
    UPDATE gst_tax b SET igst_payable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.igst_payable_account_id;
    UPDATE gst_tax b SET cgst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.cgst_receivable_account_id;
    UPDATE gst_tax b SET sgst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.sgst_receivable_account_id;
    UPDATE gst_tax b SET igst_receivable_account_uuid = a.uuid_id FROM account a WHERE a.id = b.igst_receivable_account_id;
--## GST_TAX

--## BILL_OF_MATERIAL
ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE bill_of_material b SET inventory_uuid = a.uuid_id FROM inventory a WHERE a.id = b.inventory_id;
--## BILL_OF_MATERIAL

--## UDM_VENDOR_ITEM_MAP
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
ALTER TABLE udm_vendor_item_map ADD COLUMN IF NOT EXISTS inventory_uuid uuid;
------------------
    UPDATE udm_vendor_item_map b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
    UPDATE udm_vendor_item_map b SET inventory_uuid = a.uuid_id FROM account a WHERE a.id = b.inventory_id;
--## UDM_VENDOR_ITEM_MAP

--## UDM_VENDOR_BILL_MAP
ALTER TABLE udm_vendor_bill_map ADD COLUMN IF NOT EXISTS vendor_uuid uuid;
------------------
    UPDATE udm_vendor_bill_map b SET vendor_uuid = a.uuid_id FROM account a WHERE a.id = b.vendor_id;
--## UDM_VENDOR_BILL_MAP

--## UDM_INVENTORY_COMPOSITION
ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS drug_classifications_uuid uuid[];
------------------
    UPDATE udm_inventory_composition t
        SET drug_classifications_uuid =
                (SELECT array_agg(udm_drug_classification.uuid_id)
                 FROM unnest(t.drug_classifications) AS u(class_id)
                          JOIN udm_drug_classification
                               ON udm_drug_classification.id = u.class_id)
        WHERE t.drug_classifications IS NOT NULL;
--## UDM_INVENTORY_COMPOSITION