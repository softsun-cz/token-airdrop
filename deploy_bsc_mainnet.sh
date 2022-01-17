#!/bin/sh

LOG=log_bsc_mainnet.txt
BUILD=build/
NETWORK=bscMainnet

if [ -d "$BUILD" ]; then
 echo "Removing old builds ..."
 rm -r $BUILD
fi
if [ -f "$LOG" ]; then
 echo "Removing old log file: $LOG"
 rm $LOG
fi
truffle deploy --network $NETWORK 2>&1 | tee $LOG