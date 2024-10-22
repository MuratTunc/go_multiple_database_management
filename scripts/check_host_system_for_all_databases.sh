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

postgresql(){


    which psql | grep '/usr/bin/psql' &> /dev/null
    if [ $? == 0 ]; then
       echo -e "${green}-->Postgresql is already installed...${clear}!"
       which psql 
    else
       echo -e "${blue}-->Status:Install Postgresql... ${clear}!"
       apt install postgresql postgresql-contrib -y
    fi
}

initialize
updatesystem
postgresql


