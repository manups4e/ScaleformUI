import {Singleton} from "../../helpers/singleton.decorator";
import {noop, waitUntilReturns} from "../../helpers/loaders";
import {ScaleformHandler} from "../scaleform";

@Singleton
export class MinimapOverlays {
    private overlay = 0
    private readonly minimaps: {txd: string, txn: string}[] = []
    public async load() {
        this.overlay = AddMinimapOverlay("files/MINIMAP_LOADER.gfx")
        await waitUntilReturns(noop, () => HasMinimapOverlayLoaded(this.overlay), [1, true], 0)
        SetMinimapOverlayDisplay(this.overlay, 0.0, 0.0, 100.0, 100.0, 100.0)
    }

    public async addSizedOverlay(
        textureDict: string, textureName: string,
        x: number, y: number,
        rotation = 0, width = -1,
        height = -1, alpha = 100, centered = false) {

        if (!HasStreamedTextureDictLoaded(textureDict)) {
            await waitUntilReturns(
                () => RequestStreamedTextureDict(textureDict, false),
                () => HasStreamedTextureDictLoaded(textureDict),
                [1, true],
                0)
        }
        CallMinimapScaleformFunction(this.overlay, "ADD_SIZED_OVERLAY")
        ScaleformMovieMethodAddParamTextureNameString(textureDict)
        ScaleformMovieMethodAddParamTextureNameString(textureName)
        ScaleformMovieMethodAddParamFloat(x)
        ScaleformMovieMethodAddParamFloat(y)
        ScaleformMovieMethodAddParamFloat(Math.round(rotation * 100) / 100)
        ScaleformMovieMethodAddParamFloat(Math.round(width * 100) / 100)
        ScaleformMovieMethodAddParamFloat(Math.round(height * 100) / 100)
        ScaleformMovieMethodAddParamInt(alpha)
        ScaleformMovieMethodAddParamBool(centered)
        EndScaleformMovieMethod()

        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
        return this.minimaps.push({txd: textureDict, txn: textureName}) - 1
    }

    public async addScaledOverlay(
        textureDict: string, textureName: string,
        x: number, y: number,
        rotation = 0, xScale = 100.0,
        yScale = 100.0, alpha = 100, centered = false
    ): Promise<number> {

        if (!HasStreamedTextureDictLoaded(textureDict)) {
            await waitUntilReturns(
                () => RequestStreamedTextureDict(textureDict, false),
                () => HasStreamedTextureDictLoaded(textureDict),
                [1, true],
                0)
        }

        CallMinimapScaleformFunction(this.overlay, "ADD_SCALED_OVERLAY")
        ScaleformMovieMethodAddParamTextureNameString(textureDict)
        ScaleformMovieMethodAddParamTextureNameString(textureName)
        ScaleformMovieMethodAddParamFloat(x)
        ScaleformMovieMethodAddParamFloat(y)
        ScaleformMovieMethodAddParamFloat(Math.round(rotation * 100) / 100)
        ScaleformMovieMethodAddParamFloat(Math.round(xScale * 100) / 100)
        ScaleformMovieMethodAddParamFloat(Math.round(yScale * 100) / 100)
        ScaleformMovieMethodAddParamInt(alpha)
        ScaleformMovieMethodAddParamBool(centered)
        EndScaleformMovieMethod()

        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
        return this.minimaps.push({ txd: textureDict, txn: textureName }) - 1
    }

    public async removeOverlayById(id: number) {
        if (id == 0) await this.load()
        CallMinimapScaleformFunction(this.overlay, "REM_OVERLAY");
        ScaleformMovieMethodAddParamInt(id)
        EndScaleformMovieMethod()
        delete this.minimaps[id]
    }
}