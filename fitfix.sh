#!/bin/sh
java -jar FitCSVTool.jar -b $1 /tmp/$1.csv
gawk -f fitfix.awk /tmp/$1.csv > /tmp/$1.fixed.csv
java -jar FitCSVTool.jar -c /tmp/$1.fixed.csv $2
