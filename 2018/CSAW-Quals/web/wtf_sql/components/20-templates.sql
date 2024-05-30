-- Template helpers

DELIMITER $$

DROP PROCEDURE IF EXISTS `populate_common_template_vars`$$
CREATE PROCEDURE `populate_common_template_vars` ()
BEGIN
    INSERT INTO `template_vars` SELECT CONCAT('config_', name), value FROM `config`;
    INSERT INTO `template_vars` SELECT CONCAT('request_', name), value FROM `query_params`;
END$$

DROP PROCEDURE IF EXISTS `set_template_var`$$
CREATE PROCEDURE `set_template_var` (IN `i_key` TEXT, IN `i_value` TEXT)
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS `template_vars` (`name` VARCHAR(255) PRIMARY KEY, `value` TEXT);
    INSERT INTO `template_vars` VALUES (`i_key`, `i_value`);
END$$


DROP PROCEDURE IF EXISTS `template_string`$$
CREATE PROCEDURE `template_string` (IN `template_s` TEXT, OUT `resp` TEXT)
BEGIN
    DECLARE formatted TEXT;
    DECLARE fmt_name, fmt_val TEXT;
    DECLARE replace_start, replace_end, i INT;

    SET @template_regex = '\\$\\{[a-zA-Z0-9_ ]+\\}';

    CREATE TEMPORARY TABLE IF NOT EXISTS `template_vars` (`name` VARCHAR(255) PRIMARY KEY, `value` TEXT);
    CALL populate_common_template_vars();

    SET formatted = template_s;
    SET i = 0;

    WHILE ( formatted REGEXP @template_regex AND i < 50 ) DO
        SET replace_start = REGEXP_INSTR(formatted, @template_regex, 1, 1, 0);
        SET replace_end = REGEXP_INSTR(formatted, @template_regex, 1, 1, 1);
        SET fmt_name = SUBSTR(formatted FROM replace_start + 2 FOR (replace_end - replace_start - 2 - 1));
        SET fmt_val = (SELECT `value` FROM `template_vars` WHERE `name` = TRIM(fmt_name));
        SET fmt_val = COALESCE(fmt_val, '');
        SET formatted = CONCAT(SUBSTR(formatted FROM 1 FOR replace_start - 1), fmt_val, SUBSTR(formatted FROM replace_end));
        SET i = i + 1;
    END WHILE;

    SET resp = formatted;

    DROP TEMPORARY TABLE `template_vars`;
END$$

DROP PROCEDURE IF EXISTS `template`$$
CREATE PROCEDURE `template` (IN `template_name` TEXT, OUT `resp` TEXT)
BEGIN
    DECLARE template_s TEXT;

    IF EXISTS(SELECT 1 FROM `templates` WHERE `path` = template_name) THEN
        SET template_s = (SELECT `data` FROM `templates` WHERE `path` = template_name LIMIT 1);
    ELSE
        SET template_s = CONCAT('ERROR: NO TEMPLATE FOUND WITH NAME: ', template_name);
    END IF;

    CALL template_string(template_s, resp);
END$$

DELIMITER ;
