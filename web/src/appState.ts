import { Config } from "./config";

export class AppState {
    public static tokenName: string = "";
    public static tokenSymbol: string = "";
    public static selectedAddress: string | null = null;
    public static chainId: number | null = null;
    public static airdropRecieved: boolean | null = null;
    public static addressToken: string = "";
    public static walletConnected(): boolean {
        return AppState.selectedAddress != null;
    }
    public static badChainId(): boolean {
        return AppState.selectedAddress != null && this.chainId != Config.main.chainID;
    }
    public static mobileMenuVisible : boolean = false;

    public static getPresale() : IPresale{
        return this.presale;
    }
    public static presale : IPresale = {
        tokenOur : {
            address: "",
            name: "",
            symbol: "",
            decimals: -1
        },
        tokenTheir: {
            address: "",
            name: "",
            symbol: "",
            decimals: -1
        },
        depositedCount: -1,
        claimedCount: -1,
        tokenPrice: -1,
        totalDeposited: -1,
        totalClaimed: -1,
        startTime: -1,
        depositTimeOut: -1,
        claimTimeOut: -1,
        remainingTokens: -1
    }
}

export interface ITokenInterface {
    address: string,
    name: string,
    symbol: string,
    decimals: number
}

export interface IPresale {
    tokenOur : ITokenInterface,
    tokenTheir: ITokenInterface,
    depositedCount: number,
    claimedCount: number,
    tokenPrice: number,
    totalDeposited: number,
    totalClaimed: number,
    startTime: number,
    depositTimeOut: number,
    claimTimeOut: number,
    remainingTokens: number
}