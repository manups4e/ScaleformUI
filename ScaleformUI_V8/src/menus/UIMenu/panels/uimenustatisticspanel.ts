import { ScaleformUI } from "scaleforms/scaleformui/main";
import { UIMenuPanel } from "./uimenupanel";

export class UIMenuStatisticsPanel extends UIMenuPanel {
    Items: StatisticsForPanel[];

    constructor() {
        super();
        this.Items = [];
    }

    public AddStatistic(name: string, val: number) {
        let _value = val;
        if (_value > 100)
            _value = 100;
        if (_value < 0)
            _value = 0;
        let item = new StatisticsForPanel(name, _value);
        this.Items.push(item)
        if (this.ParentItem != null && this.ParentItem.Parent != null && this.ParentItem.Parent.Visible) {
            let it = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
            let van = this.ParentItem.Panels.indexOf(this);
            ScaleformUI.Scaleforms._ui?.callFunction("ADD_STATISTIC_TO_PANEL", it, van, name, _value);
        }
    }

    public GetPercentage(ItemId: number): number {
        return this.Items[ItemId].Value;
    }

    public UpdateStatistic(itemId: number, value: number) {
        this.Items[itemId].Value = value;
        if (this.Items[itemId].Value > 100)
            this.Items[itemId].Value = 100;
        if (this.Items[itemId].Value < 0)
            this.Items[itemId].Value = 0;
        let it = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
        let van = this.ParentItem.Panels.indexOf(this);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_PANEL_STATS_ITEM_VALUE", it, van, itemId, this.Items[itemId].Value);
    }

}

export class StatisticsForPanel {
    public Text: string;
    public Value: number;

    constructor(label: string, value: number) {
        this.Text = label;
        this.Value = value;
        if (this.Value > 100)
            this.Value = 100;
        if (this.Value < 0)
            this.Value = 0;
    }
}