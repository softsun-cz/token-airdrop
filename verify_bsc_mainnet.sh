#!/bin/sh

if [ "$#" -eq 0 ]; then
  echo ""
  echo "---------------------------------"
  echo "Solidity source code verification"
  echo "---------------------------------"
  echo ""
  echo "This script publishes smart contract source code to blockchain explorer."
  echo ""
  echo "Usage: $0 [CONTRACT NAME 1] [CONTRACT NAME 2] ..."
  echo "Example: $0 Token Presale Airdrop Pool"
  echo ""
  exit 1
fi
truffle run verify $@ --network bscMainnet | tee -a ./log_bsc_mainnet.txt