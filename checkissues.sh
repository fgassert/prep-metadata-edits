#!/bin/bash

ls jsons/*.json |
    while read f
    do python checkissues.py $f
    done <&0
