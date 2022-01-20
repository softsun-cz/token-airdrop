
export class Config {
    public static main = {
        project: 'Test Token Airdrop',
        description: 'Claim your Test tokens!',
        updateInterval: 30,
       
        // network: 'https://rpc-mainnet.matic.quiknode.pro', // Polygon (MATIC) - Mainnet
        // explorer: 'https://polygonscan.com/', // Polygon (MATIC) - Mainnet
        // chainID: '137',
        networkName: "Polygon (MATIC) - Testnet",
        network: 'https://matic-mumbai.chainstacklabs.com', // Polygon (MATIC) - Testnet,
        nativeCurrency: {
            name: "MATIC",
            symbol: "MATIC",
            decimals: 18
        },
        explorer: 'https://mumbai.polygonscan.com/', // Polygon (MATIC) - Testnet
        chainID: 80001,
        getHexChainId() : string{
            return "0x" +Config.main.chainID.toString(16);
        },       
        addressToken: "0x9b6452d8EE8B79605F3F73d04F5f43D7A9Df59A3",
        addressAirdrop: '0x86541beBa4888f306fb47bc7064314d638Cb4B14',
        addressPresale: '0x4bF75Ae2C99754AA783e39363e2Db201956809AE',
        addressPool: '0x64Ad4bd154b405D312FF302c5814517405DF58c3',
        airdropContractInterface: [] = [
            "function claimCount () view returns (uint)",
            //"event Transfer(address indexed from, address indexed to, uint amount)",
            "function addressReceived(address) view returns (bool)",
            "function claim()",
            "function amountToClaim () view returns (uint)",
            "function getRemainingTokens () view returns (uint)",
            "function totalClaimed () view returns (uint)",
            "function token () view returns (uint)",
            "function timeOut () view returns (uint)",
        ],
        presaleContractInterface: [] = [
            "function tokenOur () view returns (uint)",
            "function tokenTheir () view returns (uint)",
            "function claimedCount () view returns (uint)",
            "function depositedCount () view returns (uint)",
            "function tokenPricePresale () view returns (uint)",
            "function tokenPriceLiquidity () view returns (uint)",
            "function totalDeposited () view returns (uint)",
            "function totalClaimed () view returns (uint)",
            "function totalClaimable () view returns (uint)",
            "function startTime () view returns (uint)",
            "function claimTimeOut () view returns (uint)",
            "function depositTimeOut () view returns (uint)",
            "function getRemainingTokens () view returns (uint)",
            "function claimed(address) view returns (uint)",
            "function deposited(address) view returns (uint)",
            "function deposit(uint)",
            "function claim()",
            "function devFeePercent() view returns (uint)",
            "function devAddress() view returns (uint)",
        ],
        tokenContractInterface: [] = [
            "function name () view returns (string)",
            "function symbol () view returns (string)",
            "function decimals () view returns (uint)",
            "function allowance (address, address) view returns (uint)",
            "function approve (address, uint)",
            "function totalSupply () view returns (uint)",
            "function balanceOf (address) view returns (uint)",            
        ],
    } 
}