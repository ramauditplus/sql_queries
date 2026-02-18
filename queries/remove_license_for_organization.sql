UPDATE organization
SET
    license_claims = NULL,
    license_token = NULL,
    reason = NULL,
    token_validity = NULL,
    last_sync = NULL;

select * from organization;