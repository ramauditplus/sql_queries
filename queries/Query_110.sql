alter table inv_txn
    add if not exists pos_id int;

select * from inv_txn where id = '96ed8c5c-7f48-449b-abc5-3d496765c3b8';

SELECT id, pos_id, (pos_id IS NULL) AS is_pos_id_null
FROM inv_txn
WHERE id = '96ed8c5c-7f48-449b-abc5-3d496765c3b8';

select * from voucher order by created_at desc;

-- id = 2588225
-- voucher_no = DP252683583