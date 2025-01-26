import { Vector2 } from "./vector2";
import { Vector3 } from "./vector3";

export class ScreenTools {

    // Global Variables
    public static GlobalGameTimer: number = Date.now();

    // Boolean Conversion
    public static ToBool(input: any): boolean {
        return input === "true" || input === 1 || input === true;
    }

    // String Split
    public static split(inputstr: string, sep: string = "\\s+"): string[] {
        return inputstr.split(new RegExp(sep));
    }

    // Resolution Helpers
    public static ResolutionMaintainRatio(): [number, number] {
        const [screenw, screenh] = GetActiveScreenResolution(); // Implement this 
        const ratio = screenw / screenh;
        const width = 1080 * ratio;
        return  [width, 1080]
    }

    public static SafezoneBounds(): Vector2 {
        const t = GetSafeZoneSize(); // Implement this 
        var g = MathExtensions.round(t, 2);
        g = (g * 100) - 90;
        g = 10 - g;

        const screenw = 720 * GetAspectRatio(false); // Implement these s
        const screenh = 720;
        const ratio = screenw / screenh;
        const wmp = ratio * 5.4;

        return new Vector2(MathExtensions.round(g * wmp), MathExtensions.round(g * 5.4));
    }

    public static FormatXWYH(value: number, value2: number): [number, number] {
        const [w, h] = ScreenTools.ResolutionMaintainRatio();
        return [value / w, value2 / h];
    }

    // Vector Operations
    public static GetVectorMagnitude(vector: Vector3): number {
        return Math.sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
    }

    public static IsVectorInsideSphere(vector: Vector3, position: Vector3, scale: Vector3): boolean {
        const distance = new Vector3(
            vector.x - position.x,
            vector.y - position.y,
            vector.z - position.z
        );
        const radius = ScreenTools.GetVectorMagnitude(scale) / 2;
        return ScreenTools.GetVectorMagnitude(distance) <= radius;
    }

    // Array Operations
    public static AllTrue(arr: boolean[]): boolean {
        return arr.every(v => v);
    }

    public static AllFalse(arr: boolean[]): boolean {
        return arr.some(v => v);
    }

    // Mouse Bounds Check
    public static IsMouseInBounds(x: number, y: number, width: number, height: number): boolean {
        var [mx, my] = [Math.round(GetControlNormal(0, 239) * 1920), Math.round(GetControlNormal(0, 240) * 1080)]
        mx = Math.round(mx * 1920);
        my = Math.round(my * 1080);
        [x, y] = ScreenTools.FormatXWYH(x, y);
        [width, height] = ScreenTools.FormatXWYH(width, height);
        return mx >= x && mx <= x + width && my > y && my < y + height;
    }

    // Table Operations
    public static TableHasKey(table: { [key: string]: any }, key: string): boolean {
        const lowercaseKey = key.toLowerCase();
        for (const k in table) {
            if (k.toLowerCase() === lowercaseKey) {
                return true;
            }
        }
        return false;
    }

    // Vector Length Squared
    public static LengthSquared(vector: Vector3): number {
        return vector.x * vector.x + vector.y * vector.y + vector.z * vector.z;
    }

    // Wrapping 
    public static Wrap(value: number, min: number, max: number): number {
        const range = max - min;
        let normalizedValue = (value - min) % range;

        if (normalizedValue < 0) {
            normalizedValue += range;
        }

        const epsilon = 1e-12;
        if (Math.abs(normalizedValue - range) < epsilon) {
            normalizedValue = range;
        }

        return min + normalizedValue;
    }

    // Coordinate Conversions
    public static ConvertResolutionCoordsToScaleformCoords(realX: number, realY: number): Vector2 {
        const [x, y] = GetActiveScreenResolution(); // Implement this 
        return new Vector2(realX / x * 1280, realY / y * 720);
    }

    public static ConvertScaleformCoordsToResolutionCoords(scaleformX: number, scaleformY: number): Vector2 {
        const [x, y] = GetActiveScreenResolution(); // Implement this 
        return new Vector2(scaleformX / 1280 * x, scaleformY / 720 * y);
    }

    public static ConvertScreenCoordsToScaleformCoords(scX: number, scY: number): Vector2 {
        return new Vector2(scX * 1280, scY * 720);
    }

    public static ConvertScaleformCoordsToScreenCoords(scaleformX: number, scaleformY: number): Vector2 {
        const [w, h] = GetActiveScreenResolution(); // Implement this 
        return new Vector2((scaleformX / w) * 2.0 - 1.0, (scaleformY / h) * 2.0 - 1.0);
    }

