#!/bin/sh
#https://stackoverflow.com/questions/11258737/restore-git-submodules-from-gitmodules/11258810#11258810
rm -rf lib/*

set -e

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
    while read path_key path
    do
        url_key=$(echo $path_key | sed 's/\.path/.url/')
        url=$(git config -f .gitmodules --get "$url_key")
        git submodule add $url $path
    done
