#!/usr/bin/env bash

function parseGenerateArgs()
{
    local generateOptions="-f -c -m -b -e -v -s -k -x -h";
    _GENERATE_DIR=$1;
    _GENERATE_VERSION=${_PHPTT_PHP_VERSION};

    if [ -z "${_GENERATE_DIR}" ] || [[ ${generateOptions} =~ (^|[[:space:]])${_GENERATE_DIR}($|[[:space:]]) ]]; then
        _GENERATE_DIR="$(pwd)";
        _GENERATE_ARGS=$@;
    fi

    if [ ! -d "${_GENERATE_DIR}" ]; then
        displayHelp "Directory ${_GENERATE_DIR} does not exist.";
    fi

    if [ -z "${_GENERATE_ARGS}" ]; then
        shift;
        _GENERATE_ARGS=$@;
    fi
}

function fixGenerateDir()
{
    if [[ ! "${_GENERATE_DIR}" = /* ]]; then
        _GENERATE_DIR="$(pwd)/${_GENERATE_DIR}";
    fi
}

function executeGenerate()
{
    parseGenerateArgs ${_COMMAND_ARGS};
    fixGenerateDir;
    docker run -u php --rm -i -w /usr/src/phpt -v ${_GENERATE_DIR}:/usr/src/phpt phptestfestbrasil/phptt:${_GENERATE_VERSION} \
        php /home/php/phptt/generate-phpt.phar ${_GENERATE_ARGS} | sed "s/php generate-phpt.php /phptt/";
}
