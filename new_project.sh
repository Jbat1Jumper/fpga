#!/usr/bin/bash
set -ex
PROJECT_NAME="$1" # FIRST ARG

rm -fr __project_template__/*
git checkout __project_template__
rm -fr "$PROJECT_NAME"
cp -r __project_template__ "$PROJECT_NAME"

for f in ./$PROJECT_NAME/__project_template__.*; do
    mv "$f" "$(echo "$f" | sed s/__project_template__/$PROJECT_NAME/)";
done

for f in ./$PROJECT_NAME/*; do
    if [[ -d "$f" ]]; then
        echo "Skipping directory"
    else
        sed -i "s/__project_template__/$PROJECT_NAME/g" "$f"
    fi
done


