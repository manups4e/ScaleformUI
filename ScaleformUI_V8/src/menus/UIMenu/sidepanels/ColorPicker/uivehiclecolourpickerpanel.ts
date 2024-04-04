import { ScaleformUI } from "scaleforms/scaleformui/main";
import { PanelSide, SidePanelsTitleType, UIMenuSidePanel } from "../uimenusidepanel";
import { VehicleColorPickerSelectEvent, VehicleColorPickerSelectEventBuilder } from '../../emitters/emitters';
import { SColor } from "elements/scolor";

export class UIVehicleColourPickerPanel extends UIMenuSidePanel {
    private title: string;
    public get Title(): string {
        return this.title;
    }
    public set Title(value: string) {
        this.title = value;
        if (this.ParentItem != null && this.ParentItem.Parent != null && this.ParentItem.Parent.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_SIDE_PANEL_TITLE", this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem)), this.title);
        }
    }

    public TitleColor: SColor;
    _titleType: SidePanelsTitleType;
    _value: number;

    public get Value():number { return this._value; }
    private _VehicleColorPickerSelect = new VehicleColorPickerSelectEventBuilder();
    public OnVehicleColorPickerSelect(delegate: VehicleColorPickerSelectEvent) {
        this._VehicleColorPickerSelect.add(delegate);
    }
    PickerSelect() {
        this._VehicleColorPickerSelect.toDelegate()(this.ParentItem, this, this._value)
    }

    constructor(side: PanelSide, title: string, titleColor: SColor) {
        super();
        this.PanelSide = side;
        this.title = title;
        this.TitleColor = titleColor;
        this._titleType = titleColor == SColor.HUD_None ? SidePanelsTitleType.Big : SidePanelsTitleType.Small;
        this._value = 0;
    }
}