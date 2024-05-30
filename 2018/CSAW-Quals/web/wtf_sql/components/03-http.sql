-- HTTP Core (parsers, cookie handling, etc.)

DELIMITER $$


DROP PROCEDURE IF EXISTS `urldecode`$$
CREATE PROCEDURE `urldecode` (IN `i_str` TEXT, OUT `o_str` TEXT)
BEGIN
    DECLARE decoded TEXT;
    DECLARE hex CHAR(2);

    SET decoded = i_str;

    WHILE (INSTR(decoded, '%') > 0) DO
        SET hex = SUBSTR(decoded FROM INSTR(decoded, '%') + 1 FOR 2);
        SET decoded = CONCAT(SUBSTR(decoded FROM 1 FOR INSTR(decoded, '%') - 1), UNHEX(hex), SUBSTR(decoded FROM INSTR(decoded, '%') + 3));
    END WHILE;

    SET o_str = decoded;
END$$


DROP PROCEDURE IF EXISTS `htmlentities`$$
CREATE PROCEDURE `htmlentities` (IN `i_str` TEXT, OUT `o_str` TEXT)
BEGIN
    SET o_str = REPLACE(REPLACE(i_str, '<', '&lt;'), '>', '&gt;');
END$$




DROP PROCEDURE IF EXISTS `sign_cookie`$$
CREATE PROCEDURE `sign_cookie` (IN `cookie_value` TEXT, OUT `signed` TEXT)
BEGIN
    DECLARE secret, signature TEXT;
    SET secret = (SELECT `value` FROM `config` WHERE `name` = 'signing_key');

    SET signature = SHA2(CONCAT(cookie_value, secret), 256);

    SET signed = CONCAT(signature, LOWER(HEX(cookie_value)));
END$$


DROP PROCEDURE IF EXISTS `verify_cookie`$$
CREATE PROCEDURE `verify_cookie` (IN `signed_value` TEXT, OUT `cookie_value` BLOB , OUT `valid` BOOLEAN)
BEGIN
    DECLARE secret, signature TEXT;
    SET secret = (SELECT `value` FROM `config` WHERE `name` = 'signing_key');
    
    SET signature = SUBSTR(signed_value FROM 1 FOR 64);
    SET cookie_value = UNHEX(SUBSTR(signed_value FROM 65));

    SET valid = (SELECT SHA2(CONCAT(cookie_value, secret), 256) = signature);
END$$


DROP PROCEDURE IF EXISTS `parse_cookies`$$
CREATE PROCEDURE `parse_cookies` (IN `cookies` TEXT)
BEGIN
    -- Parse cookies in the form a=b; b=c; c=d;
    DECLARE cookie_value BLOB;
    DECLARE cur_cookies, cookie, cookie_name, cookie_value_and_sig TEXT;
    DECLARE cookie_valid BOOLEAN;

    SET cur_cookies = cookies;

    WHILE ( INSTR(cur_cookies, '=') > 0 ) DO
        SET cookie = SUBSTRING_INDEX(cur_cookies, ';', 1);
        
        SET cookie_name = TRIM(SUBSTRING(cookie FROM 1 FOR INSTR(cookie, '=') - 1));
        SET cookie_value_and_sig = TRIM(SUBSTRING(cookie FROM INSTR(cookie, '=') + 1));

        CALL verify_cookie(cookie_value_and_sig, cookie_value, cookie_valid);

        IF cookie_valid THEN
            INSERT INTO `cookies` VALUES (cookie_name, cookie_value) ON DUPLICATE KEY UPDATE `value` = cookie_value;
        END IF;

        -- + 2 because the mysql is 1-indexed and because this needs to pass the ';'
        -- Also TRIM to remove the optional space after the semicolon
        SET cur_cookies = TRIM(SUBSTRING(cur_cookies FROM LENGTH(cookie) + 2));
    END WHILE;
END$$


DROP PROCEDURE IF EXISTS `set_cookie`$$
CREATE PROCEDURE `set_cookie` (IN `i_name` VARCHAR(255), IN `i_value` TEXT)
BEGIN
    DECLARE signed_value TEXT;
    CALL sign_cookie(i_value, signed_value);

    INSERT INTO `resp_cookies` VALUES (i_name, signed_value) ON DUPLICATE KEY UPDATE `value` = signed_value;
END$$


DROP PROCEDURE IF EXISTS `get_cookie`$$
CREATE PROCEDURE `get_cookie` (IN `i_name` TEXT, OUT `o_value` BLOB)
BEGIN
    IF EXISTS(SELECT 1 FROM `cookies` WHERE `name` = `i_name`) THEN
        SET `o_value` = (SELECT `value` FROM `cookies` WHERE `name` = `i_name` LIMIT 1);
    ELSE
        SET `o_value` = NULL;
    END IF;
END$$




DROP PROCEDURE IF EXISTS `parse_params`$$
CREATE PROCEDURE `parse_params` (IN `params` TEXT)
BEGIN
    -- Parse URL params of the form a=b&b=c&c=d
    DECLARE cur_params, param, encoded_param_name, param_name, encoded_param_value, param_value TEXT;
    SET cur_params = params;

    WHILE ( INSTR(cur_params, '=') > 0 ) DO 
        SET param = SUBSTRING_INDEX(cur_params, '&', 1);

        SET encoded_param_name = TRIM(SUBSTRING(param FROM 1 FOR INSTR(param, '=') - 1));
        SET encoded_param_value = TRIM(SUBSTRING(param FROM INSTR(param, '=') + 1));

        SET encoded_param_name = REPLACE(encoded_param_name, '+', ' ');
        SET encoded_param_value = REPLACE(encoded_param_value, '+', ' ');

        CALL urldecode(encoded_param_name, param_name);
        CALL urldecode(encoded_param_value, param_value);

        INSERT INTO `query_params` VALUES (param_name, param_value) ON DUPLICATE KEY UPDATE `value` = param_value;

        SET cur_params = SUBSTRING(cur_params FROM LENGTH(param) + 2);
    END WHILE;
END$$


DROP PROCEDURE IF EXISTS `get_param`$$
CREATE PROCEDURE `get_param` (IN `i_name` TEXT, OUT `o_value` TEXT)
BEGIN
    IF EXISTS(SELECT 1 FROM `query_params` WHERE `name` = i_name) THEN
        SET o_value = (SELECT `value` FROM `query_params` WHERE `name` = i_name LIMIT 1);
    END IF;
END$$




DROP PROCEDURE IF EXISTS `set_header`$$
CREATE PROCEDURE `set_header` (IN `name` VARCHAR(255), IN `value` TEXT)
BEGIN
    INSERT INTO `resp_headers` VALUES (`name`, `value`) ON DUPLICATE KEY UPDATE `value` = `value`;
END$$




DROP PROCEDURE IF EXISTS `redirect`$$
CREATE PROCEDURE `redirect` (IN `i_location` TEXT, OUT `o_status` INT)
BEGIN
    SET o_status = 302;
    CALL set_header('Location', i_location);
END$$


DELIMITER ;
