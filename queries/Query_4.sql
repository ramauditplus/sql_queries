insert into account (id, contact_type, name, val_name, account_type_id, account_type_name, is_default, base_account_types,
                     transaction_enabled, created_by, updated_by, created_at, updated_at, changed_at)
values (1,'ACCOUNT','Cash','cash',17,'Cash',true,'{"CURRENT_ASSET","CASH"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (2,'ACCOUNT','Sales','sales',5,'Sale',true,'{"SALE"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (3,'ACCOUNT','Purchases','purchase',8,'Purchase',true,'{"PURCHASE"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (4,'ACCOUNT','CGST Payable','cgstpayable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (5,'ACCOUNT','SGST Payable','sgstpayable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (6,'ACCOUNT','IGST Payable','igstpayable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (7,'ACCOUNT','CESS Payable','cesspayable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (8,'ACCOUNT','CGST Receivable','cgstreceivable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (9,'ACCOUNT','SGST Receivable','sgstreceivable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (10,'ACCOUNT','IGST Receivable','igstreceivable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (11,'ACCOUNT','CESS Receivable','cessreceivable',22,'Duties And Taxes',true,'{"CURRENT_LIABILITY","DUTIES_AND_TAXES"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (12,'ACCOUNT','Rounded Off','roundedoff',4,'Indirect Income',true,'{"INDIRECT_INCOME"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (13,'ACCOUNT','Discount Given','discountgiven',7,'Indirect Expense',true,'{"INDIRECT_EXPENSE"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (14,'ACCOUNT','Discount Received','discountreceived',4,'Indirect Income',true,'{"INDIRECT_INCOME"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (15,'ACCOUNT','Gift Voucher Reimbursement','giftvoucherreimbursement',2,'Current Liability',true,'{"CURRENT_LIABILITY"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (16,'ACCOUNT','Inventory Asset','inventoryasset',12,'Stock',true,'{"STOCK"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (17,'ACCOUNT','RCM Payable','rcmpayable',2,'Current Liability',true,'{"CURRENT_LIABILITY"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (18,'ACCOUNT','Shipping Charge','shippingcharge',4,'Indirect Income',true,'{"INDIRECT_INCOME"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (19,'ACCOUNT','Stock Transfer Income','stocktransferincome',3,'Direct Income',true,'{"DIRECT_INCOME"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp),
       (20,'ACCOUNT','Retained Earning','retainedearning',24,'Profit & Loss',true,'{"PROFIT_LOSS"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp);
--##
SELECT setval('account_id_seq', 100);
--##

insert into account (contact_type, name, val_name, account_type_id, account_type_name, is_default, base_account_types,
                     transaction_enabled, created_by, updated_by, created_at, updated_at, changed_at)
values ('ACCOUNT','test','test',24,'Profit & Loss',true,'{"PROFIT_LOSS"}',true, 1, 1, current_timestamp, current_timestamp, current_timestamp);