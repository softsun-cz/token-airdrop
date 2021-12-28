#!/bin/sh

rm -r build/contracts/
rm out_bsc_testnet.txt
truffle deploy --network bscTestnet 2>&1 | tee out_bsc_testnet.txt
truffle run verify Token Airdropper --network bscTestnet

