#!/bin/bash

source ./common.sh
root_verification

echo -e "$R ENTER ROOT PASSWORD TO SETUP $N" | tee -a $LOG_FILE
read -s MYSQL_ROOT_PASSWORD

dnf install mysql-server -y &>>$LOG_FILE
VERIFY $? "Installing mysql"

systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
VERIFY $? "Starting Mysql"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>>$LOG_FILE
VERIFY $? "Setting MySQL root password"

print_time