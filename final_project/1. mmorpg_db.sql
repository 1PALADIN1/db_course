DROP DATABASE IF EXISTS mmorpg_db;
CREATE DATABASE IF NOT EXISTS mmorpg_db;

USE mmorpg_db;


/* =================== ТАБЛИЦЫ =================== */

/* 1. Таблица с игровыми расами */

DROP TABLE IF EXISTS races;
CREATE TABLE races (
  id SERIAL PRIMARY KEY,
  name VARCHAR(10) NOT NULL,
  UNIQUE unique_name(name(10))
) COMMENT = 'Игровые расы';


/* 2. Таблица с пользователями */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    password_hash CHAR(80) NOT NULL,
    gender ENUM('f', 'm', 'x') DEFAULT 'x',
    birthday DATE NOT NULL,
    UNIQUE unique_email(email)
) COMMENT = 'Пользователи';


/* 3. Таблица с игровыми предметами */

DROP TABLE IF EXISTS items;
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL COMMENT 'Название предмента',
    item_type ENUM('COMMON', 'CONSUMABLE', 'EQUIPMENT') DEFAULT 'COMMON' COMMENT 'Тип предмета',
    UNIQUE unique_name(name)
) COMMENT = 'Предметы';


/* 4. Таблица с типами экипировки (на какую часть тела персонаж может надеть предмет)*/

DROP TABLE IF EXISTS equip_item_types;
CREATE TABLE equip_item_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL COMMENT 'Тип экипировки',
    UNIQUE unique_name(name)
) COMMENT = 'Типы экипировки';


/* 5. Таблица с предметами экипировки персонажей (расширяет таблицу items с типом item_type = EQUIPMENT) */

DROP TABLE IF EXISTS equip_items;
CREATE TABLE equip_items (
    id SERIAL PRIMARY KEY,
    required_level INT DEFAULT NULL COMMENT 'Требуемый уровень для ношения предмета', -- NULL - отсутсвие требования
    required_race_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'Требуемая раса для ношения предмета', -- NULL - отсутсвие требования
    equip_item_type_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'Тип экипировки',
    -- Экипировка улучшает какую-либо характеристику у персонажа
    health_boost INT NOT NULL DEFAULT 0 COMMENT 'Прирост к макс. уровню здоровья',
    damage_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к атаке',
    defence_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к защите',
    dexterity_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к ловкости',
    manna_boost INT NOT NULL DEFAULT 0 COMMENT 'Прирост к макс. уровню манны',
    critical_hit_chance_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к шансу крит. урона',
    FOREIGN KEY (id) REFERENCES items(id),
    KEY (required_race_id),
    KEY (equip_item_type_id),
    CONSTRAINT fk_equip_items_races FOREIGN KEY (required_race_id) REFERENCES races (id),
    CONSTRAINT fk_equip_items_equip_item_types FOREIGN KEY (equip_item_type_id) REFERENCES equip_item_types (id)
) COMMENT = 'Экипировака';


/* 6. Таблица с предметами типа CONSUMABLE (расширяет таблицу items с типом item_type = CONSUMABLE) */
/* Эти предметы дают временный прирост к указанной характеристики */

DROP TABLE IF EXISTS consumable_items;
CREATE TABLE consumable_items (
    id SERIAL PRIMARY KEY,
    max_health_boost INT NOT NULL DEFAULT 0 COMMENT 'Прирост к макс. уровню здоровья',
    health_restore INT NOT NULL DEFAULT 0 COMMENT 'Количество восстанавливаемого здоровья',
    damage_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к атаке',
    defence_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к защите',
    dexterity_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к ловкости',
    max_manna_boost INT NOT NULL DEFAULT 0 COMMENT 'Прирост к макс. уровню манны',
    manna_restore INT NOT NULL DEFAULT 0 COMMENT 'Количество восстанавливаемой манны',
    critical_hit_chance_boost INT NOT NULL DEFAULT 0 COMMENT 'Доп. бонус к шансу крит. урона',
    duration FLOAT NOT NULL DEFAULT 0 COMMENT 'Время действия (сек.)', -- NULL - применяется мгновенно
    FOREIGN KEY (id) REFERENCES items(id)
) COMMENT 'Расходники';


/* 7. Таблица с инвентарями. У каждого персонажа из таблицы characters свой инвентарь */

DROP TABLE IF EXISTS inventories;
CREATE TABLE inventories (
    id SERIAL PRIMARY KEY,
    max_size INT NOT NULL -- размер инвентаря можно апгрейдить
) COMMENT = 'Инвентари персонажей';


/* 8. Таблица инвентарь - предметы */

DROP TABLE IF EXISTS inventories_items;
CREATE TABLE inventories_items (
    id SERIAL PRIMARY KEY,
    inventory_id BIGINT UNSIGNED NOT NULL,
    item_id BIGINT UNSIGNED NOT NULL,
    KEY (inventory_id),
    KEY (item_id),
    CONSTRAINT fk_inventories_items_inventories FOREIGN KEY (inventory_id) REFERENCES inventories (id),
    CONSTRAINT fk_inventories_items_items FOREIGN KEY (item_id) REFERENCES items (id)
) COMMENT = 'Инвентари предменты';


/* 9. Таблица с игровыми персонажами */

