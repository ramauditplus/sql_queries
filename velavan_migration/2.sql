------------------------------------------------------------------------
-- UUID CHANGES
------------------------------------------------------------------------

ALTER TABLE ac_txn ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE account ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE account SET uuid_id = '0194af5b-8c00-701c-8000-000000000000' WHERE id = 1;
    UPDATE account SET uuid_id = '0194b481-e800-701d-8000-000000000000' WHERE id = 2;
    UPDATE account SET uuid_id = '0194b9a8-4400-701e-8000-000000000000' WHERE id = 3;
    UPDATE account SET uuid_id = '0194bece-a000-701f-8000-000000000000' WHERE id = 4;
    UPDATE account SET uuid_id = '0194c3f4-fc00-7020-8000-000000000000' WHERE id = 5;
    UPDATE account SET uuid_id = '0194c91b-5800-7021-8000-000000000000' WHERE id = 6;
    UPDATE account SET uuid_id = '0194ce41-b400-7022-8000-000000000000' WHERE id = 7;
    UPDATE account SET uuid_id = '0194d368-1000-7023-8000-000000000000' WHERE id = 8;
    UPDATE account SET uuid_id = '0194d88e-6c00-7024-8000-000000000000' WHERE id = 9;
    UPDATE account SET uuid_id = '0194ddb4-c800-7025-8000-000000000000' WHERE id = 10;
    UPDATE account SET uuid_id = '0194e2db-2400-7026-8000-000000000000' WHERE id = 11;
    UPDATE account SET uuid_id = '0194e801-8000-7027-8000-000000000000' WHERE id = 12;
    UPDATE account SET uuid_id = '0194ed27-dc00-7028-8000-000000000000' WHERE id = 13;
    UPDATE account SET uuid_id = '0194f24e-3800-7029-8000-000000000000' WHERE id = 14;
    UPDATE account SET uuid_id = '0194f774-9400-702a-8000-000000000000' WHERE id = 15;
    UPDATE account SET uuid_id = '0194fc9a-f000-702b-8000-000000000000' WHERE id = 16;
    UPDATE account SET uuid_id = '019501c1-4c00-702c-8000-000000000000' WHERE id = 17;
    UPDATE account SET uuid_id = '019506e7-a800-702d-8000-000000000000' WHERE id = 18;
    UPDATE account SET uuid_id = '01950c0e-0400-702e-8000-000000000000' WHERE id = 19;
    UPDATE account SET uuid_id = '01951134-6000-702f-8000-000000000000' WHERE id = 20;

ALTER TABLE account_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE account_type SET uuid_id = '01942976-3400-7002-8000-000000000000' WHERE id = 1;
    UPDATE account_type SET uuid_id = '01942e9c-9000-7003-8000-000000000000' WHERE id = 2;
    UPDATE account_type SET uuid_id = '019433c2-ec00-7004-8000-000000000000' WHERE id = 3;
    UPDATE account_type SET uuid_id = '019438e9-4800-7005-8000-000000000000' WHERE id = 4;
    UPDATE account_type SET uuid_id = '01943e0f-a400-7006-8000-000000000000' WHERE id = 5;
    UPDATE account_type SET uuid_id = '01944336-0000-7007-8000-000000000000' WHERE id = 6;
    UPDATE account_type SET uuid_id = '0194485c-5c00-7008-8000-000000000000' WHERE id = 7;
    UPDATE account_type SET uuid_id = '01944d82-b800-7009-8000-000000000000' WHERE id = 8;
    UPDATE account_type SET uuid_id = '019452a9-1400-700a-8000-000000000000' WHERE id = 9;
    UPDATE account_type SET uuid_id = '019457cf-7000-700b-8000-000000000000' WHERE id = 10;
    UPDATE account_type SET uuid_id = '01945cf5-cc00-700c-8000-000000000000' WHERE id = 11;
    UPDATE account_type SET uuid_id = '0194621c-2800-700d-8000-000000000000' WHERE id = 12;
    UPDATE account_type SET uuid_id = '01946742-8400-700e-8000-000000000000' WHERE id = 13;
    UPDATE account_type SET uuid_id = '01946c68-e000-700f-8000-000000000000' WHERE id = 14;
    UPDATE account_type SET uuid_id = '0194718f-3c00-7010-8000-000000000000' WHERE id = 15;
    UPDATE account_type SET uuid_id = '019476b5-9800-7011-8000-000000000000' WHERE id = 16;
    UPDATE account_type SET uuid_id = '01947bdb-f400-7012-8000-000000000000' WHERE id = 17;
    UPDATE account_type SET uuid_id = '01948102-5000-7013-8000-000000000000' WHERE id = 18;
    UPDATE account_type SET uuid_id = '01948628-ac00-7014-8000-000000000000' WHERE id = 19;
    UPDATE account_type SET uuid_id = '01948b4f-0800-7015-8000-000000000000' WHERE id = 20;
    UPDATE account_type SET uuid_id = '01949075-6400-7016-8000-000000000000' WHERE id = 21;
    UPDATE account_type SET uuid_id = '0194959b-c000-7017-8000-000000000000' WHERE id = 22;
    UPDATE account_type SET uuid_id = '01949ac2-1c00-7018-8000-000000000000' WHERE id = 23;
    UPDATE account_type SET uuid_id = '01949fe8-7800-7019-8000-000000000000' WHERE id = 24;
    UPDATE account_type SET uuid_id = '0194a50e-d400-701a-8000-000000000000' WHERE id = 25;
    UPDATE account_type SET uuid_id = '0194aa35-3000-701b-8000-000000000000' WHERE id = 26;
