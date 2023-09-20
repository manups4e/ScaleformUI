Marker = setmetatable({}, Marker)
Marker.__index = Marker
Marker.__call = function()
    return "Marker"
end

---@class Marker
---@field public Type MarkerType
---@field public Position vector3
---@field public Scale vector3
---@field public Direction vector3
---@field public Rotation vector3
---@field public Distance number
---@field public Color SColor -- {Red, Green, Blue, Alpha}
---@field public PlaceOnGround boolean
---@field public BobUpDown boolean
---@field public Rotate boolean
---@field public FaceCamera boolean
---@field public IsInMarker boolean
---@field public CheckZ boolean
---@field private _height number
---@field public Draw fun(self: Marker):nil
---@field public IsInRange fun(self: Marker):boolean

---Creates a new marker
---@param type MarkerType?
---@param position vector3
---@param scale vector3
---@param distance number
---@param color SColor -- {R: Red, G: Green, B: Blue, A: Alpha}
---@param placeOnGround boolean
---@param bobUpDown boolean
---@param rotate boolean
---@param faceCamera boolean
---@param checkZ boolean
---@return Marker
function Marker.New(type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ)
    local _marker = {
        Type = type or MarkerType.UpsideDownCone,
        Position = position or vector3(0, 0, 0),
        Scale = scale or vector3(1, 1, 1),
        Direction = vector3(0, 0, 0),
        Rotation = vector3(0, 0, 0),
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
    if (self:IsInRange() and self.PlaceOnGround and self.Position.z ~= self._height + 0.1) then
        local success, height = GetGroundZFor_3dCoord(self.Position.x, self.Position.y, self.Position.z, false)
        self._height = height
        if (success) then
            self.Position = vector3(self.Position.x, self.Position.y, height + 0.03)
        end
    end

    DrawMarker(self.Type, self.Position.x, self.Position.y, self.Position.z, self.Direction.x, self.Direction.y,
        self.Direction.z, self.Rotation.x, self.Rotation.y, self.Rotation.z, self.Scale.x, self.Scale.y, self.Scale.z,
        ---@diagnostic disable-next-line: param-type-mismatch -- Texture dictionary and texture name have to be strings but cannot be empty strings
        self.Color.R, self.Color.G, self.Color.B, self.Color.A, self.BobUpDown, self.FaceCamera, 2, self.Rotate, nil, nil,
        false)
    local posDif = pedPos - self.Position
    local distanceSquared = (posDif.x * posDif.x) + (posDif.y * posDif.y) + (posDif.z * posDif.z)
    if (self.CheckZ) then
        -- unknown reason as to why this stopped working as well as it should.
        -- self.IsInMarker = distanceSquared <= (self.Scale.x / 2) ^ 2 or distanceSquared <= (self.Scale.y / 2) ^ 2 or
        --     distanceSquared <= (self.Scale.z / 2) ^ 2
        self.IsInMarker = IsVectorInsideSphere(pedPos, self.Position, self.Scale)
    else
        self.IsInMarker = distanceSquared <= (self.Scale.x / 2) ^ 2 or distanceSquared <= (self.Scale.y / 2) ^ 2
    end
end

---Returns true if the player is in range of the marker
---@return boolean
function Marker:IsInRange()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local dist = vector3(0, 0, 0)
    if (self.CheckZ) then
        dist = #(pos - self.Position) --[[@as vector3]]       -- Use Z
    else
        dist = #(pos.xy - self.Position.xy) --[[@as vector3]] -- Do not use Z
    end
    return dist <= self.Distance
end

---Sets the marker color
function Marker:SetColor(color)
    self.Color = color
end
