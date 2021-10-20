#!/bin/bash

set -eu -o pipefail

cat some_vars.txt | while read v; do
  ./get-data.sh $v
done
