CrewTag = setmetatable({}, CrewTag)
CrewTag.__index = CrewTag
CrewTag.__call = function()
    return "Tag", "CrewTag"
end

---@param tag string
---@param crewTypeIsPrivate boolean
---@param crewTagContainsRockstar boolean
---@param level number|CrewHierarchy
---@param crewColor SColor
---@return table
function CrewTag.New(tag, crewTypeIsPrivate, crewTagContainsRockstar, level, crewColor)
    local r, g, b, a
    local hexColor
    hexColor = crewColor:ToHex()

    local result = "";
    if tag ~= nil and tag ~= "" then
        if crewTypeIsPrivate then result = result .. "(" else result = result .. " " end
        if crewTagContainsRockstar then result = result .. "*" else result = result .. " " end
        result = result .. level
        result = result .. string.upper(tag)
        result = result .. hexColor
    end
    local data = {
        TAG = result
    }
    return setmetatable(data, CrewTag)
end

    