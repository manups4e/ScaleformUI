GalleryItem = setmetatable({}, GalleryItem)
GalleryItem.__index = GalleryItem
GalleryItem.__call = function()
    return "BasicTabItem", "GalleryItem"
end

---@class GalleryItem
---@field public TextureDictionary string
---@field public TextureName string
---@field public Label1 string
---@field public Label2 string
---@field public Label3 string
---@field public Label4 string
---@field public RightPanelDescription string
---@field public Parent GalleryTab
---@field public Blip FakeBlip
function GalleryItem.New(txd, txn, label1, label2, label3, label4)
    local data = {
        TextureDictionary = txd or "",
        TextureName = txn or "",
        Label1 = label1 or "",
        Label2 = label2 or "",
        Label3 = label3 or "",
        Label4 = label4 or "",
        RightPanelDescription = "",
        Parent = nil,
        Blip = nil,
        Activated = function (tab, item, totalIndex, gridIndex)
        end
    }
    return setmetatable(data, GalleryItem)
end

---Sets item description labels.
---@param label1 string
---@param label2 SColor
---@param label3 boolean
---@param label4 boolean
function GalleryItem:SetLabels(label1, label2, label3, label4)
    self.Label1 = label1
    self.Label2 = label2
    self.Label3 = label3
    self.Label4 = label4
    if self.Parent ~= nil and self.Parent.Base ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() and self.Parent.Visible then
        if self.Parent:isItemVisible(IndexOf(self.Parent.GalleryItems, self)) then
            local gridPosition = self.Parent:gridIndexFromItemIndex(IndexOf(self.Parent.GalleryItems, self))
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_GALLERY_ITEM", gridPosition-1, gridPosition-1, 33, 4, 0, 1, self.Label1, self.Label2, self.TextureDictionary, self.TextureName, 1, false, self.Label3, self.Label4)
        end
    end
end

---Sets item long panel description.
---@param description string
function GalleryItem:SetRightDescription(description)
    self.RightPanelDescription = description
    if self.Blip ~= nil then return end
    if self.Parent ~= nil and self.Parent.Base ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() and self.Parent.Visible then
        if self.Parent:isItemVisible(IndexOf(self.Parent.GalleryItems, self)) then
            AddTextEntry("gallerytab_desc", self.RightPanelDescription)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_GALLERY_PANEL_HIDDEN", false)
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_GALLERY_PANEL_DESCRIPTION")
            BeginTextCommandScaleformString("gallerytab_desc")
            EndTextCommandScaleformString_2()
            EndScaleformMovieMethod()
        end
    end
end