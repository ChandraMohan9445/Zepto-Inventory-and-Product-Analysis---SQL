# 🛒 Zepto Inventory and Product Analysis Using MySQL

## 📌 Project Overview

This project focuses on analyzing Zepto's inventory and product data using **MySQL** to uncover business insights related to product pricing, discounts, stock availability, category-wise revenue, and inventory management.

The objective is to help an e-commerce business understand product performance, identify pricing opportunities, monitor inventory levels, and make data-driven business decisions through SQL queries.

## 🎯 1. Problem Statement

E-commerce businesses manage thousands of products across multiple categories, each with different prices, discounts, weights, and stock availability.

Without proper data analysis, businesses may struggle to identify high-value products, monitor stock levels, evaluate discount strategies, and estimate potential revenue.

The goal of this project is to use MySQL to analyze Zepto's product inventory dataset and transform raw product information into actionable business insights that can support better pricing, inventory, and sales decisions.

## ⚠️ 2. Business Pain Points

1. **Ineffective Discount Strategies:** Difficulty identifying products offering attractive discounts and evaluating discount distribution across categories.
2. **Inventory Management Issues:** Limited visibility into products that are out of stock, especially high-priced products.
3. **Revenue Estimation Challenges:** Difficulty estimating potential revenue from available inventory across different product categories.
4. **Pricing Opportunities:** Identifying expensive products with relatively low discounts to understand potential pricing improvements.
5. **Category-Wise Discount Analysis:** Difficulty identifying categories that provide the highest average discounts.
6. **Product Value Comparison:** Difficulty comparing product value based on price and weight.
7. **Product Classification:** Lack of a structured approach to classify products based on their weight.
8. **Inventory Weight Management:** Difficulty understanding the total inventory weight maintained across product categories.

## 💡 3. SQL-Based Solutions to Business Pain Points

| Business Pain Point | SQL-Based Solution |
|---|---|
| Identifying attractive discounts | Used `ORDER BY` and `LIMIT` to find the top 10 discounted products. |
| Monitoring stock availability | Used `WHERE`, `GROUP BY`, and `ORDER BY` to identify high-priced out-of-stock products. |
| Estimating category revenue | Used `SUM()` with `GROUP BY` to calculate estimated inventory revenue. |
| Identifying pricing opportunities | Applied conditional filtering using `WHERE` and `AND`. |
| Evaluating discount strategies | Used `AVG()` and `GROUP BY` to identify top discount categories. |
| Comparing product value | Calculated price per gram using arithmetic operations. |
| Classifying products by weight | Implemented `CASE WHEN` to create weight categories. |
| Understanding inventory distribution | Used `SUM()` and `GROUP BY` to calculate total inventory weight. |

## 📂 4. Dataset Overview

The project uses a Zepto product inventory dataset containing product-level information.

- **Database Name:** `Zepto`
- **Table Name:** `zepto`

### Dataset Columns

| Column Name | Description |
|---|---|
| `name` | Name of the product |
| `category` | Product category |
| `mrp` | Maximum Retail Price |
| `discountPercent` | Discount percentage offered |
| `availableQuantity` | Available inventory quantity |
| `discountedSellingPrice` | Selling price after discount |
| `weightInGms` | Product weight in grams |
| `outOfStock` | Indicates whether the product is out of stock |
| `quantity` | Product quantity information |
| `sku_id` | SKU identifier |

## 🔍 5. Data Exploration and Cleaning

Before performing business analysis, the dataset was explored and cleaned to improve data consistency and reliability.

### A. Data Exploration

**1. Create and select the database**

```sql
CREATE DATABASE Zepto;
USE Zepto;
```

**2. Preview the dataset**

```sql
SELECT *
FROM zepto.zepto
LIMIT 10;
```

**3. Count total records**

```sql
SELECT COUNT(*)
FROM zepto.zepto;
```

**4. Identify missing values**

```sql
SELECT *
FROM zepto.zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;
```

**5. Identify unique product categories**

