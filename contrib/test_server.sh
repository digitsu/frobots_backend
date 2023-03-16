#!/bin/bash

greeting="Welcome"
user=$(whoami)
day=$(date +%A)
teststring=$2

echo "$greeting back $user! Today is $day, which is the best day of the entire week!"
echo "Your Bash shell version is: $BASH_VERSION. Enjoy!"

ret=$(curl -LIs $1 | grep HTTP | cut -d ' ' -f2 | tail -1 )

if [ $ret -eq 200 ]; then
	echo "SUCCESS 200 - Got a website!"
else
	echo "FAILED Web Check"
	exit 1
fi

ret2=$(curl -get $1 | grep -q $teststring; echo $?)

if [ $ret2 -eq 1 ]; then
	echo "FAILED to find '$teststring' in HTTP response body"
	exit 1
else
	echo "SUCCESS in getting '$teststring' in HTTP response body"
	exit 0
fi

