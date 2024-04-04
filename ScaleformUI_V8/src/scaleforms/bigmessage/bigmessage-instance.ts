import {Singleton} from "../../helpers/singleton.decorator";
import {Scaleform, ScaleformHandler} from "../scaleform";
import {cache} from "@babel/traverse";
import scope = cache.scope;
import {block, noop, waitUntilReturns} from "../../helpers/loaders";
import {Color} from "../../elements/color";

@Singleton
export class BigmessageInstance implements ScaleformHandler {
    private scaleform?: Scaleform
    private manualDispose = false
    private transition: "TRANSITION_OUT" | "TRANSITION_UP" | "TRANSITION_DOWN"  = "TRANSITION_OUT"
    private transitionDuration = 0.15
    private transitionPreventAutoExpansion = false
    private transitionExecuted = false
    private start = 0
    private duration = 0

    constructor() {}

    /**
     * Loads the MP_BIG_MESSAGE_FREEMODE scaleform
     */
    public async load() {
        if (this.scaleform) return
        this.scaleform = Scaleform.request("MP_BIG_MESSAGE_FREEMODE")
        const start = GetGameTimer()
        const to = 1000
        await waitUntilReturns(noop, () => this.scaleform!.isLoaded() && GetGameTimer() - start < to, true, 0)
    }

    /**
     * Disposes the scaleform
     */
    public async destroy() {
        if (!this.scaleform) return
        if (this.manualDispose) {
            this.scaleform.callFunction(this.transition, false, this.transitionDuration, this.transitionPreventAutoExpansion)
            await block((this.transitionDuration * .5) * 1000)
            this.manualDispose = false
        }
        this.start = 0
        this.transitionExecuted = false
        this.scaleform.destroy()
        delete this.scaleform
    }

    /**
     * Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
     * @param message The message
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showMissionPassedMessage(message: string, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_MISSION_PASSED_MESSAGE", message, "", 100, true, 0, true)
    }
    /**
     * Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
     * @param message The message
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showOldMessage(message: string, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_MISSION_PASSED_MESSAGE", message)
    }

    /**
     * Runs the SHOW_SHARD_CENTERED_MP_MESSAGE method on the scaleform
     * @param message The message
     * @param description The description
     * @param textColor `Color` The color of the text
     * @param bgColor `Color` The background color
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showColoredShard(message: string, description: string, textColor: Color, bgColor: Color, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_SHARD_CENTERED_MP_MESSAGE", message, description, bgColor, textColor)
    }
    /**
     * Runs the SHOW_SHARD_CREW_RANKUP_MP_MESSAGE  method on the scaleform
     * @param message The message
     * @param subtitle The subtitle
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showSimpleShard(message: string, subtitle: string, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_SHARD_CREW_RANKUP_MP_MESSAGE", message, subtitle)
    }
    /**
     * Runs the SHOW_BIG_MP_MESSAGE method on the scaleform
     * @param message The message
     * @param subtitle The subtitle
     * @param rank The rank
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showRankupMessage(message: string, subtitle: string, rank: number, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_BIG_MP_MESSAGE", message, subtitle, rank, "", "")
    }
    /**
     * Runs the SHOW_WEAPON_PURCHASED method on the scaleform
     * @param bigMessage The message
     * @param weaponName The name of the weapon
     * @param weaponHash The JIT hash of the weapon
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showWeaponPurchasedMessage(bigMessage: string, weaponName: string, weaponHash: number, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_WEAPON_PURCHASED", bigMessage, weaponName, weaponHash, "", 100);
    }

    /**
     * Runs the SHOW_CENTERED_MP_MESSAGE_LARGE method on the scaleform
     * @param message The message
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showMpMessageLarge(message: string, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_CENTERED_MP_MESSAGE_LARGE", message, "", 100, true, 100);
        this.scaleform?.callFunction("TRANSITION_IN", false);
    }
    /**
     * Runs the SHOW_SHARD_WASTED_MP_MESSAGE method on the scaleform
     * @param message The message
     * @param subtitle The subtitle
     * @param duration The duration of the scaleform in miliseconds (defaults to `5000`)
     * @param manualDispose Whether to automatically dispose the scaleform after it has been ran
     */
    public async showMpWastedMessage(message: string, subtitle: string, duration = 5000, manualDispose = false) {
        await this.drawCustomScaleformFunction(manualDispose, duration, "SHOW_SHARD_WASTED_MP_MESSAGE", message, subtitle);
    }

    /**
     * Sets the transition and the duration of the transition when its disposed
     * @param transition `"TRANSITION_OUT" | "TRANSITION_UP" | "TRANSITION_DOWN"` (defaults to `"TRANSITION_OUT"`)
     * @param duration The duration of the transition (defaults to `0.4`), this is not the same as the duration when rendering scaleforms.
     * @param preventAutoExpansion (defaults to `true`)
     */
    public setTransition(transition: "TRANSITION_OUT" | "TRANSITION_UP" | "TRANSITION_DOWN" = "TRANSITION_OUT", duration = 0.4, preventAutoExpansion = true, ) {
        this.transition = transition
        this.transitionDuration = duration + .0
        this.transitionPreventAutoExpansion = preventAutoExpansion
    }

    /**
     * Renders the scaleform, draws transitions etc
     */
    public update() {
        if (!this.scaleform) return
        //TODO! ScaleformUI.WaitTime = 0
        this.scaleform.render2d()
        if (this.manualDispose) return

        if (this.start !== 0 && GetGameTimer() - this.start > this.duration) {
            if (!this.transitionExecuted) {
                this.scaleform.callFunction(this.transition, false, this.transitionDuration, this.transitionPreventAutoExpansion)
                this.transitionExecuted = true
                this.duration = this.duration + (this.transitionDuration * .5) * 1000
            } else {
                this.destroy()
            }
        }
    }


    /**
     * Internal function, do not call it manually.
     * @param manualDispose
     * @param duration
     * @param funcName
     * @param args
     * @private
     */
    private async drawCustomScaleformFunction(manualDispose: boolean, duration: number, funcName: string, ...args: any[]) {
        await this.load()
        this.start = GetGameTimer()
        this.manualDispose = manualDispose
        this.scaleform?.callFunction(funcName, false, ...args)
        this.duration = duration
    }
}