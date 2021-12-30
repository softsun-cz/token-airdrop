import {AbiItem} from 'web3-utils';

export class Config {
    public static main = {
        project: 'Test Token Airdrop',
        description: 'Claim your Test tokens!',
        updateInterval: 30,
       
        // network: 'https://rpc-mainnet.matic.quiknode.pro', // Polygon (MATIC) - Mainnet
        // explorer: 'https://polygonscan.com/', // Polygon (MATIC) - Mainnet
        // chainID: '137',
       
        network: 'https://matic-mumbai.chainstacklabs.com', // Polygon (MATIC) - Testnet
        explorer: 'https://mumbai.polygonscan.com/', // Polygon (MATIC) - Testnet
        chainID: '80001',
       
        addressAirdrop: '0x8B8C03041B87DFA7afDe85487A98FC0519734877',
        airdropAbi:  Array<AbiItem>(
            { "constant": false, "inputs": [], "name": "amountOfTokens", "outputs": [{ "name": "_value", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, 
            { "constant": false, "inputs": [], "name": "remainingTokens", "outputs": [{ "name": "_value", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, 
            { "constant": false, "inputs": [], "name": "totalClaimed", "outputs": [{ "name": "_value", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, 
            { "constant": true, "inputs": [], "name": "token", "outputs": [{ "name": "_value", "type": "address" }], "payable": false, "stateMutability": "view", "type": "function" }, 
        ),
        addressTokenTax: '0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D',
        tokenTexAbi:  Array<AbiItem>(
            { "constant": true, "inputs": [], "name": "decimals", "outputs": [{ "name": "_value", "type": "uint8" }], "payable": false, "stateMutability": "view", "type": "function" }, 
        ),
    } 
}