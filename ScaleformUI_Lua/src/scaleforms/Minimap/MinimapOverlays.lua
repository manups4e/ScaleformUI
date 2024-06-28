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

---Adds a new overlay with variable size to the minimap
---@param textureDict string the texture dict
---@param textureName string the texture name
---@param x number x position
---@param y number y position
---@param rotation number rotation of the overlay (-180 to 180), if you wish to use the heading of an entity, use -GetEntityRotation(entity).z
---@param width number size of the overlay
---@param height number size of the overlay
---@param alpha number the alpha of the overlay
---@param centered boolean|nil Bypass the CanPlayerCloseMenu condition
function MinimapOverlays:AddSizedOverlayToMap(textureDict, textureName, x, y, rotation, width, height, alpha, centered)
    if self.overlay == 0 then self:Load() end
    if rotation == nil then rotation = 0 end
    if width == nil then width = -1 end
    if height == nil then height = -1 end
    if alpha == nil then alpha = 100 end
    if centered == nil then centered = false end
    Citizen.CreateThread(function()
        if not HasStreamedTextureDictLoaded(textureDict) then
            RequestStreamedTextureDict(textureDict, false)
            while not HasStreamedTextureDictLoaded(textureDict) do Citizen.Wait(0) end
        end
    end)

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

    local overlay = MinimapOverlay.New(#self.minimaps + 1, textureDict, textureName, x, y, rotation, width, height, alpha, centered)
    table.insert(self.minimaps, overlay)
    return overlay
end

---Adds a new overlay with variable size to the minimap
---@param textureDict string the texture dict
---@param textureName string the texture name
---@param x number x position
---@param y number y position
---@param rotation number rotation of the overlay (-180 to 180), if you wish to use the heading of an entity, use -GetEntityRotation(entity).z
---@param xScale number scale in percentage of the overlay (0 to 100), using negative numbers will rotate the overlay on the respective axis
---@param yScale number scale in percentage of the overlay (0 to 100), using negative numbers will rotate the overlay on the respective axis
---@param alpha number the alpha of the overlay
---@param centered boolean|nil Bypass the CanPlayerCloseMenu condition
function MinimapOverlays:AddScaledOverlayToMap(textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered)
    if self.overlay == 0 then self:Load() end
    if rotation == nil then rotation = 0 end
    if xScale == nil then xScale = 100.0 end
    if yScale == nil then yScale = 100.0 end
    if alpha == nil then alpha = 100 end
    if centered == nil then centered = false end
    local returned = 0

    Citizen.CreateThread(function()
        if not HasStreamedTextureDictLoaded(textureDict) then
            RequestStreamedTextureDict(textureDict, false)
            while not HasStreamedTextureDictLoaded(textureDict) do Citizen.Wait(0) end
        end
    end)

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

    local overlay = MinimapOverlay.New(#self.minimaps + 1, textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered)
    table.insert(self.minimaps, overlay)
    return overlay
end

---Changes color to the desired overlay
---@param overlayId number the overlay handle
---@param color SColor the color for the overlay
function MinimapOverlays:SetOverlayColor(overlayId, color)
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "SET_OVERLAY_COLOR");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamInt(color.A);
    ScaleformMovieMethodAddParamInt(color.R);
    ScaleformMovieMethodAddParamInt(color.G);
    ScaleformMovieMethodAddParamInt(color.B);
    EndScaleformMovieMethod();
    self.minimaps[overlayId - 1].color = color;
end

---Hides overlay in minimap
---@param overlayId number the overlay handle
---@param hide boolean true = hidden, false = visible
function MinimapOverlays:HideOverlay(overlayId, hide)
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "HIDE_OVERLAY");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamBool(hide);
    EndScaleformMovieMethod();
    self.minimaps[overlayId - 1].visible = not hide;
end

---Sets the desired Alpha to the overlay
---@param overlayId number the overlay handle
---@param alpha number the desired alpha value
function MinimapOverlays:SetOverlayAlpha(overlayId, alpha)
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "SET_OVERLAY_ALPHA");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(alpha);
    EndScaleformMovieMethod();
    self.minimaps[overlayId - 1].alpha = alpha;
end

---Changes position of the overlay
---@param overlayId number the overlay handle
---@param position vector2 the new overlay position
function MinimapOverlays:SetOverlayPosition(overlayId, position)
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "UPDATE_OVERLAY_POSITION");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(position.x);
    ScaleformMovieMethodAddParamFloat(position.y);
    EndScaleformMovieMethod();
    self.minimaps[overlayId - 1].position = position;
end

---Changes size of the overlay
---@param overlayId number the overlay handle
---@param width number the new size, if the overlay is scaled, value must be in percentage (0 to 100)
---@param height number the new size, if the overlay is scaled, value must be in percentage (0 to 100)
function MinimapOverlays:SetOverlaySizeOrScale(overlayId, width, height)
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "UPDATE_OVERLAY_SIZE_OR_SCALE");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(width);
    ScaleformMovieMethodAddParamFloat(height);
    EndScaleformMovieMethod();
    self.minimaps[overlayId - 1].size = { width, height };
end

---Removes the desired overlay from the minimap
---@param overlayId number the overlay handle
function MinimapOverlays:RemoveOverlayFromMinimap(overlayId)
    if overlayId == nil then return end
    if self.overlay == 0 then self:Load() end
    CallMinimapScaleformFunction(self.overlay, "REM_OVERLAY");
    ScaleformMovieMethodAddParamInt(overlayId - 1)
    EndScaleformMovieMethod()
    for k, v in pairs(self.minimaps) do
        if k == overlayId then
            table.remove(self.minimaps, k)
        end
    end
end

---Removes all the overlays from the minimap
function MinimapOverlays:ClearAll()
    if self.overlay == 0 then return end
    CallMinimapScaleformFunction(self.overlay, "CLEAR_ALL");
    EndScaleformMovieMethod();
    self.minimaps = {}
end
