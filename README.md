# Token, Presale, Airdrop and Pool - smart contracts and website
1. Edit .secret and put there a wallet mnemonic phrase (24 words) - you need to have some gas on it
2. Register on polygonscan.com, bscscan.com and create a new API keys
3. Edit .apikey_* files and add your api keys on the first line of each file (* means block explorer name, e.g.: polygonscan, bscscan ...)
4. edit ./migrations/2_deploy_contracts.js and set variables
5. edit ./web/build.sh and set a different web root where you'd like to deploy your web page
6. Install dependencies and run deploy script:
```console
yarn install
./deploy.sh
```

# Used dependencies
- Truffle v5.4.26 (core: 5.4.26)
- Solidity - ^0.8.11 (solc-js)
- Node v16.13.1
- NPM 8.3.0
- Web3.js v1.5.3
- Yarn 1.22.17

# Web page
You can also build web page manualy without deploying new smart contracts using:
1. Edit ./web/build.sh and set a different web root where you'd like to deploy your web page if needed
2. Build and deploy web page: 
```console
cd ./web
./build.sh
```
