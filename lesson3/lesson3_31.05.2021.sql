DROP DATABASE IF EXISTS vk;
CREATE DATABASE IF NOT EXISTS vk;

-- используем БД vk
USE vk;

CREATE TABLE users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(150) NOT NULL COMMENT "Имя", 
	last_name VARCHAR(150) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	phone CHAR(11) NOT NULL,
	password_hash CHAR(80) DEFAULT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
	INDEX users_email_idx (email),
	UNIQUE INDEX users_phone_unique_idx (phone)
);

-- 1:1 связь
CREATE TABLE profiles (
	user_id SERIAL PRIMARY KEY, -- ? BIGINT UNSIGNED PRIMARY KEY
	gender ENUM('f', 'm', 'x'),
	birthday DATE NOT NULL,
	photo_id BIGINT UNSIGNED,
	city VARCHAR(130),
	country VARCHAR(130),
	FOREIGN KEY (user_id) REFERENCES users(id)	
);

-- описание таблицы
DESCRIBE users;
DESCRIBE profiles;

-- скрипт создания таблицы
SHOW CREATE TABLE users;

CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_types_id BIGINT UNSIGNED NOT NULL,
	file_name VARCHAR(200),
	file_size BIGINT UNSIGNED,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	INDEX media_media_types_idx (media_types_id),
  	INDEX media_users_idx (user_id)
);

CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL UNIQUE
);

-- добавляем
INSERT INTO media_types VALUES (DEFAULT, 'изображение');
INSERT INTO media_types VALUES (DEFAULT, 'музыка');
INSERT INTO media_types VALUES (DEFAULT, 'документ');

-- добавляем внешний ключ
ALTER TABLE media ADD FOREIGN KEY (media_types_id) REFERENCES media_types(id);

-- добавляем внешний ключ с именем ограничения
ALTER TABLE media ADD CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOL DEFAULT false,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY (from_user_id),
	KEY (to_user_id),
	CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

CREATE TABLE friend_requests (
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  accepted BOOLEAN DEFAULT False,
  PRIMARY KEY (from_user_id, to_user_id),
  KEY (from_user_id),
  KEY (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL
);

-- Таблица связи пользователей и сообществ
CREATE TABLE communities_users (
	community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (community_id, user_id),
	KEY (community_id),
  	KEY (user_id),
  	CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  	CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
);

-- заполняем таблицы данными
-- Заполним таблицу, добавим Петю и Васю
INSERT INTO users VALUES (DEFAULT, 'Petya', 'Petukhov', 'petya@mail.com', '89212223334', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasya', 'Vasilkov', 'vasya@mail.com', '89212023334', DEFAULT, DEFAULT);

INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, 'Moscow', 'Russia'); -- профиль Пети
INSERT INTO profiles VALUES (2, 'm', '1988-11-02', NULL, 'Moscow', 'Russia'); -- профиль Васи

-- вызовет ошибку
-- INSERT INTO profiles VALUES (3, 'm', '1988-11-02', NULL, 'Moscow', 'Russia'); -- профиль Васи

-- Добавим два сообщения от Пети к Васе, одно сообщение от Васи к Пете
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 1
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Vasya!', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 2
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi, Petya', 1, DEFAULT, DEFAULT); -- сообщение от Пети к Васе номер 2

-- Добавим запрос на дружбу от Пети к Васе
INSERT INTO friend_requests VALUES (1, 2, 1);

-- Добавим сообщество 
INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one');

-- Добавим запись вида Вася участник сообщества Number 1
INSERT INTO communities_users VALUES (1, 2);

-- Добавим два изображения, которые добавил Петя
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.png', 78, DEFAULT);
-- Добавим документ, который добавил Вася
INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

-- Добавим колонку с номером паспорта
ALTER TABLE users ADD COLUMN passport_number VARCHAR(10);

-- Изменим ее тип
ALTER TABLE users MODIFY COLUMN passport_number VARCHAR(20);

-- Переименуем ее
ALTER TABLE users RENAME COLUMN passport_number TO passport;

-- Добавим уникальный индекс на колонку
ALTER TABLE users ADD KEY passport_idx (passport);

-- Удалим индекс
ALTER TABLE users DROP INDEX passport_idx;

-- Удалим колонку
ALTER TABLE users DROP COLUMN passport;

-- совершенствуем таблицу дружбы
-- добавляем ограничение, что отправитель запроса на дружбу 
-- не может быть одновременно и получателем
ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check 
CHECK (from_user_id != to_user_id);

-- добавляем ограничение, что номер телефона должен состоять из 11
-- символов и только из цифр
ALTER TABLE users 
ADD CONSTRAINT phone_check
CHECK (REGEXP_LIKE(phone, '^[0-9]{11}$'));

DESCRIBE users;

-- Таблица с лайками для медиа файлов
CREATE TABLE media_likes (
    media_id BIGINT UNSIGNED NOT NULL,
    from_user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (media_id, from_user_id),
    KEY (media_id),
  	KEY (from_user_id),
  	CONSTRAINT fk_media_likes_media_id FOREIGN KEY (media_id) REFERENCES media (id),
  	CONSTRAINT fk_media_likes_user_id FOREIGN KEY (from_user_id) REFERENCES users (id)
);

-- Таблица с лайками для пользователей
CREATE TABLE user_likes (
    user_id BIGINT UNSIGNED NOT NULL,
    from_user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (user_id, from_user_id),
    KEY (user_id),
  	KEY (from_user_id),
  	CONSTRAINT fk_user_likes_user_id FOREIGN KEY (user_id) REFERENCES users (id),
  	CONSTRAINT fk_user_likes_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id)
);

-- Пользователь не может сам себя лайкнуть
ALTER TABLE user_likes 
ADD CONSTRAINT user_like_himself_check 
CHECK (user_id != from_user_id);

-- Таблица с постами
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
    post_name VARCHAR(500),
    post_text VARCHAR(10000),
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY (user_id),
    CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Прикреплённые к постам медиафайлы
CREATE TABLE posts_media (
	post_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, media_id),
    KEY (post_id),
  	KEY (media_id),
  	CONSTRAINT fk_posts_media_post_id FOREIGN KEY (post_id) REFERENCES posts (id),
  	CONSTRAINT fk_posts_media_media_id FOREIGN KEY (media_id) REFERENCES media (id)
);

-- Таблица с лайками для постов
CREATE TABLE posts_likes (
	post_id BIGINT UNSIGNED NOT NULL,
    from_user_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, from_user_id),
    KEY (post_id),
  	KEY (from_user_id),
  	CONSTRAINT fk_posts_likes_post_id FOREIGN KEY (post_id) REFERENCES posts (id),
  	CONSTRAINT fk_posts_likes_user_id FOREIGN KEY (from_user_id) REFERENCES users (id)
);