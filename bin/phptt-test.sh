#!/usr/bin/env bash

function parseTestArgs()
{
    _TEST_FILE_PATH=$1
    _TEST_VERSION=$2;

    if [ -z "${_TEST_FILE_PATH}" ] || ([ ! -f "${_TEST_FILE_PATH}" ] && [ ! -d "${_TEST_FILE_PATH}" ] && [ ! "${_TEST_FILE_PATH}" = "suite" ]); then
        displayHelp "You need to provide a phpt or a directory with phpt files to be tested or pass \`suite\` as first parameter to run the full test suite.";
    fi

    if [ -z "${_TEST_VERSION}" ]; then
        _TEST_VERSION=${_PHPTT_PHP_VERSION};
    elif [ "${_TEST_VERSION}" != "PHP_HEAD" ] && [ "${_TEST_VERSION}" != "PHP_7_4" ] && [ "${_TEST_VERSION}" != "PHP_7_3" ] && [ "${_TEST_VERSION}" != "PHP_7_2" ] && [ "${_TEST_VERSION}" != "PHP_7_1" ]; then
        displayHelp "The versions supported are PHP_7_1, PHP_7_2, PHP_7_3, PHP_7_4, PHP_HEAD or all to run in all available versions.";
    fi
}

function executeTestSuite()
{
    docker run -u php --rm -i phptestfestbrasil/phptt:${_TEST_VERSION} make test;
    exit 0;
}

function fixTestPath()
{
    _TEST_FILENAME=${_TEST_FILE_PATH##*/};
    if [[ ! "${_TEST_FILE_PATH}" = /* ]]; then
        _TEST_FILE_PATH="$(pwd)/${_TEST_FILE_PATH}";
    fi
    _TEST_FILE_DIR=$(dirname "${_TEST_FILE_PATH}");
}

function singleTest()
{
    mkdir -p ${_TEST_FILE_DIR}/${_TEST_VERSION}/;
    cp -r ${_TEST_FILE_PATH} ${_TEST_FILE_DIR}/${_TEST_VERSION}/;
    docker run -u php --rm -i \
        -v ${_TEST_FILE_DIR}/${_TEST_VERSION}/:/usr/src/phpt/ \
        phptestfestbrasil/phptt:${_TEST_VERSION} \
        make test TESTS=/usr/src/phpt/${_TEST_FILENAME} \
        | sed -e "s/Build complete./Test build successfully./" -e "s/Don't forget to run 'make test'./=\)/";
}

function executeTest()
{
    parseTestArgs ${_COMMAND_ARGS};

    if [ "${_TEST_VERSION}" = "all" ]; then
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_HEAD;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_4;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_3;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_2;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_1;
        exit 0;
    fi

    if [ "${_TEST_FILE_PATH}" = "suite" ]; then
        executeTestSuite;
    fi

    fixTestPath;
    singleTest;
}
