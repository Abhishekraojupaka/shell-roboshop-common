#!/bin/bash

source ./common.sh
app_name=redis

check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling default Redis"
dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling Redis 7"
dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e ' /protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing Remote connections to Redis"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling redis"
systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting redis"

print_total_time