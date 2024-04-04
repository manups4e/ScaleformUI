import { SColor } from "elements/scolor";
import { UIMenuItem } from "./uimenuitem";
import { ItemSliderCallback, SliderItemCallbackBuilder } from "../emitters/emitters";

export class UIMenuSliderItem extends UIMenuItem {
    _value: number = 0;
    _max: number = 100;
    _multiplier: number = 5;
    public Divider: boolean;
    sliderColor: SColor;
    _heritage: boolean
    _itemSliderCallback = new SliderItemCallbackBuilder()

    constructor(text: string, description: string, max: number, mult: number, startVal: number, sliderColor: SColor, heritage: boolean) {
        super(text, description);
        this.SliderColor = sliderColor;
        this._itemId = 3;
        this._heritage = heritage;
        this.Maximum = max;
        this.Multiplier = mult;
        this.Value = startVal;
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

    public set Maximum(value: number) {
        this._max = value;
        if (this._value > value)
            this._value = value;
    }
    public get Maximum(): number {
        return this._max;
    }

    public set Value(value: number) {
        if (value > this._max)
            this._value = this._max;
        else if (value < 0)
            this._value = 0;
        else
            this._value = value;
        this.sliderChanged(this._value)
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("SET_ITEM_VALUE", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), this._value);
        }
    }
    public get Value(): number {
        return this._value;
    }

    public set Multiplier(value: number) {
        this._multiplier = value;
    }
    public get Multiplier(): number {
        return this._multiplier;
    }

    public onSliderChanged(delegate: ItemSliderCallback) {
        this._itemSliderCallback.add(delegate);
    }

    sliderChanged(value: number) {
        this._itemSliderCallback.toDelegate()(this, value);
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuSliderItem cannot have a right badge.");
    }

    public SetRightLabel(text: string) {
        throw new Error("UIMenuSliderItem cannot have a right label.");
    }
}