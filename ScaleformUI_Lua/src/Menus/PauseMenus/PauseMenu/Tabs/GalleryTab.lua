GalleryTab = setmetatable({}, GalleryTab)
GalleryTab.__index = GalleryTab
GalleryTab.__call = function()
    return "BaseTab", "GalleryTab"
end

---@class GalleryTab
---@field public Base BaseTab
---@field public LeftItemList BasicTabItem[]
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
    local data = {
        Base = BaseTab.New(name or "", 3, color),
        LeftItemList = {},
        Label = name or "",
        TextTitle = "",
        GalleryItems = {},
        Minimap = nil,
        Index = 0,
        Focused = false,
        _focus = 0,
        Visible = false,
        txd = "",
        txn = "",
        maxItemsPerPage = 12,
        titleLabel = "",
        dateLabel = "",
        locationLabel = "",
        trackLabel = "",
        labelsVisible = "",
        state = 0,
        bigPic = false,
        CurPage = 1,
        currentSelection = 1,
        currentIndex = 1,
        OnFocusChanged = function(focus)
        end,
        OnGalleryModeChanged = function(tab, item, bigPicture)
        end,
        OnGalleryIndexChanged = function(tab, item, totalIndex, gridIndex)
        end,
        OnGalleryItemSelected = function(tab, item, totalIndex, gridIndex)
        end
    }
    return setmetatable(data, GalleryTab)
end

---Returns the max pages available.
---@return number
function GalleryTab:MaxPages()
    return math.ceil(#self.GalleryItems / 12)
end

function GalleryTab:shouldNavigateToNewPage(index)
    if #self.GalleryItems <= 12 or self:MaxPages() <= 1 then
        return false
    end

    return (self.currentSelection == 1 and index == 1) or (self.currentSelection == 5 and index == 5) or (self.currentSelection == 9 and index == 9) or
    (self.currentSelection == 4 and index == 4) or (self.currentSelection == 8 and index == 8) or (self.currentSelection == 12 and index == 12)
end

function GalleryTab:isItemVisible(index)
    local initial = (self.CurPage - 1) * self.maxItemsPerPage + 1
    return index > initial and index < initial + 11
end

function GalleryTab:gridIndexFromItemIndex(index)
    return index % 12
end

function GalleryTab:setTitle(txd, txn, state)
    self.txd = txd
    self.txn = txn
    self.state = state
    if self.Base.Parent ~= nil and self.Base.Parent:Visible() and self.Visible then
        self.bigPic = not (state == 0)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_GALLERY_TITLE", txd, txn, state)
    end
end

---Sets the title labels for all the items.
---@param maxItems number
---@param title string
---@param date string
---@param location string
---@param track string
---@param visible boolean
function GalleryTab:SetDescriptionLabels(maxItems, title, date, location, track, visible)
    self.maxItemsPerPage = maxItems
    self.titleLabel = title
    self.dateLabel = date
    self.locationLabel = location
    self.trackLabel = track
    self.labelsVisible = visible
    if self.Base.Parent ~= nil and self.Base.Parent:Visible() and self.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_GALLERY_DESCRIPTION_LABELS", maxItems, title, date, location, track, visible)
    end
end

---Adds a GalleryItem to the gallery.
---@param item GalleryItem
function GalleryTab:AddItem(item)
    item.Parent = self
    table.insert(self.GalleryItems, item)
    if item.Blip ~= nil then
        table.insert(self.Minimap.MinimapBlips, item.Blip)
    end
    if self.Base.Parent ~= nil and self.Base.Parent:Visible() and self.Visible then
        if #self.GalleryItems < 12 then
            local idx = IndexOf(self.GalleryItem, self) -1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_GALLERY_ITEM", idx, idx, 33, 0, 0, 1, "", item.TextureDictionary, item.TextureName, "", 1, false, item.Label1, item.Label2, item.Label3, item.Label4)
        end
    end
end

---Gets the current grid selection (1 -> 12)
---@return number | nil
function GalleryTab:CurrentSelection(index)
    if index == nil then
        return self.currentSelection
    else
        self.currentSelection = index
    end
end

function GalleryTab:updateHighLight()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_GALLERY_HIGHLIGHT", self.currentSelection-1, true)
end

function GalleryTab:updatePage()
    if not self.bigPic then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_GALLERY_SCROLL_LABEL")
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        BeginTextCommandScaleformString("GAL_NUM_PAGES")
        AddTextComponentInteger(self.CurPage)
        AddTextComponentInteger(self:MaxPages())
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    else
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_GALLERY_SCROLL_LABEL")
        ScaleformMovieMethodAddParamInt(self.currentIndex-1)
        ScaleformMovieMethodAddParamInt(#self.GalleryItems)
        ScaleformMovieMethodAddParamInt(self.maxItemsPerPage)
        EndScaleformMovieMethod()
    end
end