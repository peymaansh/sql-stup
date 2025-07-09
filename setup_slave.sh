#!/bin/bash
set -e

echo "[+] Creating directories for slave instance..."
mkdir -p /etc/mysql-slave /var/lib/mysql-slave /var/log/mysql-slave
chown -R mysql:mysql /var/lib/mysql-slave /var/log/mysql-slave

echo "[+] Creating slave config..."
cat <<EOF > /etc/mysql-slave/my.cnf
[mysqld]
server-id = 2
port = 3307
datadir = /var/lib/mysql-slave
socket = /var/run/mysqld/mysqld_slave.sock
pid-file = /run/mysqld/mysqld-slave.pid
log-bin = mysql-bin
relay-log = relay-log
binlog_do_db = exampledb
log_error = /var/log/mysql-slave-error.log
bind-address = 0.0.0.0
EOF

echo "[+] Initializing slave data directory..."
mysqld --defaults-file=/etc/mysql-slave/my.cnf --initialize-insecure --user=mysql

echo "[+] Creating systemd service for slave..."
cat <<EOF > /etc/systemd/system/mysql-slave.service
[Unit]
Description=MySQL Slave Instance
After=network.target

[Service]
User=mysql
Group=mysql
ExecStart=/usr/sbin/mysqld --defaults-file=/etc/mysql-slave/my.cnf
LimitNOFILE=5000

[Install]
WantedBy=multi-user.target
EOF

echo "[+] Starting slave service..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable mysql-slave
systemctl start mysql-slave

echo "[+] Slave setup completed. Run CHANGE MASTER TO manually with MASTER_LOG_FILE and MASTER_LOG_POS."
