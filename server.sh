#!/bin/bash

PORT=4000

function response() {
	echo "HTTP/1.0 200 OK"
	echo "Connect-Type: text/plain"
	echo ""

	echo "hello, world"

}

# main
trap exit INT

while true; do
	response | nc -l "$PORT" -w 1
done