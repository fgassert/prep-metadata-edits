#!/bin/bash

KEY=${1:-$RW_API_KEY}
APP=prep
NEW_METADATA=jsons
BACKUP_DIR=api_jsons
CMD=PATCH
LANGUAGE=en

if [ -z "$KEY" ]
then
    echo "Usage: $0 [RW_API_KEY] | bash"
    echo "  Generate PATCH commands to patch jsons/{*id}.json to RW API"
    echo "  Pipe to bash to run commands"
    echo "  RW_API_KEY is your API token"
    exit
fi

if [ "$2" == "--post" ]
then
   CMD=POST
fi

rm -rf $BACKUP_DIR
mkdir -p $BACKUP_DIR

echo  "Backing up current metadata to $BACKUP_DIR/{*id}.json"

curl -s "https://api.resourcewatch.org/v1/dataset/?app=$APP&page\[size\]=1000" |
    jq -r '.data[] | .id' |
    while read id
    do
        curl -s "https://api.resourcewatch.org/v1/dataset/$id/metadata?language=$LANGUAGE&application=$APP" |
            jq -S '.data[].attributes | del(.resource, .status, .updatedAt, .createdAt, .dataset)' > $BACKUP_DIR/$id.json
    done <&0

ls $NEW_METADATA/*.json |
    while read f
    do
        id=$(basename $f .json)
        echo "curl -X $CMD -H \"Authorization: Bearer $KEY\" -H \"Content-Type: application/json\" -H \"Cache-Control: no-cache\" -d @$f \"https://api.resourcewatch.org/v1/dataset/$id/metadata\""
    done <&0
