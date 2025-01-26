import { UIMenuGridAudio } from "elements/uimenugridaudio";
import { UIMenuPanel } from "./uimenupanel";
import { GridPanelChangedEvent, GridPanelChangedEventBuilder } from '../emitters/emitters';
import { ScaleformUI } from "scaleforms/scaleformui/main";
import { Vector2 } from "math/vector2";


export enum GridType {
    Full,
    Horizontal
}

export class UIMenuGridPanel extends UIMenuPanel {
    public TopLabel: string
    public LeftLabel: string
    public RightLabel: string
    public BottomLabel: string
    Type: GridType = GridType.Full;

    _value: Vector2 = new Vector2(0.5,0.5);

    public get CirclePosition(): Vector2 {
        return this._value;
    }
    public set CirclePosition(value: Vector2) {
        this._value = value;
        this._setValue(value);
    }

    _GridPanelChanged = new GridPanelChangedEventBuilder();
    public OnGridPanelChanged(delegate: GridPanelChangedEvent) {
        this._GridPanelChanged.add(delegate);
    }

    OnGridChange() {
        this._GridPanelChanged.toDelegate()(this.ParentItem, this, this.CirclePosition)
    }

    constructor(topText: string = "UP", leftText: string = "LEFT", rightText: string = "RIGHT", bottomText: string = "DOWN", circlePosition: Vector2 = new Vector2(0.5, 0.5), gridType: GridType = GridType.Full) {
        super();
        this.TopLabel = topText;
        this.RightLabel = rightText;
        this.LeftLabel = leftText;
        this.BottomLabel = bottomText;
        this.CirclePosition = circlePosition;
        this.Type = gridType;
    }

    private _setValue(value: Vector2) {
        let it = this.ParentItem.Parent.Pagination.GetScaleformIndex(this.ParentItem.Parent.Items.indexOf(this.ParentItem));
        let van = this.ParentItem.Panels.indexOf(this);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_GRID_PANEL_VALUE_RETURN_VALUE", it, van, value.x, value.y);
    }

}