USE mmorpg_db;

/* =================== ТЕСТИРОВАНИЕ ПРОЦЕДУР И ТРИГГЕРОВ =================== */

/* Тестирование триггеров */

-- Таблица item
INSERT INTO `items` (name, item_type)
VALUES
       ('test_item_eq','EQUIPMENT');

INSERT INTO `items` (name, item_type)
VALUES
       ('test_item_consume','CONSUMABLE');

SELECT * FROM items
ORDER BY id DESC
LIMIT 2;

SELECT * FROM equip_items
ORDER BY id DESC
LIMIT 1;

SELECT * FROM consumable_items
ORDER BY id DESC
LIMIT 1;


-- Таблица shop
-- Expected error
INSERT INTO `shop` (buy_currency_id, sell_currency_id, item_id, buy_price, sell_price)
VALUES
       (1, 2, 58, 2000, 1000);

-- OK
INSERT INTO `shop` (buy_currency_id, sell_currency_id, item_id, buy_price, sell_price)
VALUES
       (1, 1, 58, 2000, 1000);

SELECT * FROM shop
WHERE item_id = 58;

-- Expected error
INSERT INTO `shop` (buy_currency_id, sell_currency_id, item_id, buy_price, sell_price)
VALUES
       (1, 1, 17, 100, 6000);

-- OK
INSERT INTO `shop` (buy_currency_id, sell_currency_id, item_id, buy_price, sell_price)
VALUES
       (1, 1, 17, 6000, 100);

SELECT * FROM shop
WHERE item_id = 17;


/* Тестирование функции */

SELECT get_level(8); -- Expected 3
SELECT get_level(14); -- Expected 9
SELECT get_level(33); -- Expected 6


/* Тестирование процедур */
CALL archive_old_chat_messages(STR_TO_DATE('2021-06-12', '%Y-%m-%d'));

-- Должны появиться записи
SELECT * FROM archive_global_chat
WHERE created_at <= STR_TO_DATE('2021-06-12', '%Y-%m-%d');

-- Запрос должен быть пустым, т.к. записи ушли в архив
SELECT * FROM global_chat
WHERE created_at <= STR_TO_DATE('2021-06-12', '%Y-%m-%d');


-- Процедура подчистки таблиц расширений
INSERT INTO items (name, item_type)
VALUES
       ('del_test_item_1','EQUIPMENT'),
       ('del_test_item_2','CONSUMABLE');


SELECT id INTO @item_id FROM items
WHERE name = 'del_test_item_1';

CALL delete_item(@item_id);

SELECT id INTO @item_id FROM items
WHERE name = 'del_test_item_2';

CALL delete_item(@item_id);

-- Тут должно быть пусто
SELECT * FROM items
WHERE name IN ('del_test_item_1', 'del_test_item_2');
