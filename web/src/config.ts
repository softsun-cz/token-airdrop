
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
        tokenContractInterface: [] = [
            "function name () view returns (string)",
            "function symbol () view returns (string)",
            "function decimals () view returns (uint)",
            "function allowance (address, address) view returns (uint)",
            "function approve (address, uint)",
        ],
        addressPresale: '0x0B3A051D9E698CA763327F749d2870Be0Ef73d90',
        presaleContractInterface: [] = [
            "function tokenOur () view returns (uint)",
            "function tokenTheir () view returns (uint)",
            "function claimedCount () view returns (uint)",
            "function depositedCount () view returns (uint)",
            "function tokenPrice () view returns (uint)",
            "function totalDeposited () view returns (uint)",
            "function totalClaimed () view returns (uint)",
            "function startTime () view returns (uint)",
            "function claimTimeOut () view returns (uint)",
            "function depositTimeOut () view returns (uint)",
            "function getRemainingTokens () view returns (uint)",
            "function claimed(address) view returns (uint)",
            "function deposited(address) view returns (uint)",
            "function deposit(uint)",
            "function claim()",
        ],
    } 
}