#!/bin/bash

source ./common.sh

root_verification
nginx_installation

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VERIFY $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip 
VERIFY $? "Downloading frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VERIFY $? "Unzipping frontend into temp directory"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VERIFY $? "Remove default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VERIFY $? "Copying nginx configuration file"

systemctl restart nginx &>>$LOG_FILE
VERIFY $? "Restarting nginx"

print_time