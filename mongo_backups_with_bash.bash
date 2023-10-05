#!/bin/bash

# MongoDB connection settings
MONGO_HOST="localhost"        # MongoDB host
MONGO_PORT="2717"            # MongoDB port
MONGO_DB="truly"      # MongoDB database name
MONGO_USERNAME="put_server_user_here"    # MongoDB username
MONGO_PASSWORD="put_mongodb_password_here" # MongoDB password

# FTP settings
FTP_SERVER="connector.kolleris.com"
FTP_USER="ftp_user"
FTP_PASS="put_server_password_here"
FTP_DIR="/mongodb_backups"

# Backup directory and file names
BACKUP_DIR="/root/backups"  # Local directory to store backups

# Generate a timestamp (e.g., YYYYMMDDHHMMSS)
TIMESTAMP=$(date "+%Y%m%d%H%M%S")

# Backup file name with timestamp
BACKUP_FILENAME="mongodb_backup_${TIMESTAMP}.tar.gz"

# 1. Create a backup of the MongoDB database
#mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USERNAME --password $MONGO_PASSWORD --db $MONGO_DB --out $BACKUP_DIR
mongodump --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB --out $BACKUP_DIR

# 2. Compress the backup into a tarball
tar -czvf $BACKUP_DIR/$BACKUP_FILENAME -C $BACKUP_DIR $MONGO_DB

# 3. Upload the compressed backup to the FTP server
lftp -e "set ssl:verify-certificate no; put -O /mongodb_backups /root/backups/$BACKUP_FILENAME; bye" connector.kolleris.com

# Clean up: remove the local backup file
rm $BACKUP_DIR/$BACKUP_FILENAME