#!/bin/bash

make app.sql
(docker exec -i wtf_sql '/bin/bash' '-c' 'mysql -uapp_sql -papp_sql app_sql') < ./app.sql
