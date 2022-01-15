# Token, Presale, Airdrop and Pool Smart contract

1. Edit .secret and put there a wallet mnemonic phrase (24 words) - you need to have some gas on it
2. Register on polygonscan.com, bscscan.com and create a new API keys
3. Edit .apikey_* files and add your api keys on the first line of each file (* means block explorer name, e.g.: polygonscan, bscscan ...)
4. > yarn install
5. > edit ./migrations/2_deploy_contracts.js and set variables
6. > ./deploy_[NETWORK NAME]_[NETWORK].sh
7. > ./verify_[NETWORK NAME]_[NETWORK].sh [CONTRACT NAME 1] [CONTRACT NAME 2] ...

# Used dependencies

- Truffle v5.4.26 (core: 5.4.26)
- Solidity - ^0.8.11 (solc-js)
- Node v16.13.1
- NPM 8.3.0
- Web3.js v1.5.3
- Yarn 1.22.17

# Web page:
1. edit ./web/src/config.ts and paste your contract addresses
2. cd ./web
3. ./build.sh

Note: 

edit ./build.sh if you'd like to move the build to different web root