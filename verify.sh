#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Solidity source code verification"
  echo "---------------------------------"
  echo ""
  echo "This script publishes smart contract source code to blockchain explorer."
  echo ""
  echo "Usage: ./verify.sh [CONTRACT NAME] [NETWORK]"
  echo "Example: ./verify.sh Token bscTestnet"
  exit 1
fi
truffle run verify $1 --network $2
