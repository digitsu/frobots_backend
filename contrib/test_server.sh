#!/bin/bash

greeting="Welcome"
user=$(whoami)
day=$(date +%A)
teststring=$1

if [[ $CI_COMMIT_BRANCH == "main" ]]; then
    url=$BACKEND_URL_PROD
elif [[ $CI_COMMIT_BRANCH == "dev" ]]; then
    url=$BACKEND_URL_STAGING
elif [[ $CI_COMMIT_BRANCH == "main2" ]]; then
    url=$BACKEND_URL_PROD2
else
    url="http://nourlprovided.com"
fi

echo "$greeting back $user! Today is $day, which is the best day of the entire week!"
echo "Your Bash shell version is: $BASH_VERSION. Enjoy!"
echo "Testing server at $url!"

ret=$(curl -LIs $url | grep HTTP | cut -d ' ' -f2 | tail -1 )

if [ $ret -eq 200 ]; then
	echo "SUCCESS 200 - Got a website!"
else
	echo "FAILED Web Check"
	exit 1
fi

#ret2=$(curl -L --get $1 | grep -q $teststring; echo $?)
ret2=$(curl -LG $url | tac | tac | grep -q "$teststring"; echo $?)

if [ $ret2 -eq 1 ]; then
	echo "FAILED to find '$teststring' in HTTP response body"
	exit 1
else
	echo "SUCCESS in getting '$teststring' in HTTP response body"
	exit 0
fi

