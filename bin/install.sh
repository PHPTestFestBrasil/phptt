#!/usr/bin/env bash

set -e
set -o pipefail

[[ $DEBUG ]] && set -x

REPO_URL="https://github.com/PHPTestFestBrasil/phptt"
REPO_DEST="${HOME}/.phptt2"

echo "PHPTT installer started ..."
echo "Step 1: cloning the repository to $REPO_DEST"
if [ -d $REPO_DEST ]
then
    rm -rf $REPO_DEST
fi
git clone $REPO_URL $REPO_DEST
pushd $REPO_DEST

echo "Step 2: linking files "
for f in "phptt-generate" "phptt-lcov" "phptt-test" "phptt"
do
    pushd bin
    file_source="$(pwd)/${f}"
    file_destination="/usr/local/bin/${f}"
    echo "*  "${file_source}" to ${file_destination} ..."
    if [ -L "${file_destination}" ]
    then
        rm "${file_destination}"
    fi
    ln -s "${file_source}.sh" "${file_destination}"
    chmod a+x "${file_destination}"
    popd
done
