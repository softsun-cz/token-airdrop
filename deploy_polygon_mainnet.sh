#!/bin/sh

rm -r build/contracts/
rm out_polygon_mainnet.txt
truffle deploy --network polygonMainnet 2>&1 | tee out_polygon_mainnet.txt
truffle run verify Token Airdropper --network polygonMainnet

