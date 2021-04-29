#!/bin/bash

source scripts/site_vars.sh

rm -f years.txt

seq -s'x' $first_year $current_year | sed 's/x/\n/g' >> years.txt
