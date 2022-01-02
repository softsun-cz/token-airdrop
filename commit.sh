#!/bin/sh

git status
git add *
git status
git commit -m "$@"
git push
