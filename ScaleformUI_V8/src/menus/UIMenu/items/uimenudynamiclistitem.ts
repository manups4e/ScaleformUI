import { UIMenuItem } from "./uimenuitem";
import { UIMenuCheckboxItemChangeCallback, UIMenuDynamicListItemChangeCallbackBuilder } from "../emitters/emitters";
import { BadgeStyle } from "elements/badge";

export enum ChangeDirection {
    Left = 0,
    Right,
}

export class UIMenuDynamicListItem extends UIMenuItem {
    callback = new UIMenuDynamicListItemChangeCallbackBuilder();
    private currentListItem: string = "";

    public set CurrentListItem(value: string) {
        this.currentListItem = value;
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("UPDATE_LISTITEM_LIST", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)),
                this.currentListItem, 0);
        }
    }
    public get CurrentListItem(): string {
        return this.currentListItem;
    }

    constructor(text: string, description: string, startingItem: string, changeCallback: UIMenuCheckboxItemChangeCallback) {
        super(text, description);
        this._itemId = 1;
        this.currentListItem = startingItem;
        this.callback.add(changeCallback);
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuDynamicListItem cannot have a right badge.");
    }

    public SetRightLabel(text: string) {
        throw new Error("UIMenuDynamicListItem cannot have a right label.");
    }
}