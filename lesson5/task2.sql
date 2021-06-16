/* Практическое задание теме «Агрегация данных» */

USE product_db;

/* 1. Подсчитайте средний возраст пользователей в таблице users. */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

/* 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

SELECT WEEKDAY(DATE_FORMAT(birthday_at, CONCAT(YEAR(CURDATE()), '-%m-%d'))) as calc_day, COUNT(*) FROM users
GROUP BY calc_day;