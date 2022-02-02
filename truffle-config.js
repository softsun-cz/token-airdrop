const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
const api_key_bscscan = fs.readFileSync(".apikey_bscscan").toString().trim();
const api_key_polygonscan = fs.readFileSync(".apikey_polygonscan").toString().trim();
const api_key_avax = fs.readFileSync(".apikey_avax").toString().trim();
const api_key_optimism = fs.readFileSync(".apikey_optimism").toString().trim();
const api_key_fantom = fs.readFileSync(".apikey_ftmscan").toString().trim();
const api_key_hecoinfo = fs.readFileSync(".apikey_hecoinfo").toString().trim();

module.exports = {
  networks: {
    polygonTestnet: {
      //provider: () => new HDWalletProvider(mnemonic, `https://rpc-mumbai.matic.today`),
      provider: () => new HDWalletProvider(mnemonic, `https://matic-mumbai.chainstacklabs.com`),
      //provider: () => new HDWalletProvider(mnemonic, `https://rpc-mumbai.maticvigil.com`),
      //provider: () => new HDWalletProvider(mnemonic, `https://matic-testnet-archive-rpc.bwarelabs.com`),
      network_id: 80001,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    polygonMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://polygon-rpc.com`),
      //provider: () => new HDWalletProvider(mnemonic, `https://rpc-mainnet.matic.network`),
      //provider: () => new HDWalletProvider(mnemonic, `https://matic-mainnet.chainstacklabs.com`),
      //provider: () => new HDWalletProvider(mnemonic, `https://rpc-mainnet.maticvigil.com`),
      //provider: () => new HDWalletProvider(mnemonic, `https://rpc-mainnet.matic.quiknode.pro
      //provider: () => new HDWalletProvider(mnemonic, `https://matic-mainnet-full-rpc.bwarelabs.com`),
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
    avaxTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://api.avax-test.network/ext/bc/C/rpc`),
      network_id: 43113,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    avaxMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://api.avax.network/ext/bc/C/rpc`),
      network_id: 43114,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    optimismTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://kovan.optimism.io/`),
      network_id: 69,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    optimismMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://mainnet.optimism.io`),
      network_id: 10,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    fantomTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://rpc.testnet.fantom.network/`),
      network_id: 4002,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    fantomMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://rpc.ftm.tools/`),
      network_id: 250,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    hecoTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://http-testnet.hecochain.com/`),
      network_id: 256,
      confirmations: 1,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    hecoMainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://http-mainnet.hecochain.com/`),
      network_id: 128,
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
    polygonscan: api_key_polygonscan,
    snowtrace: api_key_avax,
    optimistic_etherscan: api_key_optimism,
    ftmscan: api_key_fantom,
    hecoinfo: api_key_hecoinfo
  }
}
