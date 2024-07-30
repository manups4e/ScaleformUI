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

    RaceGalleryNextBlipSprite(self.StartPoint.Sprite)
    RaceGalleryAddBlip(self.StartPoint.Position.x, self.StartPoint.Position.y, self.StartPoint.Position.z)

    AddPointToGpsCustomRoute(self.StartPoint.Position.x, self.StartPoint.Position.y, self.StartPoint.Position.z)

    for i = 1, #self.CheckPoints, 1 do
        local checkPoint = self.CheckPoints[i]
        RaceGalleryNextBlipSprite(checkPoint.Sprite)
        local b = RaceGalleryAddBlip(checkPoint.Position.x, checkPoint.Position.y, checkPoint.Position.z)
        if checkPoint.Scale > 0 then
            SetBlipScale(b, checkPoint.Scale)
        end
        SetBlipColour(b, checkPoint.Color)
        AddPointToGpsCustomRoute(checkPoint.Position.x, checkPoint.Position.y, checkPoint.Position.z)
    end

    RaceGalleryNextBlipSprite(self.EndPoint.Sprite)
    RaceGalleryAddBlip(self.EndPoint.Position.x, self.EndPoint.Position.y, self.EndPoint.Position.z)
    AddPointToGpsCustomRoute(self.EndPoint.Position.x, self.EndPoint.Position.y, self.EndPoint.Position.z)

    SetGpsCustomRouteRender(true, 18, self.MapThickness)
end
