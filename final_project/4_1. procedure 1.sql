USE mmorpg_db;

/* Процедура, которая перемещает старые сообщения из чата (начиная с указанной даты) в архив */

DELIMITER //

DROP PROCEDURE IF EXISTS archive_old_chat_messages;
CREATE PROCEDURE archive_old_chat_messages(
    start_date_time DATETIME
)
BEGIN
    START TRANSACTION;

    INSERT INTO archive_global_chat (message_id, from_character_id, message, created_at)
    SELECT id,
           from_character_id,
           message,
           created_at
    FROM global_chat
    WHERE created_at <= start_date_time;

	SET SQL_SAFE_UPDATES = 0;
    DELETE FROM global_chat
    WHERE created_at <= start_date_time;
    SET SQL_SAFE_UPDATES = 1;

    COMMIT;
END;