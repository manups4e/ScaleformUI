export enum PanelSide {
    Left,
    Right
}
export enum SidePanelsTitleType {
    Big,
    Small,
    Classic
}

export abstract class UIMenuSidePanel {
    public Selected: boolean = false;
    public Enabled: boolean = true;
    public PanelSide: PanelSide
    public UpdateParent(): void { }
    public SetParentItem(item: UIMenuItem) {
        this.ParentItem = item;
    }

    public ParentItem: UIMenuItem;
}