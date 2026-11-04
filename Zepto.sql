CREATE DATABASE Zepto;
USE Zepto;
SELECT * FROM zepto.zepto;

#data exploration
SELECT * FROM zepto.zepto LIMIT 10;

#count of rows
SELECT COUNT(*) FROM zepto.zepto;

#sample data
SELECT * FROM zepto.zepto LIMIT 10;

#null values
SELECT * FROM zepto.zepto  WHERE name IS NULL OR 
Category IS NULL OR
mrp IS NULL OR
discountPercent IS NULL OR
availableQuantity IS NULL OR
discountedSellingPrice IS NULL OR
weightInGms IS NULL OR
outOfStock IS NULL OR
quantity IS NULL;

#different product categories
SELECT DISTINCT category FROM zepto.zepto ORDER BY category;

#products in stock and out if stock
SELECT outOfStock,COUNT(sku_id) FROM zepto.zepto GROUP BY outOfStock;

#product names present multiple times
SELECT name, COUNT(sku_id) AS Number_of_sku FROM zepto.zepto GROUP BY
name HAVING COUNT(sku_id) > 1 ORDER BY COUNT(sku_id) DESC;

#data cleaning

#products with price = 0
SELECT * FROM zepto.zepto WHERE mrp = 0 OR discountedSellingPrice = 0;

#Delete the product which has price =0
DELETE FROM zepto.zepto WHERE mrp = 0;

#converting paise to Rupees
UPDATE zepto.zepto SET mrp = mrp/100.0, discountedSellingPrice = discountedSellingPrice/100.0;
SELECT mrp, discountedSellingPrice FROM zepto.zepto;

#Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp, discountPercent FROM zepto.zepto ORDER BY discountPercent DESC LIMIT 10;

#Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name,mrp  FROM zepto.zepto  WHERE outOFStock LIKE "TRUE" GROUP BY name, mrp ORDER BY mrp DESC;

#Q3.Calculate Estimated Revenue for each category
SELECT Category,SUM(discountedSellingPrice*availableQuantity) AS Total_Revenue FROM zepto.zepto GROUP BY Category ORDER BY Total_Revenue DESC;

#04. Find all products where MRP is greater than 500 and discount is less than 10%. 
SELECT DISTINCT name,mrp,discountPercent FROM zepto.zepto WHERE mrp > 500 AND discountPercent < 10 ORDER BY mrp DESC,discountPercent DESC;

#05. Identify the top 5 categories offering the highest average discount percentage.
SELECT DISTINCT Category,AVG(discountPercent) AS Average_Discount FROM zepto.zepto GROUP BY Category ORDER BY Average_Discount DESC LIMIT 5;
 
#06. Find the price per gram for products above 108g and sort by best value.
SELECT DISTINCT name,mrp,discountedSellingPrice,weightInGms, discountedSellingPrice/weightInGms AS price_per_gram FROM
zepto.zepto WHERE weightInGms > 180 ORDER BY price_per_gram ASC;

#07.Group the products into categories like Lw, Medium, Bulk.
SELECT DISTINCT name, weightInGMS, CASE WHEN weightInGms < 1000 THEN 'Low'
WHEN weightInGms < 5000 THEN 'Medium'
 ELSE 'Bulk'
END AS Weight_Category FROM zepto.zepto;

#08. What is the Total Inventory Weight Per Category
SELECT Category,SUM(weightInGms * availableQuantity) AS Weight FROM zepto.zepto GROUP BY Category ORDER BY weight;