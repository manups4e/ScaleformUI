MinimapOverlays = setmetatable({
    overlay = 0,
    minimaps = {},
    minimapHandle = 0,
    isLoaded = false
}, MinimapOverlays)
MinimapOverlays.__index = MinimapOverlays
MinimapOverlays.__call = function() return "MinimapOverlays" end

---@class MinimapOverlays
---@field private overlay number
---@field private minimaps table
---@field private minimapHandle number
---@field public isLoaded boolean
---@field private Load fun(self:MinimapOverlays)
---@field public AddSizedOverlayToMap fun(self:MinimapOverlays, textureDict:string, textureName:string, x:number, y:number, rotation:number, width:number, height:number, alpha:number, centered:boolean)
---@field public AddScaledOverlayToMap fun(self:MinimapOverlays, textureDict:string, textureName:string, x:number, y:number, rotation:number, xScale:number, yScale:number, alpha:number, centered:boolean)
---@field public AddAreaOverlay fun(self:MinimapOverlays, coords:table, outline:boolean, color:SColor)
---@field public SetOverlayColor fun(self:MinimapOverlays, overlayId:number, color:SColor)
---@field public HideOverlay fun(self:MinimapOverlays, overlayId:number, hide:boolean)
---@field public SetOverlayAlpha fun(self:MinimapOverlays, overlayId:number, alpha:number)
---@field public SetOverlayRotation fun(self:MinimapOverlays, overlayId:number, rotation:number)
---@field public SetOverlayPosition fun(self:MinimapOverlays, overlayId:number, position:vector2|vector3)
---@field public SetOverlaySizeOrScale fun(self:MinimapOverlays, overlayId:number, width:number, height:number)
---@field public RemoveOverlayFromMinimap fun(self:MinimapOverlays, overlayId:number)
---@field public ClearAll fun(self:MinimapOverlays)


function MinimapOverlays:Load()
    -- TriggerEvent("ScUI:getMinimapHandle", function(handle)
    --     self.minimapHandle = handle
    -- end)
    -- if self.minimapHandle == 0 then
    --     local sc = Scaleform.RequestWidescreen("minimap")
    --     while not HasScaleformMovieLoaded(sc.handle) do
    --         Wait(0)
    --     end
    --     self.minimapHandle = sc.handle
    --     SetBigmapActive(true, false)
    --     Wait(0)
    --     SetBigmapActive(false, false)
    -- end
    -- TODO: ADD CHECKS IN FUNCTIONS TO PREVENT USING WITH AREA OVERLAY (COORDS FOR EXAMPLE)
    TriggerEvent("ScUI:AddMinimapOverlay", function(handle)
        self.overlay = handle
        while not HasMinimapOverlayLoaded(self.overlay) do Citizen.Wait(0) end
        SetMinimapOverlayDisplay(self.overlay, 0.0, 0.0, 100.0, 100.0, 100.0)
        self.isLoaded = HasMinimapOverlayLoaded(self.overlay) and HasScaleformMovieLoaded(self.minimapHandle)
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if ScaleformUI.Scaleforms.MinimapOverlays.isLoaded then
            local success, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms.MinimapOverlays.minimapHandle)
            if success then
                if context == 1000 then
                    if ScaleformUI.Scaleforms.MinimapOverlays.minimaps[item_id + 1] ~= nil then
                        ScaleformUI.Scaleforms.MinimapOverlays.minimaps[item_id + 1].OnMouseEvent(event_type)
                    end
                end
            end
        else
            ScaleformUI.Scaleforms.MinimapOverlays:Load()
        end
    end
end)

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

    local overlay = MinimapOverlay.New(#self.minimaps + 1, textureDict, textureName, x, y, rotation, width, height, alpha,
        centered)
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

    local overlay = MinimapOverlay.New(#self.minimaps + 1, textureDict, textureName, x, y, rotation, xScale, yScale,
        alpha, centered)
    table.insert(self.minimaps, overlay)
    return overlay
end

