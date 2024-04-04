import { ScaleformUI } from 'scaleforms/scaleformui/main';
import { PercentagePanelChangedEvent, PercentagePanelChangedEventBuilder } from '../emitters/emitters';
import { UIMenuPanel } from './uimenupanel';
export class UIMenuPercentagePanel extends UIMenuPanel{
    public Min:string
    public Max:string
    public Title:string
    _value:number;

    _PercentagePanelChanged = new PercentagePanelChangedEventBuilder();

    public OnPercentagePanelChange(delegate:PercentagePanelChangedEvent){
        this._PercentagePanelChanged.add(delegate);
    }

    PercentagePanelChange(){
        this._PercentagePanelChanged.toDelegate()(this.ParentItem, this, this.Percentage);
    }

    constructor(title:string = "", minText:string="0%", maxText:string="100%", initialValue:number=0.0){
        super();
        this.Min = minText
        this.Max = maxText
        this.Title = title
        this._value = initialValue
    }

    public set Percentage(value:number){
        this._value = value;
        this._setValue(value);
    }
    public get Percentage():number{
        return this._value;
    }

    private _setValue(val:number){
        let it = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
        let van = this.ParentItem.Panels.indexOf(this);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_PERCENT_PANEL_RETURN_VALUE", it, van, val);
    }
}