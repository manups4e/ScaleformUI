import { UIMenu } from "../uimenu";

export class UIMenuWindow{
    public ParentMenu : UIMenu;
    id:number;
    public UpdateParent(){}
    public Draw(){}
    public SetParentMenu(menu:UIMenu){
        this.ParentMenu = menu;
    }
}