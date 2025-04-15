CREATE TABLE Customer (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) CHECK (price > 0),
    stock INT NOT NULL,
    category VARCHAR(50)
);
CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customer(id),
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

CREATE TABLE OrderItem (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(id),
    product_id INT REFERENCES Product(id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);
	CREATE TABLE Payment (
    id INT PRIMARY KEY, 
    orders_id INT NOT NULL,
    payment_mode VARCHAR(50) NOT NULL, 
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    paid_on DATE NOT NULL, 
    FOREIGN KEY (orders_id) REFERENCES Orders (id) 
);


--4.Alter the Customer table to add a column loyalty_points INT DEFAULT 0
ALTER TABLE Customer ADD COLUMN loyalty_points INT DEFAULT 0;

--5.Alter the Product table to rename the column category to product_category.
ALTER TABLE Product RENAME COLUMN category TO product_category;

--6.Insert a new product into the Product table with sample data.
INSERT INTO Product (id, name, description, price, stock, product_category)
VALUES (1, 'Laptop', 'High-performance laptop', 1200.00, 50, 'Electronics');

--7.Update the stock of a product after an order is placed.
UPDATE Product
SET stock = stock - 1
WHERE id = 1;


-- Insert sample data into the Orders table
INSERT INTO Orders (id, customer_id, order_date, status, total_amount)
VALUES 
    (1, 101, '2025-04-01', 'Pending', 250.00),
    (2, 102, '2025-04-02', 'Shipped', 150.00),
    (3, 103, '2025-04-03', 'Delivered', 300.00),
    (4, 101, '2025-04-04', 'Cancelled', 0.00),
    (5, 104, '2025-04-05', 'Pending', 450.00);

-- Insert sample data into the Customer table
INSERT INTO Customer (id, name, email, phone, address, created_at)
VALUES 
    (101, 'John Doe', 'john.doe@example.com', '1234567890', '123 Main St', CURRENT_TIMESTAMP),
    (102, 'Jane Smith', 'jane.smith@example.com', '9876543210', '456 Elm St', CURRENT_TIMESTAMP),
    (103, 'Alice Johnson', 'alice.johnson@example.com', '4567891230', '789 Oak St', CURRENT_TIMESTAMP),
    (104, 'Bob Brown', 'bob.brown@example.com', '7891234560', '321 Pine St', CURRENT_TIMESTAMP);
	
--8.Delete an order and cascade delete corresponding OrderItems.
DELETE FROM Orders
WHERE id = 4; 

--9. Insert a payment record linked to a particular order.
INSERT INTO Payment (id, orders_id, payment_mode, amount_paid, payment_status, paid_on)
VALUES (1, 1, 'Credit Card', 1200.00, 'Completed', CURRENT_DATE);

--10.Update the status of a customer’s order from 'Pending' to 'Shipped'.
UPDATE Orders
SET status = 'Shipped'
WHERE id = 1; 

--11.Get the list of all orders with the customer name and order total.
SELECT o.id AS orders_id, c.name AS customer_name, o.total_amount
FROM Orders o
JOIN Customer c
ON o.customer_id = c.id;


-- Insert a product with stock = 0
INSERT INTO Product (id, name, description, price, stock, product_category)
VALUES (2, 'Sample Product', 'This is a sample product.', 100.00, 0, 'Electronics');
--12.List all products that are out of stock (stock = 0).
SELECT name AS product_name
FROM Product
WHERE stock = 0;


-- Insert a customer who hasn’t placed any orders yet
INSERT INTO Customer (id, name, email, phone, address, created_at)
VALUES 
    (105, 'Emily Davis', 'emily.davis@example.com', '9876543211', '789 Maple St', CURRENT_TIMESTAMP);
--13.Find all customers who haven’t placed any orders yet.
SELECT c.name AS customer_name
FROM Customer c
LEFT JOIN  Orders o
ON c.id = o.customer_id
WHERE o.id IS NULL;

--14.Get top 3 customers who have spent the most money (based on total payments).
SELECT c.id AS customer_id,c.name AS customer_name,SUM(p.amount_paid) AS total_spent
FROM Customer c
JOIN  Orders o
ON  c.id = o.customer_id
JOIN  Payment p
ON  o.id = p.orderS_id
GROUP BY  c.id, c.name
ORDER BY total_spent DESC
LIMIT 3;

--15.Get the details of the highest value order (max total_amount).
SELECT 
    o.id AS orders_id,
    c.name AS customer_name,
    o.order_date,
    o.status,
    o.total_amount
FROM 
    Orders o
JOIN 
    Customer c
ON 
    o.customer_id = c.id
WHERE 
    o.total_amount = (SELECT MAX(total_amount) FROM Orders);

select * from orders;
select * from customer;
select * from payment;
select * from product;
select * from orderitem;



