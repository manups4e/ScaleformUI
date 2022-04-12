MenuPool = setmetatable({}, MenuPool)
MenuPool.__index = MenuPool

---New
function MenuPool.New()
    local _MenuPool = {
        Menus = {},
        PauseMenus = {}
    }
    return setmetatable(_MenuPool, MenuPool)
end

---AddSubMenu
---@param Menu table
---@param Text string
---@param Description string
---@param KeepPosition boolean
---@param KeepBanner boolean
function MenuPool:AddSubMenu(Menu, Text, Description, KeepPosition, KeepBanner)
    if Menu() == "UIMenu" then
        local Item = UIMenuItem.New(tostring(Text), Description or "")
        Menu:AddItem(Item)
        local SubMenu
        if KeepPosition then
            SubMenu = UIMenu.New(Menu.Title, Text, Menu.Position.X, Menu.Position.Y, Menu.Glare, Menu.TextureDict, Menu.TextureName, Menu.AlternativeTitle)
        else
            SubMenu = UIMenu.New(Menu.Title, Text)
        end
        if KeepBanner then
            if Menu.Logo ~= nil then
                SubMenu.Logo = Menu.Logo
            else
                SubMenu.Logo = nil
                SubMenu.Banner = Menu.Banner
            end
        end

        SubMenu.Glare = Menu.Glare
        SubMenu.Settings.MouseControlsEnabled = Menu.Settings.MouseControlsEnabled
        SubMenu.Settings.MouseEdgeEnabled = Menu.Settings.MouseEdgeEnabled
        SubMenu:MaxItemsOnScreen(Menu:MaxItemsOnScreen())
        self:Add(SubMenu)
        Menu:BindMenuToItem(SubMenu, Item)
        return SubMenu
    end
end

---Add
---@param Menu table
function MenuPool:Add(Menu)
    if Menu() == "UIMenu" then
        Menu.pool = self
        table.insert(self.Menus, Menu)
    end
end

function MenuPool:AddPauseMenu(Menu)
    if Menu() == "PauseMenu" then
        table.insert(self.PauseMenus, Menu)
    end
end

---MouseEdgeEnabled
---@param bool boolean
function MenuPool:MouseEdgeEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseEdgeEnabled = tobool(bool)
        end
    end
end

---ControlDisablingEnabled
---@param bool boolean
function MenuPool:ControlDisablingEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ControlDisablingEnabled = tobool(bool)
        end
    end
end

---ResetCursorOnOpen
---@param bool boolean
function MenuPool:ResetCursorOnOpen(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ResetCursorOnOpen = tobool(bool)
        end
    end
end

---MultilineFormats
---@param bool boolean
function MenuPool:MultilineFormats(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MultilineFormats = tobool(bool)
        end
    end
end

---Audio
---@param Attribute number
---@param Setting table
function MenuPool:Audio(Attribute, Setting)
    if Attribute ~= nil and Setting ~= nil then
        for _, Menu in pairs(self.Menus) do
            if Menu.Settings.Audio[Attribute] then
                Menu.Settings.Audio[Attribute] = Setting
            end
        end
    end
end

---WidthOffset
---@param offset number
function MenuPool:WidthOffset(offset)
    if tonumber(offset) then
        for _, Menu in pairs(self.Menus) do
            Menu:SetMenuWidthOffset(tonumber(offset))
        end
    end
end

---CounterPreText
---@param str string
function MenuPool:CounterPreText(str)
    if str ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.PageCounter.PreText = tostring(str)
        end
    end
end

---DisableInstructionalButtons
---@param bool boolean
function MenuPool:DisableInstructionalButtons(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.InstructionalButtons = tobool(bool)
        end
    end
end

---MouseControlsEnabled
---@param bool boolean
function MenuPool:MouseControlsEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseControlsEnabled = tobool(bool)
        end
    end
end

---RefreshIndex
function MenuPool:RefreshIndex()
    for _, Menu in pairs(self.Menus) do
        Menu:RefreshIndex()
    end
end

---ProcessControl
function MenuPool:ProcessControl()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:ProcessControl()
            Menu:ProcessMouse()
        end
    end

    for _, Menu in pairs(self.PauseMenus) do
        if Menu:Visible() then
            Menu:ProcessControl()
        end
    end
end

---Draw
function MenuPool:Draw()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:Draw()
        end
    end
    for _, Menu in pairs(self.PauseMenus) do
        if Menu:Visible() then
            Menu:Draw()
        end
    end
end

---IsAnyMenuOpen
function MenuPool:IsAnyMenuOpen()
    local open = false
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            open = true
            break
        end
    end
    for _, Menu in pairs(self.PauseMenus) do
        if Menu:Visible() then
            open = true
            break
        end
    end
    return open
end

function MenuPool:IsAnyPauseMenuOpen()
    for _, Menu in pairs(self.PauseMenus) do
        if #Menu.Children > 0 then
            for k,v in pairs(Menu.Children) do
                if v:Visible() then
                    return true
                end
            end
        end
        if Menu:Visible() then
            return true
        end
    end
    return false
end

---CloseAllMenus
function MenuPool:CloseAllMenus()
    for _, Menu in pairs(self.Menus) do
        for _,subMenu in pairs(Menu.Children) do
            if subMenu:Visible() then
                subMenu:Visible(false)
            end
        end
        if Menu:Visible() then
            Menu:Visible(false)
        end
    end
    ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL", false)
    if ScaleformUI.Scaleforms.InstructionalButtons:Enabled() then
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
    end
end

---SetBannerSprite
---@param Sprite table
function MenuPool:SetBannerSprite(Sprite)
    if Sprite() == "Sprite" then
        for _, Menu in pairs(self.Menus) do
            Menu:SetBannerSprite(Sprite)
        end
    end
end

---SetBannerRectangle
---@param Rectangle table
function MenuPool:SetBannerRectangle(Rectangle)
    if Rectangle() == "Rectangle" then
        for _, Menu in pairs(self.Menus) do
            Menu:SetBannerRectangle(Rectangle)
        end
    end
end