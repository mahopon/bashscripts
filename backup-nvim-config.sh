#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_FILE=$SCRIPT_DIR/updates.txt

find ~/.config -type d -name ".git" -prune | sed  -e 's|\.git$||' -e 's|^\.||' > "$OUT_FILE"

while IFS= read -r path;
do
    cd "$path" || { echo "Unable to cd to $path"; continue; }
    if git status --porcelain | grep -q .; then
        git pull > /dev/null 2>&1
        git add .
        git commit -m "Auto-update $(date +"%d-%m-%y %H:%M")" > /dev/null 2>&1
        git push > /dev/null 2>&1
        echo "Auto pushed updates for $path"
    else
        echo "No updates for $path"
    fi
done < "$OUT_FILE"
