alter table voucher
    add if not exists branch_gst_no      text,
    add if not exists branch_location_id text,
    add if not exists party_reg_type     text,
    add if not exists party_location_id  text,
    add if not exists party_gst_no       text,
    add if not exists gst_location_type  text;
--##
update voucher
set branch_gst_no      = branch_gst ->> 'gst_no'::text,
    branch_location_id = branch_gst ->> 'location_id'::text,
    party_reg_type     = coalesce(party_gst ->> 'reg_type'::text, 'UNREGISTER'),
    party_location_id  = coalesce(party_gst ->> 'location_id'::text, branch_gst ->> 'location_id'::text),
    party_gst_no       = party_gst ->> 'gst_no'::text,
    gst_location_type  = case
                             when branch_gst ->> 'location_id' is not null
                                 then case
                                          when (
                                              branch_gst ->> 'location_id'::text <> party_gst ->> 'location_id'::text or
                                              party_gst ->> 'reg_type'::text = 'IMPORT_EXPORT') then 'INTER_STATE'
                                          else 'INTRA_STATE' end end
where branch_gst is not null;
--##
alter table sale_bill_inv_item
    add if not exists uqc text not null default 'OTH';
--##
alter table sale_bill_inv_item
    alter uqc drop default;
--##
alter table ac_txn
    add if not exists gst_tax        text,
    add if not exists uqc            text,
    add if not exists hsn_code       text,
    add if not exists qty            float,
    add if not exists taxable_amount float,
    add if not exists cgst_amount    float,
    add if not exists sgst_amount    float,
    add if not exists igst_amount    float,
    add if not exists cess_amount    float;
--##
update ac_txn
set gst_tax        = gst.gst_tax,
    uqc            = gst.uqc,
    hsn_code       = gst.hsn_code,
    qty            = gst.qty,
    taxable_amount = gst.taxable_amount,
    cgst_amount    = gst.cgst_amount,
    sgst_amount    = gst.sgst_amount,
    igst_amount    = gst.igst_amount,
    cess_amount    = gst.cess_amount
from gst_txn gst
where ac_txn.id = gst.ac_txn_id;
--##
drop table if exists gst_txn;
--##
alter table voucher
    add constraint voucher_branch_location_id_fkey foreign key (branch_location_id) references country;
--##
alter table voucher
    add constraint voucher_party_location_id_fkey foreign key (party_location_id) references country;
--##
alter table purchase_bill_inv_item
    drop if exists hsn_code;
--##
alter table credit_note_inv_item
    drop if exists hsn_code;
--##
alter table debit_note_inv_item
    drop if exists hsn_code;
--##
alter table personal_use_purchase_inv_item
    drop if exists hsn_code;
--##