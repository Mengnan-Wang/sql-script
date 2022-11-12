-- how many female customers do we have from the state of oregon and new york
SELECT firstname, lastname, gender, state FROM "public"."customers"
WHERE gender = 'F' AND (state = 'OR' OR state= 'NY');

-- how many custormers not 55
SELECT firstname, lastname, age FROM "public"."customers"
WHERE NOT age = 55;

-- how many female customers do we have from the stateof oregon
SELECT firstname, lastname, state FROM "public"."customers"
WHERE state = 'OR' AND gender = 'F';

-- who between the ages of 30 and 50 has an income of less than 50000
SELECT count(customerid ) FROM "public"."customers"
WHERE age >=30 AND age <= 50 AND income <= 50000;


/*Select people either under 30 or over 50 with an income above 50000
 * Include people that are 50
 * that are from either Japan or Australia*/
SELECT country, firstname, lastname, age, income FROM "public"."customers"
WHERE income > 50000 AND (country = 'Japan' OR country = 'Australia') AND (age >=50 OR age < 30);


-- Who between the ages of 30 and 50 has an income less than 50 000?
SELECT customerid, age, COALESCE(address2, 'empty') AS address2, income
FROM "public"."customers"
WHERE age BETWEEN 30 AND 50 AND income > 50000;


--How many orders were made by customer 7888, 1082, 12808, 9623
SELECT count(orderid) FROM "public"."orders"
WHERE customerid IN (7888, 1082, 12808, 9632);


--Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
SELECT * FROM "public"."orders" AS a
INNER JOIN "public"."customers" AS B
ON a.customerid = b.customerid
WHERE b.state IN ('OH','NY', 'OR');


--Show the inventory for each product
SELECT a.quan_in_stock, a.sales, b.title FROM "public"."inventory" AS a
INNER JOIN "public"."products" AS b
ON a.prod_id = b.prod_id;


/*
* Create a case statement that's named "price class" where if a product is over 20 dollars you show 'expensive'
* if it's between 10 and 20 you show 'average' 
* and of is lower than or equal to 10 you show 'cheap'.
*/
SELECT prod_id, title, price,
       CASE WHEN price > 20 THEN 'expensive'
            WHEN price BETWEEN 10 AND 20 THEN 'average'
            ELSE 'cheap'
       END AS "price class"
FROM "public"."products";


-- Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state
SELECT o.customerid, o.orderdate, c.state
FROM "public"."orders" AS o
INNER JOIN "public"."customers" AS c
ON o.customerid = c.customerid
WHERE c.state IN ('OH', 'NY', 'OR');

--subquery
SELECT o.customerid, o.orderdate
FROM "public"."orders" AS o
JOIN "public"."orders"
ON o.customerid IN (SELECT c.customerid FROM "public"."customers"AS c WHERE c.state IN ('OH', 'NY', 'OR'));













