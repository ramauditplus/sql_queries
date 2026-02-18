select
    inv.id as inventory_id,
    inv.name as inventory_name,
    div.id divsion_id,
    div.name division_name
from
    inventory inv
        join division div on inv.division_id = div.id;

SELECT
    inventory.division_id AS "inventory.division_id",
    division.id AS "division.id"
FROM inventory
    JOIN division ON inventory.division_id = division.id;

SELECT division.id           AS "division.id",
       inventory.division_id AS "inventory.division_id",
       inventory.id          AS "inventory.id",
       inv_txn.inventory_id  AS "inv_txn.inventory_id"
FROM division
         JOIN inventory ON division.id = inventory.division_id
         JOIN inv_txn ON inventory.id = inv_txn.inventory_id;

SELECT division.id           AS "division.id",
       inventory.division_id AS "inventory.division_id",
       inventory.id          AS "inventory.id",
       inv_txn.inventory_id  AS "inv_txn.inventory_id"
FROM inventory
         JOIN inventory ON division.id = inventory.division_id
         JOIN inv_txn ON inventory.id = inv_txn.inventory_id;

SELECT division.id           AS "division.id",
       inventory.division_id AS "inventory.division_id",
       inventory.id          AS "inventory.id",
       inv_txn.inventory_id  AS "inv_txn.inventory_id"
FROM division
         JOIN inventory ON division.id = inventory.division_id
         JOIN inv_txn ON inventory.id = inv_txn.inventory_id

SELECT
    column_name
FROM
    information_schema.columns
WHERE
    table_schema = 'public'
    AND table_name = 'division'
ORDER BY ordinal_position;
