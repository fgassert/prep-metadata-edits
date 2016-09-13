#!/bin/bash

ls dataset-jsons/*.json |
    while read f
    do
        id=$(basename $f .json)

        echo curl -X PUT -H \"Authorization: Bearer $1\" -H \"Content-Type: application/json\" -H \"Cache-Control: no-cache\"  -d @dataset-jsons/$id.json \"http://api.prepdata.org/datasets/$id\"

    done <&0