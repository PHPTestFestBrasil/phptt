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
curl -s https://git.io/phptt-install | bash

# https://git.io/phptt-install points to https://raw.githubusercontent.com/PHPTestFestBrasil/phptt/master/bin/install.sh
```

## Docker images

Docker images are available on https://github.com/phptestfestbrasil/docker-phptt

[![Docker Starts](https://img.shields.io/docker/stars/phptestfestbrasil/phptt.svg)](https://hub.docker.com/r/phptestfestbrasil/phptt/)
[![Docker Pulls](https://img.shields.io/docker/pulls/phptestfestbrasil/phptt.svg)](https://hub.docker.com/r/phptestfestbrasil/phptt/)
[![Docker Automated build](https://img.shields.io/docker/automated/phptestfestbrasil/phptt.svg)](https://hub.docker.com/r/phptestfestbrasil/phptt/)
[![Docker Build Status](https://img.shields.io/docker/build/phptestfestbrasil/phptt.svg)](https://hub.docker.com/r/phptestfestbrasil/phptt/)

<hr>

### PHP Versions (linked to https://github.com/php/php-src branches)

- PHP_HEAD: [![](https://images.microbadger.com/badges/image/phptestfestbrasil/phptt:PHP_HEAD.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/phptestfestbrasil/phptt:PHP_HEAD.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own version badge on microbadger.com")
- PHP_7_2: [![](https://images.microbadger.com/badges/image/phptestfestbrasil/phptt:PHP_7_2.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/phptestfestbrasil/phptt:PHP_7_2.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own version badge on microbadger.com")
- PHP_7_1: [![](https://images.microbadger.com/badges/image/phptestfestbrasil/phptt:PHP_7_1.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/phptestfestbrasil/phptt:PHP_7_1.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own version badge on microbadger.com")
- PHP_7_0: [![](https://images.microbadger.com/badges/image/phptestfestbrasil/phptt:PHP_7_0.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/phptestfestbrasil/phptt:PHP_7_0.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own version badge on microbadger.com")
- PHP_5_6: [![](https://images.microbadger.com/badges/image/phptestfestbrasil/phptt:PHP_5_6.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/phptestfestbrasil/phptt:PHP_5_6.svg)](https://microbadger.com/images/phptestfestbrasil/phptt:PHP_HEAD "Get your own version badge on microbadger.com")
