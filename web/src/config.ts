
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
        chainID: 80001,
       
        addressAirdrop: '0xe358295E0Ffd36D381081ADc4D699eFce4ab9d18',
        airdropContractInterface: [] = [
            "function airdropsCount () view returns (uint)",
            //"event Transfer(address indexed from, address indexed to, uint amount)",
            "function addressReceived(address) view returns (bool)",
            "function airdrop()",
            "function amountOfTokens () view returns (uint)",
            "function remainingTokens () view returns (uint)",
            "function totalClaimed () view returns (uint)",
            "function token () view returns (uint)",
        ],
        tokenTaxContractInterface: [] = [
            "function name () view returns (string)",
            "function symbol () view returns (string)",
            "function decimals () view returns (uint)",
        ]
    } 
}