SELECT DISTINCT unnest(perms) AS perm
FROM member
ORDER BY perm;

SELECT DISTINCT perm
FROM (
    SELECT unnest(perms) AS perm
    FROM member
) AS all_perms
WHERE perm NOT IN (
    SELECT name FROM member_permission
)
ORDER BY perm;