function MinimapOverlays:AddAreaOverlay(coords, outline, color)
    if self.overlay == 0 then self:Load() end
    local points = {}
    for _, coord in ipairs(coords) do
        table.insert(points, string.format("%.2f:%.2f", coord.x, coord.y))
    end
    local tobeparsed = table.concat(points, ",")

    CallMinimapScaleformFunction(self.overlay, "ADD_AREA_OVERLAY")
    ScaleformMovieMethodAddParamTextureNameString(tobeparsed)
    ScaleformMovieMethodAddParamBool(outline)
    ScaleformMovieMethodAddParamInt(color.R)
    ScaleformMovieMethodAddParamInt(color.G)
    ScaleformMovieMethodAddParamInt(color.B)
    ScaleformMovieMethodAddParamInt(color.A)
    EndScaleformMovieMethod()

    local overlay = MinimapOverlay.New(#self.minimaps + 1, "", "", 0, 0, 0, 0, 0, color.A, true)
    overlay.Color = color
    overlay.isArea = true
    table.insert(self.minimaps, overlay)
    return overlay
end

---Creates a new Textfield object in the scaleform and returns its handle
---@param label string the texture
---@param x number the x coordinate in world format 
---@param y number the y coordinate in world format
---@param fontSize number FontSize (default is 13)
---@param alignment number the text alignment (0 = left, 1 = center, 2 = right)
---@param font string the font to be used (default $Font2, check https://forum.cfx.re/t/using-html-images-and-blips-in-scaleform-texts/553298/2 for all ingame fonts)
---@param outline boolean toggle the text outline
---@param shadow boolean toggle the text shadow
---@return MinimapOverlay
function MinimapOverlays:AddTextOverlay(label, x,y, fontSize, alignment, font, outline, shadow)
    if fontSize == nil then fontSize = 13 end
    if alignment == nil then alignment = 0 end
    if font == nil then font = "$Font2" end
    if outline == nil then outline = true end
    if shadow == nil then shadow = false end

    CallMinimapScaleformFunction(self.overlay, "ADD_TEXT_OVERLAY")
    AddTextEntry("MinimapOverlays_" .. #self.minimaps, label)
    BeginTextCommandScaleformString("MinimapOverlays_" .. #self.minimaps)
    EndTextCommandScaleformString_2()
    ScaleformMovieMethodAddParamFloat(x)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamInt(fontSize)
    ScaleformMovieMethodAddParamInt(alignment)
    ScaleformMovieMethodAddParamTextureNameString(font)
    ScaleformMovieMethodAddParamBool(outline)
    ScaleformMovieMethodAddParamBool(shadow)
    EndScaleformMovieMethod()

    local overlay = TextOverlay.New(#self.minimaps + 1, label, x,y, fontSize, alignment, font, outline, shadow)
    table.insert(self.minimaps, overlay)
    return overlay
end

function MinimapOverlays:UpdateTextOverlay(overlayId, label, x,y, fontSize, alignment, font, outline, shadow)
    if self.overlay == 0 then return end
    if fontSize == nil then fontSize = 13 end
    if alignment == nil then alignment = 0 end
    if font == nil then font = "$Font2" end
    if outline == nil then outline = true end
    if shadow == nil then shadow = false end

    CallMinimapScaleformFunction(self.overlay, "UPDATE_TEXT")
    ScaleformMovieMethodAddParamInt(overlayId - 1)
    AddTextEntry("MinimapOverlays_" .. #self.minimaps, label)
    BeginTextCommandScaleformString("MinimapOverlays_" .. #self.minimaps)
    EndTextCommandScaleformString_2()
    ScaleformMovieMethodAddParamFloat(x)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamInt(fontSize)
    ScaleformMovieMethodAddParamInt(alignment)
    ScaleformMovieMethodAddParamTextureNameString(font)
    ScaleformMovieMethodAddParamBool(outline)
    ScaleformMovieMethodAddParamBool(shadow)
    EndScaleformMovieMethod()

    self.minimaps[overlayId] = TextOverlay.New(overlayId, label, x,y, fontSize, alignment, font, outline, shadow)
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
    self.minimaps[overlayId].Color = color;
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
    self.minimaps[overlayId].Visible = not hide;
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
    self.minimaps[overlayId].Alpha = alpha;
end

function MinimapOverlays:SetOverlayRotation(overlayId, rotation)
    if self.overlay == 0 then return end
    if self.minimaps[overlayId].isArea then print("ScaleformUI - MinimapOverlays - method \"SetOverlayRotation\" is not supported on Areas due to their vector boundaries") return end
    CallMinimapScaleformFunction(self.overlay, "UPDATE_OVERLAY_ROTATION");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(rotation);
    EndScaleformMovieMethod();
    self.minimaps[overlayId].Rotation = rotation;
end

---Changes position of the overlay
---@param overlayId number the overlay handle
---@param position vector2 the new overlay position
function MinimapOverlays:SetOverlayPosition(overlayId, position)
    if self.overlay == 0 then return end
    if self.minimaps[overlayId].isArea then print("ScaleformUI - MinimapOverlays - method \"SetOverlayPosition\" is not supported on Areas due to their vector boundaries") return end
    CallMinimapScaleformFunction(self.overlay, "UPDATE_OVERLAY_POSITION");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(position.x);
    ScaleformMovieMethodAddParamFloat(position.y);
    EndScaleformMovieMethod();
    self.minimaps[overlayId].position = position;
end

---Changes size of the overlay
---@param overlayId number the overlay handle
---@param width number the new size, if the overlay is scaled, value must be in percentage (0 to 100)
---@param height number the new size, if the overlay is scaled, value must be in percentage (0 to 100)
function MinimapOverlays:SetOverlaySizeOrScale(overlayId, width, height)
    if self.overlay == 0 then return end
    if self.minimaps[overlayId].isArea then print("ScaleformUI - MinimapOverlays - method \"SetOverlaySizeOrScale\" is not supported on Areas due to their vector boundaries") return end
    CallMinimapScaleformFunction(self.overlay, "UPDATE_OVERLAY_SIZE_OR_SCALE");
    ScaleformMovieMethodAddParamInt(overlayId - 1);
    ScaleformMovieMethodAddParamFloat(width);
    ScaleformMovieMethodAddParamFloat(height);
    EndScaleformMovieMethod();
    self.minimaps[overlayId].size = { width, height };
end

---Removes the desired overlay from the minimap
---@param overlayId number the overlay handle
function MinimapOverlays:RemoveOverlayFromMinimap(overlayId)
    if overlayId == nil or overlayId <= 0 then return end
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
