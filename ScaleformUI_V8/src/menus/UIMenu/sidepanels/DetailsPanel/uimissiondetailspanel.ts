import { UIMenuPanel } from "menus/UIMenu/panels/uimenupanel";
import { PanelSide } from "../uimenusidepanel";
import { SColor } from "elements/scolor";
import { UIFreemodeDetailsItem } from "./uifreemodedetailsitem";
import { ScaleformUI } from "scaleforms/scaleformui/main";
import { cache } from '@babel/traverse';

export class UIMissionDetailsPanel extends UIMenuPanel{

    private title:string;
    public PanelSide:PanelSide;
    public TitleColor:SColor;
    public TitleType:number;
    public TextureDict:string;
    public TextureName:string
    public Items:UIFreemodeDetailsItem[];

    public set Title(value:string){
        this.title = value;
        if (this.ParentItem != undefined && this.ParentItem.Parent != undefined && this.ParentItem.Parent.Visible)
        {
            ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_SIDE_PANEL_TITLE", this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem)), this.title);
        }
    }
    public get Title():string{
        return this.title;
    }

    public UpdatePanelPicture(txd:string, txn:string){
        this.TextureDict = txd;
        this.TextureName = txn;
        if (this.ParentItem != undefined && this.ParentItem.Parent != undefined && this.ParentItem.Parent.Visible)
        {
            let wid = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
            ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_MISSION_DETAILS_PANEL_IMG", wid, this.TextureDict, this.TextureName);
        }
    }

    public AddItem(item:UIFreemodeDetailsItem){
        this.Items.push(item);
        if (this.ParentItem != undefined && this.ParentItem.Parent != undefined && this.ParentItem.Parent.Visible)
        {
            let wid = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
            ScaleformUI.Scaleforms._ui?.callFunction("ADD_MISSION_DETAILS_DESC_ITEM", wid, item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick, item._labelFont.fontName, item._labelFont.fontId, item._rightLabelFont.fontName, item._rightLabelFont.fontId);
        }
    }

    public RemoveItem(idx:number){
        this.Items.splice(idx, 1);
        if (this.ParentItem != undefined && this.ParentItem.Parent != undefined && this.ParentItem.Parent.Visible)
        {
            let wid = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
            ScaleformUI.Scaleforms._ui?.callFunction("REMOVE_MISSION_DETAILS_DESC_ITEM", wid, idx);
        }

    }



    constructor(side:PanelSide, title:string, color:SColor, inside:number|boolean, txd:string, txn:string){
        super();
        let _titleType:number;
        let _titleColor:SColor;

        if (inside == -1)
            _titleType = 1
        else if (inside)
            _titleType = 2
        else
            _titleType = 0
        
    
        if (color != SColor.HUD_None)
            _titleColor = color
        else
            _titleColor = SColor.HUD_None
        
        this.PanelSide = side;
        this.Title = title;
        this.TitleColor = _titleColor;
        this.TitleType = _titleType;
        this.TextureDict = txd || "";
        this.TextureName = txn || "";
        this.Items = [];
    }


}