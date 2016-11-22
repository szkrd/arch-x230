#!/usr/bin/env bash
# moves source to git repo, creates symlink
# TODO: spaces in filenames?
test -h "$1" && echo Already a symlink && exit 1
SRC=$(realpath "$1")
REPO_ROOT=~/projects/arch-x230/src
cp --parents $SRC $REPO_ROOT
chown szabi:szabi $REPO_ROOT$SRC
OWNER=`ls -ld $SRC | awk '{print $3}'`
if [ "$OWNER" == "szabi" ]
then
  echo This file is mine, I\'ll symlink it back.
  rm $SRC
  ln -s $REPO_ROOT$SRC $SRC
  ls -la $SRC
fi
