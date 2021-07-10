USE mmorpg_db;

/* =================== ПЕРДСТАВЛЕНИЯ =================== */
/* Подробная информация о персонажах игроков */

CREATE OR REPLACE VIEW characters_info AS
    SELECT u.id, u.email, c.name as character_name, c.exp, t.level, r.name as race_name FROM users u
    JOIN characters c ON u.id = c.user_id
    JOIN races r ON c.race_id = r.id
    JOIN (SELECT ch.id, MAX(cl.level) as level
        FROM characters ch
        JOIN character_levels cl on ch.race_id = cl.race_id
        WHERE ch.exp >= cl.exp
        GROUP BY ch.id) t on c.id = t.id;


/* Все товары магазина */

CREATE OR REPLACE VIEW shop_items AS
    SELECT sh.buy_price,
           bc.name as buy_currency,
           sh.sell_price,
           sc.name as sell_currency,
           i.name as item_name,
           i.item_type
    FROM shop sh
    JOIN currencies bc on sh.buy_currency_id = bc.id
    JOIN currencies sc on sh.sell_currency_id = sc.id
    JOIN items i on sh.item_id = i.id;


/* Количесвто сообщений от каждого из пользователей в чате */

CREATE OR REPLACE VIEW users_count_messages AS
    SELECT u.email, COUNT(gc.message) FROM users u
    LEFT JOIN characters c on u.id = c.user_id
    LEFT JOIN global_chat gc on c.id = gc.from_character_id
    GROUP BY u.email;

/* =================== Поверка представлений =================== */

SELECT * FROM characters_info;
SELECT * FROM shop_items;
SELECT * FROM users_count_messages;