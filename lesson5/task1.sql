/* Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение» */

USE product_db;

/* 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */

SET SQL_SAFE_UPDATES = 0;

UPDATE users 
SET created_at = NOW(),
	updated_at = NOW();

SET SQL_SAFE_UPDATES = 1;

/* 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */

DROP TABLE IF EXISTS tmp_users_dates;
CREATE TABLE IF NOT EXISTS tmp_users_dates (
  id SERIAL PRIMARY KEY,
  created_at VARCHAR(20),
  updated_at VARCHAR(20));

INSERT INTO tmp_users_dates
SELECT id, DATE_FORMAT(created_at, '%d.%m.%Y %T'), DATE_FORMAT(updated_at, '%d.%m.%Y %T') FROM users;

-- Преобразовываем string к datetime
SELECT STR_TO_DATE(created_at, '%d.%m.%Y %T'), STR_TO_DATE(updated_at, '%d.%m.%Y %T') FROM tmp_users_dates;

DROP TABLE IF EXISTS tmp_users_dates;

/* 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех */

SELECT *, `value` = 0 as empty_value FROM storehouses_products
ORDER BY empty_value, `value`;