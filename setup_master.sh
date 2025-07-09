#!/bin/bash
set -e

echo "[+] Installing MySQL server..."
apt update -qq && apt install -y mysql-server

echo "[+] Configuring MySQL master..."
sed -i '/\[mysqld\]/a server-id=1\nlog_bin=/var/log/mysql/mysql-bin.log\nbinlog_do_db=exampledb' /etc/mysql/mysql.conf.d/mysqld.cnf

echo "[+] Restarting MySQL..."
systemctl restart mysql

echo "[+] Setting root password and creating replication user..."
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Peyman021peyman';
CREATE USER IF NOT EXISTS 'replica_user'@'%' IDENTIFIED BY 'Peyman021peyman';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
FLUSH PRIVILEGES;
EOF

echo "[+] Master setup completed."
