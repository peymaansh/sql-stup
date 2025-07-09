# MySQL Master-Slave Replication Setup

This project sets up a MySQL master and slave replication on a single Ubuntu 22.04 server.

## Files

- `setup_master.sh`: Installs and configures a MySQL master server.
- `setup_slave.sh`: Creates and configures a second MySQL instance as a replication slave.

## Usage

1. Run the master setup script:
   ```bash
   sudo bash setup_master.sh
   ```

2. Run the slave setup script:
   ```bash
   sudo bash setup_slave.sh
   ```

3. Manually execute on slave (replace with your master log file and position):
   ```sql
   CHANGE MASTER TO
     MASTER_HOST='127.0.0.1',
     MASTER_USER='replica_user',
     MASTER_PASSWORD='Peyman021peyman',
     MASTER_PORT=3306,
     MASTER_LOG_FILE='mysql-bin.000001',
     MASTER_LOG_POS=157;

   START SLAVE;
   ```

## Notes

- Master runs on port `3306`
- Slave runs on port `3307`
