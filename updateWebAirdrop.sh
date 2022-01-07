#!/bin/sh

if [ "$#" -eq 0 ]; then
  echo ""
  echo "----------------------------"
  echo "Airdrop contract web changer"
  echo "----------------------------"
  echo ""
  echo "This script changes smart contract address on web source and then builds and deploy it."
  echo ""
  echo "Usage: $0 [CONTRACT ADDRESS]"
  echo "Example: $0 0x1234567890123456789012345678901234567890"
  echo ""
  exit 1
fi

sed -i '/addressAirdrop/c\        addressAirdrop: '\'$1\'',' ./web/src/config.ts
cd web
./build.sh
cd ..
