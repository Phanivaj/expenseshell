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

dnf install nginx -y &>>$logfilepath
validate $? "Installing nginx"
systemctl enable nginx&>>$logfilepath
validate $? "Enabling nginx service"
systemctl start nginx&>>$logfilepath
validate $? "Starting nginx service"