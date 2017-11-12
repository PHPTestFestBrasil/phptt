#!/usr/bin/env bash

set -e
set -o pipefail

[[ $DEBUG ]] && set -x

REPO_URL="https://github.com/PHPTestFestBrasil/phptt"
REPO_DEST="${HOME}/.phptt2"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"

indent()
{
    sed "#^#    #"
}

phptt_clone()
{
	echo "Step 1: cloning the repository to $REPO_DEST"
	if [ -d $REPO_DEST ]
	then
	    rm -rf $REPO_DEST
	fi
	git clone $REPO_URL $REPO_DEST 2>&0 | indent
	pushd $REPO_DEST
}

phptt_link()
{
	echo "Step 2: linking files "
	for f in "phptt-generate" "phptt-lcov" "phptt-test" "phptt"
	do
	    pushd ${REPO_DEST}/bin
	    file_source="$(pwd)/${f}"
	    file_destination="${BIN_DIR}/${f}"
	    directory_destination=$(dirname $file_destination)
	    echo "*  "${file_source}" to ${file_destination} ..."
	    if [ ! -w "$directory_destination" ]
	    then
		echo "ERROR! $directory_destination is not writable."
		echo "You can use BIN_DIR variable to tell us where you want to install."
		exit 2
	    fi
	    if [ -L "${file_destination}" -o -f "${file_destination}" ]
	    then
		rm "${file_destination}"
	    fi
	    ln -s "${file_source}.sh" "${file_destination}"
	    chmod a+x "${file_destination}"
	    popd
	done
}

echo "PHPTT installer started ..."
phptt_clone | indent
phptt_link | indent
