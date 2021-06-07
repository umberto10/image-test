#!/bin/sh
TOKEN=$(<"${HOME}"/token)
echo ${TOKEN}
oneclient -v 1 -H onedata.kdm.wcss.pl -t ${TOKEN} "${HOME}"/onedata
