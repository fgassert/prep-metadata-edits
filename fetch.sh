#!/bin/bash

mkdir -p attributes
mkdir -p raw

curl http://api.prepdata.org/datasets?app=prep | jq -r '.[] | .id' | while read line; do curl http://api.prepdata.org/metadata/$line > raw/$line.json; done <&0

cd raw
for f in *.json; do cat $f | jq '.data[0].attributes.info' > ../attributes/$f ; done
