#!/bin/bash

source ./common.sh
root_verification

echo -e "$R Enter rabbitmq password to setup $N"
read -s RABBITMQ_PASSWD

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VERIFY $? "Copying repo file"

dnf install rabbitmq-server -y &>>$LOG_FILE
VERIFY $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
VERIFY $? "Starting rabbitmq-server"

rabbitmqctl add_user roboshop $RABBITMQ_PASSWD &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE

print_time