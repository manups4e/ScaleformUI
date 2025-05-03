MinimapRoute = setmetatable({}, MinimapRoute)
MinimapRoute.__index = MinimapRoute
MinimapRoute.__call = function()
    return "LobbyComponent", "MinimapRoute"
end

---@class MinimapRoute
---@field private New fun()
---@field public StartPoint MinimapRaceCheckpoint
---@field public EndPoint MinimapRaceCheckpoint
---@field public CheckPoints MinimapRaceCheckpoint[]
---@field public RadarThickness number
---@field public MapThickness number
---@field public RouteColor HudColours
---@field private SetupCustomRoute fun()

function MinimapRoute.New()
    local _data = {
        StartPoint = MinimapRaceCheckpoint.New(0, vector3(0, 0, 0)),
        EndPoint = MinimapRaceCheckpoint.New(0, vector3(0, 0, 0)),
        CheckPoints = {},
        MapThickness = 30,
        RouteColor = HudColours.HUD_COLOUR_FREEMODE
    }
    return setmetatable(_data, MinimapRoute)
end

function MinimapRoute:SetupCustomRoute()
    if self.StartPoint == nil or self.StartPoint.Position.x == 0 or self.StartPoint.Position.y == 0 or self.StartPoint.Position.z == 0 then
        return
    end

    ClearGpsFlags()
    SetGpsFlags(8, 0.0)
    StartGpsCustomRoute(self.RouteColor, true, true)

    -- Start Point
    local startPoint = self.StartPoint
    RaceGalleryNextBlipSprite(startPoint.Sprite)
    local bStart = RaceGalleryAddBlip(startPoint.Position.x, startPoint.Position.y, startPoint.Position.z)
    if startPoint.Scale > 0 then
        SetBlipScale(bStart, startPoint.Scale)
    end
    SetBlipColour(bStart, startPoint.Color)
    if startPoint.Number then
        ShowNumberOnBlip(bStart, startPoint.Number)
    else
        HideNumberOnBlip(bStart)
    end
    AddPointToGpsCustomRoute(startPoint.Position.x, startPoint.Position.y, startPoint.Position.z)

    -- CheckPoints
    for i = 1, #self.CheckPoints, 1 do
        local checkPoint = self.CheckPoints[i]
        RaceGalleryNextBlipSprite(checkPoint.Sprite)
        local b = RaceGalleryAddBlip(checkPoint.Position.x, checkPoint.Position.y, checkPoint.Position.z)
        if checkPoint.Scale > 0 then
            SetBlipScale(b, checkPoint.Scale)
        end
        SetBlipColour(b, checkPoint.Color)
        if checkPoint.Number then
            ShowNumberOnBlip(b, checkPoint.Number)
        else
            HideNumberOnBlip(b)
        end
        AddPointToGpsCustomRoute(checkPoint.Position.x, checkPoint.Position.y, checkPoint.Position.z)
    end

    -- End Point
    local endPoint = self.EndPoint
    RaceGalleryNextBlipSprite(endPoint.Sprite)
    local bEnd = RaceGalleryAddBlip(endPoint.Position.x, endPoint.Position.y, endPoint.Position.z)
    if startPoint.Scale > 0 then
        SetBlipScale(bEnd, endPoint.Scale)
    end
    SetBlipColour(bEnd, endPoint.Color)
    if endPoint.Number then
        ShowNumberOnBlip(bEnd, endPoint.Number)
    else
        HideNumberOnBlip(bEnd)
    end
    AddPointToGpsCustomRoute(endPoint.Position.x, endPoint.Position.y, endPoint.Position.z)

    SetGpsCustomRouteRender(true, 18, self.MapThickness)
end
