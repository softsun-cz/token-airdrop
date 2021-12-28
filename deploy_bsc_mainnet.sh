#!/bin/sh

rm -r build/contracts/
rm out_bsc_mainnet.txt
truffle deploy --network bscMainnet 2>&1 | tee out_bsc_mainnet.txt
truffle run verify Token Airdropper --network bscMainnet

