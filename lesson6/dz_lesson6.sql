USE vk;

/* 2. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. */

SET @user_id = 1;

SELECT IF(from_user_id = @user_id, to_user_id, from_user_id) as mes_friend_id, COUNT(*) FROM messages
WHERE (from_user_id = @user_id OR to_user_id = @user_id) AND (
		from_user_id IN (SELECT IF(from_user_id = @user_id, to_user_id, from_user_id) as friend_id FROM friend_requests
			WHERE request_type = (SELECT id FROM friend_requests_types WHERE `name` = 'accepted')
				AND (from_user_id = @user_id OR to_user_id = @user_id))
		OR
        to_user_id IN (SELECT IF(from_user_id = @user_id, to_user_id, from_user_id) as friend_id FROM friend_requests
			WHERE request_type = (SELECT id FROM friend_requests_types WHERE `name` = 'accepted')
				AND (from_user_id = @user_id OR to_user_id = @user_id))
)
GROUP BY mes_friend_id;

-- Ответ: в текущем запросе друг с id = 2

/* 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. */

-- DROP VIEW IF EXISTS youngest_users;
CREATE OR REPLACE VIEW youngest_users AS
SELECT * FROM `profiles`
ORDER BY birthday DESC LIMIT 10;

SELECT COUNT(*)
FROM posts_likes
WHERE (SELECT user_id FROM posts WHERE id = posts_likes.post_id) IN (SELECT user_id FROM youngest_users);

/* 4. Определить кто больше поставил лайков (всего) - мужчины или женщины? */

SELECT (SELECT gender FROM `profiles` WHERE user_id = posts_likes.user_id) as gender, COUNT(*)
FROM posts_likes
GROUP BY gender;

-- Ответ: женщины

/* 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.  */

SELECT user_id, COUNT(*) FROM
(SELECT from_user_id as user_id FROM messages
UNION ALL
SELECT user_id FROM posts
UNION ALL
SELECT user_id FROM posts_likes
UNION ALL
SELECT user_id FROM communities_users) t
GROUP BY user_id
ORDER BY COUNT(*)
LIMIT 10;