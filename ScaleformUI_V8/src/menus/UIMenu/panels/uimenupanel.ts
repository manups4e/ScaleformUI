import { UIMenuItem } from "../items/uimenuitem";

export abstract class UIMenuPanel {
    public Selected: boolean = false
    public Enabled: boolean = true
    public UpdateParent(){

    }

    public SetParentItem(item: UIMenuItem) {
        this.ParentItem = item;
    }

    public ParentItem: UIMenuItem;
}