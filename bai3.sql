CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(50),
	city VARCHAR(20)
);

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_date DATE,
	total_price NUMERIC(10,2)
);

CREATE TABLE order_items(
	item_id SERIAL PRIMARY KEY,
	order_id INT REFERENCES orders(order_id),
	product_id INT,
    quantity INT,
	price NUMERIC(10,2)
);

INSERT INTO customers(customer_name,city) VALUES
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Hà Nội');

SELECT * FROM customers

INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-05', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);

SELECT * FROM orders

INSERT INTO order_items (item_id, order_id, product_id, quantity, price)
VALUES
(1, 101, 1, 2, 1500),
(2, 102, 2, 1, 1500),
(3, 103, 3, 5, 500),
(4, 104, 2, 4, 1000);

SELECT * FROM order_items

--1.Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
--Chỉ hiển thị khách hàng có tổng doanh thu > 2000
--Dùng ALIAS: total_revenue và order_count
SELECT c.customer_name,
	SUM(o.total_price) AS total_price,
	COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_price) > 2000;

--2.Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
--Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
SELECT 
    c.customer_name,
    SUM(o.total_price) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_price) > (
    SELECT AVG(total_rev)
    FROM (
        SELECT SUM(total_price) AS total_rev
        FROM orders
        GROUP BY customer_id
    ) AS temp
);

--3.Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
SELECT 
    c.city,
    SUM(o.total_price) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_price) = (
    SELECT MAX(city_total)
    FROM (
        SELECT SUM(o.total_price) AS city_total
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        GROUP BY c.city
    ) AS temp
);

--4.(Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
--Tên khác0h hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
SELECT 
    c.customer_name,
    c.city,
    SUM(oi.quantity) AS total_products,
    SUM(oi.quantity * oi.price) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name, c.city;




