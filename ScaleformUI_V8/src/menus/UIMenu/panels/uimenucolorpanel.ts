import { UIMenuPanel } from "./uimenupanel";
import { ColorPanelChangedEvent, ColorPanelChangedEventBuilder } from '../emitters/emitters';
import { SColor } from "elements/scolor";
import { ScaleformUI } from "scaleforms/scaleformui/main";

export enum ColorPanelType { Hair, Makeup }
export class UIMenuColorPanel extends UIMenuPanel {
    Title: string;
    PanelColorType: ColorPanelType;
    CustomColors: Scolor[]
    _value: number;
    private _ColorPanelChanged = new ColorPanelChangedEventBuilder();
    public OnColorPanelChange(delegate: ColorPanelChangedEvent) {
        this._ColorPanelChanged.add(delegate);
    }
    public get CurrentSelection(): number {
        return this._value;
    }
    public set CurrentSelection(value: number) {
        this._value = value;
        if (this.CustomColors.length == 0) {
            if (value > 63)
                this._value -= 63;
            if (value < 0)
                this._value += 63;
        }
        else {
            if (value > this.CustomColors.length - 1)
                this._value -= this.CustomColors.length - 1;
            if (value < 0)
                this._value += this.CustomColors.length - 1;
        }
        this._setValue(this._value);
    }

    constructor(title: string, colorType: ColorPanelType, startIndex: number, colors: SColor[]) {
        super();
        this.Title = title;
        this.PanelColorType = colorType;
        this.CustomColors = colors;
        this._value = 0;
    }

    PanelChanged() {
        this._ColorPanelChanged.toDelegate()(this.ParentItem, this, this.CurrentSelection)
    }

    private _setValue(val: number) {
        let it = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
        let van = this.ParentItem.Panels.indexOf(this);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_COLOR_PANEL_VALUE", it, van, val);
    }
}