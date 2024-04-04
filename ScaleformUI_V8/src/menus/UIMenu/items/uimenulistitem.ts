import { UIMenuItem } from "./uimenuitem";
import { ListItemChangeCallbackBuilder, UIMenuListItemChangeCallback } from '../emitters/emitters';
import { SColor } from "elements/scolor";
import { BadgeStyle } from "elements/badge";

export class UIMenuListItem extends UIMenuItem {
    private _index: number = 0;
    private _items: any[] = [];

    private _listChangedEmitter = new ListItemChangeCallbackBuilder();
    private _listSelectedEmitter = new ListItemChangeCallbackBuilder();

    public set Index(value: number) {
        if (value < 0)
            this._index = 0;
        else if (value >= this._items.length)
            this._index = this.Items.length - 1;
        else
            this._index = value;
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("SET_ITEM_VALUE", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), this._index);
        }
    }
    public get Index():number{
        return this._index % this.Items.length;
    }

    public set Items(value:any[]){
        this.Index = 0;
        this._items = value;
    }
    public get Items():any[]{
        return this._items;
    }

    constructor(text:string , items:any[] , index:number , description:string , mainColor:SColor , higlightColor:SColor , textColor:SColor , highlightTextColor: SColor){
        super(text, description, mainColor, higlightColor, textColor, highlightTextColor);
        this._itemId = 1;
        this._items = items;
        this.Index = index;
    }

    public ChangeList(list:any[], index:number){
        this._items.length = 0;
        this._items = list;
        this._index = index;
        if (this.Parent !== null && this.Parent.Visible && this.Parent.Pagination.IsItemVisible(this.Parent.Items.indexOf(this))) {
            ScaleformUI.Scaleforms._ui.callFunction("UPDATE_LISTITEM_LIST", this.Parent.Pagination.GetScaleformIndex(this.Parent.Items.indexOf(this)), this._items.join(","), index);
        }
    }

    public onListChanged(delegate: UIMenuListItemChangeCallback) {
        this._listChangedEmitter.add(delegate)
    }
    public onHighlighted(delegate: UIMenuListItemChangeCallback) {
        this._listSelectedEmitter.add(delegate)
    }

    listChangedEmit() {
        this._listChangedEmitter.toDelegate()(this, this.Index);
    }
    listSelectedEmit() {
        this._listSelectedEmitter.toDelegate()(this, this.Index);
    }

    public SetRightBadge(badge: BadgeStyle) {
        throw new Error("UIMenuListItem cannot have a right badge.");
    }
    
    public SetRightLabel(text: string) {
        throw new Error("UIMenuListItem cannot have a right label.");
    }

}