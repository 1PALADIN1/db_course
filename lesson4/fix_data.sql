-- Написать запрос для переименования названий типов медиа (колонка name в media_types), которые вы получили в пункте 3 в image, audio, video, document.
UPDATE vk.media_types
SET name = "image"
WHERE id = 1;

UPDATE vk.media_types
SET name = "audio"
WHERE id = 2;

UPDATE vk.media_types
SET name = "video"
WHERE id = 3;

UPDATE vk.media_types
SET name = "document"
WHERE id = 4;

-- Написать запрос, удаляющий заявки в друзья самому себе.
SET SQL_SAFE_UPDATES = 0;

DELETE FROM vk.friend_requests
WHERE from_user_id = to_user_id;

SET SQL_SAFE_UPDATES = 1;
