#!/bin/bash

username=$(id -u)
userid=$(whoami)
date=$(date +%F-%H-%M-%S)
logfilepath=/tmp/$(echo $0 | cut -d. -f1)-$date.log
#touch $logfilepath
echo $logfilepath
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo $userid Executing $0
echo "Execution started at $date"
#echo "Enter password for MySql server"
#read -s password
if [ $username -ne 0 ]
then
echo "please use root user acces for the installation"
exit 1 
else
echo "you are a root user"
fi

validate(){
    if [ $1 -ne 0 ]
    then
    echo -e "$Y $2 ....$R failed $N"
    exit 1
    else
    echo -e "$Y $2 .....$G success $N"
   fi
}

dnf module disable nodejs -y &>>$logfilepath
validate $? "Disabling the nodejs"

dnf module enable nodejs:20 -y &>>$logfilepath
validate $? "Enabling the nodejs"

dnf install nodejs -y &>>$logfilepath
validate $? "Installation of nodejs"

id expense &>>$logfilepath
if [ $? -ne 0 ]
then
useradd expense &>>$logfilepath
validate $? "Adding user expense"
else
echo -e "$Y User already added .... $G skipped $N"
fi
if [ -d /app ]
then
echo -e "$Y Directory already created .... $G skipped $N"
else
mkdir /app &>>$logfilepath
validate $? "Creating App directory"
fi
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logfilepath
validate $? "Downloading the backend.ZIp file"
cd /app
unzip /tmp/backend.zip &>>$logfilepath
validate $? "Unzipping the backend.zip"

