/* Практическое задание по теме “Транзакции, переменные, представления” */

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users (name, birthday_at, created_at, updated_at)
SELECT shop_u.name, shop_u.birthday_at, shop_u.created_at, shop_u.updated_at
FROM shop.users shop_u
WHERE shop_u.id = 1;

DELETE FROM shop.users shop_u
WHERE shop_u.id = 1;

COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

USE shop;

CREATE OR REPLACE VIEW products_catalogs AS
SELECT p.name product_name, c.name catalog_name FROM products p
LEFT JOIN catalogs c ON p.catalog_id = c.id;

SELECT * FROM products_catalogs;
