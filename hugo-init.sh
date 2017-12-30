#!/bin/bash
BASE_BRANCH=hugo

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
        cp common/.gitignore .
        git add .gitignore
        git commit .gitignore -m "init commit (.gitignore)"
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

doOrphanCheckout gh-pages
doOrphanCheckout content
git worktree add public gh-pages
git worktree add content content
addIgnoreItem "/public"
addIgnoreItem "/content"
