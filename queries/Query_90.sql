select id, voucher_no, e_invoice_details, eway_bill_details_via_irn, eway_bill_details from voucher order by created_at desc;
select voucher.e_invoice_details from voucher order by created_at desc;
select * from gst_registration;
select organization.license_token from organization;

--##
alter table voucher
    rename column e_invoice_details to e_invoice_input;
--##
alter table voucher
    add column if not exists e_invoice_response json;
--##

--##
alter table voucher
    alter column eway_bill_via_irn_items set data type json using eway_bill_via_irn_items::json;
--##

--##
alter table voucher
    rename column eway_bill_details_via_irn to eway_bill_via_irn_input;
--##
alter table voucher
    add column if not exists eway_bill_via_irn_response json;
--##
--##
alter table voucher
    add column if not exists eway_bill_input json;
--##
--##
alter table voucher
    add column if not exists eway_bill_response json;
--##
