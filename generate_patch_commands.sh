#!/bin/bash

ls jsons/*.json |
    while read f
    do
        id=$(basename $f .json)
        echo "curl -X PATCH -H \"Authorization: $1\" -H \"Content-Type: application/json\" -H \"Cache-Control: no-cache\" -H -d @jsons/$id.json \"http://api.prepdata.org/metadata/$id/prep\""
    done <&0
