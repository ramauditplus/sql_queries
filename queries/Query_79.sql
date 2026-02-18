--##
alter table gst_registration
    add if not exists eway_username text,
    add if not exists eway_password text;
--##
alter table voucher
    add if not exists eway_bill_details jsonb,
    add if not exists eway_bill_details_via_irn jsonb;
--##

