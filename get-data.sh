#!/bin/bash

set -eu -o pipefail

table=$1

mkdir -p data
mkdir -p tidied-data

if [ ! -f data/$table.zip ]; then
    curl -o data/$table.zip "https://www.nomisweb.co.uk/output/census/2011/${table}ew_2011_oa.zip"
    cd data
    unzip $table.zip
    cd ..
fi

cd data/${table}ew_2011_oa

cat */*META0.* >> ../../log.txt

# The perl bit removes DOS line endings https://stackoverflow.com/a/6374360/3347737
perl -pe 's/\r\n|\n|\r/\n/g' *DATA.CSV > $table.csv

perl -pe 's/\r\n|\n|\r/\n/g' */*DESC0*.CSV | cut -d, -f1,4 | awk 'NR>1' | tr ',' ' ' | while read code name; do
    echo $code $name
    sed -i.bak "1s/$code/$name/" $table.csv
done

xsv join code ../../output-areas.csv GeographyCode $table.csv > $table-oa.csv

cp $table-oa.csv ../../tidied-data

echo 'Done!'
