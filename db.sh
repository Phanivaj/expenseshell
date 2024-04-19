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
echo "Enter password for MySql server"
read -s password
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

dnf install mysql-server -y &>>$logfilepath
validate $? "Installing MySql Server"

systemctl enable mysqld &>>$logfilepath
validate $? "Enabling MySQL Server service"

systemctl start mysqld &>>$logfilepath
validate $? "Starting MySQL Server service"

mysql -h db.expensedevops.online -uroot -p$password -e 'show databases;'
if [$0 -ne 0]
then
mysql_secure_installation --set-root-pass $password &>>$logfilepath
validate $? "Setting MySQL Server password"
else
echo  -e "$Y Setting MySQL Server password .... $G skipped"


