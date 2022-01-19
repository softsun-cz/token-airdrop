
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
        tokenAddress: "0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D",
        addressAirdrop: '0x0f74d838E9d2543735CB10eEbDE1f9ec43C049ce',
        addressPresale: '0x25C09269511043bdAD578242245B87E30aF5603F',
        addressPool: '0xF8D6aB0Ccc2459AaeA156ec7818DF2c61e0d3a83',
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
            "function tokenPrice () view returns (uint)",
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