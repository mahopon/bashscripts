#!/bin/bash

CDPATH="/home/mahopon/infra"

cd "$CDPATH"
rsync -av --delete home2:~/infra ~/infra/home2
git pull > /dev/null 2>&1
if git status --porcelain | grep -q .; then
    git add .
    git commit -m "Auto-update $(date +"%d-%m-%y")" > /dev/null 2>&1
    git push > /dev/null 2>&1
    echo "Auto pushed updates for $CDPATH"
else
    echo "No updates for $CDPATH"
fi
