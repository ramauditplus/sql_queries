
select * from inventory where ARRAY ['h1','d3'] && barcodes;
SELECT * FROM "inventory" WHERE ARRAY('h1', 'd3') && "barcodes";
 SELECT * FROM "inventory" WHERE (ARRAY["h1", "d3"]) && "barcodes";

 select * from branch where ARRAY ['1', '2'] && "members";