USE mmorpg_db;

/* Функция, которая считает текущий уровень персонажа */

DELIMITER //

DROP FUNCTION IF EXISTS get_level;
CREATE FUNCTION get_level(
    character_id BIGINT UNSIGNED
)
RETURNS INT DETERMINISTIC
BEGIN
    SELECT MAX(cl.level) INTO @result FROM character_levels cl
        WHERE cl.exp <=
              (SELECT c.exp FROM characters c WHERE c.id = character_id)
            AND cl.race_id = (SELECT c.race_id FROM characters c WHERE c.id = character_id);

    IF @result IS NULL THEN
        RETURN 0;
    END IF;

    RETURN @result;
END;