DROP TABLE IF EXISTS characters;
CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL COMMENT 'Имя персонажа',
    exp INT NOT NULL COMMENT 'Набранный опыт', -- текущий набранный опыт для конкретного персонажа
    user_id BIGINT UNSIGNED NOT NULL,
    race_id BIGINT UNSIGNED NOT NULL,
    inventory_id BIGINT UNSIGNED NOT NULL,
    KEY (user_id),
    KEY (race_id),
    KEY (inventory_id),
    UNIQUE unique_name(name),
    CONSTRAINT fk_characters_users FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_characters_races FOREIGN KEY (race_id) REFERENCES races (id),
    CONSTRAINT fk_characters_inventories FOREIGN KEY (inventory_id) REFERENCES inventories (id)
) COMMENT = 'Игровые персонажи';


/* 10. Таблица с предметами, которые персонаж одел на себя */

DROP TABLE IF EXISTS characters_equip_items;
CREATE TABLE characters_equip_items (
    id SERIAL PRIMARY KEY,
    character_id BIGINT UNSIGNED NOT NULL,
    equip_item_id BIGINT UNSIGNED NOT NULL,
    KEY (character_id),
    KEY (equip_item_id),
    UNIQUE(character_id, equip_item_id),
    CONSTRAINT fk_characters_equip_items_characters FOREIGN KEY (character_id) REFERENCES characters (id),
    CONSTRAINT fk_characters_equip_items_equip_items FOREIGN KEY (equip_item_id) REFERENCES equip_items (id)
);


/* 11. Таблица с уровнями (и характеристиками для каждого уровня) для персонажей каждой расы, прогресс и прокачка */

DROP TABLE IF EXISTS character_levels;
CREATE TABLE character_levels (
    id SERIAL PRIMARY KEY,
    race_id BIGINT UNSIGNED NOT NULL,
    level INT NOT NULL,
    exp INT NOT NULL, -- требуемое количество опыта для перехода на указанный уровень
    damage INT NOT NULL COMMENT 'Наносимый урон',
    defence INT NOT NULL COMMENT 'Уровень защиты',
    health INT NOT NULL COMMENT 'Количество здоровья',
    dexterity INT NOT NULL COMMENT 'Ловкость',
    manna INT NOT NULL COMMENT 'Манна',
    critical_hit_chance INT NOT NULL COMMENT 'Шанс нанесения критического урона',
    health_recovery INT NOT NULL COMMENT 'Количество восстановления здоровья', -- в единицу времени
    manna_recovery INT NOT NULL COMMENT 'Количество восстановления манны', -- в единицу времени
    KEY (race_id),
    CONSTRAINT fk_character_levels_races FOREIGN KEY (race_id) REFERENCES races (id)
) COMMENT = 'Уровни и прогресс персонажей';


/* 12. Таблица с абилками для каждой из рас */

DROP TABLE IF EXISTS abilities;
CREATE TABLE abilities (
    id SERIAL PRIMARY KEY,
    race_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(20),
    available_level INT NOT NULL, -- с какого уровня доступна способность
    cooldown FLOAT NOT NULL COMMENT 'Время перезарядки (сек.)',
    UNIQUE unique_name(name),
    KEY (race_id),
    CONSTRAINT fk_abilities_races FOREIGN KEY (race_id) REFERENCES races (id)
) COMMENT = 'Магические способности рас';


/* 13. Внутриигровые валюты */

DROP TABLE IF EXISTS currencies;
CREATE TABLE currencies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    UNIQUE unique_name(name)
) COMMENT 'Внутриигровые валюты';


/* 14. Магазин */

DROP TABLE IF EXISTS shop;
CREATE TABLE shop (
    id SERIAL PRIMARY KEY,
    buy_currency_id BIGINT UNSIGNED NOT NULL,
    sell_currency_id BIGINT UNSIGNED NOT NULL,
    item_id BIGINT UNSIGNED NOT NULL,
    buy_price INT NOT NULL COMMENT 'Стоимость в магазине на покупку',
    sell_price INT NOT NULL COMMENT 'Стоимость на продажу',
    KEY (buy_currency_id),
    KEY (sell_currency_id),
    KEY (item_id),
    UNIQUE (item_id),
    CONSTRAINT fk_shop_buy_currencies FOREIGN KEY (buy_currency_id) REFERENCES currencies (id),
    CONSTRAINT fk_shop_sell_currencies FOREIGN KEY (sell_currency_id) REFERENCES currencies (id),
    CONSTRAINT fk_shop_items FOREIGN KEY (item_id) REFERENCES items (id)
) COMMENT 'Магазин';


/* 15. Чат */

DROP TABLE IF EXISTS global_chat;
CREATE TABLE global_chat (
    id SERIAL PRIMARY KEY,
    message VARCHAR(255),
    from_character_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY (from_character_id),
    CONSTRAINT fk_global_chat_characters FOREIGN KEY (from_character_id) REFERENCES characters (id)
) COMMENT 'Чат';


/* 16. Архив для чата */

DROP TABLE IF EXISTS archive_global_chat;
CREATE TABLE archive_global_chat (
  message_id INT UNSIGNED NOT NULL,
  from_character_id INT UNSIGNED NOT NULL,
  message VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL
) COMMENT 'Архив для чата' ENGINE=Archive;