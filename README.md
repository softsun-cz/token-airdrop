# Test token, Airdrop and Presale

1. Edit .secret and put there a wallet mnemonic phrase (24 words) - you need to have some gas on it
2. Register on polygonscan.com, bscscan.com and create a new API keys
3. Edit .apikey_* files and add your api keys on the first line of each file
4. > yarn install
5. > ./deploy_[NETWORK_NAME]_[NETWORK].sh
6. > ./verify.sh [CONTRACT_NAME] [NETWORK]

# Used dependencies

- Truffle v5.4.26 (core: 5.4.26)
- Solidity - ^0.8.11 (solc-js)
- Node v16.13.1
- NPM 8.3.0
- Web3.js v1.5.3
- Yarn 1.22.17

# After deploy and verify

## Token contract:
1. set tax exceptions addresses (for example airdrop contract, presale contract, LP address contract, owner wallet, devs wallet,...)

## Airdrop contract:
1. Send some tokens to this contract
2. Set setTokenAmount (number of tokens in each airdrop)
3. Set setTokenAddress (address of our token)

## Presale contract:
1. Send some tokens to this contract
2. Set devAddress (if other than owner)
3. Set tokenOur (our token address)
4. Set tokenTheir (for example BUSD address)
5. Set setTokenPrice

## Web page:
1. edit ./web/src/config.ts and paste your contract addresses
2. cd ./web
3. ./build.sh

Note: 

edit ./build.sh if you'd like to move the build to different web root