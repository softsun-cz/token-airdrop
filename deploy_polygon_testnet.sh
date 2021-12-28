#!/bin/sh

rm -r build/contracts/
rm out_polygon_testnet.txt
truffle deploy --network polygonTestnet 2>&1 | tee out_polygon_testnet.txt
truffle run verify Token Airdropper --network polygonTestnet

