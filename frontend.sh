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
rm -rf /usr/share/nginx/html/*&>>$logfilepath
validate $? "Removing the content from html folder"
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip&>>$logfilepath
validate $? "Downloading frontend.zip file"
cd /usr/share/nginx/html &>>$logfilepath
validate $? "Moving to html folder"
unzip /tmp/frontend.zip&>>logfilepath
validate $? "Unzip frontend.zip file"
cp /home/ec2-user/expenseshell/expense.conf /etc/nginx/default.d/expense.conf&>>$logfilepath
validate $? "Copying expense.conf file"
systemctl restart nginx &>>$logfilepath
validate $? "Restarting nginx service"

