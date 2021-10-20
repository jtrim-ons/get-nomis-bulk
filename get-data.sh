#!/bin/zsh

set -eu -o pipefail

table=$1

mkdir -p data
mkdir -p tidied-data

if [ ! -f data/$table/$table.zip ]; then
    mkdir -p data/$table

    # cp data/$table.zip data/$table  # temporary; use cURL instead
    curl -o data/$table/$table.zip "https://www.nomisweb.co.uk/output/census/2011/${table}ew_2011_oa.zip"

    cd data/$table
    unzip $table.zip
    cd ../..
fi

cd data/$table

cat **/*META0.* >> ../../log.txt
filename=$(tail -n1 **/*META0.* | tr -C '[:alnum:]' '_' | sed 's/_*$//')

# The perl bit removes DOS line endings https://stackoverflow.com/a/6374360/3347737
perl -pe 's/\r\n|\n|\r/\n/g' **/*DATA.CSV > $table.csv

cat $table.csv | awk 'NR == 1' > $table-head.csv
cat $table.csv | awk 'NR > 1' > $table-body.csv
perl -pe 's/\r\n|\n|\r/\n/g' **/*DESC0*.CSV | xsv select 1,4 | cut -d, -f1,2- | awk 'NR>1' | sed 's`,` `' | while read code name; do
    echo $code $name
    sed -i.bak "1s\`$code\`$name\`" $table-head.csv
done
cat $table-head.csv $table-body.csv > $table.csv
rm $table-head.csv
rm $table-body.csv

xsv join code ../../output-areas.csv GeographyCode $table.csv | xsv select !1 > $table-oa.csv

cp $table-oa.csv ../../tidied-data/$filename.csv

echo 'Done!'
