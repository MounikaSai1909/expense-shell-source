#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter DB password"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
       echo -e " $2.. $G SUCCESS $N"
    else
       echo -e "$2.. $R FAILURE $N"  
    fi
} 

check_user(){ 
     if [ $USERID -eq 0 ]
     then
        echo "You are a super user "
     else
        echo "Please run this script with root access"
     fi
}
