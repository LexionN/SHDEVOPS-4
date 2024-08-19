#!/bin/sh

if [ ! -d /opt/backup ]; then
    sudo mkdir /opt/backup && sudo chown -R  $USER:$USER /opt/backup
fi
#uname=$(ls -l $1 | awk '{print $3}')
if [ -O /opt/backup ];
 then
   now=$(date +"%s_%Y-%m-%d")
    docker run -d --network='hvirt_backend' schnitzler/mysqldump \
      /usr/bin/mysqldump --opt -h ${MYSQL_HOST} \
      -u ${MYSQL_USER} -p${MYSQL_PASSWORD} \
      ${MYSQL_DATABASE} > "/opt/backup/${now}_${MYSQL_DATABASE}.sql"

 else 
   sudo chown -R  $USER:$USER /opt/backup
fi



