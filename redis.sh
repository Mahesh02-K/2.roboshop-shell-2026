#!/bin/bash

source ./common.sh
root_verification

dnf module disable redis -y &>>$LOG_FILE
VERIFY $? "Disabling default redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VERIFY $? "Enabling redis:7"

dnf install redis -y &>>$LOG_FILE
VERIFY $? "Installing redis"

sed -i -e "s/127.0.0.1/0.0.0.0/g" -e "/protected-mode/ c protected-mode no" /etc/redis/redis.conf 
VERIFY $? "Enabling remote connections"

systemctl enable redis &>>$LOG_FILE
VERIFY $? "Enabling redis"

systemctl start redis &>>$LOG_FILE
VERIFY $? "Starting redis"

print_time