#!/bin/bash

set -eu -o pipefail

echo "#!/bin/bash" > generated-recode-script.sh
echo "set -eu -o pipefail" >> generated-recode-script.sh
echo "mkdir -p recoded-data" >> generated-recode-script.sh
chmod u+x generated-recode-script.sh

ls tidied-data | head -n5 | while read f; do
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
            echo "python3 recode.py $categories < tidied-data/$f > recoded-data/$f" >> generated-recode-script.sh
            break
        fi
        done
    fi
done

rm -f tmp-categories.txt
