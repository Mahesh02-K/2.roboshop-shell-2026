#!/bin/bash

source ./common.sh
app_name=catalogue

root_verification
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE
VERIFY $? "Installing Mongodb client"

STATUS=$(mongosh --host mongodb.kakuturu.online --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.kakuturu.online </app/db/master-data.js &>>$LOG_FILE
    VERIFY $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N" | tee -a $LOG_FILE
fi 

print_time