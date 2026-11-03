# Indian E-Commerce Sales Analysis | SQL Project

## Project Overview
An SQL-based analysis of an Indian e-commerce sales dataset, designed to explore sales performance, customer behaviour, product profitability, and return patterns.

The project uses a relational database containing five interconnected tables: `customers`, `products`, `orders`, `order_items`, and `returns`. SQL queries are used to combine data across tables, investigate business questions, and identify patterns that can support data-driven decision-making.

## Project Objectives
- Analyse overall sales and revenue performance.
- Identify high-value customers and understand purchasing behaviour.
- Evaluate product and category-level sales and profitability.
- Examine order patterns and customer purchasing frequency.
- Investigate product returns and their potential impact on profitability.
- Extract actionable business insights using SQL.

## Database Structure
The project uses a relational database named `ecommerce_sales`.

**Tables:**
- `customers`: Customer information and identifying details.
- `products`: Product information and associated attributes.
- `orders`: Order-level transaction information.
- `order_items`: Individual products purchased within each order, including quantities, discounts, revenue, costs, and profit.
- `returns`: Information relating to returned orders and products.

The tables are connected through primary and foreign key relationships, allowing analysis across multiple entities while maintaining referential integrity.

## Tools & Technologies
- **MySQL**
- **MySQL Workbench**
- SQL Data Definition Language (DDL)
- SQL Data Manipulation Language (DML)

## SQL Concepts & Techniques Used
- **Filtering and Sorting:** `WHERE`, `ORDER BY`, `DISTINCT`
- **Aggregate Functions:** `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- **Grouping:** `GROUP BY`, `HAVING`
- **Joins:** `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `SELF JOIN`, `CROSS JOIN`
- **Subqueries:** Nested queries and `IN` conditions
- **Common Table Expressions:** `WITH` clauses for organising complex queries
- **Window Functions:** `RANK()`, `DENSE_RANK()` for comparative and ranking analysis
- **Conditional Logic:** `CASE` statements
- **Database Constraints:** Primary keys, foreign keys, and referential integrity

## Business Analysis & Key Questions
The project investigates several business-oriented questions, including:

- Which customers generate the highest revenue?
- Which customers have placed multiple orders?
- Which products and categories contribute most to revenue and profit?
- How do discounts affect product profitability?
- Which products generate the highest and lowest profit margins?
- What patterns can be observed in product returns?
- How does sales performance vary across different time periods?
- Which customers demonstrate the strongest purchasing activity?

## Key Learning Outcomes
- Developed practical experience working with a multi-table relational database.
- Applied joins to retrieve and analyse information across interconnected tables.
- Used subqueries, CTEs, and window functions to solve more complex analytical problems.
- Translated business questions into structured SQL queries.
- Used query results to identify customer, product, and sales-related insights.

## Future Scope
The project can be extended by incorporating additional datasets such as payments, shipments, marketing campaigns, and customer reviews. Further analysis could explore customer lifetime value, customer retention, delivery performance, campaign effectiveness, and return-rate trends. These additions would enable a broader evaluation of the e-commerce business and support more comprehensive business intelligence reporting.

---
**Project Category:** SQL | Data Analysis | Business Analytics | E-Commerce
