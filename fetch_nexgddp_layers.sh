#!/bin/bash


rm -rf nexjsons nexlayers

mkdir -p nexjsons
mkdir -p nexlayers

curl -o nexlayers.json "https://api.resourcewatch.org/v1/layer/?provider=nexgddp&page\[size\]=100"

cat nexlayers.json | jq -r '.data | unique_by(.attributes.layerConfig.indicator)[].attributes.layerConfig.indicator' |
    while read indicator
    do
        echo $indicator
        cat nexlayers.json | jq ".data | map(select(.attributes.layerConfig.indicator == \"$indicator\") | {layerId:.id, scenario:.attributes.layerConfig.scenario, temp_resolution:.attributes.layerConfig.temp_resolution, compareWith:.attributes.layerConfig.compareWith})" > nexlayers/$indicator.json
    done

ls jsons |
    while read f
    do
        indicator=$(cat jsons/$f | jq -r ".info.nexgddp.indicator_id")
        if [ "$indicator" != '' ]
        then
            layers=$(cat nexlayers/$indicator.json)
            cat jsons/$f | jq ".info.nexgddp.layers=$layers" > nexjsons/$f
        fi
    done

cp -rf nexjsons/* jsons/
