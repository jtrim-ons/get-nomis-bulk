#!/bin/bash

set -eu -o pipefail

rules_filename=$1

mkdir -p recoded-data
cat $rules_filename | while read filename rules; do
    echo $filename
    python3 recode.py $rules < tidied-data/$filename > recoded-data/$filename
    echo
done
