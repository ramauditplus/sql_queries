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