#!/usr/bin/env bash

set -ex

GIT_DIR="$(git rev-parse --show-toplevel)"

activeSource="$GIT_DIR/pyfunceble/domains/ACTIVE/list"
inactiveSource="$GIT_DIR/pyfunceble/domains/INACTIVE/list"
invalidSource="$GIT_DIR/pyfunceble/domains/INVALID/list"

## Active Records
if [ -r "${activeSource}" ]; then
    echo "Cleaning up the source files"
    sed -i "/^#/d;/^$/d" "$activeSource"
    jq -R -s -c 'split("\n")' <"$activeSource" | jq '.[:-1]' >"$GIT_DIR/active_records.json"
    echo "Delicious a fresh and updated list of active domains"

else
    echo "Did not find any source file, are you sure @PyFunceble did right?"
    echo "Stopping the process as you encountered an source error"
    exit 1
fi

## INactive records
if [ -r "$inactiveSource" ]; then
    echo "Cleaning up the source files"
    sed -i "/^#/d;/^$/d" "$inactiveSource"
    jq -R -s -c 'split("\n")' <"$inactiveSource" | jq '.[:-1]' >"$GIT_DIR/dead_records.json" &&
        echo "Perfect, the list of dead records is up to date"
    echo "You should had run PyFunceble earlier..."

else
    echo "Perfect: No INACTIVE records found"
fi

## Invalid records
if [ -r "$invalidSource" ]; then
    echo "Cleaning up the source files"
    sed -i "/^#/d;/^$/d" "$invalidSource"
    jq -R -s -c 'split("\n")' <"$invalidSource" | jq '.[:-1]' >"$GIT_DIR/invalid_records.json" &&
        echo "Perfect, the list of dead records is up to date"
else
    echo "but haed, plants of typppooosss thiiiss time"
    el
fi
