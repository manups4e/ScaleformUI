-- Globals
GlobalGameTimer = GetNetworkTime() --[[@type number]] -- GlobalGameTimer is used in many places, so we'll just define it here.

-- Make the number type detected as integer to avoid multiple lint detections.
---@diagnostic disable-next-line: duplicate-doc-alias
---@alias integer number

--Update GlobalGameTimer every 100ms, so we don't have to call GetNetworkTime() every time we need it.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        GlobalGameTimer = GetNetworkTime()
    end
end)

function Delegate(klass, methodName, memberName)
    -- Validate inputs
    assert(type(klass) == 'table', "klass must be a table")
    assert(type(methodName) == 'string', "methodName must be a string")
    assert(type(memberName) == 'string', "memberName must be a string")
    
    -- Cache the member access for better performance
    local function getMember(self)
        local member = self[memberName]
        if not member then
            error(string.format("Member '%s' not found in object", memberName))
        end
        if type(member) == 'function' then
            member = member(self)
            if not member then
                error(string.format("Member '%s' returned nil", memberName))
            end
        end
        return member
    end
    
    -- Create the delegate method with error handling
    klass[methodName] = function(self, ...)
        local member = getMember(self)
        local method = member[methodName]
        
        if not method then
            error(string.format("Method '%s' not found in member '%s'", 
                methodName, memberName))
        end
        
        if type(method) ~= 'function' then
            error(string.format("'%s' is not a function in member '%s'", 
                methodName, memberName))
        end
        
        return method(member, ...)
    end
end

--- Enhanced delegate many function with batch validation
function DelegateMany(klass, methodNames, memberName)
    -- Validate inputs
    assert(type(klass) == 'table', "klass must be a table")
    assert(type(methodNames) == 'table', "methodNames must be a table")
    assert(type(memberName) == 'string', "memberName must be a string")
    
    -- Validate method names array
    for i, name in ipairs(methodNames) do
        assert(type(name) == 'string', 
            string.format("Method name at index %d must be a string", i))
    end
    
    -- Delegate each method
    for _, methodName in ipairs(methodNames) do
        Delegate(klass, methodName, memberName)
    end
end

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

---SplitLabel
---@param self string
---@return table
string.SplitLabel = function(self)
    local stringsNeeded = math.ceil((self:len() - 1) / 99)
    local outputString = {}

    -- Fill table with substrings
    for i = 0, stringsNeeded - 1 do
        local start = i * 99
        local length = math.min(99, self:len() - start)
        table.insert(outputString, self:sub(start + 1, start + length))
    end

    return outputString
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
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((num * power) + 0.5) / (power)
    else
        return math.floor(num + 0.5)
    end
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

function LengthSquared(vector)
    return math.sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
end

function Wrap(value, min, max)
    local range = max - min
    local normalizedValue = math.fmod(value - min, range)

    if normalizedValue < 0 then
        normalizedValue = normalizedValue + range
    end

    local epsilon = 1e-12 -- A small number close to zero
    if math.abs(normalizedValue - range) < epsilon then
        normalizedValue = range
    end

    return min + normalizedValue
end

---Converts player's current screen resolution coordinates into scaleform coordinates (1280 x 720)
---@param realX number
---@param realY number
---@return vector2
function ConvertResolutionCoordsToScaleformCoords(realX, realY)
    local x, y = GetActiveScreenResolution()
    return vector2(realX / x * 1280, realY / y * 720)
end

---Converts scaleform coordinates (1280 x 720) into player's current screen resolution coordinates
---@param scaleformX number
---@param scaleformY number
---@return vector2
function ConvertScaleformCoordsToResolutionCoords(scaleformX, scaleformY)
    local x, y = GetActiveScreenResolution()
    return vector2(scaleformX / 1280 * x, scaleformY / 720 * y)
end

---Converts screen coords (0.0 - 1.0) into scaleform coords (1280 x 720)
---@param scX number
---@param scY number
---@return vector2
function ConvertScreenCoordsToScaleformCoords(scX, scY)
    return vector2(scX * 1280, scY * 720)
end

