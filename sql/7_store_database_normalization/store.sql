SELECT *
FROM store LIMIT 10;

/*There are some columns in this table that do not describe the primary key ('order_id'). For example, 'customer_id', 'customer_phone' and 'customer_email' describe details about customers and could therefore be moved to a customers table. Also, all of the columns with names beginning in item describe details about items and could be moved to an items table.*/

/*Have any customers made more than one order?*/
SELECT COUNT(DISTINCT(order_id)) 
FROM store;
SELECT COUNT(DISTINCT(customer_id)) 
FROM store; --there are fewer customers than orders: some customers have made more than one order

/*Let's create a customers table*/
CREATE TABLE customers AS 
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

/*Let's create an items table*/
CREATE TABLE items AS 
SELECT DISTINCT item_1_id as item_id, item_1_name as name, item_1_price as price
FROM store
UNION
SELECT DISTINCT item_2_id as item_id, item_2_name as name, item_2_price as price
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT DISTINCT item_3_id as item_id, item_3_name as name, item_3_price as price
FROM store
WHERE item_3_id IS NOT NULL;

ALTER TABLE items
ADD PRIMARY KEY (item_id);

/*Let's create an orders_items table*/
CREATE TABLE orders_items AS
SELECT order_id, item_1_id as item_id 
FROM store
UNION ALL
SELECT order_id, item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT order_id, item_2_id as item_id
FROM store
WHERE item_3_id IS NOT NULL;

/*Let's create an orders table*/
CREATE TABLE orders AS 
SELECT DISTINCT order_id, order_date, customer_id
FROM store;

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

/*Let's cross-reference our normzalized database tables'*/
ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id)
REFERENCES items(item_id);

/*Let's return the emails of all customers who made an order after July 25, 2019*/
SELECT customer_email
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
AND
orders.order_date > '2019-07-25' ;

/*Let's return the number of orders containing each unique item'*/
SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;
