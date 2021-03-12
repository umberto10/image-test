#!/bin/bash

manager_s3.py

S3_DIR="/home/jovyan/s3"
if [ ! -d "$S3_DIR" ]; then
	mkdir $S3_DIR;
fi

mount_s3.sh $S3_DIR
