#!/bin/bash

set -eu -o pipefail

rules_filename=$1

rm -f $rules_filename
touch $rules_filename

ls tidied-data | while read f; do
    echo
    echo $f
    xsv headers tidied-data/$f
    read -r -p "Use this data set?" response < /dev/tty
    if [[ "$response" =~ ^([yY]) ]]
    then
        while true; do
        read -r -p "Enter recoding rules (e.g. a=2+3 b=5+6 *=7):" categories < /dev/tty
        #cat < /dev/tty > tmp-categories.txt
        python3 recode.py $categories < tidied-data/$f > /dev/null || echo "*** Something went wrong when attempting to recode! ***"

        read -r -p "Are you happy with this?" response < /dev/tty
        if [[ "$response" =~ ^([yY]) ]]
        then
            echo "$f $categories" >> $rules_filename
            break
        fi

        read -r -p "Try again?" response < /dev/tty
        if [[ ! "$response" =~ ^([yY]) ]]
        then
            break
        fi
        done
    fi
done

rm -f tmp-categories.txt
