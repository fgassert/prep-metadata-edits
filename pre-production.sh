#!/bin/bash

rm -rf jsons
mkdir -p jsons

echo '{"env":"production"}' > env-prod.json

curl 'https://api.resourcewatch.org/v1/dataset/?app=prep&published=true&env=preproduction&page\[size\]=1000' |
    jq -r ".data[] | .id" |
    while read f
    do
        echo "curl -X PATCH -H \"Authorization: Bearer $1\" -H \"Content-Type: application/json\" -H \"Cache-Control: no-cache\" -d @\env-prod.json \"https://api.resourcewatch.org/v1/dataset/$f\""
    done