```sql
SELECT DISTINCT category
FROM zepto.zepto
ORDER BY category;
```

**6. Analyze stock availability**

```sql
SELECT outOfStock, COUNT(sku_id)
FROM zepto.zepto
GROUP BY outOfStock;
```

**7. Identify product names associated with multiple SKUs**

```sql
SELECT name, COUNT(sku_id) AS Number_of_sku
FROM zepto.zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;
```

### B. Data Cleaning

**1. Identify products with zero prices**

```sql
SELECT *
FROM zepto.zepto
WHERE mrp = 0
   OR discountedSellingPrice = 0;
```

**2. Remove products with zero MRP**

```sql
DELETE FROM zepto.zepto
WHERE mrp = 0;
```

**3. Convert prices from paise to rupees**

The original price values were stored in paise. They were converted into Indian Rupees for easier interpretation.

```sql
UPDATE zepto.zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
```

> **Important:** Run the price conversion only once. Re-running this update will divide the values again. It is recommended to create a backup before modifying the source table.

## 📊 6. Business Questions and SQL Analysis

### Q1. Find the Top 10 Best-Value Products Based on Discount Percentage

**Business Objective:** Identify products offering the highest discounts to understand attractive pricing opportunities.

```sql
SELECT DISTINCT
    name,
    mrp,
    discountPercent
FROM zepto.zepto
ORDER BY discountPercent DESC
LIMIT 10;
```

**Business Value:** Helps identify products with the highest discounts and supports promotional strategy evaluation.

### Q2. Identify Products with High MRP That Are Out of Stock

**Business Objective:** Find expensive products that are currently unavailable to identify potential inventory replenishment opportunities.

```sql
SELECT DISTINCT
    name,
    mrp
FROM zepto.zepto
WHERE outOfStock = TRUE
GROUP BY name, mrp
ORDER BY mrp DESC;
```

**Business Value:** Helps inventory managers prioritize reviewing expensive products that are unavailable for customers.

### Q3. Calculate Estimated Revenue for Each Product Category

**Business Objective:** Estimate the potential value of available inventory across different product categories.

```sql
SELECT
    category,
    SUM(discountedSellingPrice * availableQuantity) AS Total_Revenue
FROM zepto.zepto
GROUP BY category
ORDER BY Total_Revenue DESC;
```

**Business Value:** Helps identify categories with higher estimated inventory value and supports category-level business planning.

### Q4. Find Products Where MRP Is Greater Than ₹500 and Discount Is Less Than 10%

**Business Objective:** Identify expensive products that offer relatively low discounts.

```sql
SELECT DISTINCT
    name,
    mrp,
    discountPercent
FROM zepto.zepto
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
```

**Business Value:** Helps identify products whose pricing and discount strategies could be reviewed to improve customer attractiveness.

### Q5. Identify the Top 5 Categories Offering the Highest Average Discount Percentage

**Business Objective:** Understand which product categories provide the highest average discounts.

```sql
SELECT
    category,
    AVG(discountPercent) AS Average_Discount
FROM zepto.zepto
GROUP BY category
ORDER BY Average_Discount DESC
LIMIT 5;
```

**Business Value:** Helps compare discount strategies across categories and evaluate promotional patterns.

### Q6. Calculate Price Per Gram for Products Weighing More Than 180 Grams

**Business Objective:** Compare products based on their price relative to weight to identify better value-for-money options.

```sql
SELECT DISTINCT
    name,
    mrp,
    discountedSellingPrice,
    weightInGms,
    discountedSellingPrice / weightInGms AS price_per_gram
FROM zepto.zepto
WHERE weightInGms > 180
ORDER BY price_per_gram ASC;
```

**Business Value:** Helps compare product value based on price and weight, supporting better purchasing decisions.

### Q7. Group Products into Weight Categories: Low, Medium, and Bulk

**Business Objective:** Classify products based on their weight to understand inventory composition.

