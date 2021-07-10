USE mmorpg_db;

/* Процедура, которая удаляет запись из items */

DELIMITER //

DROP PROCEDURE IF EXISTS delete_item;
CREATE PROCEDURE delete_item(
    item_id INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM consumable_items
    WHERE id = item_id;

    DELETE FROM equip_items
    WHERE id = item_id;

    DELETE FROM items
    WHERE id = item_id;

    COMMIT;
END;