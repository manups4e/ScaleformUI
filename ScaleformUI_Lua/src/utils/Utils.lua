-- Globals
GlobalGameTimer = GetGameTimer() --[[@type number]] -- GlobalGameTimer is used in many places, so we'll just define it here.

--Update GlobalGameTimer every 100ms, so we don't have to call GetNetworkTime() every time we need it.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        GlobalGameTimer = GetNetworkTime()
    end
end)

---starts
---@param Str string
---@param Start string
---@return boolean
function string.starts(Str, Start)
    return string.sub(Str, 1, string.len(Start)) == Start
end

---StartsWith
---@param self string
---@param str string
---@return boolean
string.StartsWith = function(self, str)
    return self:find('^' .. str) ~= nil
end

---IsNullOrEmpty
---@param self string
---@return boolean
string.IsNullOrEmpty = function(self)
    return self == nil or self == '' or not not tostring(self):find("^%s*$")
end

---Insert
---@param self string
---@param pos number
---@param str2 string
string.Insert = function(self, pos, str2)
    return self:sub(1, pos) .. str2 .. self:sub(pos + 1)
end

-- Return the first index with the given value (or -1 if not found).
function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return -1
end

-- Return a key with the given value (or nil if not found).  If there are
-- multiple keys with that value, the particular key returned is arbitrary.
function KeyOf(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function ToBool(input)
    if input == "true" or tonumber(input) == 1 or input == true then
        return true
    else
        return false
    end
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end

    return t
end

function Split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            Table[#Table + 1] = cap
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        Table[#Table + 1] = cap
    end
    return Table
end

function ResolutionMaintainRatio()
    local screenw, screenh = GetActiveScreenResolution()
    local ratio = screenw / screenh
    local width = 1080 * ratio
    return width, 1080
end

function SafezoneBounds()
    local t = GetSafeZoneSize();
    local g = math.round(t, 2);
    g = (g * 100) - 90;
    g = 10 - g;

    local screenw = 720 * GetAspectRatio(false)
    local screenh = 720
    local ratio = screenw / screenh;
    local wmp = ratio * 5.4

    return math.round(g * wmp), math.round(g * 5.4)
end

function FormatXWYH(Value, Value2)
    local w, h = ResolutionMaintainRatio()
    return Value / w, Value2 / h
end

---Returns the magnitude of the vector.
---@param vector vector3 -- The vector to get the magnitude of.
---@return number
function GetVectorMagnitude(vector)
    return Sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
end

---Returns true if the vector is inside the sphere, false otherwise.
---@param vector vector3 -- The vector to check.
---@param position vector3 -- The position of the sphere.
---@param scale vector3 -- The scale of the sphere.
---@return boolean
function IsVectorInsideSphere(vector, position, scale)
    local distance = (vector - position)
    local radius = GetVectorMagnitude(scale) / 2
    return GetVectorMagnitude(distance) <= radius
end

function AllTrue(t)
    for _, v in pairs(t) do
        if not v then return false end
    end

    return true
end

function AllFalse(t)
    for _, v in pairs(t) do
        if v then return true end
    end

    return false
end

function IsMouseInBounds(X, Y, Width, Height)
	local MX, MY = math.round(GetControlNormal(0, 239) * 1920), math.round(GetControlNormal(0, 240) * 1080)
    MX, MY = FormatXWYH(MX, MY)
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
	return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

function TableHasKey(table, key)
    local lowercaseKey = string.lower(key)
    
    for k, _ in pairs(table) do
        if string.lower(k) == lowercaseKey then
            return true
        end
    end
    
    return false
end
