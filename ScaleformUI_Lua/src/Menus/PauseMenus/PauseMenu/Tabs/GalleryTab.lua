GalleryTab = {}
GalleryTab.__index = GalleryTab
setmetatable(GalleryTab, { __index = BaseTab })
GalleryTab.__call = function() return "GalleryTab" end

---@class GalleryTab
---@field public Base BaseTab
---@field public LeftItemList PauseMenuItem[]
---@field public Label string
---@field public TextTitle string
---@field public SettingsColumn SettingsListColumn
---@field public PlayersColumn PlayerListColumn
---@field public MissionsColumn MissionListColumn
---@field public StoreColumn StoreListColumn
---@field public Index number
---@field public Focused boolean
---@field public GalleryItems GalleryItem[]
---@field private txd string
---@field private txn string
---@field private maxItemsPerPage number
---@field private titleLabel string
---@field private dateLabel string
---@field private locationLabel string
---@field private trackLabel string
---@field private labelsVisible boolean
---@field private state number
---@field private bigPic boolean
---@field private CurPage number
---@field private currentSelection number
---@field private currentIndex number

---Creates a new Gallery tab.
---@param name string
---@param color SColor
---@param newStyle boolean
---@return GalleryTab
function GalleryTab.New(name, color)
    local base = BaseTab.New(name, color)
    base._identifier = "Page_Gallery"
    base.LeftColumn = GalleryColumn.New()
    base.bigPic = false
    base.OnFocusChanged = function(focus)
    end
    base.OnGalleryModeChanged = function(tab, item, bigPicture)
    end
    base.OnGalleryIndexChanged = function(tab, item, totalIndex, gridIndex)
    end
    base.OnGalleryItemSelected = function(tab, item, totalIndex, gridIndex)
    end
local meta = setmetatable(base, GalleryTab)
    meta.LeftColumn.Parent = meta
    meta.Minimap = MinimapPanel.New(meta)
    return meta
end

function GalleryTab:Populate()
    self.LeftColumn:Index(1)
    self.LeftColumn.currentPageIndex = 1
    self.LeftColumn:Populate()
end

function GalleryTab:GoUp()
    if not self.Focused then return end
    self.LeftColumn:GoUp()
    self.LeftColumn:UpdatePage()
    local it = self.LeftColumn.Items[self.LeftColumn.currentPageIndex]
    if self.bigPic then
        self:SetTitle(it.TextureDictionary, it.TextureName, 4)
    end

    if it.Blip ~= nil then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", false)
        self.Minimap:Enabled(true)
        self.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
    elseif not it.RightPanelDescription:IsNullOrEmpty() then
        self.Minimap:Enabled(false)
        local labels = it.RightPanelDescription:SplitLabel()
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE");
        ScaleformMovieMethodAddParamInt(self.LeftColumn.position);
        BeginTextCommandScaleformString("CELL_EMAIL_BCON");
        for i=1, #labels, 1 do
            AddTextComponentScaleform(labels[i]);
        end
        EndTextCommandScaleformString_2();
        ScaleformMovieMethodAddParamBool(true);
        EndScaleformMovieMethod();
    else
        self.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
    end
end

function GalleryTab:GoDown()
    if not self.Focused then return end
    self.LeftColumn:GoDown()
    self.LeftColumn:UpdatePage()
    local it = self.LeftColumn.Items[self.LeftColumn.currentPageIndex]
    if self.bigPic then
        self:SetTitle(it.TextureDictionary, it.TextureName, 4)
    end

    if it.Blip ~= nil then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", false)
        self.Minimap:Enabled(true)
        self.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
    elseif not it.RightPanelDescription:IsNullOrEmpty() then
        self.Minimap:Enabled(false)
        local labels = it.RightPanelDescription:SplitLabel()
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE");
        ScaleformMovieMethodAddParamInt(self.LeftColumn.position);
        BeginTextCommandScaleformString("CELL_EMAIL_BCON");
        for i=1, #labels, 1 do
            AddTextComponentScaleform(labels[i]);
        end
        EndTextCommandScaleformString_2();
        ScaleformMovieMethodAddParamBool(true);
        EndScaleformMovieMethod();
    else
        self.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
    end
end

