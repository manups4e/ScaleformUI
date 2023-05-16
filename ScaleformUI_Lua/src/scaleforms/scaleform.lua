Scaleform = setmetatable({}, Scaleform)
Scaleform.__index = Scaleform
Scaleform.__call = function()
    return "Scaleform"
end

---@class Scaleform
---@field public CallFunction fun(self:Scaleform, theFunction:string, returndata?:boolean, ...:any):nil|number
---@field public Dispose fun(self:Scaleform):nil
---@field public IsLoaded fun(self:Scaleform):boolean
---@field public IsValid fun(self:Scaleform):boolean
---@field public Render2D fun(self:Scaleform):nil
---@field public Render2DMasked fun(self:Scaleform, scaleformToMask:Scaleform):nil
---@field public Render2DNormal fun(self:Scaleform, x:number, y:number, width:number, height:number):nil
---@field public Render3D fun(self:Scaleform, x:number, y:number, z:number, rx:number, ry:number, rz:number, scale:number):nil
---@field public Render3DAdditive fun(self:Scaleform, x:number, y:number, z:number, rx:number, ry:number, rz:number, scale:number):nil
---@field public handle number

---Create a new scaleform instance
---@param Name string
---@return Scaleform
function Scaleform.Request(Name)
    assert(Name ~= "string",
        "^1ScaleformUI [ERROR]: ^7The first argument must be a string, not a ^1" .. type(Name) .. "^7.")
    local _scaleform = {
        name = Name,
        handle = RequestScaleformMovie(Name)
    }
    return setmetatable(_scaleform, Scaleform)
end

---Create a new scaleform instance
---@param Name string
---@return Scaleform
function Scaleform.RequestWidescreen(Name)
    assert(Name ~= "string",
        "^1ScaleformUI [ERROR]: ^7The first argument must be a string, not a ^1" .. type(Name) .. "^7.")
    local _scaleform = {
        name = Name,
        handle = RequestScaleformMovieInstance(Name)
    }
    return setmetatable(_scaleform, Scaleform)
end

---Call a function on the scaleform
---@param theFunction string -- The name of the function to call
---@param returndata? boolean -- If true, returns the return value of the function
---@vararg any -- The arguments to pass to the function
---@return nil|number -- If returndata is true, returns the return value of the function
function Scaleform:CallFunction(theFunction, returndata, ...)
    BeginScaleformMovieMethod(self.handle, theFunction)
    local arg = { ... }
    if arg ~= nil then
        for i = 1, #arg do
            local sType = type(arg[i])
            if sType == "boolean" then
                ScaleformMovieMethodAddParamBool(arg[i])
            elseif sType == "number" then
                if math.type(arg[i]) == "integer" then
                    ScaleformMovieMethodAddParamInt(arg[i])
                else
                    ScaleformMovieMethodAddParamFloat(arg[i])
                end
            elseif sType == "table" then
                local tType = arg[i].type
                if tType == "label" then
                    BeginTextCommandScaleformString(arg[i].data)
                    EndTextCommandScaleformString()                              -- END_TEXT_COMMAND_SCALEFORM_STRING
                elseif tType == "literal" then
                    ScaleformMovieMethodAddParamTextureNameString_2(arg[i].data) -- SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING
                elseif tType == "playerNameComp" then
                    BeginTextCommandScaleformString("STRING")
                    AddTextComponentSubstringPlayerName(arg[i].data)
                    EndTextCommandScaleformString()
                elseif tType == "playerNameString" then
                    ScaleformMovieMethodAddParamPlayerNameString(arg[i].data)
                else
                    assert(false, "^1ScaleformUI [ERROR]: ^7Unknown type ^1" .. tType .. "^7.")
                end
            elseif sType == "string" then
                if arg[i]:find("^desc_{") or arg[i]:find("^menu_lobby_desc_{") or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
                    BeginTextCommandScaleformString(arg[i])
                    EndTextCommandScaleformString_2()
                else
                    ScaleformMovieMethodAddParamTextureNameString(arg[i])
                end
            end
        end
    end

    if not returndata then
        EndScaleformMovieMethod()
    else
        return EndScaleformMovieMethodReturnValue()
    end
end

---Render the scaleform full screen
function Scaleform:Render2D()
    DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, 255, 0)
end

---Render the scaleform in a rectangle
function Scaleform:Render2DNormal(x, y, width, height)
    DrawScaleformMovie(self.handle, x, y, width, height, 255, 255, 255, 255, 0)
end

---Render the scaleform in a rectangle with screen space coordinates
function Scaleform:Render2DScreenSpace(locx, locy, sizex, sizey)
    local Width, Height = GetScreenResolution()
    local x = locy / Width
    local y = locx / Height
    local width = sizex / Width
    local height = sizey / Height
    DrawScaleformMovie(self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255, 0)
end

---Render the scaleform in 3D space
function Scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
    DrawScaleformMovie_3dSolid(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

---Render the scaleform in 3D space with additive blending
function Scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
    DrawScaleformMovie_3d(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

---Mask this scaleform with another scaleform full screen
function Scaleform:Render2DMasked(scaleformToMask)
    DrawScaleformMovieFullscreenMasked(self.handle, scaleformToMask.handle, 255, 255, 255, 255)
end

---Disposes the scaleform
function Scaleform:Dispose()
    SetScaleformMovieAsNoLongerNeeded(self.handle)
    self = nil
end

---Returns true if the scaleform is valid
---@return boolean
function Scaleform:IsValid()
    return self and true or false
end

---Returns true if the scaleform is loaded
---@return boolean
function Scaleform:IsLoaded()
    return HasScaleformMovieLoaded(self.handle)
end
