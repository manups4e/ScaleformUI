import { Vector2 } from "math/vector2";
import { UIMenuWindow } from "./uimenuwindow";
import { SColor } from "elements/scolor";
import { ScaleformUI } from "scaleforms/scaleformui/main";

export class UIDetailImage {
    public Txd: string
    public Txn: string
    public Pos: Vector2
    public Size: Vector2

    constructor(txd: string, txn: string, pos: Vector2, size: Vector2) {
        this.Txd = txd;
        this.Txn = txn;
        this.Pos = pos;
        this.Size = size;
    }
}

export class UIDetailStat {
    public Percentage: number;
    public HudColor: SColor;
    constructor(percentage: number, color: SColor) {
        this.Percentage = percentage;
        this.HudColor = color;
    }
}


export class UIMenuDetailsWindow extends UIMenuWindow {
    public DetailTop: string;
    public DetailMid: string;
    public DetailBottom: string;
    public DetailLeft: UIDetailImage;
    public StatWheelEnabled: boolean;
    public DetailStats: UIDetailStat[];

    constructor(...args: any[]) {
        super();
        this.id = 1;
        this.DetailTop = args[0];
        this.DetailMid = args[1];
        this.DetailBottom = args[2];
        this.StatWheelEnabled = false;
        this.DetailLeft = new UIDetailImage("", "", Vector2.zero, Vector2.zero);
        this.DetailStats = [];

        if (args.length === 3 || args.length === 4) {
            if (args.length === 4) {
                this.DetailLeft = args[3] || this.DetailLeft;
            }
        } else if (args.length === 5) {
            this.StatWheelEnabled = args[3];
            this.DetailStats = args[4] as UIDetailStat[];
            this.DetailLeft = this.DetailLeft;
        }
    }

    public UpdateLabels(top: string, mid: string, bot: string, leftDetail: UIDetailImage) {
        this.DetailTop = top;
        this.DetailMid = mid;
        this.DetailBottom = bot;
        this.DetailLeft = leftDetail == undefined ? new UIDetailImage("", "", Vector2.zero, Vector2.zero) : leftDetail;
        if (this.ParentMenu != undefined && this.ParentMenu.Visible) {
            let wid = this.ParentMenu.Windows.indexOf(this);
            if (!this.StatWheelEnabled)
                ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_DETAILS_WINDOW_VALUES", wid, this.DetailBottom, this.DetailMid, this.DetailTop, this.DetailLeft.Txd, this.DetailLeft.Txn, this.DetailLeft.Pos.x, this.DetailLeft.Pos.y, this.DetailLeft.Size.x, this.DetailLeft.Size.y);
            else
                ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_DETAILS_WINDOW_VALUES", wid, this.DetailBottom, this.DetailMid, this.DetailTop, "statWheel");
        }
    }

    public AddStatsListToWheel(stats: UIDetailStat[]) {
        if (this.StatWheelEnabled) {
            this.DetailStats = stats;
            if (this.ParentMenu != undefined && this.ParentMenu.Visible) {
                let wid = this.ParentMenu.Windows.indexOf(this);
                stats.forEach((value: UIDetailStat) => {
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", wid, value.Percentage, value.HudColor);
                });
            }
        }
    }

    public AddStatSingleToWheel(stat: UIDetailStat) {
        if (this.StatWheelEnabled) {
            this.DetailStats.push(stat);
            if (this.ParentMenu != undefined && this.ParentMenu.Visible) {
                let wid = this.ParentMenu.Windows.indexOf(this);
                ScaleformUI.Scaleforms._ui?.callFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", wid, stat.Percentage, stat.HudColor);
            }
        }
    }

    public UpdateStatsToWheel() {
        this.UpdateStatsToWheel(this.DetailStats);
    }
    public UpdateStatsToWheel(stats: UIDetailStat[]) {
        if (this.StatWheelEnabled) {
            if (this.DetailStats.length != stats.length) {
                throw new Error("You cannot add items using this function");
            }
            this.DetailStats = stats;
            if (this.ParentMenu != undefined && this.ParentMenu.Visible) {
                let wid = this.ParentMenu.Windows.indexOf(this);
                stats.forEach((value: UIDetailStat) => {
                    ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_STATS_DETAILS_WINDOW_STATWHEEL", wid, this.DetailStats.indexOf(value), value.Percentage, value.HudColor);
                });
            }
        }
    }

    public RemoveStatToWheel(stat: UIDetailStat) {
        let index = this.DetailStats.findIndex(s => s.Percentage === stat.Percentage && s.HudColor === stat.HudColor);
        if (index !== -1) {
            this.DetailStats.splice(index, 1);
        }
    }
    public RemoveStatToWheel(idx: number) {
        if (idx < 0 || idx >= this.DetailStats.length) return;
        this.DetailStats.splice(idx, 1);
        if (this.ParentMenu != undefined && this.ParentMenu.Visible) {
            let wid = this.ParentMenu.Windows.indexOf(this);
            ScaleformUI.Scaleforms._ui?.callFunction("REMOVE_STATS_DETAILS_WINDOW_STATWHEEL", wid, idx);
        }
    }
}