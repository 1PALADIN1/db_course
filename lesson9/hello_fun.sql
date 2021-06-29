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