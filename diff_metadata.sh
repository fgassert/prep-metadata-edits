#!/bin/bash

APP=prep
LANGUAGE=en
NEW_METADATA=jsons
BACKUP_DIR=api_jsons
CMD=PATCH

rm -rf $BACKUP_DIR
mkdir -p $BACKUP_DIR

(>&2 echo  "Backing up current metadata to $BACKUP_DIR/{*id}.json")

curl -s "https://api.resourcewatch.org/v1/dataset/?app=$APP&page\[size\]=1000" |
    jq -r '.data[] | .id' |
    while read id
    do
        curl -s "https://api.resourcewatch.org/v1/dataset/$id/metadata?application=$APP&language=$LANGUAGE" |
            jq -S '.data[].attributes | del(.resource, .status, .updatedAt, .createdAt, .dataset)' > $BACKUP_DIR/$id.json
    done <&0

(>&2 echo "Current metadata saved to $BACKUP_DIR")

ls $NEW_METADATA/*.json |
    while read f
    do
        id=$(basename $f .json)
        echo "$id"
        diff $BACKUP_DIR/$id.json $NEW_METADATA/$id.json | colordiff
    done <&0
