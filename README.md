# E-Commerce-Sales-Analysis-using-SQL

This project performs detailed analysis on an e-commerce dataset using SQL. It simulates the kind of insights a data analyst might provide to help a business make data-driven decisions about customers, products, regions, and sales trends.

---

## Entity Relationship Diagram
<img width="741" alt="ERD" src="https://github.com/user-attachments/assets/2739c408-1bcf-4442-bf30-ade0bcb15ad0" />

---

## Dataset Overview

The project uses 5 main CSV files:

- `customers.csv` – Customer demographics
- `orders.csv` – Order IDs and timestamps
- `orderitems.csv` – Individual products per order
- `products.csv` – Product details (category, dimensions)
- `payments.csv` – Payment type and installment data

All datasets were cleaned and imported into MySQL using MySQL Workbench.

---

## Schema Design

The final schema includes the following tables:

- `customers (customer_id PRIMARY KEY)`
- `orders (order_id PRIMARY KEY, customer_id FOREIGN KEY)`
- `orderitems (order_item_id PRIMARY KEY, order_id & product_id FOREIGN KEY)`
- `products (product_id PRIMARY KEY)`
- `payments (payment_id PRIMARY KEY, order_id FOREIGN KEY)`

---

## SQL Objectives

The analysis answers real-world business questions in three categories:

### 1. Summarizing business

- What is our total revenue, number of customers, and number of orders?
- Which 5 product categories bring in the highest revenue?
- Which states or cities have the highest  number of customers?
- What is the average order value and average shipping charge?
- Which payment methods are most used by customers?

### 2. Sales and Product Performance

- Which are the top 10 best selling products by quantity sold?
- Which products generated the highest total revenue?
- What products are frequently ordered together?
- What are the top 5 sellers by total revenue and how does their average price compare to others?
- Which product categories have the highest shipping costs and do they correspond with high revenue?

### 3. Customer Behavior Analysis

- Who are our top spending and most loyal customers?
- What percentage of customers are repeat buyers?
- Which states or cities have the highest average order value?
- How does customer behavior differ across regions?
- What is the lifetime value of each customer?

### 4. Time Series and Trends

- Monthly trends in orders and revenue
- Peak sales months and days of the week
- Change in average order value over time
- Shift in payment method preferences
- Products growing in popularity over time

---

## Advanced SQL Concepts Used

- JOIN, GROUP BY, HAVING
- Subqueries and nested SELECT
- Common Table Expressions (WITH)
- Window functions
- Aggregations: SUM, COUNT, AVG, MAX, MIN
- Date functions (DATE_FORMAT, DAYNAME)
- Conditional logic (CASE)

---

## Insights Highlights

- States with the highest number of orders didn’t always have the highest average order value, revenue was more evenly spread.
- Only a small percentage of customers were repeat buyers.
- Credit cards were the most used payment methods.
- Monthly trends showed peak activity around winter season.

---

