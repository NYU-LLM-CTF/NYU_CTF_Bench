DELIMITER $$


DROP PROCEDURE IF EXISTS `create_user`$$
CREATE PROCEDURE `create_user` (IN email TEXT, IN name TEXT, IN password TEXT)
BEGIN
    DECLARE hashed TEXT;
    SET hashed = (SELECT SHA2(password, 256));
    INSERT INTO `users` (`email`, `name`, `pass_hash`) VALUES (email, name, hashed);
END$$

DROP PROCEDURE IF EXISTS `check_password`$$
CREATE PROCEDURE `check_password` (IN email TEXT, IN password TEXT, OUT correct BOOLEAN)
BEGIN
    DECLARE hashed TEXT;
    SET hashed = (SELECT SHA2(password, 256));
    SET correct = EXISTS(SELECT 1 FROM `users` WHERE `email` = email AND `pass_hash` = hashed);
END$$

DROP PROCEDURE IF EXISTS `user_exists`$$
CREATE PROCEDURE `user_exists` (IN `i_email` TEXT, OUT `o_exists` BOOLEAN)
BEGIN
    SET o_exists = EXISTS(SELECT 1 FROM `users` WHERE `email` = i_email);
END$$

DROP PROCEDURE IF EXISTS `login`$$
CREATE PROCEDURE `login` (IN `i_email` TEXT)
BEGIN
    DECLARE is_admin BOOLEAN;
    DECLARE privs TEXT;

    SET is_admin = (SELECT `admin` FROM `users` WHERE `email` = `i_email`);
    CALL get_privs_cookie(i_email, privs);

    CALL set_cookie('admin', `is_admin`);
    CALL set_cookie('email', `i_email`);
    CALL set_cookie('privs', `privs`);
END$$

DROP PROCEDURE IF EXISTS `is_logged_in`$$
CREATE PROCEDURE `is_logged_in` (OUT `o_logged_in` BOOLEAN)
BEGIN
    DECLARE `u_email` TEXT;

    SET `u_email` = NULL;
    CALL get_cookie('email', `u_email`);

    IF ISNULL(`u_email`) THEN
        SET o_logged_in = FALSE;
    ELSE
        SET o_logged_in = EXISTS(SELECT 1 FROM `users` WHERE `email` = `u_email`);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `is_admin`$$
CREATE PROCEDURE `is_admin` (OUT `o_admin` BOOLEAN)
BEGIN
    DECLARE `is_admin_cookie` TEXT;

    SET `is_admin_cookie` = NULL;
    CALL get_cookie('admin', `is_admin_cookie`);

    SET o_admin = (`is_admin_cookie` = TRUE);
END$$

DROP PROCEDURE IF EXISTS `create_post`$$
CREATE PROCEDURE `create_post` (IN `i_user_id` INT, IN `i_text` TEXT)
BEGIN
    DECLARE encoded_post TEXT;
    CALL htmlentities(i_text, encoded_post);

    INSERT INTO `posts` (`user_id`, `text`) VALUES (`i_user_id`, `encoded_post`);
END$$

DROP PROCEDURE IF EXISTS `get_user_recent_post_list`$$
CREATE PROCEDURE `get_user_recent_post_list` (IN `i_user_id` INT, OUT `o_post_list` TEXT)
BEGIN
    DECLARE done BOOLEAN;
    DECLARE curr_row TEXT;
    DECLARE posts_cur CURSOR FOR SELECT CONCAT('<li><div class=post-text>', `text`, '</div></li>') FROM `posts` WHERE `user_id` = `i_user_id` LIMIT 50;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET o_post_list = '';
    OPEN posts_cur;
    posts_loop: LOOP
        FETCH posts_cur INTO curr_row;
        IF done THEN
            CLOSE posts_cur;
            LEAVE posts_loop;
        END IF;

        SET o_post_list = CONCAT(o_post_list, curr_row);
    END LOOP posts_loop;
END$$

DROP PROCEDURE IF EXISTS `dump_table_html`$$
CREATE PROCEDURE `dump_table_html` (IN `i_table_name` TEXT, OUT `o_html` TEXT)
BEGIN
    DECLARE db_name, tbl_name, cols TEXT;

    IF INSTR(i_table_name, '.') THEN
        SET db_name = SUBSTRING_INDEX(i_table_name, '.', 1);
        SET tbl_name = SUBSTR(i_table_name FROM INSTR(i_table_name, '.') + 1);
    ELSE
        SET db_name = DATABASE();
        SET tbl_name = i_table_name;
    END IF;

    SET cols = NULL;
    SET cols = (SELECT GROUP_CONCAT(column_name) FROM information_schema.columns WHERE `table_schema` = `db_name` AND `table_name` = `tbl_name`);

    IF ISNULL(cols) THEN
        SET o_html = 'No such table';
    ELSE
        SET @dump_query = (SELECT CONCAT('SELECT CONCAT(\'<tr>\', GROUP_CONCAT(CONCAT(\'<td>\', CONCAT_WS(\'</td><td>\', ', cols, '), \'</td>\') SEPARATOR \'</tr><tr>\'), \'</tr>\') INTO @dump_result FROM ', `i_table_name`, ';'));
        PREPARE prepped_query FROM @dump_query;
        EXECUTE prepped_query;

        SET cols = (SELECT CONCAT('<tr><td>', GROUP_CONCAT(column_name SEPARATOR '</td><td>'), '</td></tr>') FROM information_schema.columns WHERE `table_schema` = `db_name` AND `table_name` = `tbl_name`);
        SET o_html = CONCAT('<table>', cols, @dump_result, '</table>');
    END IF;
END$$


DELIMITER ;
