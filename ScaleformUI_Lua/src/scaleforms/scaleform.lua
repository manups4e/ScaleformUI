Scaleform = setmetatable({}, Scaleform)
Scaleform.__index = Scaleform
Scaleform.__call = function()
    return "Scaleform"
end

function Scaleform.Request(Name)
    local ScaleformHandle = RequestScaleformMovie(Name)
    local data = { name = Name, handle = ScaleformHandle }
    return setmetatable(data, Scaleform)
end

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
            elseif sType == "string" then
                if arg[i]:find("^desc_{") ~= nil or arg[i]:find("^menu_lobby_desc_{") ~= nil or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
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

function Scaleform:Render2D()
    DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, 255, 0)
end

function Scaleform:Render2DNormal(x, y, width, height)
    DrawScaleformMovie(self.handle, x, y, width, height, 255, 255, 255, 255, 0)
end

function Scaleform:Render2DScreenSpace(locx, locy, sizex, sizey)
    local Width, Height = GetScreenResolution()
    local x = locy / Width
    local y = locx / Height
    local width = sizex / Width
    local height = sizey / Height
    DrawScaleformMovie(self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255, 0)
end

function Scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
    DrawScaleformMovie_3dSolid(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function Scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
    DrawScaleformMovie_3d(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function Scaleform:Dispose()
    SetScaleformMovieAsNoLongerNeeded(self.handle)
    self = nil
end

function Scaleform:IsValid()
    return self and true or false
end

function Scaleform:IsLoaded()
    return HasScaleformMovieLoaded(self.handle)
end
