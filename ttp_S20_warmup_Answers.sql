-- Another clever use of SUBQUERIES

-- EXAMPLE: What is the average customer lifetime spending?
-- Does this work?

SELECT AVG(SUM(amount))
FROM payment
GROUP BY customer_id; --NOPE! "ERROR:  aggregate function calls cannot be nested"
--TRY THIS
SELECT AVG(total)
FROM (SELECT SUM(amount) as total 
	  FROM payment 
	  GROUP BY customer_id) as customer_totals; --NICE! 

-- IMPORTANT! NOTICE THE ALIAS AT THE END. THIS IS NECESSARY WHEN THE SUBQUERY
-- IS IN THE FROM CLAUSE


--OR do the above with a CTE:
WITH customer_totals as ( --start of CTE
SELECT SUM(amount) as total 
FROM payment 
GROUP BY customer_id) --end of CTE
SELECT AVG(total)
FROM customer_totals;



--1 YOUR TURN: what is the AVG average of the (amount of stock) each store has in their inventory (amount_film_per_store? (Use inventory table)
/*********************
store_id | avg_amount_of_stock     
----------+---------------------
        2 |  3.0328083989501312
        1 |  2.9907773386034256

store_id | avg_amount_of_stock     ROUND()
----------+---------------------
        2 |                   3
        1 |                   3        
You are returning the first SELECT. The second SELECT/Subquery is how you come to the answer/returned value
*/
SELECT store_id, ROUND(AVG(amount_of_stock)) AS avg_amount_of_stock
FROM (SELECT film_id, store_id, COUNT(inventory_id) AS amount_of_stock
		FROM inventory
		GROUP BY film_id, store_id) AS amount_film_per_store
GROUP BY store_id;


--2 YOUR TURN: What is the average (customer lifetime spending), for each staff member (staff_id)?
-- (Use payment table | staff_id and amount)
-- HINT: you can work off the example
/*
staff_id | avg_cust_lt_spending 
----------+----------------------
        2 |  51.8529549248747913
        1 |  50.5043739565943239
(2 rows)

 staff_id | avg_cust_lt_spending    ROUND()
----------+----------------------
        2 |                   52
        1 |                   51
(2 rows)
*/
SELECT staff_id, ROUND(AVG(lt_spending)) AS avg_cust_lt_spending
FROM (SELECT staff_id, SUM(amount) AS lt_spending
		FROM payment
		GROUP BY customer_id, staff_id) AS cust_per_staff
GROUP BY staff_id;


--3 YOUR TURN: 
--What is the AGV average (number of film) we have per genre (film_category table)?
/*
 avg_num_per_genre  
---------------------
 62.5000000000000000
(1 row)

avg_num_per_genre     ROUND()
-------------------
                63
(1 row)
*/
SELECT ROUND(AVG(num_of_film)) AS avg_num_per_genre
FROM (SELECT category_id, COUNT(film_id) AS num_of_film
		FROM film_category
		GROUP BY category_id) AS film_per_genre;















































































