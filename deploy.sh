#!/bin/bash

NETWORKS=`node deploy-networks.js`
echo ''
echo '---------------------------'
echo 'List of available networks:'
echo '---------------------------'
echo ''
parser=' ' read -r -a array <<< $NETWORKS
array=($NETWORKS)
for i in "${!array[@]}"
do
    echo [$((i + 1))] - ${array[$i]}
done
echo ''
echo 'Select the network where would you like to deploy your contracts (default: [1]):'
read net

echo 'Deploying on:' ${array[$((net - 1))]}