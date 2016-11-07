#!/usr/bin/env bash
# moves source to git repo, creates symlink
# TODO: spaces in filenames?
test -h "$1" && echo Already a symlink && exit 1
SRC=$(realpath "$1")
REPO_ROOT=~/projects/arch-x230/src
cp --parents $SRC $REPO_ROOT
rm $SRC
ln -s $REPO_ROOT$SRC $SRC
ls -la $SRC
