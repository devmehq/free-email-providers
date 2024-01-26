#!/usr/bin/env sh

GIT_DIR="$(git rev-parse --show-toplevel)"

# shellcheck disable=SC2086
activeSource="$(grep -vE '^($|#)' $GIT_DIR/pyfunceble/domains/ACTIVE/list)"
# shellcheck disable=SC2086
inactiveSource="$(grep -vE '^($|#)' $GIT_DIR/pyfunceble/domains/INACTIVE/list)"
# shellcheck disable=SC2086
invalidSource="$(grep -vE '^($|#)' $GIT_DIR/pyfunceble/domains/ACTIVE/list)"

echo "Writing test results to json files."

if [ -f "$activeSource" ]; then
    echo "Did not find any source file, are you sure @PyFunceble did right?"
    echo "Stopping the process as you encountered an source error"
    exit 1
elif [ -r "$activeSource" ]; then
    jq -R -s -c 'split("\n")' <"$activeSource" | jq '.[:-1]' \
        >"$GIT_DIR/active_records.json"
    echo "Delicious a fresh and updated list of active domains"
fi

if [ -f "$inactiveSource" ]; then
    echo "You should had run PyFunceble earlier..."
elif [ ! -f "$inactiveSource" ]; then
    echo "Perfect: No INACTIVE records found"
elif [ -r "$inactiveSource" ]; then
    jq -R -s -c 'split("\n")' <"$inactiveSource" | jq '.[:-1]' \
        >"$GIT_DIR/dead_records.json"
    echo "Perfect, the list of dead records is up to date"
fi

if [ -f "$invalidSource" ]; then
    echo "Well done, plants of typppooosss thiiiss time"
elif [ -r "$invalidSource" ]; then
    jq -R -s -c 'split("\n")' <"$invalidSource" | jq '.[:-1]' \
        >"$GIT_DIR/dead_records.json"
fi
