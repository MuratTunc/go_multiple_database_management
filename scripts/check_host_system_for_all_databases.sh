#!/bin/bash
#title           :check_host_system_for_all_databases.sh
#description     :This script will make ready for sw development for the project
#                 go_multiple_database_management
#author          :Murat Tunç- Senior Backend Developer -Türkiye-İstanbul
#date            :20240228
#version         :0.1    
#usage           :sudo ./Development_Ready.sh
#repository      :https://github.com/MuratTunc/go_multiple_database_management
#notes           :Linux bash terminal is needed to use this script.
#bash_version    :5.2.21(1)-release
#operating_system:Ubuntu 24.04.1 LTS
#==================================================================================

slp=2 #sleep constant in seconds
##-------------------------------------------------------------------------------##
#Color variables.
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'

initialize() {
    clear
    echo -e "${green}-->Status: Starting all databases with bash commands, relax and have a coffee, of course a biscuit${clear}!"
}

updatesystem() {

    echo -e "${green}-->Status:Updating and linux system... ${clear}!"
    apt update -y
    sleep ${slp}
    echo -e "${green}-->Status:Install curl... ${clear}!"
    sleep ${slp}
    apt install curl -y
    echo -e "${green}-->Status:Install build essential... ${clear}!"
    sleep ${slp}
    apt install build-essential -y
}

install_postgresql(){

    which psql | grep '/usr/bin/psql' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->Postgresql is already installed...${clear}!"
    else
       echo -e "${blue}-->Status:Install Postgresql... ${clear}!"
       apt install postgresql postgresql-contrib -y
    fi

    which psql
    systemctl start postgresql.service 
    systemctl status postgresql.service
}

install_mysql(){

    which mysqld | grep '/usr/sbin/mysqld' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->Mysql is already installed...${clear}!"
    else
       echo -e "${blue}-->Status:Install Mysql... ${clear}!"
       apt install mysql-server -y
    fi
    which mysqld
    systemctl start mysql.service
    systemctl status mysql.service
}

install_sqlite(){

    which sqlite3 | grep '/usr/bin/sqlite3' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->sqlite3 is already installed...${clear}!"
    else
       echo -e "${blue}-->Status:Install sqlite3... ${clear}!"
       apt install sqlite3 -y
    fi
    which sqlite3
}

install_mongodb(){

    which mongod | grep '/usr/bin/mongod' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->Mongodb is already installed...${clear}!"
    else
       echo -e "${green}-->Status:Install mongodb... ${clear}!"
       apt-get install gnupg curl -y
       curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
       sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
       --dearmor
       echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
       apt-get update
       apt-get install -y mongodb-org
       #Prevent automatic updates to MongoDB packages:
       echo "mongodb-org hold" | sudo dpkg --set-selections
       echo "mongodb-org-database hold" | sudo dpkg --set-selections
       echo "mongodb-org-server hold" | sudo dpkg --set-selections
       echo "mongodb-mongosh hold" | sudo dpkg --set-selections
       echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
       echo "mongodb-org-tools hold" | sudo dpkg --set-selections
    fi

    sudo systemctl start mongod
    sudo systemctl enable mongod
    which mongod
}

install_mariadb(){

    which mariadb | grep '/usr/bin/mariadb' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->mariadb is already installed...${clear}!"
    else
       echo -e "${blue}-->Status:Install mariadb... ${clear}!"
       apt install mariadb-server -y
    fi
    sudo systemctl start mariadb.service
    sudo systemctl status mariadb.service
    which mariadb
}

initialize
updatesystem
install_postgresql  # Relational database
install_mysql       # Relational database
install_sqlite      # Server-less relational database
install_mongodb     # NoSQL database
install_mariadb     # Columnar Relational database
