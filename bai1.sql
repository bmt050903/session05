Create table products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(50),
	category VARCHAR(50)
);

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	product_id INT REFERENCES products(product_id),
	quantity INT,
	total_price NUMERIC(10,2)
);

INSERT INTO products(product_name,category) VALUES 
('Laptop Dell', 'Electronics'),
('IPhone 15', 'Electronics'),
('Bàn học gỗ', 'Furniture'),
('Ghế xoay', 'Furniture');

SELECT * FROM products

INSERT INTO orders (product_id, quantity, total_price)
VALUES
(1, 2, 2200),
(2, 3, 3300),
(3, 5, 2500),
(4, 4, 1600),
(1, 1, 1100);

SELECT * FROM orders

--1.Viết truy vấn hiển thị tổng doanh thu (SUM(total_price))-- 
--và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)--

SELECT p.category, 
		SUM(o.total_price) AS total_sales,
		SUM(o.quantity) AS total_quantity 
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY  p.category;

--2.Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
SELECT p.category, 
		SUM(o.total_price) AS total_sales,
		SUM(o.quantity) AS total_quantity 
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY  p.category
HAVING SUM(o.total_price) > 2000;

--3.Sắp xếp kết quả theo tổng doanh thu giảm dần

SELECT 
    p.category,
    SUM(o.total_price) AS total_sales,
    SUM(o.quantity) AS total_quantity
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.category
HAVING SUM(o.total_price) > 2000
ORDER BY total_sales DESC;

