import { BigNumber } from "ethers";
import { Config } from "./config";

export class AppState {
    public static token : ITokenInterface = {
        address: "",
        name: "",
        symbol: "",
        decimals: -1,
        isReady(): boolean{
            return this.address != "" && this.name != "" && this.symbol != "" && this.decimals != -1;
        },
        reduceDecimals(number: BigNumber) : number{
            return Number(number.toBigInt()) / (10 ** this.decimals);
        }
    };
    public static selectedAddress: string | null = null;
    public static chainId: number | null = null;
    public static airdropRecieved: boolean | null = null;
    static tokenDecimals: number;
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

    public static reduceTheirDecimals(number: BigNumber) : number{
        return Number(number.toBigInt()) / (10 ** AppState.presale.tokenTheir.decimals);
    }

    public static reduceOurDecimals(number: BigNumber) : number{
        return Number(number.toBigInt()) / (10 ** AppState.presale.tokenOur.decimals);
    }

    public static presale : IPresale = {
        tokenOur : {
            address: "",
            name: "",
            symbol: "",
            decimals: -1,
            isReady(): boolean{
                return this.address != "" && this.name != "" && this.symbol != "" && this.decimals != -1;
            },
            reduceDecimals(number: BigNumber) : number{
                return Number(number.toBigInt()) / (10 ** this.decimals);
            }
        }, 
        tokenTheir: {
            address: "",
            name: "",
            symbol: "",
            decimals: -1,
            isReady(): boolean{
                return this.address != "" && this.name != "" && this.symbol != "" && this.decimals != -1;
            },
            reduceDecimals(number: BigNumber) : number{
                return Number(number.toBigInt()) / (10 ** this.decimals);
            }
        },
        depositedCount: -1,
        claimedCount: -1,
        tokenPrice: -1,
        totalDeposited: -1,
        totalClaimed: -1,
        startTime: -1,
        depositTimeOut: -1,
        claimTimeOut: -1,
        remainingTokens: -1,
    }
}

export class ITokenInterface {
    address: string = "";
    name: string = "";
    symbol: string = "";
    decimals: number = -1;
    isReady(): boolean{
        return this.address != "" && this.name != "" && this.symbol != "" && this.decimals != -1;
    };
    reduceDecimals(number: BigNumber) : number{
        return Number(number.toBigInt()) / (10 ** this.decimals);
    }
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