select
    date,
    branch_gst_no,
    base_voucher_type,
    gst_tax,
    gst_location_type,
    taxable_amount,
    igst_amount,
    sgst_amount,
    cgst_amount
from gst_txn
where base_voucher_type in ('CREDIT_NOTE', 'DEBIT_NOTE');
