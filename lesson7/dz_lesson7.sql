USE product_db;

/* 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине. */

SELECT DISTINCT u.id, u.`name` FROM users u
JOIN orders o ON o.user_id = u.id;

/* 2. Выведите список товаров products и разделов catalogs, который соответствует товару. */

SELECT p.id, p.`name`, p.`description`, c.`name` FROM products p
JOIN catalogs c ON p.catalog_id = c.id;
