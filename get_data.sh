#!/bin/bash

FILE_NAME=$1
DATA_DIR=./data

if [ -f "$DATA_DIR$FILE_NAME" ]; then
	echo "HTTP/1.0 200 OK"
	echo "Content-Type: application/json"
	echo ""
	cat "$DATA_DIR$FILE_NAME"
else
	echo "HTTP/1.0 404 Not Found"
	echo "Content-Type: application/json"
fi