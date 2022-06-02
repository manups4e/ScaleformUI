Scaleform = {}

local scaleform = {}
scaleform = setmetatable({}, scaleform)

scaleform.__call = function()
    return true
end

scaleform.__index = scaleform

function Scaleform.Request(Name)
	local ScaleformHandle = RequestScaleformMovie(Name)
	local data = {name = Name, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function scaleform:CallFunction(theFunction, returndata, ...)
    BeginScaleformMovieMethod(self.handle, theFunction)
    local arg = {...}
    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == "boolean" then
                PushScaleformMovieMethodParameterBool(arg[i])
			elseif sType == "number" then
				if math.type(arg[i]) == "integer" then
					PushScaleformMovieMethodParameterInt(arg[i])
				else
					PushScaleformMovieMethodParameterFloat(arg[i])
				end
            elseif sType == "string" then
				if arg[i]:find("^desc_{") ~= nil or arg[i]:find("^menu_lobby_desc_{") ~= nil or arg[i]:find("^PauseMenu_") or arg[i]:find("^menu_pause_playerTab{") then
					BeginTextCommandScaleformString(arg[i])
					EndTextCommandScaleformString_2()
				else
					PushScaleformMovieMethodParameterString(arg[i])
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

function scaleform:Render2D()
	DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, 255)
end

function scaleform:Render2DNormal(x, y, width, height)
	DrawScaleformMovie(self.handle, x, y, width, height, 255, 255, 255, 255)
end

function scaleform:Render2DScreenSpace(locx, locy, sizex, sizey)
	local Width, Height = GetScreenResolution()
	local x = locy / Width
	local y = locx / Height
	local width = sizex / Width
	local height = sizey / Height
	DrawScaleformMovie(self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255)
end

function scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3dNonAdditive(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3d(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Dispose()
	SetScaleformMovieAsNoLongerNeeded(self.handle)
	self = nil
end

function scaleform:IsValid()
	return self and true or false
end

function scaleform:IsLoaded() 
    return HasScaleformMovieLoaded(self.handle)
end