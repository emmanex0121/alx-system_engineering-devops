# Mysql Master-Slave Database setup on web server
Setting up the web-01 and web-02 to have a master-slave database setup

## Installing MySql 5.7 distribution

copy the key at https://dev.mysql.com/doc/refman/5.7/en/checking-gpg-signature.html
save it in a file signature.key

```
sudo apt update
sudo apt-key add signature.key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C
sudo sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu bionic mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'

sudo apt-get update
sudo apt-cache policy mysql-server
sudo apt install -f -y mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
```

If you get this kind of error:

Package mysql-server-5.7 is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source
However the following packages replace it:
  mariadb-server-10.3

E: Package 'mysql-server-5.7' has no installation candidate


means:
 that the package mysql-server-5.7 is not available in your package repository.

Then you will have to use this command to fetch the repo and install it as well.

```
sudo wget -O mysql57 https://raw.githubusercontent.com/nuuxcode/alx-system_engineering-devops/master/scripts/mysql57 && sudo chmod +x mysql57 &&  sudo ./mysql57
```


## Creating a new user, setting a password and assigning the permision to check primary/replica status


`login to mysql with root using the password set at setup`
```
mysql -u root -p
```
`Creates user and assign a password`
```
CREATE USER 'user_name'@'host_name' IDENTIFIED BY 'password';
```
`Grants user permission to check primary/replica status of databases`
```
GRANT REPLICATION CLIENT ON *.* TO 'user_name'@'host_name';
```
`commit changes, apply and exit`
```
FLUSH PRIVILEGES;
```
```
exit
```
`Check status and priviledges of newly created user using the new user`
```
mysql -u user_name -p -e "SHOW GRANTS FOR 'user_name'@'localhost'"
```


`Common mysql commands`
```
SELECT User, Host FROM mysql.user;
SHOW DATABASES;
SHOW TABLES;
SELECT * FROM table_name;
```

```
CREATE DATABASE IF NOT EXIXTS database_name;
USE database_name;
```

`creates a table and adds two rows`
```
CREATE TABLE IF NOT EXISTS table_name (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
    );
```

`inserting using column list`
```
INSERT INTO table_name (name) VALUES ('Phoenix');
```
`inserting using column order and id position as defined in table`
```
INSERT INTO table_name VALUES (1, 'Phoenix');
```

`Grants SELECT privilege on table_name to specified user`
```
GRANT SELECT ON database_name.table_name TO 'user_name'@'host_name';
```
`Grants replica_user ability to duplicate primary MySQL server`
```
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
```

`allows holberton_user to view MySQL user table`
```
GRANT SELECT ON mysql.user TO 'holberton_user'@'localhost';
```
```
FLUSH PRIVILEGES;
exit
```




## CONFIGURING MYSQL Master-Slave on web-01 and web-02
- create a database on web-01 with root
- create user holberton_user on both servers with hostname 'localhost'
- set holberton_user permision to be able to check primary/replica status on my database
	```
	GRANT REPLICATION CLIENT ON *.* TO 'holberton_user'@'localhost'
	```
- create a table on database and populate it
- allow holberton_user SELECT privilege on table to be able to view table
	```
	GRANT SELECT ON database.table_name TO 'user_name'@'host_name';
	```
- Create a new user 'replica_user' with hostname '%'
- Grants replica_user ability to replicate primary MySQL server
	```
	GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
	```
- Grant holberton_user ability to view mysql.user table to view users and their permissions
	```
	GRANT SELECT ON mysql.user TO 'holberton_user'@'localhost';
	```

## Setting up the Master/Primary/web-01 - Slave/Replica/web-02
- ensure that UFW is allowing connections on port 3306(MySql port) on both servers
    ```
    sudo ufw allow 3306/tcp
    sud0 ufw status
    ```
- edit mysql config file
    sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
  - comment out the line "bind-address"
  - add this lines without the quotes:
    > "log_bin = /var/log/mysql/mysql-bin.log"

    > "server-id = 1"

    >  "binlog_do_db = tyrell_corp"
- restart mysql service
    ```
    sudo service mysql restart
    sudo service mysql status
    ```
- login MySql to retrieve binary log file name and position on web-01
    ```
    SHOW MASTER STATUS; # Which is file: mysql-bin.000002, position: 154
    ```

## login to web-02/replica server
- Open mysql config file
	```
	sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
	```
    - comment out "bind-address"
    - add lines:
        > "server-id = 2"
        > "relay-log = /var/log/mysql/mysql-relay-bin.log"
        > "log_bin = /var/log/mysql/mysql-bin.log"
        > "binlog_do_db = tyrell_corp"

        where tyrell_corp is the database_name
    - restart mysql service
	```
	sudo service mysql restart
	sudo service mysql status
	```
    - configure the replica master settings using values from web-01
        ```
	CHANGE MASTER TO MASTER_HOST='100.25.16.150', MASTER_USER='replica_user', MASTER_PASSWORD='1352', MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=154;
	```
        
        MASTER_HOST='web-01 ipaddress'
        MASTER_USER='replica_user' from web-01
        MASTER_PASSWORD='1352' replica_user password
        MASTER_LOG_FILE='master-status-file'
        MASTER_LOG_POS=master-status-position
    - start slave mysql
        ```
	START SLAVE;
	```
    - verify that slave is up and running
        ```
	SHOW SLAVE STATUS;
	```
        `OR`
	```
        SHOW SLAVE STATUS\G;
	```
    - confirm that `slave IO running` and `slave SQL running` is set to `yes`
    - restart mysql service
        ```
	sudo mysql service restart
        sudo mysql service status
	```

### Emmanuel Nwachukwu [<emmax0121@gmail.com>]
