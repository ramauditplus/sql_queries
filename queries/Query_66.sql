-- country
select * from udm_country;

-- gst_registration
select * from model_metadata where name in ('udm_gst_registration');
select * from field_metadata where model in ('udm_gst_registration');
-- select * from field_metadata where model in ('udm_gst_registration') and required = true;
select * from relation_metadata where to_model in ('udm_gst_registration');
select * from udm_gst_registration;

-- tds_nature_of_payment
select * from model_metadata where name in ('udm_tds_nature_of_payment');
select * from field_metadata where model in ('udm_tds_nature_of_payment');
-- select * from field_metadata where model in ('udm_tds_nature_of_payment') and required = true;
select * from relation_metadata where to_model in ('udm_tds_nature_of_payment');
select * from udm_tds_nature_of_payment;

-- account_type
select * from model_metadata where name in ('udm_account_type');
select * from field_metadata where model in ('udm_account_type');
select * from field_metadata where model in ('udm_account_type') and required = true;
select * from relation_metadata where to_model in ('udm_account_type');
select * from udm_account_type;

-- account
select * from model_metadata where name in ('udm_account');
select * from field_metadata where model in ('udm_account');
select * from field_metadata where model in ('udm_account') and required = true;
select * from relation_metadata where to_model in ('udm_account');
select * from udm_account;

-- branch
select * from model_metadata where name in ('udm_branch');
select * from field_metadata where model in ('udm_branch');
select * from field_metadata where model in ('udm_branch') and required = true;
select * from relation_metadata where to_model in ('udm_branch');
select * from udm_branch;


