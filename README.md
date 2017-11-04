# phptt
phptt a.k.a php test tools

Heavilly inspired on [herdphp/phpqa](https://github.com/herdphp/docker-phpqa).

## What is phptt

phptt aims to follow PHP versions listed in http://gcov.php.net/ . Those PHP versions target git branches in php source code repository (https://github.com/php/php-src/branches and http://php.net/git.php) instead of released (http://www.php.net/downloads.php) or tagged ones (i.e. https://downloads.php.net/~pollita/).

phptt updates all its Docker images via a cron job which is run via Travis CI that is configured in GitHub repository. That cron job runs at least once a day automatically. This way, as long as you maintain your phptt binary updated in your machine (executing `phptt update`), you'll be at most one day late with latest PHP versions.

## What is the differences between phptt and herdphp/phpqa?

herdphp/phpqa tries to follow PHP versions that are released or tagged versions of PHP plus master/HEAD. The issue is that there's no automatic process providing every day upgraded Docker images. Because of this you can pass a longer time unsynced with new PHP versions until a person process new Docker images and notice users.

## Usage

```shell
phptt help

phptt a.k.a php test tools
GENERAL usage:
    phptt help ....................... Display this help message
    phptt update ..................... Update scripts and Docker images
GENERATING usage:
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
    -h ............................... Print this message
TESTING usage:
    phptt test <path/to/test.phpt|suite> [<version>] ... Run tests
    phptt lcov <path/to/test.phpt|suite> [<version>] ... Run tests and generate GCOV/LCOV report
```

## Install

```shell
#Step 1: cloning the repository
if [ -d "$HOME/.phptt" ]; then
    rm -rf $HOME/.phptt;
fi
git clone https://github.com/PHPTestFestBrasil/phptt $HOME/.phptt;

#Step 2: linking into /usr/local/bin/
if [ -L "/usr/local/bin/phptt" ] ; then
    rm /usr/local/bin/phptt;
fi
ln -s $HOME/.phptt/bin/phptt.sh /usr/local/bin/phptt;

#Step 3: applying exec permissions
chmod +x /usr/local/bin/phptt;

#Success! phptt command was added to your /usr/local/bin/ and can be used globally
```