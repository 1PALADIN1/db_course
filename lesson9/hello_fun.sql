-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //

DROP FUNCTION IF EXISTS hello;

CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE cur_time TIME DEFAULT NULL;
    
    SET cur_time = CURRENT_TIME();
    
	IF cur_time >= STR_TO_DATE("6:00", "%H:%i") AND cur_time < STR_TO_DATE("12:00", "%H:%i") THEN
		RETURN "Доброе утро";
	END IF;
	IF cur_time >= STR_TO_DATE("12:00", "%H:%i") AND cur_time < STR_TO_DATE("18:00", "%H:%i") THEN
		RETURN "Добрый день";
	END IF;
    IF cur_time >= STR_TO_DATE("18:00", "%H:%i") AND cur_time < STR_TO_DATE("23:59:59", "%H:%i:%s") THEN
		RETURN "Добрый вечер";
	END IF;

	RETURN "Доброй ночи";
END//