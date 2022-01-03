#!/bin/sh

#if [ "$#" -eq 0 ]; then
#  echo ""
#  echo "------------------------"
#  echo "Git commit & push script"
#  echo "------------------------"
#  echo ""
#  echo "This script commits changes and pushes it on GitHub."
#  echo ""
#  echo "Usage: $0 \"[SOME COMMENT]\""
#  echo "Example: $0 \"Add README.md\""
#  echo ""
#  exit 1
#fi

git status
git add *
git status
git commit -m "-"
git push https://softsun-cz@github.com/softsun-cz/token-airdrop.git
git status