---Converts scaleform coords (1280 x 720) into screen coords (0.0 - 1.0)
---@param scaleformX number
---@param scaleformY number
---@return vector2
function ConvertScaleformCoordsToScreenCoords(scaleformX, scaleformY)
    -- Normalize coordinates to 0.0 - 1.0 range
    local w, h = GetActualScreenResolution()
    return vector2((scaleformX / w), (scaleformY / h))
end

function ConvertResolutionCoordsToScreenCoords(x, y)
    local w, h = GetActualScreenResolution()
    local normalizedX = math.max(0.0, math.min(1.0, x / w))
    local normalizedY = math.max(0.0, math.min(1.0, y / h))
    return vector2(normalizedX, normalizedY)
end

---Converts player's current screen resolution size into scaleform size (1280 x 720)
---@param realWidth number
---@param realHeight number
---@return vector2
function ConvertResolutionSizeToScaleformSize(realWidth, realHeight)
    local x, y = GetActiveScreenResolution()
    return vector2(realWidth / x * 1280, realHeight / y * 720)
end

---Converts scaleform size (1280 x 720) into player's current screen resolution size
---@param scaleformWidth number
---@param scaleformHeight number
---@return vector2
function ConvertScaleformSizeToResolutionSize(scaleformWidth, scaleformHeight)
    local x, y = GetActiveScreenResolution()
    return vector2(scaleformWidth / 1280 * x, scaleformHeight / 720 * y)
end

---Converts screen size (0.0 - 1.0) into scaleform size (1280 x 720)
---@param scWidth number
---@param scHeight number
---@return vector2
function ConvertScreenSizeToScaleformSize(scWidth, scHeight)
    return vector2(scWidth * 1280, scHeight * 720)
end

---Converts scaleform size (1280 x 720) into screen size (0.0 - 1.0)
---@param scaleformWidth number
---@param scaleformHeight number
---@return vector2
function ConvertScaleformSizeToScreenSize(scaleformWidth, scaleformHeight)
    -- Normalize size to 0.0 - 1.0 range
    local w, h = GetActualScreenResolution()
    return vector2((scaleformWidth / w), (scaleformHeight / h))
end

function ConvertResolutionSizeToScreenSize(width, height)
    local w, h = GetActualScreenResolution()
    local normalizedWidth = math.max(0.0, math.min(1.0, width / w))
    local normalizedHeight = math.max(0.0, math.min(1.0, height / h))
    return vector2(normalizedWidth, normalizedHeight)
end

---Adjust 1080p values to any aspect ratio
---@param x number
---@param y number
---@param w number
---@param h number
---@return number
---@return number
---@return number
---@return number
function AdjustNormalized16_9ValuesForCurrentAspectRatio(x, y, w, h)
    local fPhysicalAspect = GetAspectRatio(false)
    if IsSuperWideScreen() then
        fPhysicalAspect = 16.0 / 9.0
    end

    local fScalar = (16.0 / 9.0) / fPhysicalAspect
    local fAdjustPos = 1.0 - fScalar

    w = w * fScalar

    local newX = x * fScalar
    x = newX + fAdjustPos * 0.5
    x, w = AdjustForSuperWidescreen(x, w)
    return x, y, w, h
end

function GetWideScreen()
    local WIDESCREEN_ASPECT = 1.5
    local fLogicalAspectRatio = GetAspectRatio(false)
    local w, h = GetActualScreenResolution()
    local fPhysicalAspectRatio = w / h
    if fPhysicalAspectRatio <= WIDESCREEN_ASPECT then
        return false
    end
    return fLogicalAspectRatio > WIDESCREEN_ASPECT;
end

---Adjusts normalized values to SuperWidescreen resolutions
---@param x number
---@param w number
---@return number
---@return number
function AdjustForSuperWidescreen(x, w)
    if not IsSuperWideScreen() then
        return x, w
    end

    local difference = ((16.0 / 9.0) / GetAspectRatio(false))

    x = 0.5 - ((0.5 - x) * difference)
    w = w * difference

    return x, w
end

function IsSuperWideScreen()
    local aspRat = GetAspectRatio(false)
    return aspRat > (16.0 / 9.0)
end

function Join(symbol, list)
    local result = ""
    for i, value in ipairs(list) do
        if i ~= 1 then
            result = result .. symbol
        end
        result = result .. tostring(value)
    end
    return result
end
