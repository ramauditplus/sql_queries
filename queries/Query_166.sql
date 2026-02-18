WITH "base"
    AS
    (SELECT "id", "inventory_name", "branch_name" FROM "batch" WHERE "inventory_name" = $1)
SELECT * FROM "base" WHERE "id" = $2 LIMIT $3 OFFSET $4