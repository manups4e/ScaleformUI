MinimapOverlays = setmetatable({
    overlay = 0,
    minimaps = {},
}, MinimapOverlays)
MinimapOverlays.__index = MinimapOverlays
MinimapOverlays.__call = function()
    return "MinimapOverlays"
end

function MinimapOverlays:Load()
    self.overlay = AddMinimapOverlay("files/MINIMAP_LOADER.gfx")
    while not HasMinimapOverlayLoaded(self.overlay) do Citizen.Wait(0) end
    SetMinimapOverlayDisplay(self.overlay, 0.0, 0.0, 100.0, 100.0, 100.0)
end

function MinimapOverlays:AddSizedOverlayToMap(textureDict, textureName, x, y, rotation, width, height, alpha, centered)
    if self.overlay == 0 then self:Load() end
    if rotation == nil then rotation = 0 end
    if width == nil then width = -1 end
    if height == nil then height = -1 end
    if alpha == nil then alpha = 100 end
    if centered == nil then centered = false end

    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, false)
        while not HasStreamedTextureDictLoaded(textureDict) do Citizen.Wait(0) end
    end

    CallMinimapScaleformFunction(self.overlay, "ADD_SIZED_OVERLAY")
    ScaleformMovieMethodAddParamTextureNameString(textureDict)
    ScaleformMovieMethodAddParamTextureNameString(textureName)
    ScaleformMovieMethodAddParamFloat(x)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamFloat(math.round(rotation, 2))
    ScaleformMovieMethodAddParamFloat(math.round(width, 2))
    ScaleformMovieMethodAddParamFloat(math.round(height, 2))
    ScaleformMovieMethodAddParamInt(alpha)
    ScaleformMovieMethodAddParamBool(centered)
    EndScaleformMovieMethod()

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)
    table.insert(self.minimaps, {id = #self.minimaps + 1, txd = textureDict, txn = textureName})
    return #self.minimaps
end

function MinimapOverlays:AddScaledOverlayToMap(textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered)
    if self.overlay == 0 then self:Load() end
    if rotation == nil then rotation = 0 end
    if xScale == nil then xScale = 100.0 end
    if yScale == nil then yScale = 100.0 end
    if alpha == nil then alpha = 100 end
    if centered == nil then centered = false end

    CallMinimapScaleformFunction(self.overlay, "ADD_SCALED_OVERLAY")
    ScaleformMovieMethodAddParamTextureNameString(textureDict)
    ScaleformMovieMethodAddParamTextureNameString(textureName)
    ScaleformMovieMethodAddParamFloat(x)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamFloat(math.round(rotation, 2))
    ScaleformMovieMethodAddParamFloat(math.round(xScale, 2))
    ScaleformMovieMethodAddParamFloat(math.round(yScale, 2))
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