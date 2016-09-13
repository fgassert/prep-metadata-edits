#!/bin/bash

rm -rf jsons
rm -rf dataset-jsons
rm -rf dataset-tags-jsons
mkdir -p jsons
mkdir -p dataset-jsons
mkdir -p dataset-tags-jsons

curl "https://docs.google.com/spreadsheets/d/1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto/export?format=csv&id=1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto&gid=181886287" | csv2json - googledocs.json
curl "https://docs.google.com/spreadsheets/d/1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto/export?format=csv&id=1eKKwh-DOL43eJcWkWWsIrCOQSoVRh8zbSCOmy7Tvqto&gid=391150960" | csv2json - googledocs_tags.json

cat googledocs.json | jq -r '.[] | .id' |
    while read id
    do
        if [ $id != "#N/A" ] && [ $id != '' ]
        then
            cat googledocs.json | jq ".[]|select(.id==\"$id\") | del(.id) | {attributes:.}" > jsons/$id.json;
            cat googledocs.json | jq ".[]|select(.id==\"$id\") | del(.id) | {dataset:{dataset_attributes: {name:.title}}}" > dataset-jsons/$id.json;
        fi
    done <&0

cat googledocs_tags.json | jq -r '.[] | .id' |
    while read id
    do
        if [ $id != "#N/A" ] && [ $id != '' ]
        then
            cat googledocs_tags.json | jq ".[]|select(.id==\"$id\") | del(.id) | {dataset:{dataset_attributes: {tags:.tags | split(\",\")}}}" > dataset-tags-jsons/$id.json;
        fi
    done <&0
