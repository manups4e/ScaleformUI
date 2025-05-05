MinimapPanel = setmetatable({}, MinimapPanel)
MinimapPanel.__index = MinimapPanel
MinimapPanel.__call = function()
    return "Panel", "MinimapPanel"
end

---@class MinimapPanel
---@field private enabled boolean
---@field private turnedOn boolean
---@field private mapPosition vector2
---@field private localMapStage number
---@field private IsRadarVisible boolean
---@field private New fun(parent:BaseTab)
---@field public Parent BaseTab
---@field public MinimapBlips FakeBlip[]
---@field public MinimapRoute MinimapRoute
---@field public Enabled fun(_e: boolean|nil)
---@field private InitializeMapSize fun()
---@field private SetupBlips fun()
---@field private MaintainMap fun()
---@field private ProcessMap fun()
---@field private InitializeMapDisplay fun()
---@field private InitializeMap fun()
---@field private RefreshZoom fun()
---@field private Dispose fun()
---@field public ClearMinimap fun()

function MinimapPanel.New(parentTab)
    local _data = {
        Parent = nil,
        ParentTab = parentTab,
        MinimapBlips = {},
        MinimapRoute = MinimapRoute.New(),
        mapPosition = vector2(0, 0),
        enabled = false,
        turnedOn = false,
        localMapStage = -1,
        HidePedBlip = false,
        IsRadarVisible = not IsRadarHidden(),
    }
    return setmetatable(_data, MinimapPanel)
end

function MinimapPanel:Enabled(_e)
    if _e == nil then
        return self.enabled
    else
        if self.Parent ~= nil and self.Parent:Visible() then
            if self.ParentTab() == "PlayerListTab" and self.ParentTab:CurrentColumn().type == PLT_COLUMNS.PLAYERS then
                if self.ParentTab:CurrentColumn():CurrentItem():KeepPanelVisible() then
                    self:Dispose()
                    return
                end
            end
        end
        self.enabled = ToBool(_e)
        if _e == true then
            if self.localMapStage == -1 then
                self.localMapStage = 0
            end
        else
            self.localMapStage = -1
            if self.turnedOn then
                self.IsRadarVisible = IsMinimapRendering()
                DisplayRadar(false)
                RaceGalleryFullscreen(false)
                self.turnedOn = false
            end
        end
        if self.Parent ~= nil and self.Parent:Visible() then
            if self.ParentTab() == "PlayerListTab" then
                if self.ParentTab:CurrentColumn().type == PLT_COLUMNS.PLAYERS then
                    if ToBool(_e) then
                        self.ParentTab:CurrentColumn():CurrentItem():Dispose()
                    else
                        self.ParentTab:CurrentColumn():CurrentItem():AddPedToPauseMenu()
                    end
                end
                if self.ParentTab.RightColumn ~= nil and self.ParentTab.RightColumn.type == PLT_COLUMNS.MISSION_DETAILS then
                    self.ParentTab.RightColumn:ColumnVisible(not ToBool(_e) and
                    self.ParentTab:CurrentColumn().type ~= PLT_COLUMNS.PLAYERS)
                end
            end
        end
    end
end

function MinimapPanel:InitializeMapSize()
    local top = -math.huge
    local bottom = math.huge
    local left = math.huge
    local right = -math.huge

    for k, data in pairs(self.MinimapRoute.CheckPoints) do
        top = math.max(top, data.Position.y)
        bottom = math.min(bottom, data.Position.y)
        left = math.min(left, data.Position.x)
        right = math.max(right, data.Position.x)
    end

    top = math.max(top, self.MinimapRoute.StartPoint.Position.y)
    bottom = math.min(bottom, self.MinimapRoute.StartPoint.Position.y)
    left = math.min(left, self.MinimapRoute.StartPoint.Position.x)
    right = math.max(right, self.MinimapRoute.StartPoint.Position.x)

    top = math.max(top, self.MinimapRoute.EndPoint.Position.y)
    bottom = math.min(bottom, self.MinimapRoute.EndPoint.Position.y)
    left = math.min(left, self.MinimapRoute.EndPoint.Position.x)
    right = math.max(right, self.MinimapRoute.EndPoint.Position.x)

    local topLeft = vector3(left, top, 0)
    local bottomRight = vector3(right, bottom, 0)

    -- Center of square area
    self.mapPosition = vector2((topLeft.x + bottomRight.x) / 2, (topLeft.y + bottomRight.y) / 2)

    -- Calculate our range and get the correct zoom.
    local DistanceX = math.abs(left - right)
    local DistanceY = math.abs(top - bottom)
    local Diagonal = math.sqrt(DistanceX ^ 2 + DistanceY ^ 2)

    if DistanceX == DistanceY then      -- Square
        self.zoomDistance = Diagonal / 2.4
    elseif (DistanceX > DistanceY) then -- Horizontal
        local mul = 1.7
        self.zoomDistance = math.min(DistanceX / mul, Diagonal / mul)
    else -- Vertical
        local mul = 2.4
        self.zoomDistance = math.max(DistanceY / mul, Diagonal / mul)
    end

    self:RefreshMapPosition(self.mapPosition)
    LockMinimapAngle(0)

    --!! Draw Debug
    -- local blipArea = AddBlipForArea(self.mapPosition.x, self.mapPosition.y, 0.0, DistanceX, DistanceY)
    -- SetBlipAlpha(blipArea, 150)
    -- RaceGalleryNextBlipSprite(1)
    -- local blipTop = RaceGalleryAddBlip(topLeft.x, topLeft.y, 0.0)
    -- RaceGalleryNextBlipSprite(1)
    -- local blipBottom = RaceGalleryAddBlip(bottomRight.x, bottomRight.y, 0.0)
    -- ShowNumberOnBlip(blipTop, 1)
    -- ShowNumberOnBlip(blipBottom, 2)
