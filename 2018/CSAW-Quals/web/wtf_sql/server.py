import pymysql

def application(environ, start_response):
    conn = pymysql.connect("localhost", "app_sql", "app_sql", "app_sql")
    with conn.cursor() as cursor:
        post_data = ''
        if environ.get("REQUEST_METHOD") == "POST":
            try:
                request_body_size = int(environ.get('CONTENT_LENGTH', 0))
            except (ValueError):
                request_body_size = 0
            post_data = environ['wsgi.input'].read(request_body_size)

        headers = {k[5:]: v for (k, v) in environ.items() if k.startswith("HTTP_")}
        cursor.execute(
            "CREATE TEMPORARY TABLE IF NOT EXISTS `headers` (`name` VARCHAR(255) PRIMARY KEY, `value` VARCHAR(4095))"
        )

        for k, v in headers.items():
            cursor.execute(
                "INSERT INTO `headers` VALUES (%s, %s) ON DUPLICATE KEY UPDATE `value` = %s",
                (k, v, v),
            )

        app_args = [environ["PATH_INFO"], environ["QUERY_STRING"], post_data, None, None]

        try:
            cursor.callproc("app", app_args)
        except pymysql.Error as e:
            print(e)
            start_response("500 Internal Server Error", [("Content-Type", "text/html")])
            return b"Somethin dun broke"

        cursor.execute("SELECT @_app_3, @_app_4")
        status, resp = cursor.fetchone()
        cursor.execute("SELECT `name`, `value` FROM `resp_headers`")
        headers = list(cursor.fetchall())

        conn.commit()

        start_response(status, headers)
        return resp
