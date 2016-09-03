#!/bin/bash

rm -rf jsons
mkdir -p jsons

curl "https://docs.google.com/spreadsheets/d/1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto/export?format=csv&id=1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto&gid=181886287" | csv2json - googledocs.json

cat googledocs.json | jq -r '.[] | .id' |
    while read id
    do
        if [ $id != "#N/A" ] && [ $id != '' ]
        then
            cat googledocs.json | jq ".[]|select(.id==\"$id\") | del(.id) | {attributes:.}" > jsons/$id.json;
        fi
    done <&0
