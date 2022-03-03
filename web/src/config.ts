
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
        addressToken: '0xfba6C30c2cE422806fa089f4E7E5E33Ce4cB30d1',
        addressAirdrop: '0xCB1bB5DCc2924fB64733b900A509Bda2e8BC8e90',
        addressPresale: '0xFf6Fd035a4423C577A5B6649a6AD1ed2D2519c99',
        addressPool: '0x7729da691E115381C9aA41870A98b72bA704e81E',
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
            "function totalClaimableNotDeducted () view returns (uint)",
            "function getLiquidityTokenOur () view returns (uint)",
            "function getLiquidityTokenTheir () view returns (uint)",
            "function getBalanceTokenOur () view returns (uint)",
            "function getBalanceTokenTheir () view returns (uint)",
            "function tokenOur () view returns (uint)",
            "function tokenTheir () view returns (uint)",
            "function claimedCount () view returns (uint)",
            "function depositedCount () view returns (uint)",
            "function tokenPricePresale () view returns (uint)",
            "function tokenPriceLiquidity () view returns (uint)",
            "function getPresaleTokenTheirMax () view returns (uint)",
            "function totalDeposited () view returns (uint)",
            "function totalClaimed () view returns (uint)",
            "function totalClaimable () view returns (uint)",
            "function startTime () view returns (uint)",
            "function claimTimeOut () view returns (uint)",
            "function depositTimeOut () view returns (uint)",
            "function claimed(address) view returns (uint)",
            "function claimable(address) view returns (uint)",
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