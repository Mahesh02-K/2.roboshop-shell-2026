#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD 

mkdir -p $LOGS_FOLDER
echo "Script started executing at : $(date)" | tee -a $LOG_FILE

root_verification(){
    if [ $USERID -eq 0 ]
    then 
        echo -e "You are running root access .. $G Move forward $N" | tee -a $LOG_FILE
    else
        echo -e "$R ERR :: $N Please run this with root access" | tee -a $LOG_FILE
        exit 1 #give other than 0 upto 127
    fi
}


VERIFY(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1 #give other than 0 upto 127
    fi
}

app_setup(){
    mkdir -p /app
    VERIFY $? "Creating app directory"

    id roboshop &>>$LOG_FILE
    if [ $? -eq 0 ]
    then
        echo -e "Roboshop user is ... $Y ALREADY CREATED $N"
    else 
        useradd --system --home /app --shell /sbin/nologin --comment "Roboshop system user" roboshop &>>$LOG_FILE
        VERIFY $? "Creating roboshop user"
    fi

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VERIFY $? "Downloading $app_name"

    rm -rf /app/*
    cd /app
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VERIFY $? "Unzipping $app_name"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VERIFY $? "Creating service file"

    systemctl daemon-reload &>>$LOG_FILE
    systemctl enable $app_name &>>$LOG_FILE
    systemctl start $app_name &>>$LOG_FILE
    VERIFY $? "Starting $app_name"
}

nginx_installation(){
    dnf module disable nginx -y &>>$LOG_FILE
    VERIFY $? "Disabling default nginx"

    dnf module enable nginx:1.24 -y &>>$LOG_FILE
    VERIFY $? "Enabling nginx 1.24"

    dnf install nginx -y &>>$LOG_FILE
    VERIFY $? "Installing nginx"

    systemctl enable nginx &>>$LOG_FILE
    systemctl start nginx &>>$LOG_FILE
    VERIFY $? "Starting nginx"
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VERIFY $? "Disabling Nodejs default version"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VERIFY $? "Enabling nodejs 20"

    dnf install nodejs -y &>>$LOG_FILE
    VERIFY $? "Installing nodejs"

    npm install &>>$LOG_FILE
    VERIFY $? "Installing Dependencies"
}

print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Script execution completed successfully, $Y Time taken = $TOTAL_TIME $N sec" | tee -a $LOG_FILE
}