ALTER TABLE account_type ADD COLUMN IF NOT EXISTS parent_uuid uuid;
    UPDATE account_type b SET parent_uuid = a.uuid_id FROM account_type a WHERE a.id = b.parent_id;

ALTER TABLE bank ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE bank SET uuid_id = '0195165a-bc00-7030-8000-000000000000' WHERE id = 1;
    UPDATE bank SET uuid_id = '01951b81-1800-7031-8000-000000000000' WHERE id = 2;
    UPDATE bank SET uuid_id = '019520a7-7400-7032-8000-000000000000' WHERE id = 3;
    UPDATE bank SET uuid_id = '019525cd-d000-7033-8000-000000000000' WHERE id = 4;
    UPDATE bank SET uuid_id = '01952af4-2c00-7034-8000-000000000000' WHERE id = 5;
    UPDATE bank SET uuid_id = '0195301a-8800-7035-8000-000000000000' WHERE id = 6;
    UPDATE bank SET uuid_id = '01953540-e400-7036-8000-000000000000' WHERE id = 7;
    UPDATE bank SET uuid_id = '01953a67-4000-7037-8000-000000000000' WHERE id = 8;
    UPDATE bank SET uuid_id = '01953f8d-9c00-7038-8000-000000000000' WHERE id = 9;
    UPDATE bank SET uuid_id = '019544b3-f800-7039-8000-000000000000' WHERE id = 10;
    UPDATE bank SET uuid_id = '019549da-5400-703a-8000-000000000000' WHERE id = 11;
    UPDATE bank SET uuid_id = '01954f00-b000-703b-8000-000000000000' WHERE id = 12;

