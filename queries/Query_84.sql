alter table pos_server
    drop if exists access_key,
    drop if exists reg_code,
    drop if exists reg_iat;
--##