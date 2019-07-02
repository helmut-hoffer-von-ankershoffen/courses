#!/usr/bin/env bash

echo "Extracting files from latest archive automatically ..."

for path in $(echo $BORGBACKUP_EXTRACT_AUTO_PATHS | sed "s/,/ /g")
do
    echo "Extracting $path ..."
    borg-backup extract-files-latest $path
    echo "Extracting $path done."
done

echo "Extracting files from latest archive automatically done."
