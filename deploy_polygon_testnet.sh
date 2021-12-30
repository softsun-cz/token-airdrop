LOG=log_polygon_testnet.txt
BUILD=build/
NETWORK=polygonTestnet

if [ -d "$BUILD" ]; then
 echo "Removing old builds ..."
 rm -r $BUILD
fi
if [ -f "$LOG" ]; then
 echo "Removing old log file: $LOG"
 rm $LOG
fi
truffle deploy --network $NETWORK 2>&1 | tee $LOG