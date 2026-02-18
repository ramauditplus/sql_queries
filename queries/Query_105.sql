WITH inv_items AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        *
    FROM vendor_item_map
    WHERE vendor_id = 812  -- Replace with actual vendor_id
        AND (
            CASE
                WHEN array_length(ARRAY['value1','value2']::text[], 1) > 0  -- Replace with your array values
                THEN vendor_inventory = ANY(ARRAY['value1','value2']::text[])
                ELSE TRUE
            END
        )
),
-- ... rest of the query
inventory_ids AS (
    SELECT
        ARRAY_AGG(inventory_id) AS ids
    FROM inv_items
),
inventories AS (
    SELECT
        a.id,
        a.name,
        a.inventory_type,
        a.allow_negative_stock,
        a.hsn_code,
        a.unit_id,
        a.gst_tax
    FROM inventory a
    CROSS JOIN inventory_ids
    WHERE a.id = ANY(inventory_ids.ids)
)
SELECT
    inv_items.*,
    (
        SELECT ROW_TO_JSON(inventories.*)
        FROM inventories
        WHERE inventories.id = inv_items.inventory_id
    ) AS inventory
FROM inv_items
ORDER BY inv_items.id;