/* Let's take a first look to the tables in this database*/
SELECT *
FROM customers;

SELECT *
FROM orders;

SELECT *
FROM books;

/* Let's take a first look at the current indexes in the database*/
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; -- there is an index from column 'customer_id'

SELECT *
FROM pg_Indexes
WHERE tablename = 'orders'; -- there is an index from column 'order_id'

SELECT *
FROM pg_Indexes
WHERE tablename = 'books'; -- there is an index from column 'book_id'

/*We are looking to create a multicolumn index, but before we do let’s get some information prepared to make sure we are ready to analyze if it was a good or bad index to create.*/
EXPLAIN ANALYZE SELECT original_language, title, sales_in_millions 
FROM books
WHERE original_language = 'French'; 
/*execution time of this query: 0.033
planning time of this query: 0.087ms
total time: 0.120ms*/

SELECT pg_size_pretty (pg_total_relation_size('books')); -- size of 'books': 56 Kb

CREATE INDEX original_language_title_sales_in_millions_idx
ON books(original_language, title, sales_in_millions);

EXPLAIN ANALYZE SELECT original_language, title, sales_in_millions 
FROM books
WHERE original_language = 'French';
/*execution time of this query: 0.031
planning time of this query: 0.101ms
total time: 0.134ms*/

SELECT pg_size_pretty (pg_total_relation_size('books')); -- size of 'books': 88 Kb

/*Adding this index we are not improving performance and we are increasing table size*/

/*After running our site for a while, we find that we're' often inserting new books into our books table as new books get released. However, many of these books don’t sell enough copies to be worth translating, so our index has proven to be more costly than beneficial*/
DROP INDEX IF EXISTS books_pkey;

/*Let’s see how long a new orders' bulk insert will take. */
SELECT NOW();

\COPY orders FROM 'orders_add.txt' DELIMITER ',' CSV HEADER;

SELECT NOW(); -- it takes about 390ms