#!/bin/bash
set -e
source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$LOG_FILE


# mysql -h $MYSQL_HOST -uroot -pRoboshop@1 -e 'use cities' &>>$LOG_FILE
if ! mysql -h 172.31.21.89 -uroot -pRoboshop@1 -e 'use cities;'; then
#[ $? -ne 0 ]; then
    mysql -h 172.31.21.89 -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h 172.31.21.89 -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h 172.31.21.89 -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

# DB_CHECK=$(mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -N -s -e 'show databases like "cities";' 2>>$LOG_FILE | xargs)
# if [ "$DB_CHECK" = "cities" ]; then
#   echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
# else
#   echo "Loading Shipping schema..."
#   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
#   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
#   mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
# fi

app_restart
print_total_time

