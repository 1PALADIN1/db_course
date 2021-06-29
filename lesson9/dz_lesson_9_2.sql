/* Практическое задание по теме “Хранимые процедуры и функции, триггеры" */

USE shop;

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

-- Проверка функции
SELECT hello();

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

select * from products;
delete from products
where id > 7;

-- Проверка триггера на добавление новой записи
INSERT INTO products (`name`, `description`, price, catalog_id) VALUES (NULL, "Test description", 9567, 1); -- триггер проходит 
INSERT INTO products (`name`, `description`, price, catalog_id) VALUES ("Test name", NULL, 9567, 1); -- триггер проходит
INSERT INTO products (`name`, `description`, price, catalog_id) VALUES (NULL, NULL, 9567, 1); -- триггер не проходит

-- Проверка триггера на обновление существующей записи
-- триггер проходит
UPDATE products 
SET `name` = "Test name", `description` = NULL
WHERE id = 15;

-- триггер проходит
UPDATE products 
SET `name` = NULL, `description` = "Test description"
WHERE id = 15;

-- триггер не проходит
UPDATE products 
SET `name` = NULL, `description` = NULL
WHERE id = 15;
