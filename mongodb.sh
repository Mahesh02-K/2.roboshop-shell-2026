#!/bin/bash

source ./common.sh
root_verification

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Copying MongoDB repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb server"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing MongoDB conf file for remote connections"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"

# cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
# VERIFY $? "Copying mongo repo file"

# dnf install mongodb-org -y &>>$LOG_FILE
# VERIFY $? "Installing MongoDB"

# systemctl enable mongod &>>$LOG_FILE
# systemctl start mongod &>>$LOG_FILE
# VERIFY $? "Starting MongoDB"

# sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
# VERIFY $? "Editing Mongod config file to enable remote connections"

# systemctl restart mongod &>>$LOG_FILE
# VERIFY $? "Restarting Mongodb"

print_time

