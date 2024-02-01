#!/bin/bash

SOURCE_DIR=~/code/k8s
DEST_DIR=transfer_folder
REMOTE_USER=alex
REMOTE_IP=192.168.2.81
REMOTE_DIR=/home/alex

# Create the transfer folder
mkdir -p $DEST_DIR

# Copy the folders which do not have a dot in the name
find $SOURCE_DIR -mindepth 1 -maxdepth 1 ! -name '.*' -type d -exec cp -r {} $DEST_DIR \; || { echo "Copy failed"; exit 1; }

# Remove unnecessary directory
rm -rf $DEST_DIR/k8s/transfer_folder

# Remove any existing files in the remote directory
ssh $REMOTE_USER@$REMOTE_IP "rm -rf $REMOTE_DIR/*" || { echo "Remote cleanup failed"; exit 1; }

# Copy the directory to the remote server
scp -r $DEST_DIR $REMOTE_USER@$REMOTE_IP:$REMOTE_DIR || { echo "SCP failed"; exit 1; }

rm -rf $DEST_DIR
