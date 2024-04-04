import { Vector3 } from "../math/vector3";
import { Delay } from "../helpers/loaders";
import { ScaleformLabel } from "elements/scaleform-label";
import { ScaleformLiteralString } from "elements/scaleform-literal-string";
import { SColor } from "elements/scolor";

export interface ScaleformHandler {
    load(): Promise<void>
    update(): void
    destroy(): Promise<void>
}

export class Scaleform {
    private deleted = false
    private constructor(private readonly name: string, readonly handle: number) { }

    public static request(name: string) {
        return new Scaleform(name, RequestScaleformMovie(name))
    }

    public static requestWideScreen(name: string) {
        return new Scaleform(name, RequestScaleformMovieInstance(name))
    }

    public callFunction(funcName: string, ...args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]) {
        BeginScaleformMovieMethod(this.handle, funcName)
        this.processScaleformArgs(funcName, args)
        EndScaleformMovieMethod()
    }

    private callFunctionReturnInternal(functionName: string, args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]): number {
        this.processScaleformArgs(functionName, args);
        return EndScaleformMovieMethodReturnValue();
    }

    public async callFunctionReturnInt(functionName: string, ...args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]): Promise<number> {
        let scaleformHandle = this.callFunctionReturnInternal(functionName, args)
        while (!IsScaleformMovieMethodReturnValueReady(scaleformHandle)) {
            await Delay(0)
        }
        return GetScaleformMovieFunctionReturnInt(scaleformHandle)
    }

    public async callFunctionReturnBool(functionName: string, ...args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]): Promise<boolean> {
        let scaleformHandle = this.callFunctionReturnInternal(functionName, args)
        while (!IsScaleformMovieMethodReturnValueReady(scaleformHandle)) {
            await Delay(0)
        }
        return GetScaleformMovieFunctionReturnBool(scaleformHandle)
    }

    public async callFunctionReturnString(functionName: string, ...args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]): Promise<string> {
        let scaleformHandle = this.callFunctionReturnInternal(functionName, args)
        while (!IsScaleformMovieMethodReturnValueReady(scaleformHandle)) {
            await Delay(0)
        }
        return GetScaleformMovieFunctionReturnString(scaleformHandle)
    }

    /**
     * Render the scaleform in fullscreen
     */
    public render2d() {
        DrawScaleformMovieFullscreen(this.handle, 255, 255, 255, 255, 0)
    }

    /**
     * Render the scaleform in a specific rectangle
     * @param x
     * @param y
     * @param width
     * @param height
     */
    public render2dNormal(x: number, y: number, width: number, height: number) {
        DrawScaleformMovie(this.handle, x, y, width, height, 255, 255, 255, 255, 0)
    }

    /**
     * Render the scaleform in a rectangle with screen space coordinates
     * @param localX
     * @param localY
     * @param sizeX
     * @param sizeY
     */
    public render2dScreenSpace(localX: number, localY: number, sizeX: number, sizeY: number) {
        const [w, h] = GetScreenResolution()
        const x = localY / w
        const y = localX / h
        const width = sizeX / w
        const height = sizeY / h
        DrawScaleformMovie(this.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255, 0)
    }

    /**
     * Render the scaleform in 3d
     * @param coords `Vector3`
     * @param rot `Vector3`
     * @param scale `Vector3`
     */
    public render3d(coords: Vector3, rot: Vector3, scale: Vector3) {
        DrawScaleformMovie_3dSolid(this.handle, ...coords.toArr(), ...rot.toArr(), 2.0, 2.0, 1.0, ...scale.toArr(), 2)
    }

    /**
     * Render the scaleform in 3D space with additive blending
     * @param coords `Vector3`
     * @param rot `Vector3`
     * @param scale `Vector3`
     */
    public render3dAdditive(coords: Vector3, rot: Vector3, scale: Vector3) {
        DrawScaleformMovie_3d(this.handle, ...coords.toArr(), ...rot.toArr(), 2.0, 2.0, 1.0, ...scale.toArr(), 2)
    }

    /**
     * Destroy the scaleform
     */
    public dispose() {
        SetScaleformMovieAsNoLongerNeeded(this.handle)
        this.deleted = true
    }

    public get isValid() {
        return !this.deleted
    }

    public get isLoaded() {
        return !HasScaleformMovieLoaded(this.handle)
    }


    private processScaleformArgs(fname: string, args: (number | boolean | string | ScaleformLiteralString | ScaleformLabel | SColor)[]) {
        for (const [argIndex, arg] of args.entries()) {
            if (typeof arg === "boolean") {
                ScaleformMovieMethodAddParamBool(arg)
            } else if (typeof arg === "number") {
                if (Number.isInteger(arg)) {
                    ScaleformMovieMethodAddParamInt(arg)
                } else {
                    ScaleformMovieMethodAddParamFloat(arg)
                }
            } else if (typeof arg === "string") {
                this.addStringArg(arg)
            } else if (arg instanceof ScaleformLiteralString) {
                ScaleformMovieMethodAddParamTextureNameString_2(arg.LiteralString)
            } else if (arg instanceof ScaleformLabel) {
                BeginTextCommandScaleformString(arg.Label)
                EndTextCommandScaleformString()
            } else if (arg instanceof SColor) {
                ScaleformMovieMethodAddParamInt(arg.toArgb())
            } else {
                throw new Error(`Received invalid argument: ${arg} at position #${argIndex} while calling scaleform function: ${fname}`)
            }
        }
    }

    private addStringArg(arg: string) {
        if (["b_", "t_"].some(prefix => arg.startsWith(prefix))) {
            ScaleformMovieMethodAddParamPlayerNameString(arg)
        } else {
            ScaleformMovieMethodAddParamTextureNameString(arg)
        }
    }
}