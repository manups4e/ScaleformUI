import { DelegateBuilder, IDelegate } from "helpers/eventemitter";
import { UIMenuItem } from "./uimenuitem";
import { SColor } from "elements/scolor";
import { BadgeStyle } from "elements/badge";
import { CheckboxItemChangeCallbackBuilder, UIMenuCheckboxItemChangeCallback } from "../emitters/emitters";

export enum UIMenuCheckboxStyle {
    Cross,
    Tick
}

export class UIMenuCheckboxItem extends UIMenuItem {
    private _checked: boolean = false;
    public Style: UIMenuCheckboxStyle = UIMenuCheckboxStyle.Cross;
    private _checkedEmitter = new CheckboxItemChangeCallbackBuilder();

    constructor(text:string, style:UIMenuCheckboxStyle, check:boolean, description:string, mainColor:SColor, highlightColor:SColor) {
        super(text, description, mainColor, highlightColor, SColor.HUD_White, SColor.HUD_Black)
        this.Style = style;
        this._checked = check;
        this._itemId = 2;
    }

    public onCheckboxEvent(delegate: UIMenuCheckboxItemChangeCallback) {
        this._checkedEmitter.add(delegate);
    }

    checkEmit() {
        this._checkedEmitter.toDelegate()(this, this._checked)
    }

    public set Checked(value:boolean){
        this._checked = value;
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("SET_INPUT_EVENT", 16, this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), value);
        }
    }
    public get Checked():boolean{
        return this._checked;
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuCheckboxItem cannot have a right badge.");
    }
    
    public SetRightLabel(text: string) {
        throw new Error("UIMenuCheckboxItem cannot have a right label.");
    }
}