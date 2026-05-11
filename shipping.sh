#!/bin/bash

source ./common.sh
app_name=shipping

root_verification
echo -e "$R ENTER ROOT PASSWORD TO SETUP $N" | tee -a $LOG_FILE
read -s MYSQL_ROOT_PASSWORD

app_setup
maven_installation
systemd_setup

dnf install mysql -y &>>$LOG_FILE
VERIFY $? "Installing mysql client"

mysql -h mysql.kakuturu.online -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities' &>>$LOG_FILE
if [ $? -eq 0 ]
then 
    echo -e "Data is .. $Y Already loaded $N" | tee -a $LOG_FILE
else 
    mysql -h mysql.kakuturu.online -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.kakuturu.online -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.kakuturu.online -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE   
    VERIFY $? "Data loading into mysql"
fi

systemctl restart shipping &>>$LOG_FILE
VERIFY $? "Restarting shipping"

print_time