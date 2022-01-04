import { BigNumber, Contract, ethers } from "ethers";
import { Config } from "./config";
import { Web3ModalService } from "./services/web3-modal.service";

export class StateToken {
    address: string = "";
    name: string = "";
    symbol: string = "";
    decimals: number = -1;
    private approvedAddreses: Array<string> = new Array<string>();
    constructor(){}
    private getContract(signed: boolean = true) : Contract | null{
        if(Web3ModalService.instance == null || Web3ModalService.instance.signer == null || !AppState.walletSigned())
            return null;
        if(signed)
            return new ethers.Contract(this.address, Config.main.tokenContractInterface, Web3ModalService.instance.signer);
        return new ethers.Contract(this.address, Config.main.tokenContractInterface, Web3ModalService.instance.notLoggedProvider);
    }
    private approveKey(contractAddress : string): string{
        return AppState.selectedAddress + contractAddress;
    }
    isReady(): boolean{
        return this.address != "" && this.name != "" && this.symbol != "" && this.decimals != -1;
    };
    reduceDecimals(number: BigNumber) : number{
        return Number(number.toBigInt()) / (10 ** this.decimals);
    };
    isApproved(contractAddress: string) : Promise<boolean>{
        return new Promise(async (resolve) => {
            if(!this.isReady() || !AppState.walletSigned())
                resolve(false);
            if(this.approvedAddreses.includes(this.approveKey(contractAddress)))
                resolve(true);
            let ret = false;
            const contract = this.getContract(false);
            if(contract != null){
                const r : BigNumber = await contract.allowance(AppState.selectedAddress, contractAddress);
                ret = r.toHexString() != ethers.constants.Zero.toHexString();
                if(ret)
                    this.approvedAddreses.push(this.approveKey(contractAddress));
            }
            resolve(ret);
        })
    };
    approve(contractAddress: string) : Promise<false | ethers.Transaction>{
        return new Promise(async (resolve) => {
            const contract = this.getContract();
            let ret: false | ethers.Transaction = false;
            if(contract != null){
                try{
                    ret = await contract.approve(contractAddress, ethers.constants.MaxUint256);
                }catch{
                    ret = false;
                }
            }
            resolve(ret);
        })
    }
}

export interface IPresale {
    tokenOur : StateToken,
    tokenTheir: StateToken,
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

export class AppState {
    public static selectedAddress: string | null = null;
    public static chainId: number | null = null;
    public static airdropRecieved: boolean | null = null;
    public static reduceActualTimestamp: number = -1;
     
    public static token : StateToken = new StateToken();
    public static walletConnected(): boolean {
        return AppState.selectedAddress != null;
    }
    public static badChainId(): boolean {
        return AppState.selectedAddress != null && this.chainId != Config.main.chainID;
    }

    public static walletSigned(): boolean{
        return AppState.walletConnected() && !AppState.badChainId();
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
        tokenOur : new StateToken(), 
        tokenTheir: new StateToken(), 
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

