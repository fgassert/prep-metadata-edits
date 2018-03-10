#!/bin/bash

NEW_METADATA=jsons
APP=prep
LANGUAGE=en

rm -rf $NEW_METADATA nexjsons nexlayers
mkdir -p $NEW_METADATA nexjsons nexlayers

echo "Fetching from Google docs"

curl -s "https://docs.google.com/spreadsheets/d/1CQ5vKg0mPkxD8uDPoTLeQDxdN2w8AotnvLRHxfKNIKI/export?format=csv&id=1CQ5vKg0mPkxD8uDPoTLeQDxdN2w8AotnvLRHxfKNIKI&gid=658960477" | csvtojson > googledocs.json

cat googledocs.json | jq -r '.[] | .api_id' |
    while read id
    do
        if [ "$id" != "#N/A" ] && [ -n "$id" ]
        then
            echo "$id"
            cat googledocs.json | jq -S ".[] | select(.api_id==\"$id\") | del(.api_id) | .language=\"$LANGUAGE\" | .application=\"$APP\"" > $NEW_METADATA/$id.json;
        fi
    done <&0

echo "Adding NEX-GDDP layer metadata"

curl -s -o nexlayers.json "https://api.resourcewatch.org/v1/layer/?provider=nexgddp&page\[size\]=100"

cat nexlayers.json | jq -r '.data | unique_by(.attributes.layerConfig.indicator)[].attributes.layerConfig.indicator' |
    while read indicator
    do
        cat nexlayers.json | jq ".data | map(select(.attributes.layerConfig.indicator == \"$indicator\") | {layerId:.id, scenario:.attributes.layerConfig.scenario, temp_resolution:.attributes.layerConfig.temp_resolution, compareWith:.attributes.layerConfig.compareWith})" > nexlayers/$indicator.json
    done

ls $NEW_METADATA |
    while read f
    do
        indicator=$(cat $NEW_METADATA/$f | jq -r ".info.nexgddp.indicator_id")
        if [ "$indicator" != '' ]
        then
            layers=$(cat nexlayers/$indicator.json)
            cat $NEW_METADATA/$f | jq -S ".info.nexgddp.layers=$layers" > nexjsons/$f
        fi
    done

cp -rf nexjsons/* $NEW_METADATA/
rm -rf nexjsons nexlayers

echo "New metadata saved to $NEW_METADATA/{*id}.json"

echo "Run './update_metadata.sh [RW_API_KEY] --post | bash' to post new metadata"
echo "Run './update_metadata.sh [RW_API_KEY] | bash' to update existing metadata"
