#!/bin/bash

mysql -uroot -e "CREATE DATABASE cloudb"
mysql -uroot < /var/www/html/backups/db.sql.bak
mysql -uroot -e "USE cloudb; SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO'; DELETE FROM user; INSERT INTO user VALUES (0,'admin',SHA1('Pg8ARJOVj4XUm2nIW67d'))"
mysql -uroot -e "GRANT ALL ON 'cloudb'.'%' TO 'admin'@'localhost'"
mysql -uroot -e "USE cloudb; SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO'; INSERT INTO todo VALUES (NULL, 0, 'flag{d0nt_Forg3t_2_San1t1ze_Y0uR_C@11back$}', 0);"

rm /mysql-setup.sh
