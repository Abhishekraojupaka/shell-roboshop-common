#!/bin/bash

source ./common.sh

check_root

dnf remove mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL server"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld  
VALIDATE $? "Enabling and starting MySQL server"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Setting root password to MySQL server"
print_total_time