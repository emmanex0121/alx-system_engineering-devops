# Mysql Master-Slave Database setup on server
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

`sudo wget -O mysql57 https://raw.githubusercontent.com/nuuxcode/alx-system_engineering-devops/master/scripts/mysql57 && sudo chmod +x mysql57 &&  sudo ./mysql57`


## Creating a new user, setting a password and assigning the permision to check primary/replica status
<!--login to mysql with root using the password set at setup-->
`mysql -u root -p`
<!--Creates user and assign a password-->
`CREATE USER 'user_name'@'host_name' IDENTIFIED BY 'password';`
<!--Grants user permission to check primary/replica status of databases-->
`GRANT REPLICATION CLIENT ON *.* TO 'user_name'@'host_name';`

### Emmanuel Nwachukwu [<emmax0121@gmail.com>]
