#!/bin/bash

for pagenum in `seq 1 1859`
do
  java -jar ${TABULA} -it -p ${pagenum} "./Records sent 2018-31145.pdf" 2>/dev/null |\
    sed "s/^/${pagenum},/" |\
    tee -a ./extracted.csv
done
