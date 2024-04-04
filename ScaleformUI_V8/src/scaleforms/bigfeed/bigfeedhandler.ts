import {Scaleform, ScaleformHandler} from "../scaleform";
import {ProxySetters} from "../../helpers/proxy-setters.decorator";
import {noop, waitUntilReturns} from "../../helpers/loaders";
import {Singleton} from "../../helpers/singleton.decorator";

@ProxySetters<BigFeedHandler>("_proxiedSetterCall", true)
@Singleton
export class BigFeedHandler implements ScaleformHandler {
    private scaleform?: Scaleform
    public accessor title = ""
    public accessor subtitle = ""
    public accessor bodyText = ""
    private txn = ""
    private txd = ""
    public accessor enabled = false
    public accessor rightAligned = false
    public accessor disabledNotifications = false
    constructor() {}

    /**
     * **DO NOT CALL THIS METHOD MANUALLY, ITS PUBLIC DUE TO TYPESCRIPT LIMITATIONS**
     * This method is called by the `ProxySetters` decorator whenever an `accessor` is invoked. It contains side effects specific to the property, and the UI update logic
     * @param calledMethod
     */
    public _proxiedSetterCall(calledMethod: keyof BigFeedHandler) {
        if (calledMethod == "enabled") {
            if (this.enabled) {
                this.scaleform!.callFunction("SETUP_BIGFEED", false, this.rightAligned)
                this.scaleform!.callFunction("HIDE_ONLINE_LOGO", false)
                this.scaleform!.callFunction("FADE_IN_BIGFEED", false)
                if (this.disabledNotifications) {
                    ThefeedCommentTeleportPoolOn()
                }
                this.updateInfo()
            } else {
                this.scaleform!.callFunction("END_BIGFEED", false)
                if (this.disabledNotifications) {
                    ThefeedCommentTeleportPoolOff()
                }
            }
        } else if (this.enabled) {
            if (calledMethod == "rightAligned") {
                this.scaleform!.callFunction("SETUP_BIGFEED", false, this.rightAligned)
            }
            this.updateInfo()
        }
    }

    public setTexture(txName: string, txDict: string) {
        this.txn = txName
        this.txd = txDict
        if (this.enabled) {
            this.scaleform?.callFunction("SET_BIGFEED_IMAGE", false, txDict, txName)
            this.updateInfo()
        }
    }

    public updateInfo() {
        if (!this.scaleform || !this.enabled) return
        AddTextEntry("scaleform_ui_bigFeed", this.bodyText)
        BeginScaleformMovieMethod(this.scaleform.handle, "SET_BIGFEED_INFO")
        ScaleformMovieMethodAddParamTextureNameString("")
        BeginTextCommandScaleformString("scaleform_ui_bigFeed")
        EndTextCommandScaleformString_2()
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamTextureNameString(this.txn)
        ScaleformMovieMethodAddParamTextureNameString(this.txd)
        ScaleformMovieMethodAddParamTextureNameString(this.subtitle)
        ScaleformMovieMethodAddParamTextureNameString("")
        ScaleformMovieMethodAddParamTextureNameString(this.title)
        ScaleformMovieMethodAddParamInt(0)
        EndScaleformMovieMethod()
    }

    public update() {
        if (!this.scaleform || !this.enabled) return
        //TODO! ScaleformUI.WaitTime = 0
        this.scaleform.render2d()
    }

    public async load() {
        if (this.scaleform) return
        this.scaleform = Scaleform.request("GTAV_ONLINE")
        const start = GetGameTimer()
        const to = 1000
        await waitUntilReturns(noop, () => this.scaleform!.isLoaded() && GetGameTimer() - start < to, true, 0)
        this.scaleform!.callFunction("HIDE_ONLINE_LOGO", false)
    }

    public destroy() {
        this.scaleform?.destroy()
        this.scaleform = undefined
    }

}