#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_FILE=$SCRIPT_DIR/updates.txt
WATCH_FILE=$SCRIPT_DIR/watch.txt
source ~/.config/bashscripts/sshTarget.sh

find ~/.config -type d -name ".git" -prune | sed  -e 's|\.git$||' -e 's|^\.||' > "$OUT_FILE"

if [[ -f "$WATCH_FILE" ]]; then
    while IFS= read -r path;
    do
        if ! grep -qF "$path" "$OUT_FILE"; then
            echo "$path" >> "$OUT_FILE"
        fi
    done < "$WATCH_FILE"
fi

while IFS= read -r path;
do
    cd "$path" || { echo "Unable to cd to $path"; continue; }
    git pull > /dev/null 2>&1
    if git status --porcelain | grep -q .; then
        git add .
        git commit -m "Auto-update $(date +"%d-%m-%y")" > /dev/null 2>&1
        git push > /dev/null 2>&1
        if [[ "$path" == *".config"* ]]; then
            rsync -r "$path" "$TARGET_SSH"
        fi
        echo "Auto pushed updates for $path"
    else
        echo "No updates for $path"
    fi
done < "$OUT_FILE"
