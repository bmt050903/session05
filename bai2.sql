--1.Viết truy vấn con (Subquery) để tìm sản phẩm có 
--doanh thu cao nhất trong bảng orders
--Hiển thị: product_name, total_revenue

SELECT p.product_name,
       SUM(o.total_price) AS total_revenue
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_name
HAVING SUM(o.total_price) = (
    SELECT MAX(total_rev)
    FROM (
        SELECT SUM(total_price) AS total_rev
        FROM orders
        GROUP BY product_id
    ) AS temp
);

--2.Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category 
--(dùng JOIN + GROUP BY)
SELECT p.category,
       SUM(o.total_price) AS total_revenue
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.category;