import { Vector2 } from "./vector2";

export class ScreenTools {

    static IsMouseInBounds(X: number, Y: number, Width: number, Height: number): boolean {
        let MXY = new Vector2(Math.round(GetControlNormal(0, 239) * 1920), Math.round(GetControlNormal(0, 240) * 1080));
        MXY = ScreenTools.FormatXWYH(MXY.x, MXY.y);
        let XY = ScreenTools.FormatXWYH(X, Y);
        let WH = ScreenTools.FormatXWYH(Width, Height)
        return (MXY.x >= X && MXY.x <= X + WH.x) && (MXY.y > Y && MXY.y < Y + WH.y)
    }

    static FormatXWYH(Value: number, Value2: number): Vector2 {
        let wh = ScreenTools.ResolutionMaintainRatio()
        return new Vector2(Value / wh.x, Value2 / wh.y)
    }

    static ResolutionMaintainRatio(): Vector2 {
        let [screenw, screenh] = GetActiveScreenResolution()
        let ratio = screenw / screenh
        let width = 1080 * ratio
        return new Vector2(width, 1080)
    }
}