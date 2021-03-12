#!/usr/bin/env python3
import untangle
import requests
from minio import Minio
#from minio.error import ResponseError
import json
import os
from pathlib import Path
import re
import urllib3


# s3 address
addr = 'minio.kdm.wcss.pl'

# Get Token
token = os.environ['TOKEN']

print(f'### TOKEN {token}')

# get temporary credentials from minio via post request
url = f'https://{addr}:9000' #'http://minio.cs.kdm.wcss.pl:9000'
data = {'Action': 'AssumeRoleWithWebIdentity',
        'DurationSeconds': '3600',
        'WebIdentityToken': token,
        'Version': '2011-06-15'
        }

# response in xml format
post = requests.post(url, data = data, verify=False)
print(post.text)

# parse post
xml = untangle.parse(post.text)
creds_xml = xml.AssumeRoleWithWebIdentityResponse.AssumeRoleWithWebIdentityResult.Credentials.children # get credentials section from xml

# setup dict with temporary creds
creds = {}
for e in creds_xml:
    creds[e._name] = e.cdata

# user home dir
home = str(Path.home())

# create .aws folder for credentials if dosen't exists
if not os.path.exists(home + '/.aws'):
    os.makedirs(home + '/.aws')

""" s3 credentials file with format
[profile_name]
aws_access_key_id = $ACCESSKEYID
aws_secret_access_key = $SECRETACCESSKEY
aws_session_token = $SESSIONTOKEN
"""
s3_creds_path =  home + '/.aws/credentials'
with open(s3_creds_path, 'w+') as f:
    f.write('[default]\n')
    f.write(f"aws_access_key_id = {creds['AccessKeyId']}\n")
    f.write(f"aws_secret_access_key = {creds['SecretAccessKey']}\n")
    f.write(f"aws_session_token = {creds['SessionToken']}\n")

httpClient = urllib3.PoolManager(
    timeout=urllib3.Timeout.DEFAULT_TIMEOUT,
    assert_hostname=False,
    cert_reqs='CERT_NONE',
    retries=urllib3.Retry(
        total=5,
        backoff_factor=0.2,
        status_forcelist=[500, 502, 503, 504]
        )
    )

if not "S3DIR" in os.environ: 
    # minio client for user to get buckets' names
    s3Client = Minio(
        f'{addr}:9000',
        access_key=creds['AccessKeyId'],
        secret_key=creds['SecretAccessKey'],
        session_token=creds['SessionToken'],
        http_client=httpClient
    )
    
    # list buckets minio
    bucket_list = s3Client.list_buckets()
    jhub_name = bucket_list[0].name
    for bucket in bucket_list:
        print(bucket.name, bucket.creation_date)
        if re.search("^jupyter-*", bucket.name):
            jhub_name = bucket.name
            break
    
    if not len(bucket_list):
       jhub_name = 'no_jupyter'
else:
    jhub_name=os.environ['S3DIR']

# save jupyter bucket name in '/tmp/user_bucket'
with open('/tmp/user_bucket', 'w+') as f:
    f.write(f'{jhub_name}')
