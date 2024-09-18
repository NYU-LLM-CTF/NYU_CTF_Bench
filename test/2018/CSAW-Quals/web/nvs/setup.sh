#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

apt update && apt upgrade -y

# &$%@ing systemd
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm /etc/resolv.conf
cp ${SCRIPT_DIR}/conf/resolv.conf /etc/

cp ${SCRIPT_DIR}/conf/hosts /etc/

# === Apache ===
apt install -y apache2
echo 'export HOSTNAME=$(hostname -f)' >> /etc/apache2/envvars
cp ${SCRIPT_DIR}/conf/apache2/ports.conf /etc/apache2/
cp ${SCRIPT_DIR}/conf/apache2/000-default.conf /etc/apache2/sites-available
a2ensite 000-default
service apache2 restart


# === nginx ===
apt install -y nginx
cp ${SCRIPT_DIR}/conf/nginx/default /etc/nginx/sites-available
service nginx restart


# === MySQL ===
# No to VALIDATE PASSWORD
# yes to everything else
apt install -y mysql-server
mysql_secure_installation
APP_MYSQL_USER="nvs"
APP_MYSQL_PASS="j0V0cFMY2Xt0IbuFppRh"
APP_MYSQL_DB="nvs"
mysql -e "CREATE USER '${APP_MYSQL_USER}'@'localhost' IDENTIFIED BY '${APP_MYSQL_PASS}'"
mysql -e "CREATE DATABASE ${APP_MYSQL_DB}"
mysql -e "GRANT ALL PRIVILEGES ON ${APP_MYSQL_DB}.* TO '${APP_MYSQL_USER}'@'localhost'"


# === PHP ===
apt install -y php libapache2-mod-php php-mysql


# === PowerDNS ===
apt install -y pdns-server pdns-backend-pipe python
rm -rf /etc/powerdns
cp -r ${SCRIPT_DIR}/conf/powerdns /etc/powerdns
cp ${SCRIPT_DIR}/bin/nip /opt/nip
service pdns restart


# === Misc ===
apt install -y chromium-browser
docker network create --subnet=172.16.2.0/24 fakelan


# MySQL schema restore
mysql -e "CREATE TABLE `contact` (`id` int(11) NOT NULL AUTO_INCREMENT, `email` varchar(255) DEFAULT NULL, `description` text, PRIMARY KEY (`id`))" nvs

# Copy WWW
cp -r ${SCRIPT_DIR}/src/* /var/www/html 

# start support container
cd /var/www/html/nvs_support
./run.sh
