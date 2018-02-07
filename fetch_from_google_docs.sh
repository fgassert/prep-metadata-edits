#!/bin/bash

rm -rf jsons
mkdir -p jsons

curl "https://docs.google.com/spreadsheets/d/1CQ5vKg0mPkxD8uDPoTLeQDxdN2w8AotnvLRHxfKNIKI/export?format=csv&id=1CQ5vKg0mPkxD8uDPoTLeQDxdN2w8AotnvLRHxfKNIKI&gid=658960477" | csvtojson > googledocs.json

cat googledocs.json | jq -r '.[] | .api_id' |
    while read id
    do
        echo $id
        if [ "$id" != "#N/A" ] && [ "$id" != '' ]
        then
            cat googledocs.json | jq ".[] | select(.api_id==\"$id\") | del(.api_id) | .language=\"en\" | .application=\"prep\"" > jsons/$id.json;
        fi
    done <&0