ALTER TABLE bank_beneficiary ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE branch ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE gst_registration ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE inventory ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE manufacturer ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE sales_person ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE section ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE tds_nature_of_payment  ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE unit ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE voucher_type SET uuid_id = '01955427-0c00-703c-8000-000000000000' WHERE id = 1;
    UPDATE voucher_type SET uuid_id = '0195594d-6800-703d-8000-000000000000' WHERE id = 2;
    UPDATE voucher_type SET uuid_id = '01955e73-c400-703e-8000-000000000000' WHERE id = 3;
    UPDATE voucher_type SET uuid_id = '0195639a-2000-703f-8000-000000000000' WHERE id = 4;
    UPDATE voucher_type SET uuid_id = '019568c0-7c00-7040-8000-000000000000' WHERE id = 5;
    UPDATE voucher_type SET uuid_id = '01956de6-d800-7041-8000-000000000000' WHERE id = 6;
    UPDATE voucher_type SET uuid_id = '0195730d-3400-7042-8000-000000000000' WHERE id = 7;
    UPDATE voucher_type SET uuid_id = '01957833-9000-7043-8000-000000000000' WHERE id = 8;
    UPDATE voucher_type SET uuid_id = '01957d59-ec00-7044-8000-000000000000' WHERE id = 9;
    UPDATE voucher_type SET uuid_id = '01958280-4800-7045-8000-000000000000' WHERE id = 10;
    UPDATE voucher_type SET name = 'Stock Journal' WHERE id = 10;
    UPDATE voucher_type SET base_type = 'STOCK_JOURNAL' WHERE id = 10;
    UPDATE voucher_type SET uuid_id = '019587a6-a400-7046-8000-000000000000' WHERE id = 17;
    UPDATE voucher_type SET uuid_id = '01958ccd-0000-7047-8000-000000000000' WHERE id = 21;
    UPDATE voucher_type SET uuid_id = '019591f3-5c00-7048-8000-000000000000' WHERE id = 23;
    UPDATE voucher_type
    SET config = (SELECT jsonb_object_agg(
                                 key,
                                 value_cleaned
                         )
                  FROM jsonb_each(config::jsonb) t(key, value)
                           CROSS JOIN LATERAL (
                      SELECT jsonb_strip_nulls(
                                     value
                                         - 'allowed_expense_accounts'
                                         - 'allowed_credit_accounts'
                                         - 'allowed_emi_accounts'
                                         - 'allowed_card_accounts'
                                         - 'exchange_account'
                                         - 'shipping_charge_account'
                                         - 'by_accounts'
                                         - 'to_accounts'
                                         - 'default_print_template'
                                         - 'cheque_print_template'
                                         - 'approvers'
                             )
                      ) AS cleaned(value_cleaned))::json;
ALTER TABLE voucher_type ADD COLUMN IF NOT EXISTS sequence_uuid uuid;
        UPDATE voucher_type b SET sequence_uuid = a.uuid_id FROM voucher_type a WHERE a.id = b.sequence_id;

ALTER TABLE warehouse ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE member ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();
    UPDATE member SET uuid_id = '01941f29-7c00-7000-8000-000000000000' WHERE id = 1;
    ALTER TABLE branch ADD COLUMN IF NOT EXISTS members_uuid uuid[];
        UPDATE branch t
        SET members_uuid =
                (SELECT array_agg(member.uuid_id)
                 FROM unnest(t.members) AS u(class_id)
                          JOIN member
                               ON member.id = u.class_id)
        WHERE t.members IS NOT NULL;
        UPDATE voucher_type vt
        SET members = (SELECT jsonb_agg(
                                      jsonb_set(
                                              elem,
                                              '{member_id}',
                                              jsonb_build_object(
                                                      '$uuid',
                                                      m.uuid_id
                                              )
                                      )
                              )
                       FROM jsonb_array_elements(vt.members) elem
                                JOIN member m
                                     ON m.id = (elem ->> 'member_id')::int)
        WHERE vt.members IS NOT NULL;
    ALTER TABLE ac_txn ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE ac_txn ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account_type ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE account ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bank_beneficiary ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE batch ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_allocation ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE bill_of_material ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE branch ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE financial_year ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gst_registration ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE gstr_2b ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inv_txn ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory_branch_detail ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE inventory ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE manufacturer ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE member ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE organization ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE permission ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE permission ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE print_template ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE sales_person ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE section ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE stock_location ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE tds_nature_of_payment ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE unit ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE unit ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher_type ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE voucher ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE warehouse ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_doctor ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_doctor ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_drug_classification ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN created_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;
    ALTER TABLE udm_inventory_composition ALTER COLUMN updated_by TYPE uuid USING '01941f29-7c00-7000-8000-000000000000'::uuid;

ALTER TABLE financial_year ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE bill_of_material ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE print_template ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_doctor ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_drug_classification ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();

ALTER TABLE udm_inventory_composition ADD COLUMN IF NOT EXISTS uuid_id uuid DEFAULT uuidv7();