```sql
SELECT DISTINCT
    name,
    weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'Low'
        WHEN weightInGms < 5000 THEN 'Medium'
        ELSE 'Bulk'
    END AS Weight_Category
FROM zepto.zepto;
```

**Business Value:** Helps categorize products based on weight, which can support inventory organization, packaging, and logistics planning.

### Q8. Calculate Total Inventory Weight Per Category

**Business Objective:** Calculate the total weight of available inventory maintained across different product categories.

```sql
SELECT
    category,
    SUM(weightInGms * availableQuantity) AS Total_Inventory_Weight
FROM zepto.zepto
GROUP BY category
ORDER BY Total_Inventory_Weight;
```

**Business Value:** Helps understand category-wise inventory distribution and supports storage, handling, and logistics planning.

## 🛠️ 7. Key SQL Concepts Practiced

| SQL Concept | Application |
|---|---|
| `CREATE DATABASE` | Creating the project database |
| `USE` | Selecting the database |
| `SELECT` | Retrieving product information |
| `WHERE` | Filtering records based on conditions |
| `IS NULL` | Identifying missing values |
| `DISTINCT` | Removing duplicate combinations from query results |
| `COUNT()` | Counting records and SKU occurrences |
| `SUM()` | Calculating estimated inventory value and weight |
| `AVG()` | Calculating average discount percentages |
| `GROUP BY` | Performing category-wise analysis |
| `HAVING` | Filtering aggregated results |
| `ORDER BY` | Sorting analytical results |
| `LIMIT` | Extracting top records |
| `CASE WHEN` | Creating weight-based classifications |
| `UPDATE` | Cleaning and transforming price values |
| `DELETE` | Removing invalid zero-MRP records |
| Arithmetic Operations | Calculating inventory value and price per gram |

## 📈 8. Business Outcomes

This project demonstrates how SQL can convert raw inventory data into meaningful business insights.

- Identified products offering the highest discount percentages.
- Highlighted expensive products that were unavailable in stock.
- Estimated potential inventory value across product categories.
- Identified expensive products with relatively low discounts.
- Compared average discount percentages across product categories.
- Calculated price per gram to evaluate product value.
- Classified products into Low, Medium, and Bulk weight categories.
- Analyzed total inventory weight across different categories.

**Overall Impact:** The analysis provides a structured approach to understanding product pricing, inventory availability, discount distribution, and category-level inventory performance.

## 🚀 9. Future Improvements

1. **Power BI Dashboard Integration:** Connect MySQL to Power BI to create interactive dashboards for inventory, pricing, and category-level analysis.
2. **Sales Performance Analysis:** Integrate historical sales data to compare estimated inventory value with actual sales revenue.
3. **Inventory Optimization:** Develop stock-level monitoring to identify products requiring replenishment.
4. **Automated Reporting:** Use Python to automate SQL data extraction and generate periodic inventory reports.
5. **Advanced SQL Analysis:** Apply window functions, CTEs, and subqueries for more advanced analytical insights.
6. **Demand Forecasting:** Integrate machine learning models to predict future product demand and improve inventory planning.

## 💻 10. Tools and Technologies Used

- **Database:** MySQL
- **Query Language:** SQL
- **Analysis Type:** Exploratory Data Analysis (EDA), Inventory Analysis, Pricing Analysis, and Inventory Value Estimation
- **Core Skills:** Data Cleaning, Data Exploration, Aggregation, Data Transformation, and Business Analysis

## 👨‍💻 11. Project Learnings

Through this project, I gained practical experience in:

- Working with e-commerce inventory data.
- Performing data exploration and cleaning using MySQL.
- Writing SQL queries to solve business-related problems.
- Applying aggregate functions to generate business insights.
- Translating business questions into SQL queries.
- Understanding how data analysis supports inventory and pricing decisions.

---

**Project Name:** Zepto Inventory and Product Analysis  
**Author:** Chandra Mohan G.  
**Domain:** E-commerce / Retail Analytics  
**Technology:** MySQL

⭐ If you find this project useful, feel free to explore the repository and share your feedback!
