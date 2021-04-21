#!/bin/bash

url=$1
payload=$2
content=${3:-text/csv}

curl --data-binary @${payload} -H "Content-Type: ${content}" -v ${url}/invocations
