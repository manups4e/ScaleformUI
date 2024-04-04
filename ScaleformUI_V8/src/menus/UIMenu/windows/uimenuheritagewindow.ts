import { Delay } from "helpers/loaders";
import { UIMenuWindow } from "./uimenuwindow";
import { ScaleformUI } from "scaleforms/scaleformui/main";

export class UIMenuHeritageWindow extends UIMenuWindow{
    public Mom:number;
    public Dad:number;

    constructor(mom:number, dad:number){
        super();
        this.Mom = mom;
        this.Dad = dad;
    }

    public async Index(mom:number, dad:number){
        this.Mom = mom;
        this.Dad = dad;
        if (mom > 21) this.Mom = 21;
        if (mom < 0) this.Mom = 0;
        if (dad > 23) this.Dad = 23;
        if (dad < 0) this.Dad = 0;
        let wid = this.ParentMenu.Windows.indexOf(this);
        while (!HasStreamedTextureDictLoaded("char_creator_portraits"))
        {
            await Delay(0);
            RequestStreamedTextureDict("char_creator_portraits", true);
        }
        ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_HERITAGE_WINDOW", wid, this.Mom, this.Dad);
        SetStreamedTextureDictAsNoLongerNeeded("char_creator_portraits");
    }
}