USE sakila;

/* First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
*/
    
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;
    
SELECT * FROM customer_rental_summary;

/* Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
*/
CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM 
    customer_rental_summary crs
JOIN 
    payment p ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;
    
SELECT * FROM temp_customer_payment_summary;
/* Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.
Next, using the CTE, create the query to generate the final customer summary report, which should include:
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
*/
  WITH customer_summary AS (
  SELECT 
    tps.customer_name,
    tps.email,
    tps.rental_count,
    tps.total_paid
  FROM 
    temp_customer_payment_summary tps
)
SELECT 
  customer_name,
  email,
  rental_count,
  total_paid,
  (total_paid / rental_count) AS average_payment_per_rental
FROM 
  customer_summary;