function GalleryTab:GoLeft()
    if not self.Focused then return end
    self.LeftColumn:GoLeft()
    self.LeftColumn:UpdatePage()
    local it = self.LeftColumn.Items[self.LeftColumn.currentPageIndex]
    if self.bigPic then
        self:SetTitle(it.TextureDictionary, it.TextureName, 4)
    end

    if it.Blip ~= nil then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", false)
        self.Minimap:Enabled(true)
        self.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
    elseif not it.RightPanelDescription:IsNullOrEmpty() then
        self.Minimap:Enabled(false)
        local labels = it.RightPanelDescription:SplitLabel()
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE");
        ScaleformMovieMethodAddParamInt(self.LeftColumn.position);
        BeginTextCommandScaleformString("CELL_EMAIL_BCON");
        for i=1, #labels, 1 do
            AddTextComponentScaleform(labels[i]);
        end
        EndTextCommandScaleformString_2();
        ScaleformMovieMethodAddParamBool(true);
        EndScaleformMovieMethod();
    else
        self.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
    end
end

function GalleryTab:GoRight()
    if not self.Focused then return end
    self.LeftColumn:GoRight()
    self.LeftColumn:UpdatePage()
    local it = self.LeftColumn.Items[self.LeftColumn.currentPageIndex]
    if self.bigPic then
        self:SetTitle(it.TextureDictionary, it.TextureName, 4)
    end

    if it.Blip ~= nil then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", false)
        self.Minimap:Enabled(true)
        self.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
    elseif not it.RightPanelDescription:IsNullOrEmpty() then
        self.Minimap:Enabled(false)
        local labels = it.RightPanelDescription:SplitLabel()
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE");
        ScaleformMovieMethodAddParamInt(self.LeftColumn.position);
        BeginTextCommandScaleformString("CELL_EMAIL_BCON");
        for i=1, #labels, 1 do
            AddTextComponentScaleform(labels[i]);
        end
        EndTextCommandScaleformString_2();
        ScaleformMovieMethodAddParamBool(true);
        EndScaleformMovieMethod();
    else
        self.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
    end
end

function GalleryTab:Select()
    if not self.Focused then return end
    self.CurrentColumnIndex = 1
    self.LeftColumn:Select()
end

function GalleryTab:GoBack()
    if not self.Focused then return end
    self.LeftColumn:GoBack()
    self.CurrentColumnIndex = 0
end

function GalleryTab:ShowColumns()
    self.LeftColumn:ShowColumn()
end

function GalleryTab:Focus()
    BaseTab.Focus(self)
    self.LeftColumn:UpdatePage()
    local it = self.LeftColumn.Items[self.LeftColumn:Index()]
    if it.Blip ~= nil then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", false)
        self.Minimap:Enabled(true)
        self.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
    elseif not it.RightPanelDescription:IsNullOrEmpty() then
        self.Minimap:Enabled(false)
        local labels = it.RightPanelDescription:SplitLabel()
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE");
        ScaleformMovieMethodAddParamInt(self.LeftColumn.position);
        BeginTextCommandScaleformString("CELL_EMAIL_BCON");
        for i=1, #labels, 1 do
            AddTextComponentScaleform(labels[i]);
        end
        EndTextCommandScaleformString_2();
        ScaleformMovieMethodAddParamBool(true);
        EndScaleformMovieMethod();
    else
        self.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
    end
end

function GalleryTab:UnFocus()
    BaseTab.UnFocus(self)
    self.Minimap:Enabled(false)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.LeftColumn.position, "", true)
end

function GalleryTab:SetTitle(txd, txn, state)
    self.LeftColumn:SetTitle(txd, txn, state)
end

function GalleryTab:SetDescriptionLabels(title, date, location, track, visible)
    self.LeftColumn.titleLabel = title;
    self.LeftColumn.dateLabel = date;
    self.LeftColumn.locationLabel = location;
    self.LeftColumn.trackLabel = track;
    self.LeftColumn.labelsVisible = visible;
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DESCRIPTION", self.LeftColumn.position, title, date, location, track, visible)
end

function GalleryTab:AddItem(item)
    self.LeftColumn:AddItem(item)
    if item.Blip ~= nil then
        table.insert(self.Minimap.MinimapBlips, item.Blip)
    end
    if self.Parent ~= nil and self.Parent:Visible() and self.Visible then
        if #self.LeftColumn.Items < 12 then
            self.LeftColumn:Populate()
        end
    end
end

function GalleryTab:MouseEvent(eventType, context, index)
    if not self.Focused then return end
    if eventType == 5 then
        if index + 1 ~= self.LeftColumn:Index() then
            self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(false)
            self.LeftColumn:Index(index)
            self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(true)
            return
        end
        self.LeftColumn:Select()
        self.CurrentColumnIndex = 1
    elseif eventType == 10 or eventType == 11 then
        local dir = -1
        if eventType == 11 then
            dir = 1
        end
        self.LeftColumn:MouseScroll(dir)
    end
end