-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

DROP TRIGGER IF EXISTS products_trigger_insert//

CREATE TRIGGER products_trigger_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF new.name IS NULL AND new.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You should fill both name and description fields!';
    END IF;
END//


DROP TRIGGER IF EXISTS products_trigger_update//

CREATE TRIGGER products_trigger_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF new.name IS NULL AND new.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You should fill both name and description fields!';
    END IF;
END//