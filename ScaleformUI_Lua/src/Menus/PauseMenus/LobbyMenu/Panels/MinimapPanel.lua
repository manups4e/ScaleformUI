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
---@field private New fun(parent:BaseTab)
---@field public Parent BaseTab
---@field public MinimapBlips FakeBlip[]
---@field public MinimapRoute MinimapRoute
---@field public Enabled fun(_e: boolean|nil)
---@field private InitializeMapSize fun()
---@field private GetVectorToCheck fun(i:number)
---@field private SetupBlips fun()
---@field private MaintainMap fun()
---@field private ProcessMap fun()
---@field private InitializeMapDisplay fun()
---@field private InitializeMap fun()
---@field private RefreshZoom fun()
---@field private Dispose fun()
---@field public ClearMinimap fun()

function MinimapPanel.New(parent)
    local _data = {
        Parent = parent,
        MinimapBlips = {},
        MinimapRoute = MinimapRoute.New(),
        mapPosition = vector2(0,0),
        enabled = false,
        turnedOn = false,
        localMapStage = 0
    }
    return setmetatable(_data, MinimapPanel)
end

function MinimapPanel:Enabled(_e)
    if _e == nil then
        return self.enabled
    else
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                if self.Parent.listCol[self.Parent._focus].Type == "players" then
                    if self.Parent.PlayersColumn.Items[self.Parent.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                        self:Dispose()
                        return
                    end
                end
            elseif pSubT == "PauseMenu" then
                local tab = self.Parent.Tabs[self.Parent.index]
                local cur_tab, cur_sub_tab = tab()
                if cur_sub_tab == "PlayerListTab" then
                    if tab.listCol[tab._focus].Type == "players" then
                        if tab.PlayerListColumn.Items[tab.PlayerListColumn:CurrentSelection()]:KeepPanelVisible() then
                            self:Dispose()
                            return
                        end
                    end
                end
            end
        end
        self.enabled = ToBool(_e)
        if _e == true then
            self.localMapStage = 0
        else
            self.localMapStage = -1
            if self.turnedOn then
                DisplayRadar(false);
                SetMapFullScreen(false);
                self.turnedOn = false;
            end
        end
        if self.Parent ~= nil and self.Parent:Visible() then
            local show = not self.enabled
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("HIDE_MISSION_PANEL", show)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("HIDE_PLAYERS_TAB_MISSION_PANEL", self.Parent.index-1, show)
            end
        end
    end
end

function MinimapPanel:InitializeMapSize()
    local iMaxNodesToCheck = 202
    local vNodeMax = vector3(0,0,0)
    local vNodeMin = vector3(0,0,0)

    for i = 1,iMaxNodesToCheck+1, 1 do
        local vectorNode = self:    GetVectorToCheck(i)

        if (#self.MinimapBlips > i) then
            if (LengthSquared(self.MinimapBlips[i].Position) > LengthSquared(vectorNode)) then
                vectorNode = self.MinimapBlips[i].Position
            end
        end

        if i == 1 then
            vNodeMax = vectorNode
            vNodeMin = vectorNode
        else
            if (vectorNode.x > vNodeMax.x) then
                vNodeMax = vector3(vectorNode.x, vNodeMax.y, vNodeMax.z)
            end
            if (vectorNode.x < vNodeMin.x) then
                vNodeMin = vector3(vectorNode.x, vNodeMax.y, vNodeMax.z)
            end
            if (vectorNode.y > vNodeMax.y) then
                vNodeMax = vector3(vNodeMax.x, vectorNode.y, vNodeMax.z)
            end
            if (vectorNode.y < vNodeMin.y) then
                vNodeMin = vector3(vNodeMax.x, vectorNode.y, vNodeMax.z)
            end
        end
    end

    -- Calculate our range and get the correct zoom.
    self.mapPosition = vector2((vNodeMax.x + vNodeMin.x) / 2, (vNodeMax.y + vNodeMin.y) / 2)

    LockMinimapPosition(self.mapPosition.x, self.mapPosition.y)
    LockMinimapAngle(0)

    local DistanceX = vNodeMax.x - vNodeMin.x
    local DistanceY = vNodeMax.y - vNodeMin.y

    if (DistanceX > DistanceY) then
        self.zoomDistance = DistanceX / 1.5
    else
        self.zoomDistance = DistanceY / 1.5
    end
end
function MinimapPanel:GetVectorToCheck(i)
    if i == 1 then
        return self.MinimapRoute.StartPoint.Position
    elseif #self.MinimapRoute.CheckPoints >= i then
        return self.MinimapRoute.CheckPoints[i].Position
    elseif i == #self.MinimapRoute.CheckPoints+1 then
        return self.MinimapRoute.EndPoint.Position
    else
        return vector3(0, 0, 0)
    end
end
function MinimapPanel:SetupBlips()
    for _,blip in pairs (self.MinimapBlips) do
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
            DisplayRadar(true)
            SetMapFullScreen(true)
            self.turnedOn = true
        end
    else
        if self.turnedOn then
            DisplayRadar(false)
            SetMapFullScreen(false)
            self.turnedOn = false
            self:Dispose()
        end
    end
    SetPlayerBlipPositionThisFrame(-5000.0, -5000.0)
    self:RefreshZoom()
end
function MinimapPanel:InitializeMapDisplay()
    DeleteWaypoint();
    SetWaypointOff();
    ClearGpsCustomRoute();
    ClearGpsMultiRoute();
    SetPoliceRadarBlips(false);

    self.MinimapRoute:SetupCustomRoute();
    self:SetupBlips();
end
function MinimapPanel:InitializeMap()
    -- Use the data to set up our map.
    self:InitializeMapSize();
    -- Initialise all our blips from data
    self:InitializeMapDisplay();
    -- Set the zoom now
    self:RefreshZoom();
    self.localMapStage = 1;
end
function MinimapPanel:RefreshZoom()
    if self.zoomDistance ~= 0 then
        SetRadarZoomToDistance(self.zoomDistance);
    end
    LockMinimapPosition(self.mapPosition.x, self.mapPosition.y);
end

function MinimapPanel:Dispose()
    self.localMapStage = -1;
    self.enabled = false;
    N_0x2de6c5e2e996f178(1);
    DisplayRadar(false);
    RaceGalleryFullscreen(false);
    ClearRaceGalleryBlips();
    self.zoomDistance = 0;
    SetRadarZoom(0);
    SetGpsCustomRouteRender(false, 18, 30);
    SetGpsMultiRouteRender(false);
    UnlockMinimapPosition();
    UnlockMinimapAngle();
    DeleteWaypoint();
    ClearGpsCustomRoute();
    ClearGpsFlags();
    self.MinimapBlips = {}
    self.MinimapRoute = MinimapRoute.New()
end

function MinimapPanel:ClearMinimap()
    self.MinimapBlips = {}
    self.MinimapRoute = MinimapRoute.New();
    self.localMapStage = -1;
    self.zoomDistance = 0;
    ClearRaceGalleryBlips();
    SetRadarZoom(0);
    SetGpsCustomRouteRender(false, 18, 30);
    DeleteWaypoint();
    ClearGpsCustomRoute();
    ClearGpsFlags();
end