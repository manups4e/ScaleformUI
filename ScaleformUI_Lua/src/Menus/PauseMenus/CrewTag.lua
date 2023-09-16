CrewTag = setmetatable({}, CrewTag)
CrewTag.__index = CrewTag
CrewTag.__call = function()
    return "Tag", "CrewTag"
end

function CrewTag.New(tag, crewTypeIsPrivate, crewTagContainsRockstar, level, crewColor)
    local r, g, b, a
    local hexColor
    if type(crewColor) == "number" then
        r, g, b, a = GetHudColour(crewColor);
    elseif type(crewColor) == "table" then
        r, g, b, a = crewColor.R, crewColor.G, crewColor.B, crewColor.A
    end
    hexColor = string.format("#%02X%02X%02X%02X", a, r, g, b)
    print(hexColor)

    local result = "";
    if tag ~= nil and tag ~= "" then
        if crewTypeIsPrivate then result = result .. "(" else result = result .. " " end
        if crewTagContainsRockstar then result = result .. "*" else result = result .. " " end
        result = result .. level
        result = result .. string.upper(tag)
        result = result .. hexColor
        print(result)
    end
    local data = {
        TAG = result
    }
    return setmetatable(data, CrewTag)
end

    