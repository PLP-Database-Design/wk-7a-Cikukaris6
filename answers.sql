Question 1: Achieving 1NF (First Normal Form) 
Task: The ProductDetail table violates 1NF because the Products column contains multiple values. To transform this table into 1NF, we need to create separate rows for each product in the Products column.
  -- Transform the table into 1NF by ensuring each row represents a single product for an order
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) n
ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1;

Question 2: Achieving 2NF (Second Normal Form) 
Task: The OrderDetails table is in 1NF but violates 2NF because the CustomerName depends on OrderID, not the full primary key. To move the table to 2NF, we need to remove partial dependencies by splitting the data into two tables: one for the order details and another for the customer.
SQL Query to Create Tables in 2NF:
Create the Orders table (removing the partial dependency of CustomerName):
-- Create the Orders table to store OrderID and CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

Second step is to Create the OrderProducts table for the product and quantity information:
-- Create the OrderProducts table to store OrderID, Product, and Quantity
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into OrderProducts table
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
