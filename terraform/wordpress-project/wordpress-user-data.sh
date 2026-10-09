#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

DB_NAME="wordpress"
DB_USER="wordpress"

apt-get update -y

apt-get install -y \
  snapd \
  apache2 \
  mariadb-server \
  php \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-xmlrpc \
  php-soap \
  php-intl \
  php-zip \
  wget \
  unzip \
  curl \
  jq \
  openssl


# install aws cli v2
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

  snap install amazon-ssm-agent --classic
systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service

systemctl enable --now apache2
systemctl enable --now mariadb

# Generate a random database password at instance startup.
DB_PASSWORD="$(openssl rand -hex 24)"

# Create the WordPress database and database user.
mysql <<MYSQL
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL

# Store the database credentials in AWS Secrets Manager.
SECRET_JSON="$(jq -n \
  --arg username "$DB_USER" \
  --arg password "$DB_PASSWORD" \
  --arg database "$DB_NAME" \
  --arg host "localhost" \
  '{
    username: $username,
    password: $password,
    database: $database,
    host: $host
  }')"

aws secretsmanager put-secret-value \
  --region "${aws_region}" \
  --secret-id "${db_secret_arn}" \
  --secret-string "$SECRET_JSON"

# Download and install WordPress.
cd /tmp

wget -q https://wordpress.org/latest.tar.gz

rm -rf wordpress

tar -xzf latest.tar.gz

rm -f /var/www/html/index.html

cp -R wordpress/* /var/www/html/

# Create WordPress configuration.
cd /var/www/html

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php

# Generate WordPress security salts.
curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-salts

python3 - <<'PY'
from pathlib import Path

config = Path("/var/www/html/wp-config.php")
salts = Path("/tmp/wp-salts").read_text()

text = config.read_text()

start_marker = "define( 'AUTH_KEY'"
end_marker = "define( 'NONCE_SALT'"

start = text.index(start_marker)
end = text.index(end_marker)

end_line = text.index("\n", end)

text = text[:start] + salts + text[end_line + 1:]

config.write_text(text)
PY

# Configure Apache for WordPress.
a2enmod rewrite

chown -R www-data:www-data /var/www/html

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

systemctl restart apache2