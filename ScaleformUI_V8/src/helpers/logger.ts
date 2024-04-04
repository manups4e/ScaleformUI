const LEVELS = [
    "debug",
    "info",
    "warn",
    "error"
] as const
type LogLevel = typeof LEVELS[number]
const COLORS = {
    BLACK: "^0",
    RED: "^1",
    GREEN: "^2",
    YELLOW: "^3",
    BLUE: "^4",
    CYAN: "^5",
    PINK: "^6",
    WHITE: "^7",
    GREY: "^9",
} as const
const colorStr = (color: keyof typeof COLORS, input: string) => `${COLORS[color]}${input}${COLORS.WHITE}`

export class Logger {
    private constructor(private readonly name: string, public readonly minLevel: LogLevel) {}

    public static scoped(scopeName: string) {
        const minLevel = (global as any).SCALEFORM_UI_MIN_LOG_LEVEL ?? GetConvar("scaleformui_min_log_level", "warn")
        return new Logger(scopeName, LEVELS.includes(minLevel) ? minLevel : "warn")
    }

    private canRelayWithLevel(level: LogLevel) {
        const ix = LEVELS.indexOf(level)
        const minLevel = LEVELS.indexOf(this.minLevel)
        return ix >= minLevel
    }

    private relayLogMessage(level: LogLevel, ...args: any[]) {
        if (!this.canRelayWithLevel(level)) return
        const string = this.serializeArgs(args)
        let color: keyof typeof COLORS
        switch (level) {
            case "debug":
                color = "WHITE"
                break
            case "error":
                color = "RED"
                break
            case "warn":
                color = "YELLOW"
                break
            case "info":
                color = "GREEN"
                break
        }
        const finalString = colorStr(color, `[${level.toUpperCase()}] - ${string}`)
        console.log(finalString)
        return finalString
    }

    private serializeArgs(args: any[]) {
        return args.map(x => typeof x === "function" ? `[FUNCTION]: ${x.name}` : typeof x === "object" ? JSON.stringify(x) : x instanceof Error ? x.toString() : String(x)).join(" ")
    }
    public debug(...args: any[]) {
        return this.relayLogMessage("debug", ...args)
    }
    public info(...args: any[]) {
        return this.relayLogMessage("info", ...args)
    }
    public warn(...args: any[]) {
        return this.relayLogMessage("warn", ...args)
    }

    public error(...args: any[]) {
        return this.relayLogMessage("error", ...args)
    }
}