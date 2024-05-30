DELIMITER $$

DROP PROCEDURE IF EXISTS `generate_sql_fact`$$
CREATE PROCEDURE `generate_sql_fact` ()
BEGIN
    INSERT INTO `resp_headers` VALUES ('X-SQL-Fact', (SELECT `fact` FROM `sql_facts` ORDER BY RAND() LIMIT 1));
END$$

DROP PROCEDURE IF EXISTS `app`$$
CREATE PROCEDURE `app` (IN `route` VARCHAR(255), IN `params` TEXT, IN `post_data` TEXT, OUT `status` TEXT, OUT `resp` LONGBLOB)
BEGIN
    DECLARE req_cookies TEXT;
    DECLARE status_code INT;

    SET SESSION group_concat_max_len = 131072;

    CREATE TEMPORARY TABLE `resp_headers` (`name` VARCHAR(255), `value` TEXT);
    INSERT INTO `resp_headers` VALUES ('Server', 'WTF.SQL');
    CALL generate_sql_fact();

    CREATE TEMPORARY TABLE `resp_cookies` (`name` VARCHAR(255) PRIMARY KEY, `value` TEXT);

    CREATE TEMPORARY TABLE `query_params` (`name` VARCHAR(255) PRIMARY KEY, `value` TEXT);
    CALL parse_params(params);
    CALL parse_params(post_data);

    CREATE TEMPORARY TABLE `cookies` (`name` VARCHAR(255) PRIMARY KEY, `value` BLOB);
    IF EXISTS(SELECT 1 FROM `headers` WHERE `name` = 'COOKIE') THEN
        SET req_cookies = (SELECT `value` FROM `headers` WHERE `name` = 'COOKIE');
        CALL parse_cookies(req_cookies);
    END IF;
    
    IF EXISTS(SELECT 1 FROM `routes` WHERE route LIKE `match`) THEN
        SET @stmt = (SELECT CONCAT('CALL ', `proc`, '(?, ?, ?)') FROM `routes` WHERE route LIKE `match` LIMIT 1);
        PREPARE handler_call FROM @stmt;
        
        SET @route = route;
        EXECUTE handler_call USING @route, @proc_status, @proc_resp;
        
        SET status_code = @proc_status;
        SET resp = @proc_resp;
    ELSE
        SET status_code = 404;
        SET resp = 'Route not found.';
    END IF;
    
    INSERT INTO `resp_headers` SELECT 'Set-Cookie', COALESCE(CONCAT(`name`, '=', `value`), '') FROM `resp_cookies`;

    INSERT INTO `responses` (route, code) VALUES (route, status_code);

    SET status = (SELECT `message` FROM `status_strings` WHERE `code` = status_code);
END$$

DELIMITER ;
