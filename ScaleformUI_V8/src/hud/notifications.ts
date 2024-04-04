import {NotificationCharacters, NotificationColors, NotificationType} from "../elements/notification";
import {Vector3} from "../math/vector3";
import {Rgba} from "../math/rgba";
import {loadPedHeadshot, waitUntilReturns} from "../helpers/loaders";
import {noop} from "@babel/types";
import {HudColor} from "../elements/color";
import {Font} from "../elements/font";

export class Notification {
    public static Type = NotificationType
    public static IconChars = NotificationCharacters
    public static Colors = NotificationColors

    private constructor(private readonly handle: number) {}

    /**
     * Hides this notification instantly.
     */
    public hide() {
        ThefeedRemoveItem(this.handle)
    }

    /**
     * Shows a simple notification
     * @param message Text
     * @param blink Should it blink (defaults to `false`)
     * @param showInBrief Should it be saved to the brief (defaults to `false`)
     */
    public static showNotification(message: string, blink = false, showInBrief = false) {
        AddTextEntry("ScaleformUINotification", message)
        BeginTextCommandThefeedPost("ScaleformUINotification")
        return new Notification(EndTextCommandThefeedPostTicker(blink, showInBrief))
    }

    /**
     * Shows a simple notification, but with a color!
     * @param message Text
     * @param color The color (`NotificationColors` enum)
     * @param blink Should it blink (defaults to `false`)
     * @param showInBrief Should it be saved to the brief (defaults to `false`)
     */
    public static showNotificationWithColor(message: string, color: NotificationColors, blink = false, showInBrief = false) {
        AddTextEntry("ScaleformUINotification", message)
        BeginTextCommandThefeedPost("ScaleformUINotification")
        ThefeedSetNextPostBackgroundColor(color)
        return new Notification(EndTextCommandThefeedPostTicker(blink, showInBrief))
    }

    /**
     * Shows a help notification for a set duration or custom draw it
     *
     * @param text The help text
     * @param duration The duration of the help text, in miliseconds. 5000 is the max. If you omit this, you will have to take care of showing the notification.
     * @param immutableText If set to `true`, you will get an optimized function back that will draw the help text while called. Its more optimized than calling `showHelpNotification()` in a loop, but you will not be able to change the help text. (default: `false`)
     */
    public static showHelpNotification<D extends number | undefined,
        T extends boolean = false>(text: string, duration?: D, immutableText?: T): D extends number ? T extends true ? () => void : void : void {
        AddTextEntry("ScaleformUIHelpText", text)
        if (duration) {
            BeginTextCommandDisplayHelp("ScaleformUIHelpText")
            EndTextCommandDisplayHelp(0, false, true, duration > 5000 ? 5000 : duration)
        } else {
            if (immutableText) {
                return (() => DisplayHelpTextThisFrame("ScaleformUIHelpText", false)) as D extends number ? T extends true ? () => void : void  : void
            }
            return DisplayHelpTextThisFrame("ScaleformUIHelpText", false) as D extends number ? T extends true ? () => void : void  : void
        }
        return undefined as D extends number ? T extends true ? () => void : void  : void //shut ts up
    }

    /**
     * Shows a floating help text notification.
     * @param text The help text
     * @param coords The coordinates provided as a `Vector3` class
     */
    public static showFloatingHelpNotification(text: string, coords: Vector3) {
        AddTextEntry("ScaleformUIFloatingHelpText", text)
        SetFloatingHelpTextWorldPosition(1, ...coords.toArr())
        SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
        BeginTextCommandDisplayHelp("ScaleformUIFloatingHelpText")
        EndTextCommandDisplayHelp(2, false, false, -1)
    }

    /**
     * Shows an advanced notification
     * @param title The title
     * @param subtitle The subtitle
     * @param text The body
     * @param characterIcon `NotificationCharacters` The character icon
     * @param notificationType `NotificationType` The notification type
     * @param backgroundColor `NotificationColors` The background color
     * @param flashColor `Rgba` The color of the flash (optional)
     * @param blink Whether it should blink (defaults to `false`)
     * @param sound Whether it should play sound (defaults to `false`)
     */
    public static showAdvancedNotification(
        title: string,
        subtitle: string,
        text: string,
        characterIcon = NotificationCharacters.Default,
        notificationType = NotificationType.Default,
        backgroundColor = NotificationColors.Default,
        flashColor?: Rgba,
        blink: boolean = false,
        sound: boolean = false) {

        AddTextEntry("ScaleformUIAdvancedNotification", text)
        BeginTextCommandThefeedPost("ScaleformUIAdvancedNotification")
        AddTextComponentSubstringPlayerName(text)
        if (backgroundColor !== NotificationColors.Default) {
            ThefeedSetNextPostBackgroundColor(backgroundColor)
        }
        if (flashColor && !blink) {
            ThefeedSetAnimpostfxColor(flashColor.r, flashColor.g, flashColor.b, flashColor.a)
        }
        if (sound) {
            PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", true)
        }
        return new Notification(EndTextCommandThefeedPostMessagetext(characterIcon, characterIcon, true, notificationType, title, subtitle))
    }

