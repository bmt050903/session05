CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10,2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_name VARCHAR(100),
    quantity INT,
    price NUMERIC(10,2)
);

INSERT INTO customers (customer_name, city) VALUES
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Cần Thơ');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-10', 5000),
(2, '2025-01-12', 3500),
(1, '2025-02-01', 7000),
(3, '2025-02-05', 9000),
(4, '2025-02-20', 2500),
(2, '2025-03-01', 8000);

INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, 'Laptop Dell', 1, 5000),
(2, 'Chuột Logitech', 2, 1750),
(3, 'IPhone 15', 1, 7000),
(4, 'Ghế xoay', 3, 3000),
(5, 'Bàn học gỗ', 1, 2500),
(6, 'Màn hình LG', 2, 4000);

--1.ALIAS: Hiển thị danh sách tất cả các đơn hàng với các cột:
--Tên khách (customer_name)
--Ngày đặt hàng (order_date)
--Tổng tiền (total_amount)
SELECT c.customer_name AS ten_khach,
	o.order_date AS ngay_dat_hang,
    o.total_amount AS tong_tien
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;

2.--Aggregate Functions:
--Tính các thông tin tổng hợp:
--Tổng doanh thu (SUM(total_amount))
--Trung bình giá trị đơn hàng (AVG(total_amount))
--Đơn hàng lớn nhất (MAX(total_amount))
--Đơn hàng nhỏ nhất (MIN(total_amount))
--Số lượng đơn hàng (COUNT(order_id))
SELECT
    SUM(total_amount) AS tong_doanh_thu,
    AVG(total_amount) AS trung_binh_don,
    MAX(total_amount) AS don_lon_nhat,
    MIN(total_amount) AS don_nho_nhat,
    COUNT(order_id) AS so_luong_don
FROM orders;

--3.GROUP BY / HAVING:
---Tính tổng doanh thu theo từng thành phố
SELECT
    c.city,
    SUM(o.total_amount) AS tong_doanh_thu
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city;
---chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
SELECT
    c.city,
    SUM(o.total_amount) AS tong_doanh_thu
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000;

--4.JOIN:
--Liệt kê tất cả các sản phẩm đã bán, kèm:
--Tên khách hàng
--Ngày đặt hàng
--Số lượng và giá
--(JOIN 3 bảng customers, orders, order_items)
SELECT
    c.customer_name,
    o.order_date,
    oi.product_name,
    oi.quantity,
    oi.price
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id;

--5.Subquery:
--Tìm tên khách hàng có tổng doanh thu cao nhất.
--Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS tong_doanh_thu
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_rev)
    FROM (
        SELECT SUM(total_amount) AS total_rev
        FROM orders
        GROUP BY customer_id
    ) AS temp
);





