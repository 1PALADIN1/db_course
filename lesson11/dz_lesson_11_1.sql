-- Практическое задание по теме “Оптимизация запросов”

/* 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name. */

USE shop;

-- Создаём таблицу с логами

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
  `table_name` VARCHAR(255),
  object_id INT UNSIGNED,
  name_content VARCHAR(255), -- содержимое поля name
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Логи' ENGINE=Archive;

-- Создаём необходимые триггеры

DELIMITER //

-- users
DROP TRIGGER IF EXISTS users_trigger_log_insert//

CREATE TRIGGER users_trigger_log_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`table_name`, object_id, name_content)
    VALUES ("users", new.id, new.`name`);
END//

-- catalogs
DROP TRIGGER IF EXISTS catalogs_trigger_log_insert//

CREATE TRIGGER catalogs_trigger_log_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`table_name`, object_id, name_content)
    VALUES ("catalogs", new.id, new.`name`);
END//

-- products
DROP TRIGGER IF EXISTS products_trigger_log_insert//

CREATE TRIGGER products_trigger_log_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`table_name`, object_id, name_content)
    VALUES ("products", new.id, new.`name`);
END//

DELIMITER ;

-- Тестирование
INSERT INTO users (`name`, birthday_at) VALUES ("Виктор", "1999-03-21");

INSERT INTO catalogs (`name`) VALUES ('Корпуса');

INSERT INTO products (`name`, `description`, price, catalog_id)
VALUES ('Test Content', 'Test description', 3000.00, 1);

SELECT * FROM `logs`;