    /**
     * TODO! Investigate if newProgress should be a boolean or a number for EndTextCommandThefeedPostStats
     * Shows a stat notification
     * @param newProgress The new progress
     * @param oldProgress The old progress
     * @param title The title
     * @param blink Whether it should blink (defaults to `false`)
     * @param showInBrief Whether it should be saved in the brief (defaults to `false`)
     */
    public static async showStatNotification(newProgress: number, oldProgress: number, title: string, blink = false, showInBrief = false) {
        AddTextEntry("ScaleformUIStatsNotification", title)
        const handle = await loadPedHeadshot(PlayerPedId())
        const txd = GetPedheadshotTxdString(handle)
        BeginTextCommandThefeedPost("PS_UPDATE")
        AddTextComponentInteger(newProgress)
        //casted to boolean for now until we investigate
        EndTextCommandThefeedPostStats("ScaleformUIStatsNotification", 2, newProgress as unknown as boolean, oldProgress, false, txd, txd)
        const noti = new Notification(EndTextCommandThefeedPostTicker(blink, showInBrief))
        UnregisterPedheadshot(handle)
        return noti
    }

    /**
     * Shows a versus notification between 2 ped heads (the notification you see in GTA online when you keep killing someone)
     * @param leftPed Left ped id
     * @param leftScore Left score
     * @param leftColor `Color` Left color
     * @param rightPed Right ped
     * @param rightScore Right score
     * @param rightColor `Color` Right color
     */
    public static async showVersusNotification(leftPed: number, leftScore: number, leftColor: HudColor, rightPed: number, rightScore: number, rightColor: HudColor) {
        const [leftHandle, rightHandle] = await Promise.all([loadPedHeadshot(leftPed), loadPedHeadshot(rightPed)])
        const [leftTxd, rightTxd] = [GetPedheadshotTxdString(leftHandle), GetPedheadshotTxdString(rightHandle)]
        BeginTextCommandThefeedPost("")
        // @ts-ignore colors (param 7 and 8) are not yet supported on the native def TODO! update the native spec
        const noti = new Notification(EndTextCommandThefeedPostVersusTu(leftTxd, leftTxd, leftScore, rightTxd, rightTxd, rightScore, leftColor, rightColor))
        UnregisterPedheadshot(leftHandle)
        UnregisterPedheadshot(rightHandle)
        return noti
    }

    /**
     * Puts a floating text in the world
     * @param coords `Vector3` The text coords
     * @param color `Rgba` The color
     * @param text The text
     * @param font `Font` The font
     * @param size `number` The size
     */
    public static draw3dText(coords: Vector3, color: Rgba, text: string, font: Font, size: number) {
        const cam = Vector3.fromArr(GetGameplayCamCoord())
        const dist = cam.distance(coords)
        const internalScale = (1 / dist) * size
        const fov = (1 / GetGameplayCamFov()) * 100
        const scale = internalScale * fov
        SetTextScale(0.1 * scale, 0.15 * scale)
        SetTextFont(font)
        SetTextProportional(true)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextDropshadow(5, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0, 0)
        ClearDrawOrigin()
    }

    /**
     * Draws a text on the screen
     * @param x X coord
     * @param y Y coord
     * @param text The text
     * @param color `Rgba` The color
     * @param font `Font` The font
     * @param textAlignment The text alignment. 0, 1 or 2
     * @param shadow Whether the text should have a shadow (defaults to `true`)
     * @param outline Whether the text should be outlined (defaults to `true`)
     * @param wrap Text wrapping style. (defaults to `0`, wont do anything)
     */
    public static drawText(
        x: number,
        y: number,
        text: string,
        color = Rgba.white,
        font = Font.CHALET_COMPRIME_COLOGNE,
        textAlignment: 0 | 1 | 2 = 1,
        shadow = true,
        outline = true,
        wrap = 0) {
        const [screenw, screenh] = GetActiveScreenResolution()
        const height = 1080
        const ratio = screenw / screenh
        const width = height * ratio
        SetTextFont(font)
        SetTextScale(0.0, 0.5)
        SetTextColour(color.r, color.g, color.b, color.a)
        if (shadow) SetTextDropShadow()
        if (outline) SetTextOutline()

        if (wrap !== 0) {
            const xSize = (x + wrap) / width
            SetTextWrap(x, xSize)
        }
        if (textAlignment === 0) {
            SetTextCentre(true)
        } else if (textAlignment == 2) {
            SetTextRightJustify(true)
            SetTextWrap(0, x)
        }
        BeginTextCommandDisplayText("jamyfafi")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(x, y)
    }

    /**
     * Shows a subtitle on the screen
     * @param msg The message
     * @param duration The duration in miliseconds (defaults to `2500`)
     */
    public static showSubtitle(msg: string, duration = 2500) {
        AddTextEntry("ScaleformUISubtitle", msg)
        BeginTextCommandPrint("ScaleformUISubtitle")
        EndTextCommandPrint(duration, true)
    }


}