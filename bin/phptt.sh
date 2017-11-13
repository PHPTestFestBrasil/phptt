#!/usr/bin/env bash

_YELLOW='\033[1;33m' # yellow color
_GREEN='\033[0;32m' # green color
_NC='\033[0m' # no color

_PHPTT_PHP_VERSION=PHP_HEAD;

_REPO_URL="https://github.com/PHPTestFestBrasil/phptt"
_REPO_DEST="${HOME}/.phptt2"
_BIN_DIR="${BIN_DIR:-/usr/local/bin}"

function displayError()
{
    local exitError=$1;
    printf "Error: ${exitError}\n\n";
}

function displayHelp()
{
    local exitError=$1;
    if [ -z "${exitError}" ]; then
        exitCode=0;
    fi

    if [ "${exitCode}" != "0" ]; then
        displayError "${exitError}";
    fi

    printf "${_GREEN}phptt a.k.a php test tools${_NC}\n";
    printf "${_YELLOW}GENERAL usage${_NC}:
    phptt help ....................... Display this help message
    phptt update ..................... Update scripts and Docker images\n";
    printf "${_YELLOW}GENERATING usage${_NC}:
    phptt generate [PHPT_DIR] -f <function_name> |-c <class_name> -m <method_name> -b|e|v [-s skipif:ini:clean:done] [-k win|notwin|64b|not64b] [-x ext]
    Where:
    -f function_name ................. Name of PHP function, eg cos
    -c class name .................... Name of class, eg DOMDocument
    -m method name ................... Name of method, eg createAttribute
    -b ............................... Generate basic tests
    -e ............................... Generate error tests
    -v ............................... Generate variation tests
    -s sections....................... Create optional sections, colon separated list
    -k skipif key..................... Skipif option, only used if -s skipif is used.
    -x extension...................... Skipif option, specify extension to check for
    -h ............................... Print this message\n";
    printf "${_YELLOW}TESTING usage${_NC}:
    phptt test <path/to/test.phpt|suite> [<version>] ... Run tests
    phptt lcov <path/to/test.phpt|suite> [<version>] ... Run tests and generate GCOV/LCOV report\n";

    exit ${exitCode};
}

function updateAll()
{
    printf "${_YELLOW}[Update 1/3]${_NC} Updating phptt scripts...\n"
    CWD=$(pwd) \
        && cd ${_REPO_DEST} \
        && git pull &>/dev/null \
        && cd $CWD;
    printf "${_GREEN}[Update 1/3]${_NC} Scripts updated!\n"
    printf "${_YELLOW}[Update 2/3]${_NC} Updating phptt Docker images...\n"
    echo \
            phptestfestbrasil/phptt:PHP_HEAD \
            phptestfestbrasil/phptt:PHP_7_2 \
            phptestfestbrasil/phptt:PHP_7_1 \
            phptestfestbrasil/phptt:PHP_7_0 \
            phptestfestbrasil/phptt:PHP_5_6 \
            | xargs -P10 -n1 docker pull &>/dev/null;
    printf "${_GREEN}[Update 2/3]${_NC} Docker images updated!\n"
    printf "${_YELLOW}[Update 3/3]${_NC} Removing old Docker images ...\n"
    docker container prune \
        && docker rmi $(docker images -f "dangling=true" -q) &>/dev/null;
    printf "${_GREEN}[Update 3/3]${_NC} Old Docker images removed!\n"
    printf "${_GREEN}Your phptt is now fully updated.${_NC}\n"

    exit 0;
}

function parseArgs()
{
    _COMMAND=$1;
    if [ -z "${_COMMAND}" ] || [ "${_COMMAND}" = "help" ]; then
        displayHelp;
    fi

    _COMMAND=$1;
    if [ "${_COMMAND}" = "update" ]; then
        updateAll;
    fi

    if [ "${_COMMAND}" != "test" ] && [ "${_COMMAND}" != "generate" ] && [ "${_COMMAND}" != "help" ] && [ "${_COMMAND}" != "lcov" ]; then
        displayHelp "Unrecognized command ${_COMMAND}.";
    fi

    shift;
    _COMMAND_ARGS=$@;
}

function executeCommand()
{
    local command=$1;
    local commandFunction="$(tr a-z A-Z <<< ${command:0:1})${command:1}";
    pushd `dirname $0` > /dev/null
    SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
    popd > /dev/null

    printf "$SCRIPTPATH";
    printf "$0";
    source $SCRIPTPATH/phptt-${command}
    "execute${commandFunction}" ${_COMMAND_ARGS};

}

function main()
{
    parseArgs $@;
    executeCommand ${_COMMAND};
}

main $@;
