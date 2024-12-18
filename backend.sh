#!/bin/bash

source ./common.sh

check_user

echo " please enter DB password "
read -s mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabling default node js"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling node js: 20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing node js"

# useradd expense
# VALIDATE $? "Creating expense user"

id expense &>>$LOGFILE
if [ $? -eq 0 ]
then 
   echo -e " Expense user already exists... $Y SKIPPING $N"
else 
    useradd expense
    VALIDATE $? " Creating expense user "
fi
    
mkdir -p /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE 
VALIDATE $? "downloading the backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installing node js dependecies"

cp /home/ec2-user/expense-shell-source/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copied backend service"

systemctl daemon-reload &>>$LOGFILE
systemctl start backend &>>$LOGFILE 
systemctl enable backend &>>$LOGFILE
VALIDATE $? "starting and enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL client"

mysql -h db.swamy.fun -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
#mysql --host=54.172.122.51 --user=root --password=ExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend
VALIDATE $? "restarting backend"
