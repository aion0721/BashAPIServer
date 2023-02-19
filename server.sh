#!/bin/bash

# define
PORT=4000
LOG_OUT="./logs/stdout.log"
LOG_ERR="./logs/stderr.log"

# Function
function response() {
	echo "HTTP/1.0 200 OK"
	echo "Connect-Type: text/plain"
	echo ""

	echo "hello, world"

}

# Check 
if [ ! -d ./logs ]; then
	mkdir ./logs
fi

# main
trap exit INT

exec 1> >(tee -a $LOG_OUT)
exec 2> >(tee -a $LOG_ERR)

while true; do
	response | nc -l "$PORT" -w 1
done