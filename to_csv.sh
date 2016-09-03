#!/bin/bash

echo 'title,service,citation,dataDownload,description,license,organization,organization-long,source,short-description,subtitle,id' > metadata.csv

ls jsons/*.json |
    while read f;
    do
        cat $f | jq '.attributes | .title, .service, .citation, .dataDownload, .description, .license, .organization, .["organization-long"], .source, .["short-description"], .subtitle' | tr '\n' ','
        echo $(basename $f .json)
    done <&0 >> metadata.csv
