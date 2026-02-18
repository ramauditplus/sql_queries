--##
CREATE OR REPLACE FUNCTION fn_notify_account() RETURNS TRIGGER AS $$
DECLARE
data text := row_to_json(coalesce(new,old))::text;
BEGIN
    PERFORM pg_notify('pos_sync', concat('{"operation":"',TG_OP,'","table":"account","data":',data,'}'));
RETURN COALESCE(new, old);
END;
$$ LANGUAGE plpgsql;
--##
CREATE OR REPLACE TRIGGER tg_notify_account
AFTER INSERT OR UPDATE OR DELETE ON account
    FOR EACH ROW EXECUTE FUNCTION fn_notify_account();
--##




update account set name = 'Test' where id = 62981;

select name from account where id = 62981;



---------------------------------------------------------------------------

--##
CREATE OR REPLACE FUNCTION fn_notify_country() RETURNS TRIGGER AS $$
DECLARE
data text := row_to_json(coalesce(new,old))::text;
BEGIN
    PERFORM pg_notify('pos_sync', concat('{"operation":"',TG_OP,'","table":"country","data":',data,'}'));
RETURN COALESCE(new, old);
END;
$$ LANGUAGE plpgsql;
--##
CREATE OR REPLACE TRIGGER tg_notify_country
AFTER INSERT OR UPDATE OR DELETE ON country
    FOR EACH ROW EXECUTE FUNCTION fn_notify_country();
--##

update country set name = 'Jammu And Kashmir' where id = '01';

