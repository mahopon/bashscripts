#!/bin/bash

tmpfile=$(mktemp)

df --block-size 1G | awk 'NR > 1 {print "FS: " $1 " Usage: " $5}' | grep 'vg' > "$tmpfile"

date | tee -a test.txt

if [ -f test.txt ]; then
    cat "$tmpfile" | tee -a test.txt
else
    cat "$tmpfile" | tee test.txt
fi

rm "$tmpfile"
