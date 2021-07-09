USE mmorpg_db;

/* Количество персонажей у каждого игрока */

SELECT u.id, u.email, t.total_characters FROM users u
JOIN
    (SELECT u.id, COUNT(*) as total_characters FROM users u
    JOIN characters c ON u.id = c.user_id
    GROUP BY u.id) t
ON u.id = t.id;

/* Подробная информация о персонажах игроков */

SELECT u.id, u.email, c.name, c.exp, r.name FROM users u
JOIN characters c ON u.id = c.user_id
JOIN races r ON c.race_id = r.id;

/* Персонажи каждой из рас */

SELECT r.name as 'Race', c.name as 'Character name' FROM races r
JOIN characters c on r.id = c.race_id
GROUP BY r.name, c.name;

/* Самая любимая раса игроков */

SELECT r.name FROM
(SELECT t2.id FROM
    (SELECT r.id, COUNT(1) as total_chars FROM races r
    JOIN characters c on r.id = c.race_id
    GROUP BY r.id) t2
WHERE t2.total_chars = (SELECT MAX(t.total_chars) FROM
    (SELECT COUNT(1) as total_chars FROM races r
    JOIN characters c on r.id = c.race_id
    GROUP BY r.id) t)) t3
JOIN races r ON r.id = t3.id;

/* Какие предметы находятся у игроков в сумках */

SELECT u.id, u.email, c.name as 'Character name', it.name as 'Item name', it.item_type FROM users u
JOIN characters c ON u.id = c.user_id
JOIN inventories i ON c.inventory_id = i.id
JOIN inventories_items ii ON i.id = ii.inventory_id
JOIN items it ON ii.item_id = it.id;

/* Текущий уровень персонажей */

SELECT chars.id, chars.name, t.level FROM
    (SELECT ch.id, MAX(cl.level) as level
    FROM characters ch
    JOIN character_levels cl on ch.race_id = cl.race_id
    WHERE ch.exp >= cl.exp
    GROUP BY ch.id) t
JOIN characters chars on chars.id = t.id
ORDER BY chars.id;

/* Вся экипровка в магазине */

SELECT i.name as item_name, sh.buy_price, cb.name as buy_currency, sh.sell_price, cs.name as sell_currency FROM shop sh
JOIN equip_items ei on sh.item_id = ei.id
JOIN items i on ei.id = i.id
JOIN currencies cb on sh.buy_currency_id = cb.id
JOIN currencies cs on sh.sell_currency_id = cs.id;

/* Все расходники в магазине */

SELECT i.name as item_name, sh.buy_price, cb.name as buy_currency, sh.sell_price, cs.name as sell_currency FROM shop sh
JOIN consumable_items ci on sh.item_id = ci.id
JOIN items i on ci.id = i.id
JOIN currencies cb on sh.buy_currency_id = cb.id
JOIN currencies cs on sh.sell_currency_id = cs.id;

/* Средняя стоимость покупки расходника (который покупается за золото) */

SELECT AVG(sh.buy_price) FROM shop sh
JOIN consumable_items ci on sh.item_id = ci.id
WHERE sh.buy_currency_id =
      (SELECT c.id FROM currencies c
          WHERE c.name = 'Gold');

/* Средняя стоимость продажи экипировки (которая продаётся за алмазы) */

SELECT AVG(sh.sell_price) FROM shop sh
JOIN equip_items ei on sh.item_id = ei.id
WHERE sh.sell_currency_id =
      (SELECT c.id FROM currencies c
          WHERE c.name = 'Diamond');

/* Максимальная стоимость товара (по валютам) */

SELECT c.name, t.max_price FROM
    (SELECT cb.id, MAX(sh.buy_price) as max_price FROM shop sh
    JOIN currencies cb on sh.buy_currency_id = cb.id
    GROUP BY cb.id) t
JOIN currencies c ON c.id = t.id;

/* Стоимости инвентарей персонажей */

SELECT ch.name, t.inventory_id, t.total_price FROM characters ch
JOIN
    (SELECT ii.inventory_id, SUM(sh.buy_price) as total_price FROM shop sh
    LEFT JOIN inventories_items ii ON sh.item_id = ii.id
    GROUP BY ii.inventory_id) t ON ch.inventory_id = t.inventory_id
ORDER BY total_price DESC;

/* Что надето на персонажах */

SELECT ch.name as character_name, r.name as race_name, i.name as item_name, eit.name as equip_item_type FROM characters ch
JOIN characters_equip_items cei on ch.id = cei.character_id
JOIN races r on ch.race_id = r.id
JOIN equip_items ei on cei.equip_item_id = ei.id
JOIN equip_item_types eit on ei.equip_item_type_id = eit.id
LEFT JOIN items i on ei.id = i.id;

/* Какие есть абилки у указанного персонажа */

SELECT * FROM
    (SELECT ch.id, ch.name as character_name, a.name as ability_name FROM characters ch
    JOIN races r on ch.race_id = r.id
    JOIN abilities a on r.id = a.race_id) t
WHERE t.id = 9;

/* Какие абилки разблокированы у указанного персонажа (подходят по его текущему уровню) */

SET @char_id = 33;

SELECT * FROM abilities a
WHERE a.available_level <=
      (SELECT MAX(cl.level) FROM character_levels cl
        WHERE cl.exp <=
              (SELECT c.exp FROM characters c WHERE c.id = @char_id)
            AND cl.race_id = (SELECT c.race_id FROM characters c WHERE c.id = @char_id))
    AND a.race_id = (SELECT c.race_id FROM characters c WHERE c.id = @char_id);

/* Отсортированный чат */

SELECT ch.name as 'Character name', gc.created_at, gc.message FROM global_chat gc
JOIN characters ch on gc.from_character_id = ch.id
ORDER BY gc.created_at DESC;

/* Расходка, которая даёт бонус к урону */

SELECT i.name, ci.damage_boost FROM consumable_items ci
JOIN items i on ci.id = i.id
WHERE ci.damage_boost IS NOT NULL AND ci.damage_boost > 0;

/* Экипировка, которая увеличивает макс. уровень здоровья и её цена в магазине */

SELECT i.name, ei.health_boost, s.buy_price, s.sell_price FROM equip_items ei
JOIN items i on ei.id = i.id
LEFT JOIN shop s on i.id = s.item_id
WHERE ei.health_boost IS NOT NULL AND ei.health_boost > 0;
