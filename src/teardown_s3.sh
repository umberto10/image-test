#!/bin/sh
set -e
mount -l | grep -Fqe s3fs || { echo "No s3fs mounts found."; exit 1; }

echo "unmounting ${HOME}/s3"
umount ${HOME}/s3

