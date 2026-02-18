SELECT 1
FROM information_schema.columns
WHERE table_name = 'country'
AND column_name = 'updated_at';