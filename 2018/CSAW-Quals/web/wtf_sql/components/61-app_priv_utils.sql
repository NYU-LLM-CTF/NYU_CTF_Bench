DELIMITER $$

DROP PROCEDURE IF EXISTS `get_privs_cookie`$$
CREATE PROCEDURE `get_privs_cookie` (IN `i_email` TEXT, OUT `signed_privs` TEXT)
BEGIN
    DECLARE privs, signing_key TEXT;

    SET privs = COALESCE((SELECT GROUP_CONCAT(priv SEPARATOR ';') FROM `admin_privs` WHERE `email` = i_email), '');

    SET signing_key = (SELECT `value` FROM `priv_config` WHERE `name` = 'signing_key');

    SET signed_privs = CONCAT(MD5(CONCAT(signing_key, privs)), privs);
END$$

DROP PROCEDURE IF EXISTS `has_priv`$$
CREATE PROCEDURE `has_priv` (IN `i_priv` TEXT, OUT `o_has_priv` BOOLEAN)
BEGIN
    DECLARE privs, cur_privs, cmp_priv BLOB;
    DECLARE hash, signing_key TEXT;

    SET o_has_priv = FALSE;

    SET privs = NULL;
    CALL get_cookie('privs', privs);

    IF NOT ISNULL(privs) THEN
        SET hash = SUBSTR(privs FROM 1 FOR 32);
        SET cur_privs = SUBSTR(privs FROM 33);
        SET signing_key = (SELECT `value` FROM `priv_config` WHERE `name` = 'signing_key');

        IF hash = MD5(CONCAT(signing_key, cur_privs)) THEN
            WHILE ( LENGTH(cur_privs) > 0 ) DO
                SET cmp_priv = SUBSTRING_INDEX(cur_privs, ';', 1);
                IF cmp_priv = i_priv THEN
                    SET o_has_priv = TRUE;
                END IF;
                SET cur_privs = SUBSTR(cur_privs FROM LENGTH(cmp_priv) + 2);
            END WHILE;
        END IF;
    END IF;
END$$

DELIMITER ;
