#!/bin/bash

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

rm -f years.txt

seq -s'x' $first_year $this_year | sed 's/x/\n/g' >> years.txt
