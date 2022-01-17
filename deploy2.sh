#!/bin/bash

BUILD=build/
LOG=deploy.log
NETWORKS=`node deploy-networks.js`
echo ''
echo '---------------------------'
echo 'List of available networks:'
echo '---------------------------'
echo ''
parser=' ' read -r -a array <<< $NETWORKS
ARRAY=($NETWORKS)
for i in "${!ARRAY[@]}"
do
 echo [$((i + 1))] - ${ARRAY[$i]}
done
echo ''
echo 'Select the network where would you like to deploy your contracts (default: [1]):'
read NET
 echo ''
if [ "$NET" = '' ]; then
 NET=1
fi
NETWORK=${ARRAY[$((NET - 1))]}
if [ "$NETWORK" = '' ] || [ "$((NET - 1))" = -1 ]; then
 echo 'Wrong network selected.'
 echo ''
 exit 0
fi
echo 'Deploying on:' $NETWORK '...'
echo ''
if [ -d "$BUILD" ]; then
 echo "Removing old builds ..."
 rm -r $BUILD
fi
truffle deploy --network $NETWORK 2>&1 | tee $LOG