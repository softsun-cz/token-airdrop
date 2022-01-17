const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
const api_key_bscscan = fs.readFileSync(".apikey_bscscan").toString().trim();
const api_key_polygonscan = fs.readFileSync(".apikey_polygonscan").toString().trim();

module.exports = {
  networks: {
    polygonTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://matic-mumbai.chainstacklabs.com`),
      network_id: 80001,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    polygonMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://rpc-mainnet.matic.quiknode.pro`),
      network_id: 137,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bscTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-1-s1.binance.org:8545`),
      network_id: 97,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bscMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed2.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard BSC port (default: none)
      network_id: "*",       // Any network (default: none)
    },
  },

  mocha: {
  },
  compilers: {
    solc: {
      version: "^0.8.11",
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    bscscan: api_key_bscscan,
    polygonscan: api_key_polygonscan
  }
}
