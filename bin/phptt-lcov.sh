#!/usr/bin/env bash

function parseLcovArgs()
{
    _TEST_FILE_PATH=$1
    _TEST_VERSION=$2;

    if [ -z "${_TEST_FILE_PATH}" ] || ([ ! -f "${_TEST_FILE_PATH}" ] && [ ! -d "${_TEST_FILE_PATH}" ] && [ ! "${_TEST_FILE_PATH}" = "suite" ]); then
        displayHelp "You need to provide a phpt or a directory with phpt files or pass \`suite\` as first parameter to run tests and generate GCOV/LCOV report for the full test suite.";
    fi

    if [ -z "${_TEST_VERSION}" ]; then
        _TEST_VERSION=${_PHPTT_PHP_VERSION};
    elif [ "${_TEST_VERSION}" != "PHP_HEAD" ] && [ "${_TEST_VERSION}" != "PHP_7_2" ] && [ "${_TEST_VERSION}" != "PHP_7_1" ] && [ "${_TEST_VERSION}" != "PHP_7_0" ] && [ "${_TEST_VERSION}" != "PHP_5_6" ]; then
        displayHelp "The versions supported are PHP_5_6, PHP_7_0, PHP_7_1, PHP_7_2, PHP_HEAD or all to run in all available versions.";
    fi
}

function executeLcovSuite()
{
    docker run --rm -i -t phptestfestbrasil/phptt:${_TEST_VERSION} make lcov;
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
    docker run --rm -i -t \
        -v ${_TEST_FILE_DIR}/${_TEST_VERSION}/:/usr/src/phpt/ \
        phptestfestbrasil/phptt:${_TEST_VERSION} \
        make lcov TESTS=/usr/src/phpt/${_TEST_FILENAME} \
        | sed -e "s/Build complete./Test build successfully./" -e "s/Don't forget to run 'make lcov'./=\)/";
}

function executeLcov()
{
    parseLcovArgs ${_COMMAND_ARGS};

    if [ "${_TEST_VERSION}" = "all" ]; then
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_HEAD;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_2;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_1;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_7_0;
        $(git rev-parse --show-toplevel)/bin/phptt.sh ${_TEST_FILENAME} PHP_5_6;
        exit 0;
    fi

    if [ "${_TEST_FILE_PATH}" = "suite" ]; then
        executeLcovSuite;
    fi

    fixTestPath;
    singleTest;
}