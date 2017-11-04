#!/usr/bin/env bash
_YELLOW='\033[1;33m' # yellow color
_GREEN='\033[0;32m' # green color
_NC='\033[0m' # no color

printf "PHPTT installer started ...\n";

printf "Step 1: cloning the repository to ${_YELLOW}$HOME/.phptt/bin/phptt.sh${_NC}\n";
if [ -d "$HOME/.phptt" ]; then
    rm -rf $HOME/.phptt;
fi
git clone https://github.com/PHPTestFestBrasil/phptt $HOME/.phptt;

printf "Step 2: linking files \n"

files=("phptt-generate" "phptt-lcov" "phptt-test" "phptt");

for ((x=0; x < ${#files[*]}; x++)) ; do
    printf "* ${_YELLOW} "${files[$x]}"${_NC} to ${_YELLOW}/usr/local/bin/${files[$x]}${_NC} ...\n";
    if [ -L "/usr/local/bin/${files[$x]}" ] ; then
        rm "/usr/local/bin/${files[$x]}";
    fi
    ln -s "$HOME/.phptt/bin/${files[$x]}.sh" "/usr/local/bin/${files[$x]}";
done


printf "Step 3: applying exec permissions ...\n";
for ((x=0; x < ${#files[*]}; x++)) ; do
    chmod +x "/usr/local/bin/${files[$x]}";
    printf "${_GREEN}Success! ${_NC}The ${_YELLOW}${files[$x]}${_NC} command was added to your ${_YELLOW}/usr/local/bin${_NC} folder and can be used globally.\n";
done


#print "${_YELLOW}phptt.sh${_NC} to ${_YELLOW}/usr/local/bin/phptt${_NC} ...\n";
#if [ -L "/usr/local/bin/phptt" ] ; then
#    rm /usr/local/bin/phptt;
#fi
#ln -s $HOME/.phptt/bin/phptt.sh /usr/local/bin/phptt;
#
#printf "Step 3: applying exec permissions ...\n";
#chmod +x /usr/local/bin/phptt;
#
#printf "${_GREEN}Success! ${_NC}The ${_YELLOW}phptt${_NC} command was added to your ${_YELLOW}/usr/local/bin${_NC} folder and can be used globally.\n";