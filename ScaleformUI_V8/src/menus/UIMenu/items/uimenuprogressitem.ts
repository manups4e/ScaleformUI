import { SColor } from "elements/scolor";
import { UIMenuItem } from "./uimenuitem";
import { UIMenuGridAudio } from "elements/uimenugridaudio";
import { ItemSliderProgressCallback, ProgressItemCallbackBuilder } from "../emitters/emitters";
import { BadgeStyle } from "elements/badge";

export class UIMenuProgressItem extends UIMenuItem {
    Pressed: boolean;
    Audio: UIMenuGridAudio;
    _value: number = 0;
    _max: number = 100;
    _multiplier: number = 5;
    sliderColor: SColor;
    Divider: boolean = false;
    _itemSliderProgressCallback = new ProgressItemCallbackBuilder()


    constructor(text: string, maxCount: number, startIndex: number, description: string, sliderColor: SColor) {
        super(text, description);
        this._max = maxCount;
        this._value = startIndex;
        this.SliderColor = sliderColor;
        this.Audio = new UIMenuGridAudio("CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0);
        this._itemId = 4;
        this.Pressed = false;
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

    public set Value(value: number) {
        if (value > this._max)
            this._value = this._max;
        else if (value < 0)
            this._value = 0;
        else
            this._value = value;
        this.progressChanged(this._value)
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

    public onProgressChanged(delegate: ItemSliderProgressCallback) {
        this._itemSliderProgressCallback.add(delegate)
    }

    progressChanged(value: number) {
        this._itemSliderProgressCallback.toDelegate()(this, value);
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuProgressItem cannot have a right badge.");
    }

    public SetRightLabel(text: string) {
        throw new Error("UIMenuProgressItem cannot have a right label.");
    }
}