end

function MinimapPanel:RefreshMapPosition(position)
    if position == vec(0,0) then return end
    self.mapPosition = position
    LockMinimapPosition(self.mapPosition.x, self.mapPosition.y)
    if self.ParentTab() == "GalleryTab" then
        if self.ParentTab.bigPic then
            self.zoomDistance = 600.0
        else
            self.zoomDistance = 1200.0
        end
    end
end

function MinimapPanel:SetupBlips()
    for _, blip in pairs(self.MinimapBlips) do
        RaceGalleryNextBlipSprite(blip.Sprite)
        local b = RaceGalleryAddBlip(blip.Position.x, blip.Position.y, blip.Position.z)
        if blip.Scale > 0 then
            SetBlipScale(b, blip.Scale) 
        end
        SetBlipColour(b, blip.Color)
    end
end

function MinimapPanel:MaintainMap()
    if self.localMapStage == 0 then
        self:InitializeMap()
    elseif self.localMapStage == 1 then
        self:ProcessMap()
    end
end

function MinimapPanel:ProcessMap()
    if self.enabled then
        if not self.turnedOn then
            DisplayRadar(self.IsRadarVisible)
            RaceGalleryFullscreen(true)
            self.turnedOn = true
        end
    else
        if self.turnedOn then
            self.IsRadarVisible = not IsRadarHidden()
            DisplayRadar(false)
            RaceGalleryFullscreen(false)
            self.turnedOn = false
            self:Dispose()
        end
    end
    if self.HidePedBlip then
        SetPlayerBlipPositionThisFrame(-5000.0, -5000.0)
    end
    self:RefreshZoom()
end

function MinimapPanel:InitializeMapDisplay()
    DeleteWaypoint()
    SetWaypointOff()
    ClearGpsCustomRoute()
    ClearGpsMultiRoute()
    SetPoliceRadarBlips(false)

    self.MinimapRoute:SetupCustomRoute()
    self:SetupBlips()
end

function MinimapPanel:InitializeMap()
    -- Use the data to set up our map.
    self:InitializeMapSize()
    -- Initialise all our blips from data
    self:InitializeMapDisplay()
    -- Set the zoom now
    self:RefreshZoom()
    self.localMapStage = 1
end

function MinimapPanel:RefreshZoom()
    if self.zoomDistance ~= 0 then
        SetRadarZoomToDistance(self.zoomDistance)
    end
    LockMinimapPosition(self.mapPosition.x, self.mapPosition.y)
end

function MinimapPanel:Dispose()
    self.localMapStage = 0
    self.enabled = false
    SetPoliceRadarBlips(true)
    PauseToggleFullscreenMap(false)
    DisplayRadar(self.IsRadarVisible)
    RaceGalleryFullscreen(false)
    ClearRaceGalleryBlips()
    self.zoomDistance = 0
    SetRadarZoom(0)
    SetGpsCustomRouteRender(false, 18, 30)
    SetGpsMultiRouteRender(false)
    UnlockMinimapPosition()
    UnlockMinimapAngle()
    DeleteWaypoint()
    ClearGpsCustomRoute()
    ClearGpsFlags()
    SetBigmapActive(false, false)
    self.MinimapBlips = {}
    self.MinimapRoute = MinimapRoute.New()
end

function MinimapPanel:ClearMinimap()
    self.MinimapBlips = {}
    self.MinimapRoute = MinimapRoute.New()
    self.localMapStage = 0
    self.zoomDistance = 0
    ClearRaceGalleryBlips()
    SetRadarZoom(0)
    SetGpsCustomRouteRender(false, 18, 30)
    DeleteWaypoint()
    ClearGpsCustomRoute()
    ClearGpsFlags()
    SetBigmapActive(false, false)
end
