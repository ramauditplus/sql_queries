SELECT round("nlc"::numeric * "cost"::numeric * (5 + 5), 2) AS "value" FROM "batch";

SELECT round("nlc" * "cost" * (5 + 5)) AS "value" FROM "batch";

select round("nlc" + "cost", 2) as "value" from "batch";
