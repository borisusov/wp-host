#!/bin/bash
set -x 

[ ! -s "$1" ] && echo "ERROR: Input file does not exist." && exit 5
[ -z "$2" ]   && echo "ERROR: No passphrase!" && exit 10

PARSTR=$(echo "$1" |rev |cut -d. -f1)
# rev "enc" = "cne" (Select Encrypt/Decrypt by file exttensiion)
if [ a$PARSTR = acne ]; then 
   ## Decrypt
   OUTFILE=$(echo "$1" |sed 's/\(^.*\)\.enc.*$/\1/')
   openssl aes-256-cbc -d -a -in "$1" -pass pass:"$2" -out "$OUTFILE"
 else
   ## Encrypt
   openssl aes-256-cbc -a -salt -in "$1" -pass pass:"$2" -out "${1}.enc"
fi

