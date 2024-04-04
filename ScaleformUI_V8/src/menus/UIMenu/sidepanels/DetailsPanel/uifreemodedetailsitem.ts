import { BadgeStyle } from "elements/badge";
import { ItemFont } from "elements/item-font";
import { ScaleformFonts } from "elements/scaleform-fonts";
import { SColor } from "elements/scolor";

export class UIFreemodeDetailsItem {
    public TextLeft: string;
    public TextRight: string = "";
    public Icon: BadgeStyle = BadgeStyle.NONE;
    public IconColor: SColor = SColor.HUD_None;
    public Type: number;
    public Tick: boolean;
    _labelFont: ItemFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
    _rightLabelFont: ItemFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;

    constructor(textLeft: string, textRight: string, seperator: boolean, icon: BadgeStyle, iconColor: SColor, tick: boolean) {
        let _type: number;
        if (seperator)
            _type = 3
        else if (icon != undefined && iconColor != undefined)
            _type = 2
        else if (textRight == undefined && seperator == undefined && icon == undefined && iconColor == undefined && tick == undefined)
            _type = 4
        else
            _type = 0

        this.Type = _type;
        this.TextLeft = textLeft;
        this.TextRight = textRight || "";
        this.Icon = icon || BadgeStyle.NONE;
        this.IconColor = iconColor || SColor.HUD_White;
        this.Tick = tick || false;
        this._labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        this._rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    }

    SetLabelsFonts(leftFont: ItemFont, rightFont: ItemFont) {
        if (leftFont != undefined)
            this._labelFont = leftFont
        if (rightFont != undefined)
            this._rightLabelFont = rightFont
    }

}