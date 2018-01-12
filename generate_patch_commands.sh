#!/bin/bash

ls jsons/*.json |
    while read f
    do
        id=$(basename $f .json)
        echo "curl -X PATCH -H \"Authorization: Bearer $1\" -H \"Content-Type: application/json\" -H \"Cache-Control: no-cache\" -d @jsons/$id.json \"https://api.resourcewatch.org/v1/dataset/$id/metadata\""
    done <&0
