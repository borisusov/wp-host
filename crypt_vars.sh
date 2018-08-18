#!/bin/bash
openssl aes-256-cbc -a -salt -in "$1" -pass pass:"$2" -out "${1}.enc"

