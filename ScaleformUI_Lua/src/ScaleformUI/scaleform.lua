Scaleform = setmetatable({}, Scaleform)
Scaleform.__index = Scaleform
Scaleform.__call = function()
    return "Scaleform"
end

---@class Scaleform
---@field public CallFunction fun(self:Scaleform, theFunction:string, ...:any):nil
---@field public CallFunctionAsyncReturnInt fun(self:Scaleform, theFunction:string, ...:any):number
---@field public CallFunctionAsyncReturnBool fun(self:Scaleform, theFunction:string, ...:any):boolean
---@field public CallFunctionAsyncReturnString fun(self:Scaleform, theFunction:string, ...:any):string
---@field public Dispose fun(self:Scaleform):nil
---@field public IsLoaded fun(self:Scaleform):boolean
---@field public IsValid fun(self:Scaleform):boolean
---@field public Render2D fun(self:Scaleform):nil
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
---@vararg any -- The arguments to pass to the function
---@return nil|number -- If returndata is true, returns the return value of the function
function Scaleform:CallFunction(theFunction, ...)
    BeginScaleformMovieMethod(self.handle, theFunction)
    local arg = { ... }
    if arg ~= nil and #arg > 0 then
        for i = 1, #arg do
            assert(arg[i] ~= nil and type(arg[i]) ~= table, "ScaleformUI - function ".. theFunction.." - argument nil or table at position " .. i)
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
                local type = arg[i].type
                if type == "label" then
                    local label = arg[i].data
                    BeginTextCommandScaleformString(label)
                    EndTextCommandScaleformString() -- END_TEXT_COMMAND_SCALEFORM_STRING
                elseif type == "literal" then
                    local label = arg[i].data
                    ScaleformMovieMethodAddParamTextureNameString_2(label) -- SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING
                elseif arg[i]() == "SColor" then
                    ScaleformMovieMethodAddParamInt(arg[i]:ToArgb())
                else
                    assert(false, "^1ScaleformUI [ERROR]: ^7Unknown type ^1" .. type .. "^7.")
                end
            elseif sType == "string" then
                if arg[i]:find("^menu_") or arg[i]:find("^menu_lobby_desc_{") or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
                    BeginTextCommandScaleformString(arg[i])
                    EndTextCommandScaleformString_2()
                elseif arg[i]:find("^b_") or arg[i]:find("^t_") then
                    ScaleformMovieMethodAddParamPlayerNameString(arg[i])
                else
                    ScaleformMovieMethodAddParamTextureNameString(arg[i])
                end
            end
        end
    end
    EndScaleformMovieMethod()
end

---Call a function on the scaleform that return integer value
---@param theFunction string -- The name of the function to call
---@vararg any -- The arguments to pass to the function
---@return number -- If returndata is true, returns the return value of the function
function Scaleform:CallFunctionAsyncReturnInt(theFunction, ...)
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
                local type = arg[i].type
                if type == "label" then
                    local label = arg[i].data
                    BeginTextCommandScaleformString(label)
                    EndTextCommandScaleformString() -- END_TEXT_COMMAND_SCALEFORM_STRING
                elseif type == "literal" then
                    local label = arg[i].data
                    ScaleformMovieMethodAddParamTextureNameString_2(label) -- SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING
                elseif arg[i]() == "SColor" then
                    ScaleformMovieMethodAddParamInt(arg[i]:ToArgb())
                else
                    assert(false, "^1ScaleformUI [ERROR]: ^7Unknown type ^1" .. type .. "^7.")
                end
            elseif sType == "string" then
                if arg[i]:find("^menu_") or arg[i]:find("^menu_lobby_desc_{") or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
                    BeginTextCommandScaleformString(arg[i])
                    EndTextCommandScaleformString_2()
                else
                    ScaleformMovieMethodAddParamTextureNameString(arg[i])
                end
            end
        end
    end

    local return_value = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(return_value) do Citizen.Wait(0) end
    return GetScaleformMovieMethodReturnValueInt(return_value)
end

---Call a function on the scaleform that return boolean value
---@param theFunction string -- The name of the function to call
---@vararg any -- The arguments to pass to the function
---@return boolean -- If returndata is true, returns the return value of the function
function Scaleform:CallFunctionAsyncReturnBool(theFunction, ...)
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
                local type = arg[i].type
                if type == "label" then
                    local label = arg[i].data
                    BeginTextCommandScaleformString(label)
                    EndTextCommandScaleformString() -- END_TEXT_COMMAND_SCALEFORM_STRING
                elseif type == "literal" then
                    local label = arg[i].data
                    ScaleformMovieMethodAddParamTextureNameString_2(label) -- SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING
                elseif arg[i]() == "SColor" then
                    ScaleformMovieMethodAddParamInt(arg[i]:ToArgb())
                else
                    assert(false, "^1ScaleformUI [ERROR]: ^7Unknown type ^1" .. type .. "^7.")
                end
            elseif sType == "string" then
                if arg[i]:find("^menu_") or arg[i]:find("^menu_lobby_desc_{") or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
                    BeginTextCommandScaleformString(arg[i])
                    EndTextCommandScaleformString_2()
                else
                    ScaleformMovieMethodAddParamTextureNameString(arg[i])
                end
            end
        end
    end

    local return_value = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(return_value) do Citizen.Wait(0) end
    return GetScaleformMovieMethodReturnValueBool(return_value)
end

---Call a function on the scaleform that return string value
---@param theFunction string -- The name of the function to call
---@vararg any -- The arguments to pass to the function
---@return string -- If returndata is true, returns the return value of the function
function Scaleform:CallFunctionAsyncReturnString(theFunction, ...)
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
                local type = arg[i].type
                if type == "label" then
                    local label = arg[i].data
                    BeginTextCommandScaleformString(label)
                    EndTextCommandScaleformString() -- END_TEXT_COMMAND_SCALEFORM_STRING
                elseif type == "literal" then
                    local label = arg[i].data
                    ScaleformMovieMethodAddParamTextureNameString_2(label) -- SCALEFORM_MOVIE_METHOD_ADD_PARAM_LITERAL_STRING
                elseif arg[i]() == "SColor" then
                    ScaleformMovieMethodAddParamInt(arg[i]:ToArgb())
                else
                    assert(false, "^1ScaleformUI [ERROR]: ^7Unknown type ^1" .. type .. "^7.")
                end
            elseif sType == "string" then
                if arg[i]:find("^menu_") or arg[i]:find("^menu_lobby_desc_{") or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
                    BeginTextCommandScaleformString(arg[i])
                    EndTextCommandScaleformString_2()
                else
                    ScaleformMovieMethodAddParamTextureNameString(arg[i])
                end
            end
        end
    end

    local return_value = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(return_value) do Citizen.Wait(0) end
    return GetScaleformMovieMethodReturnValueString(return_value)
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
