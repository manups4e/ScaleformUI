Marker = setmetatable({}, Marker)
Marker.__index = Marker
Marker.__call = function()
    return "Marker", "Marker"
end

function Marker.New(type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ)
    _marker = {
        MarkerType = type or 0,
        Position = position or vector3(0,0,0),
        Scale = scale or vector3(1, 1, 1),
        Direction = vector3(0,0,0),
        Rotation = vector3(0,0,0),
        Distance = distance or 250.0,
        Color = color,
        PlaceOnGround = placeOnGround,
        BobUpDown = bobUpDown or false,
        Rotate = rotate or false,
        FaceCamera = faceCamera and not rotate or false,
        _height = 0,
        IsInMarker = false,
        CheckZ = checkZ or false,
    }
    return setmetatable(_marker, Marker)
end

function Marker:Draw()
    -- [Position.Z != _height] means that we make the check only if we change position
    -- but if we change position and the Z is still the same then we don't need to check again
    -- We draw it with _height + 0.1 to ensure marker drawing (like horizontal circles)

    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped, true)
    if(self:IsInRange() and self.PlaceOnGround and self.Position.z ~= self._height +0.1) then
        local success, height = GetGroundZFor_3dCoord(self.Position.x, self.Position.y, self.Position.z, false)
        self._height = height
        if(success) then
            self.Position = vector3(self.Position.x, self.Position.y, height+0.03)
        end
    end
    DrawMarker(self.MarkerType, self.Position, self.Direction, self.Rotation, self.Scale, self.Color.R, self.Color.G, self.Color.B, self.Color.A, self.BobUpDown, self.FaceCamera, 2, self.Rotate, nil,nil, false)
    local dist = vector3(0, 0, 0)
    if(self.CheckZ) then
        self.IsInMarker = ((pedPos.x - self.Position.x)^2 + (pedPos.y - self.Position.y)^2 + (pedPos.z - self.Position.z)^2) < #self.Scale/2
    else
        self.IsInMarker = ((pedPos.x - self.Position.x)^2 + (pedPos.y - self.Position.y)^2) < #self.Scale/2
    end
end

function Marker:IsInRange()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local dist = vector3(0, 0, 0)
    if(self.CheckZ) then
        dist = #(pos - self.Position) -- Use Z
    else
        dist = #(pos.xy - self.Position.xy) -- Do not use Z
    end
    return dist <= self.Distance
end

function Marker:SetColor(r, g, b, a)
    self.Color = {R=r,G=g,B=b,A=a}
end