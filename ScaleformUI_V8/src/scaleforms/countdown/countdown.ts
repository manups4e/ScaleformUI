import {Singleton} from "../../helpers/singleton.decorator";
import {Scaleform, ScaleformHandler} from "../scaleform";
import {Rgba} from "../../math/rgba";
import {block, noop, waitUntilReturns} from "../../helpers/loaders";
import {Color} from "../../elements/color";
import {Logger} from "../../helpers/logger";

@Singleton
export class Countdown implements ScaleformHandler {
    private color = Rgba.white
    private scaleform?: Scaleform
    private startTime = 0
    private timer = 0
    private render = false
    private readonly logger = Logger.scoped("CountdownScaleform")

    public async load() {
        if (this.scaleform) return
        RequestScriptAudioBank("HUD_321_GO", false)
        this.scaleform = Scaleform.request("COUNTDOWN")
        const to = 1000
        const start = GetGameTimer()
        await waitUntilReturns(noop, () => this.scaleform!.isLoaded() && GetGameTimer() - start < to, true, 0)
        if (!this.scaleform.isLoaded()) {
            throw new Error("Countdown scaleform didnt load")
        }
    }

    public async destroy() {
        await block(1000)
        this.scaleform?.destroy()
        delete this.scaleform
    }

    public async update() {
        if (!this.scaleform) return
        this.scaleform.render2d()
    }

    private startRenderingCountDown() {
        const renderTick = setTick(() => {
            if (this.render) {
                this.update()
            } else {
                clearTick(renderTick)
            }
        })
    }

    /**
     * Shows a message on the countdown
     * @param message
     */
    public showMessage(message: string) {
        this.scaleform?.callFunction("SET_MESSAGE", false, message, this.color.r, this.color.g, this.color.b, true)
        this.scaleform?.callFunction("FADE_MP", false, message, this.color.r, this.color.g, this.color.b)
    }

    public async start(
        startFrom = 3,
        hudColor = Color.HUD_COLOUR_GREEN,
        countdownAudioName = "321",
        countdownAudioRef = "Car_Club_Races_Pursuit_Series_Sounds",
        goAudioName = "go",
        goAudioRef = "Car_Club_Races_Pursuit_Series_Sounds") {
        try {
            await this.load()
            this.startRenderingCountDown()
            this.color = Rgba.fromArr(GetHudColour(hudColor))

            let gameTime = GetGameTimer()
            while (startFrom >= 0) {
                if (GetGameTimer() - gameTime > 1000) {
                    PlaySoundFrontend(-1, countdownAudioName, countdownAudioRef, true);
                    this.showMessage(startFrom.toString())
                    startFrom--
                    gameTime = GetGameTimer()
                }
            }
            PlaySoundFrontend(-1, goAudioName, goAudioRef, true);
            this.showMessage("CNTDWN_GO")
            this.destroy()
            return
        } catch (err) {
            this.logger.error("Failed to load countdown scaleform", err)
        }

    }

}