#!/bin/bash
DB_USER="root"
DB_PASSS="root"
DB_HOST="localhost"
LINK="https://www.dropbox.com/s/t2l2us4p24xxgsn/mnist.sql.zip?dl=1"
FILE_NAME="mnist"


#install gdown, a tools that download from google drive, download and unzip files
wget -O ./"$FILE_NAME".sql.zip "$LINK"

unzip "$FILE_NAME".sql.zip

#connect to sql and insert data
echo "Executing sql script file. It may take some time"
mysql -u $DB_USER -h $DB_HOST -p$DB_PASSS < "$FILE_NAME".sql
echo  -e "Installation Finished\n"
