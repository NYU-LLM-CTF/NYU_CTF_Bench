-- Routes

INSERT INTO `routes` VALUES
    ('/', 'index_handler'),
    ('/robots.txt', 'robots_txt_handler'),
    ('/verify', 'verify_handler'),
    ('/static/%', 'static_handler'),
    -- ('/reflect', 'reflect_handler'),
    -- ('/template_demo', 'template_demo_handler'),
    ('/login', 'login_handler'),
    ('/register', 'register_handler'),
    ('/post', 'post_handler'),
    ('/admin', 'admin_handler');

DELIMITER $$

DROP PROCEDURE IF EXISTS `static_handler`$$
CREATE PROCEDURE `static_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` LONGBLOB)
BEGIN
    IF EXISTS(SELECT 1 FROM `static_assets` WHERE `path` = route) THEN
        SET status = 200;
        SET resp = (SELECT `data` FROM `static_assets` WHERE `path` = route);
    ELSE
        SET status = 404;
        SET resp = 'Static file not found.';
    END IF;
END$$

DROP PROCEDURE IF EXISTS `index_handler`$$
CREATE PROCEDURE `index_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE logged_in BOOLEAN;

    CALL is_logged_in(logged_in);
    if logged_in THEN
        CALL logged_in_index_handler(status, resp);
    ELSE
        SET resp = 'redirecting to register...';
        CALL redirect('/register', status);
    END IF;
END$$


DROP PROCEDURE IF EXISTS `robots_txt_handler`$$
CREATE PROCEDURE `robots_txt_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    SET status = 200;
    SET resp = CONCAT('User-agent: *\n', (SELECT GROUP_CONCAT(CONCAT('Disallow: ', `match`, ' # procedure:', proc) SEPARATOR '\n') FROM `routes`), '\n\n# Yeah, we know this is contrived :(');
END$$


DROP PROCEDURE IF EXISTS `verify_handler`$$
CREATE PROCEDURE `verify_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE proc TEXT;

    SET proc = NULL;
    CALL get_param('proc', proc);

    SET status = 200;
    IF ISNULL(proc) THEN
        SET resp = 'Missing required param \'proc\'!';
    ELSE
        SET resp = COALESCE((SELECT routine_definition FROM information_schema.routines WHERE routine_name = proc), 'No such procedure!');
    END IF;
END$$


DROP PROCEDURE IF EXISTS `logged_in_index_handler`$$
CREATE PROCEDURE `logged_in_index_handler` (OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE u_email TEXT;
    DECLARE user_id INT;
    DECLARE user_name TEXT;
    DECLARE post_list TEXT;
    DECLARE u_id INT;

    CALL get_cookie('email', u_email);
    SET user_id = (SELECT `id` FROM `users` WHERE `email` = u_email);
    SET user_name = (SELECT `name` FROM `users` WHERE `email` = u_email);

    CALL get_user_recent_post_list(user_id, post_list);
    CALL set_template_var('post_list', post_list);
    CALL set_template_var('user_name', user_name);
    
    SET status = 200;
    CALL template('/templates/index_logged_in.html', resp);
END$$

    
DROP PROCEDURE IF EXISTS `reflect_handler`$$
CREATE PROCEDURE `reflect_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE tmp TEXT;
    SET status = 200;
    
    SET resp = 'Query params: \n';
    SET tmp = (SELECT GROUP_CONCAT(CONCAT(`name`, ': ', `value`) SEPARATOR '\n') FROM `query_params`);
    SET resp = CONCAT(resp, COALESCE(tmp, ''));
    
    SET resp = CONCAT(resp, '\n\nHeaders:\n');
    SET tmp = (SELECT GROUP_CONCAT(CONCAT(`name`, ': ', `value`) SEPARATOR '\n') FROM `headers`);
    SET resp = CONCAT(resp, COALESCE(tmp, ''));
    
    SET resp = CONCAT(resp, '\n\nCookies:\n');
    SET tmp = (SELECT GROUP_CONCAT(CONCAT(`name`, ': ', `value`) SEPARATOR '\n') FROM `cookies`);
    SET resp = CONCAT(resp, COALESCE(tmp, ''));

    CALL set_cookie('an_cookie', 'an_value');
    CALL set_header('X-Custom-Header', 'custom_header_value');
END$$


