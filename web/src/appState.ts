export class AppState {
    public static walletConnected: boolean = false;
    public static mobileMenuVisible : boolean = false;
    private static gridClass: string | null = null;
    private static onlyStacked: boolean | null = null;

    public static poolGridClass(): string{
        if(AppState.gridClass != null) {
            return AppState.gridClass;
        } else {
            const poolsGridClass = localStorage.getItem("pools-grid-class");
            AppState.gridClass = poolsGridClass && ["list-view", "grid-view"].includes(poolsGridClass) ? poolsGridClass : "grid-view";
        }
        return AppState.gridClass;
    }

    public static poolOnlyStacked(): boolean{
        if(AppState.onlyStacked != null) {
            return AppState.onlyStacked;
        } else {
            AppState.onlyStacked = localStorage.getItem("pools-only-stacked") == "true" ? true : false
        }
        return AppState.onlyStacked;
    }

    public static ChangeOnlyStacked(){
        AppState.onlyStacked = AppState.poolOnlyStacked() ? false : true;
        localStorage.setItem("pools-grid-class", AppState.onlyStacked ? "false" : "true");
    }

    public static SetPoolView(listview: boolean = true){
        AppState.gridClass  = listview ? "list-view" : "grid-view";
        localStorage.setItem("pools-grid-class", AppState.gridClass);
    }

}
