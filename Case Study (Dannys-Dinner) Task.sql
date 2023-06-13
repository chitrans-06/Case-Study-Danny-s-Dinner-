CREATE SCHEMA dannys_diner;
use dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
(customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  select* from sales;
  select* from members;
  select* from menu; 
 
# 1.What is the total amount each customer spent at the restaurant
    SELECT sales.customer_id,sum(menu.price) AS total_amount_spent
    FROM sales  JOIN menu menu ON sales.product_id=menu.product_id
    GROUP BY sales.customer_id;

# 2.How many days has each customer visited the restaurant
    SELECT customer_id, COUNT(DISTINCT order_date) number_of_days_customer_visited 
    FROM sales
    GROUP BY customer_id;

# 3. What was the first item from the menu purchased by each customer
    SELECT customer_id,menu.product_id,menu.product_name
    from sales
    JOIN menu ON menu.product_id = sales.product_id
    group by customer_id;

# 4.What is the most purchased item on the menu and how many times was it purchased by all customers
    SELECT count(product_name),product_name
    FROM sales 
    JOIN menu ON menu.product_id=sales.product_id
    order by product_name;

# 5. Which item has the most price for each customer
    SELECT customer_id,product_name,price
    FROM sales  
    JOIN menu  ON sales.product_id = menu.product_id
    group by customer_id;

# 6. Which item was purchased first by the customer after they became a member
    SELECT members.customer_id , members.join_date , menu.product_name ,sales.product_id ,sales.order_date
	FROM members 
    JOIN sales  ON members.customer_id = sales.customer_id
    JOIN menu  ON menu.product_id= sales.product_id;

# 7. Which item was purchased just before the customer became a member
    SELECT members.customer_id , members.join_date , menu.product_name , sales.product_id ,sales.order_date
    FROM members 
    JOIN sales ON members.customer_id = sales.customer_id
    JOIN menu ON menu.product_id= sales.product_id
    where order_date < join_date
    group by customer_id;

# 8.  What is the total items and amount spent for each member before they became a member
    SELECT ms.customer_id , count(product_name) , sum(price)
    FROM members ms
    JOIN sales s ON ms.customer_id = s.customer_id
    JOIN menu mu ON mu.product_id= s.product_id 
    WHERE order_date < join_date
    GROUP BY  customer_id ;

# 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier  
    #how many points would each customer have?
    SELECT sales.customer_id,
    CASE 
      WHEN menu.product_name = "sushi" THEN sum(price)*20
      WHEN menu.product_name <> "sushi" THEN sum(price)*10
      END AS points
      FROM sales 
      JOIN menu  ON sales.product_id=menu.product_id
      group by customer_id;

# 10. In the first week after a customer joins the program (including their join date) they earn 
 # 2x points on all items, not just sushi - how many points do customer A and B have at the end of January 
	  SELECT sales.customer_id, sum(price)*20
      FROM sales JOIN members ON sales.customer_id=members.customer_id
      JOIN menu  ON sales.product_id = menu.product_id
      WHERE join_date<=order_date AND MONTH(order_date)=1
      GROUP BY customer_id;
 
























 
  