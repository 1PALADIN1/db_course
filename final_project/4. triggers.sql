USE mmorpg_db;

/* =================== ХРАНИМЫЕ ПРОЦЕДУРЫ И ТРИГГЕРЫ =================== */

/* Триггер, который автоматически добавляет в таблицы расширений equip_items и consumable_items новые записи при добавлении записи в items */

DELIMITER //

DROP TRIGGER IF EXISTS items_trigger_insert_eq_items//

CREATE TRIGGER items_trigger_insert_eq_items AFTER INSERT ON items
FOR EACH ROW
BEGIN
    IF new.item_type = 'EQUIPMENT' THEN
        SELECT COUNT(*) INTO @items_count FROM equip_items eq
        WHERE eq.id = new.id;

        IF @items_count = 0 THEN
            INSERT INTO equip_items (id) VALUES (new.id);
        END IF;
    END IF;

    IF new.item_type = 'CONSUMABLE' THEN
        SELECT COUNT(*) INTO @items_count FROM consumable_items ci
        WHERE ci.id = new.id;

        IF @items_count = 0 THEN
            INSERT INTO consumable_items (id) VALUES (new.id);
        END IF;
    END IF;
END;

/* Триггеры, которые добавляют небольшие проверки в магазин на добавление и обновление товаров */

DROP TRIGGER IF EXISTS shop_check_insert_trigger//
CREATE TRIGGER shop_check_insert_trigger BEFORE INSERT ON shop
FOR EACH ROW
BEGIN
	IF new.buy_currency_id <> new.sell_currency_id THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buy and sell currency should be equal!';
    END IF;

	IF new.buy_price < new.sell_price THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buy price must be greater than sell price!';
    END IF;
END;

DROP TRIGGER IF EXISTS shop_check_update_trigger//
CREATE TRIGGER shop_check_update_trigger BEFORE UPDATE ON shop
FOR EACH ROW
BEGIN
	IF new.buy_currency_id <> new.sell_currency_id THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buy and sell currency should be equal!';
    END IF;

	IF new.buy_price < new.sell_price THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Buy price must be greater than sell price!';
    END IF;
END;

DELIMITER ;
