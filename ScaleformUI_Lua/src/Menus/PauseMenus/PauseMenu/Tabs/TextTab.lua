TextTab = setmetatable({}, TextTab)
TextTab.__index = TextTab
TextTab.__call = function()
    return "BaseTab", "TextTab"
end

---@class TextTab

function TextTab.New(name, _title, color)
    local data = {
        Base = BaseTab.New(name or "", 0, color),
        Label = name,
        TextTitle = _title or "",
        LabelsList = {},
        LeftItemList = {},
        Index = 0,
        Focused = false,
        BGTextureDict = "",
        BGTextureName = "",
        RightTextureDict = "",
        RightTextureName = "",
        Parent = nil
    }
    return setmetatable(data, TextTab)
end

function TextTab:AddTitle(title)
    if not title:IsNullOrEmpty() then
        self.TextTitle = title
    end
end

function TextTab:AddItem(item)
    self.LabelsList[#self.LabelsList + 1] = item
end

function TextTab:UpdateBackground(txd, txn)
    self.BGTextureDict = txd
    self.BGTextureName = txn
    if self.Parent ~= nil and self.Base.Parent ~= nil and self.Base.Parent:Visible() then
        local tab = IndexOf(self.Base.Parent.Tabs, self.Parent) - 1
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_BASE_TAB_BACKGROUND", tab, txd, txn)
    end
end

function TextTab:AddPicture(txd, txn)
    self.RightTextureDict = txd
    self.RightTextureName = txn
    if self.Parent ~= nil and self.Base.Parent ~= nil and self.Base.Parent:Visible() then
        local tab = IndexOf(self.Base.Parent.Tabs, self.Parent) - 1
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_BASE_TAB_RIGHT_PICTURE", tab, txd, txn)
    end
end
