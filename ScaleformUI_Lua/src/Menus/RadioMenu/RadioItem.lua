RadioItem = setmetatable({}, RadioItem)
RadioItem.__index = RadioItem
RadioItem.__call = function()
    return "RadioItem"
end

function RadioItem.New(_station, _artist, _track, _txd, _txn)
    local data = {
        Parent = nil,
        StationName = _station,
        Artist = _artist,
        Track = _track,
        TextureDictionary = _txd,
        TextureName = _txn
    }
    return setmetatable(data, RadioItem)
end
