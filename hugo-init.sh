#!/bin/bash

#
# Usage:
#
# GH_PAGES_BRANCH default: gh-pages
# GH_PAGES_BRANCH default: master (xxx.github.io)
#
# $ GH_PAGES_BRANCH=abc ./hugo-init.sh # if you want to identify public branch
#

REPO_NAME=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename $REPO_NAME)
echo $REPO_NAME
if [[ $REPO_NAME =~ .*.github.io ]]
then
    DEFAULT_GH_PAGES_BRANCH=master
else
    DEFAULT_GH_PAGES_BRANCH=gh-pages
fi

BASE_BRANCH=hugo
GH_PAGES_BRANCH=${GH_PAGES_BRANCH:-$1}
GH_PAGES_BRANCH=${GH_PAGES_BRANCH:-$DEFAULT_GH_PAGES_BRANCH}

function doOrphanCheckout { # $1 branch
    git checkout origin/$1 -b $1
    if [ $? -eq 0 ]
    then
        git checkout $BASE_BRANCH
        return
    fi
    git checkout --orphan $1
    if [ $? -eq 0 ]
    then
        git checkout $BASE_BRANCH
    fi
}

function addIgnoreItem {
    grep ^$1$ .gitignore
    if [ $? -ne 0 ]
    then
    	echo "# ignore document site item..." >> .gitignore
    	echo $1 >> .gitignore
        git add .gitignore
        git commit .gitignore -m "ignore document site item:"$1
    fi
}

echo GH_PAGES_BRANCH: $GH_PAGES_BRANCH

doOrphanCheckout $GH_PAGES_BRANCH
git worktree add public $GH_PAGES_BRANCH
addIgnoreItem "/public"
