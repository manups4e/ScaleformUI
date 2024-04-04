import { SColor } from "elements/scolor";
import { UIMenuItem } from "./uimenuitem";
import { ItemStatCallback, StatsItemCallbackBuilder } from "../emitters/emitters";
import { BadgeStyle } from "elements/badge";

export class UIMenuStatsItem extends UIMenuItem {
    _value: number;
    public _type: number;
    sliderColor: SColor;
    _statChanged = new StatsItemCallbackBuilder();

    constructor(text: string, subtitle: string, value: number, color: SColor) {
        super(text, subtitle);
        this._itemId = 5;
        this.Type = 0;
        this._value = value;
        this.sliderColor = color;
    }

    public set Value(value: number) {
        this._value = value;
        this.SetValue(this._value)
    }
    public get Value(): number {
        return this._value;
    }

    set Type(_t) {
        this._type = _t;
    }
    public get Type(): number {
        return this.Type;
    }

    public set SliderColor(value: SColor) {
        this.sliderColor = value;
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("UPDATE_COLORS", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), this.MainColor.toArgb(), this.HighlightColor.toArgb(), this.TextColor, this.HighlightedTextColor, value);
        }
    }
    public get SliderColor(): SColor {
        return this.sliderColor;
    }

    public SetValue(value: number) {
        ScaleformUI.Scaleforms._ui.callFunction("SET_ITEM_VALUE", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), value);
        this._statChanged.toDelegate()(value);
    }

    public onStatChanged(delegate: ItemStatCallback) {
        this._statChanged.add(delegate);
    }

    public SetLeftBadge(badge: BadgeStyle) {
        throw new Error("UIMenuStatsItem cannot have a left badge.");
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuStatsItem cannot have a right badge.");
    }

    public SetRightLabel(text: string) {
        throw new Error("UIMenuStatsItem cannot have a right label.");
    }
}