    public static ConvertResolutionCoordsToScreenCoords(x: number, y: number): Vector2 {
        const [w, h] = GetActiveScreenResolution(); // Implement this 
        const normalizedX = Math.max(0.0, Math.min(1.0, x / w));
        const normalizedY = Math.max(0.0, Math.min(1.0, y / h));
        return new Vector2(normalizedX, normalizedY);
    }

    public static ConvertResolutionSizeToScaleformSize(realWidth: number, realHeight: number): Vector2 {
        const [x, y] = GetActiveScreenResolution(); // Implement this 
        return new Vector2(realWidth / x * 1280, realHeight / y * 720);
    }

    public static ConvertScaleformSizeToResolutionSize(scaleformWidth: number, scaleformHeight: number): Vector2 {
        const [x, y] = GetActiveScreenResolution(); // Implement this 
        return new Vector2(scaleformWidth / 1280 * x, scaleformHeight / 720 * y);
    }

    public static ConvertScreenSizeToScaleformSize(scWidth: number, scHeight: number): Vector2 {
        return new Vector2(scWidth * 1280, scHeight * 720);
    }

    public static ConvertScaleformSizeToScreenSize(scaleformWidth: number, scaleformHeight: number): Vector2 {
        const [w, h] = GetActiveScreenResolution(); // Implement this 
        return new Vector2((scaleformWidth / w) * 2.0 - 1.0, (scaleformHeight / h) * 2.0 - 1.0);
    }

    public static ConvertResolutionSizeToScreenSize(width: number, height: number): Vector2 {
        const [w, h] = GetActiveScreenResolution(); // Implement this 
        const normalizedWidth = Math.max(0.0, Math.min(1.0, width / w));
        const normalizedHeight = Math.max(0.0, Math.min(1.0, height / h));
        return new Vector2(normalizedWidth, normalizedHeight);
    }

    // Aspect Ratio Adjustments
    public static AdjustNormalized16_9ValuesForCurrentAspectRatio(x: number, y: number, w: number, h: number): [number, number, number, number] {
        var fPhysicalAspect = GetAspectRatio(false); // Implement this 
        if (ScreenTools.IsSuperWideScreen()) { // Implement this 
            fPhysicalAspect = 16.0 / 9.0;
        }

        const fScalar = (16.0 / 9.0) / fPhysicalAspect;
        const fAdjustPos = 1.0 - fScalar;

        w *= fScalar;

        const newX = x * fScalar;
        x = newX + fAdjustPos * 0.5;
        [x, w] = ScreenTools.AdjustForSuperWidescreen(x, w);
        return [x, y, w, h];
    }

    public static AdjustForSuperWidescreen(x: number, w: number): [number, number] {
        if (!ScreenTools.IsSuperWideScreen()) { // Implement this 
            return [x, w];
        }

        const difference = ((16.0 / 9.0) / GetAspectRatio(false)); // Implement this 

        x = 0.5 - ((0.5 - x) * difference);
        w *= difference;

        return [x, w];
    }

    public static IsSuperWideScreen(): boolean {
        const aspRat = GetAspectRatio(false); // Implement this 
        return aspRat > (16.0 / 9.0);
    }

}

// String Extensions
export class StringExtensions {
    public static starts(str: string, start: string): boolean {
        return str.substring(0, start.length) === start;
    }

    public static startsWith(str: string, prefix: string): boolean {
        return str.startsWith(prefix);
    }

    public static isNullOrEmpty(str: string): boolean {
        return !str || str.trim().length === 0;
    }

    public static insert(str: string, pos: number, str2: string): string {
        return str.slice(0, pos) + str2 + str.slice(pos + 1);
    }
}

// Array Extensions
export class ArrayExtensions {
    public static indexOf(arr: any[], value: any): number {
        return arr.indexOf(value);
    }

    public static keyOf(obj: { [key: string]: any }, value: any): string | undefined {
        for (const key in obj) {
            if (obj[key] === value) {
                return key;
            }
        }
        return undefined;
    }
}

// Math Extensions
export class MathExtensions {
    public static round(num: number, decimalPlaces?: number): number {
        if (decimalPlaces !== undefined) {
            const multiplier = Math.pow(10, decimalPlaces);
            return Math.floor((num * multiplier) + 0.5) / multiplier;
        } else {
            return Math.floor(num + 0.5);
        }
    }
}