DROP PROCEDURE IF EXISTS `template_demo_handler`$$
CREATE PROCEDURE `template_demo_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    SET status = 200;

    CALL template('/templates/asdf.html', resp);
END$$


DROP PROCEDURE IF EXISTS `login_handler`$$
CREATE PROCEDURE `login_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE email, password TEXT;
    DECLARE auth BOOLEAN;
    
    SET `email` = NULL;
    SET `password` = NULL;

    CALL get_param('email', `email`);
    CALL get_param('password', `password`);

    IF ISNULL(`email`) OR ISNULL(`password`) THEN
        SET status = 200;
        CALL template('/templates/login.html', resp);
    ELSE
        CALL check_password(`email`, `password`, `auth`);
        IF auth THEN
            SET resp = CONCAT(`email`, ', ', `password`);
            CALL login(`email`);
            CALL redirect('/', status);
        ELSE
            SET status = 401;
            
            CALL set_template_var('error_msg', 'Email or password is incorrect.');
            CALL template('/templates/404.html', resp);
        END IF;
    END IF;
END$$


DROP PROCEDURE IF EXISTS `register_handler`$$
CREATE PROCEDURE `register_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE name, email, password TEXT;
    DECLARE already_exists BOOLEAN;

    SET `name` = NULL;
    SET `email` = NULL;
    SET `password` = NULL;

    CALL get_param('name', `name`);
    CALL get_param('email', `email`);
    CALL get_param('password', `password`);

    CALL user_exists(email, already_exists);
    IF ISNULL(`name`) OR ISNULL(`email`) OR ISNULL(`password`) THEN
        SET status = 200;
        CALL set_template_var('error_msg', '');
        CALL template('/templates/register.html', resp);
    ELSEIF already_exists THEN
        SET status = 200;
        CALL set_template_var('error_msg', 'User already exists. <a href=/register>Go Back</a>');
        CALL template('/templates/register.html', resp);
    ELSE
        SET resp = 'Registered!!!!';
        CALL create_user(`email`, `name`, `password`);
        CALL login(`email`);
        CALL redirect('/', status);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `post_handler`$$
CREATE PROCEDURE `post_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE logged_in BOOLEAN;
    DECLARE u_email TEXT;
    DECLARE user_id INT;
    DECLARE post_text TEXT;

    SET resp = '';

    CALL is_logged_in(logged_in);
    IF logged_in THEN
        CALL get_cookie('email', u_email);
        CALL get_param('post', post_text);
        SET user_id = (SELECT `id` FROM `users` WHERE `email` = u_email);

        IF EXISTS (SELECT 1 FROM `banned_post_patterns` WHERE `post_text` REGEXP `pattern`) THEN
            SET status = 200;
            SET resp = 'Banned word used in post!';
        ELSE
            CALL create_post(user_id, post_text);
            CALL redirect('/', status);
        END IF;

    ELSE
        CALL redirect('/login', status);
    END IF;
END$$



DROP PROCEDURE IF EXISTS `admin_handler`$$
CREATE PROCEDURE `admin_handler` (IN `route` VARCHAR(255), OUT `status` INT, OUT `resp` TEXT)
BEGIN
    DECLARE u_email, table_name, rendered_table, html TEXT;
    DECLARE admin, can_view_panels, can_create_panels  BOOL;

    DECLARE done BOOLEAN;
    DECLARE panel_cur CURSOR FOR SELECT `tbl` FROM `panels` WHERE `email` = `u_email`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CALL is_admin(admin);

    IF admin THEN
        CALL get_cookie('email', u_email);

        CALL has_priv('panel_view', can_view_panels);
        CALL has_priv('panel_create', can_create_panels);

        SET html = '';
        SET rendered_table = '';

        IF can_create_panels THEN
            CALL get_param('tbl', table_name);

            IF table_name <> '' THEN
                INSERT INTO `panels` VALUES (`u_email`, `table_name`);
            END IF;

            CALL template('/templates/admin_create_panel_partial.html', rendered_table);
            SET html = CONCAT(html, rendered_table);
        END IF;

        SET rendered_table = '';
        IF can_view_panels THEN
            OPEN panel_cur;
            panels_loop: LOOP
                FETCH panel_cur INTO table_name;
                IF done THEN
                    CLOSE panel_cur;
                    LEAVE panels_loop;
                END IF;

                CALL dump_table_html(table_name, rendered_table);

                SET html = CONCAT(html, rendered_table, '<br/>');
            END LOOP panels_loop;
        END IF;

        DROP TEMPORARY TABLE IF EXISTS `template_vars`;
        CREATE TEMPORARY TABLE IF NOT EXISTS `template_vars` (`name` VARCHAR(255) PRIMARY KEY, `value` TEXT);
        INSERT INTO `template_vars` VALUES ('tables', html);

        SET status = 200;
        CALL template('/templates/admin.html', resp);
    ELSE
        SET status = 403;
        SET resp = 'You must be an admin to view this page.';
    END IF;
END$$


DELIMITER ;
