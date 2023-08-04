MinimapOverlays = setmetatable({
    overlay = 0,
    minimaps = {},
}, MinimapOverlays)
MinimapOverlays.__index = MinimapOverlays
MinimapOverlays.__call = function()
    return "MinimapOverlays"
end

function MinimapOverlays:Load()
    self.overlay = AddMinimapOverlay("MINIMAP_LOADER.gfx")
    while not HasMinimapOverlayLoaded(self.overlay) do Citizen.Wait(0) end
    SetMinimapOverlayDisplay(self.overlay, 0.0, 0.0, 100.0, 100.0, 100.0)
end

function MinimapOverlays:AddOverlayToMinimap(textureDict, textureName, x, y, width, height, alpha, centered)
    if self.overlay == 0 then self:Load() end
    if width == nil then width = -1 end
    if height == nil then height = -1 end
    if alpha == nil then alpha = -1 end
    if centered == nil then centered = false end

    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, false)
        while not HasStreamedTextureDictLoaded(textureDict) do Citizen.Wait(0) end
    end
    
    CallMinimapScaleformFunction(self.overlay, "ADD_OVERLAY")
    ScaleformMovieMethodAddParamTextureNameString(textureDict)
    ScaleformMovieMethodAddParamTextureNameString(textureName)
    ScaleformMovieMethodAddParamFloat(x)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamFloat(width)
    ScaleformMovieMethodAddParamFloat(height)
    ScaleformMovieMethodAddParamInt(alpha)
    ScaleformMovieMethodAddParamBool(centered)
    EndScaleformMovieMethod()

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)

    table.insert(self.minimaps, {id = #self.minimaps + 1, txd = textureDict, txn = textureName})
    return #self.minimaps
end

function MinimapOverlays:RemoveOverlayFromMinimap(overlayId)
    if overlayId == nil then return end
    if self.overlay == 0 then self:Load() end
    CallMinimapScaleformFunction(self.overlay, "REM_OVERLAY");
    ScaleformMovieMethodAddParamInt(overlayId)
    EndScaleformMovieMethod()
    for k,v in pairs(self.minimaps) do
        if k == overlayId then
            table.remove(k)
        end
    end
end