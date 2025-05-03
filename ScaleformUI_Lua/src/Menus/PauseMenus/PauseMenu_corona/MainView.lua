MainView = {}
MainView.__index = MainView
setmetatable(MainView, { __index = TabView })
MainView.__call = function() return "MainView" end


---@class MainView
---@field public Title string
---@field public Subtitle string
---@field public SideTop string
---@field public SideMid string
---@field public SideBot string
---@field public SettingsColumn SettingsListColumn
---@field public PlayersColumn PlayerListColumn
---@field public MissionPanel MissionDetailsPanel
---@field public InstructionalButtons InstructionalButton[]
---@field public OnLobbyMenuOpen fun(menu: MainView)
---@field public OnLobbyMenuClose fun(menu: MainView)
---@field public TemporarilyHidden boolean
---@field public controller boolean
---@field public _focus number

function MainView.New(title, subtitle, sideTop, sideMid, sideBot)
    local base = TabView.New(title, subtitle, sideTop, sideMid, sideBot)
    base.IsCorona = true
    base.coronaTab = PlayerListTab.New("corona for mainview", SColor.HUD_None)
    base.OnLobbyMenuOpen = function(menu)
    end
    base.OnLobbyMenuClose = function(menu)
    end
    local meta = setmetatable(base, MainView)
    meta:AddTab(meta.coronaTab)
    meta.Minimap = meta.coronaTab.Minimap
    meta.Minimap.Parent = meta
    return meta
end

function MainView:SelectColumn(column)
    self.coronaTab:SwitchColumn(column)
end

function MainView:SwitchColumn(column)
    self.coronaTab:SwitchColumn(column)
end

function MainView:SetupLeftColumn(column)
    self.coronaTab:SetupLeftColumn(column)
end

function MainView:SetupCenterColumn(column)
    self.coronaTab:SetupCenterColumn(column)
end

function MainView:SetupRightColumn(column)
    self.coronaTab:SetupRightColumn(column)
end