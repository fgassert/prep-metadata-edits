#!/bin/bash

rm -rf jsons
mkdir -p jsons

curl http://api.prepdata.org/datasets?app=prep |
    jq -r '.[] | .id' |
    while read id
    do curl http://api.prepdata.org/metadata/$id |
            jq '.data[0].attributes.info' > jsons/$id.json
    done <&0
