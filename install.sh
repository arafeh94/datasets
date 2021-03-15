#!/bin/bash

DB_USER="root"
DB_PASS="root"
DB_HOST="localhost"
DB_NAME="mnist"
LINK="https://www.dropbox.com/s/t2l2us4p24xxgsn/mnist.sql.zip?dl=1"
FILE_NAME="mnist"


#install gdown, a tools that download from google drive, download and unzip files
FILE=./"$FILE_NAME".sql
if [ -f "$FILE" ]; then
    echo "$FILE exists, skip download."
else 
    echo "$FILE does not exist, downloading..."
    wget -O ./"$FILE_NAME".sql.zip "$LINK"
    unzip "$FILE_NAME".sql.zip
fi


#connect to sql and insert data
echo "removing older runs"
docker container stop $DB_NAME-sql
docker container rm $DB_NAME-sql
echo "run mysql-server docker"
docker run --name $DB_NAME-sql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
echo "copy required files"
docker cp "$FILE_NAME".sql $DB_NAME-sql:/home/
docker cp inflate.sh $DB_NAME-sql:/home/
echo "Make sure SQL Service started"
while ! docker exec $DB_NAME-sql mysql -u $DB_USER -p$DB_PASS -e 'status' &> /dev/null; do
    echo "Waiting for database connection..."
    sleep 2
done
echo "Executing sql script file. It may take some time"
docker exec $DB_NAME-sql /bin/sh -c "/home/inflate.sh $DB_USER $DB_HOST $DB_PASS $FILE_NAME.sql"
echo "Connecting to sql server..."
docker exec -it $DB_NAME-sql /bin/sh -c "mysql -u $DB_USER -p$DB_PASS"
echo  -e "Installation Finished\n"

