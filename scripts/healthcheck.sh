#!/bin/bash

URL=http://localhost:8080/health

STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)

if [ "$STATUS" == "200" ]
then
    echo "Application Healthy"
    exit 0
else
    echo "Health Check Failed"
    exit 1
fi
