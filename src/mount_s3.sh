#!/bin/sh
# take creds from ~/.aws.credentials generate by test.py

# s3 url
URL="https://minio.kdm.wcss.pl:9000"
# error hadler patterns
NO_BUCKET="no_jupyter"
ERROR="error"

# read bucket name
read -r BUCKET_NAME < /tmp/user_bucket

# chceck if bucket name is valid
case ${BUCKET_NAME} in
  *${NO_BUCKET}*) 
		echo "No valid bucket found.";
		exit 1;
		;;
  *${ERROR}*)
		echo "${BUCKET_NAME}.";
		exit 1
		;;
esac

optstring=":d"
DAEMON=false

while getopts ${optstring} arg; do
  case ${arg} in
    d)
      DAEMON=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 2
      ;;
  esac
done

if "$DAEMON" ; then
      echo 'WORKING NOT AS A DAEMON!'
      echo 'if u want daemon delete -d option'
      s3fs $BUCKET_NAME $2 -o no_check_certificate,use_path_request_style,url="$URL" -f
else
      s3fs $BUCKET_NAME $1 -o no_check_certificate,use_path_request_style,url="$URL"
fi
