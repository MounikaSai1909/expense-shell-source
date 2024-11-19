#!/bin/bash

source ./common.sh
check_user()

echo "please enter DB password"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idemponent nature
mysql -h db.swamy.fun -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -eq 0 ]
then
   echo -e "MYSQL root password is already setup.. $Y SKIPPING $N"
else
   mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>$LOGFILE
   VALIDATE $? "MySQL root password setup"
fi
  
   