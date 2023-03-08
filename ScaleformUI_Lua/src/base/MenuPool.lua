MenuPool = setmetatable({}, MenuPool)
MenuPool.__index = MenuPool

---New
function MenuPool.New()
    local _MenuPool = {
        Menus = {},
        PauseMenus = {},
        ableToDraw = false
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
        ---@diagnostic disable-next-line: missing-parameter
        local Item = UIMenuItem.New(tostring(Text), Description or "")
        Menu:AddItem(Item)
        local SubMenu
        if KeepPosition then
            SubMenu = UIMenu.New(Menu.Title, Text, Menu.Position.X, Menu.Position.Y, Menu.Glare, Menu.TextureDict,
                Menu.TextureName, Menu.AlternativeTitle)
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
        Menu._internalpool = self
        self.Menus[#self.Menus + 1] = Menu
    end
end

function MenuPool:AddPauseMenu(Menu)
    if Menu() == "PauseMenu" or Menu() == "LobbyMenu" then
        Menu._internalpool = self,
            table.insert(self.PauseMenus, Menu)
    end
end

---MouseEdgeEnabled
---@param bool boolean
function MenuPool:MouseEdgeEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseEdgeEnabled = ToBool(bool)
        end
    end
end

---ControlDisablingEnabled
---@param bool boolean
function MenuPool:ControlDisablingEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ControlDisablingEnabled = ToBool(bool)
        end
    end
end

---ResetCursorOnOpen
---@param bool boolean
function MenuPool:ResetCursorOnOpen(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ResetCursorOnOpen = ToBool(bool)
        end
    end
end

---MultilineFormats
---@param bool boolean
function MenuPool:MultilineFormats(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MultilineFormats = ToBool(bool)
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
            Menu.Settings.InstructionalButtons = ToBool(bool)
        end
    end
end

---MouseControlsEnabled
---@param bool boolean
function MenuPool:MouseControlsEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseControlsEnabled = ToBool(bool)
        end
    end
end

---RefreshIndex
function MenuPool:RefreshIndex()
    for _, Menu in pairs(self.Menus) do
        Menu:RefreshIndex()
    end
end

function MenuPool:ProcessMenus(bool)
    self.ableToDraw = bool
    Citizen.CreateThread(function()
        while self.ableToDraw do
            Citizen.Wait(0)
            self:ProcessControl()
            self:Draw()
        end
        return
    end)
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
            Menu:ProcessMouse()
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
    for _, Menu in pairs(self.Menus) do
        if #Menu.Children > 0 then
            for k, v in pairs(Menu.Children) do
                if v:Visible() then
                    return true
                end
            end
        end
        if Menu:Visible() then
            return true
        end
    end
    for _, Menu in pairs(self.PauseMenus) do
        if Menu:Visible() then
            return true
        end
    end
    return false
end

function MenuPool:IsAnyPauseMenuOpen()
    for _, Menu in pairs(self.PauseMenus) do
        if Menu:Visible() then
            return true
        end
    end
    return false
end

---CloseAllMenus
function MenuPool:CloseAllMenus()
    if self.currentMenu ~= nil and self.currentMenu() == "UIMenu" then
        for _, subMenu in pairs(self.currentMenu.Children) do
            if subMenu:Visible() then
                subMenu:Visible(false)
            end
        end
        if self.currentMenu:Visible() then
            self.currentMenu:Visible(false)
        else
            self.currentMenu.OnMenuChanged(self.currentMenu, nil, "closed")
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

function MenuPool:FlushMenus()
    local countMenu = #self.Menus
    for i = 0, countMenu do
        if self.Menus[i] ~= nil and self.Menus[i]:Visible() then
            self.Menus[i]:Visible(false)
        end
        self.Menus[i] = nil
    end
end

function MenuPool:FlushPauseMenus()
    local countPause = #self.PauseMenus
    for i = 0, countPause do
        if self.PauseMenus[i] ~= nil and self.PauseMenus[i]:Visible() then
            self.PauseMenus[i]:Visible(false)
        end
        self.PauseMenus[i] = nil
    end
end

function MenuPool:FlushAllMenus()
    local countMenu = #self.Menus
    local countPause = #self.PauseMenus
    for i = 0, countMenu do
        if self.Menus[i] ~= nil and self.Menus[i]:Visible() then
            self.Menus[i]:Visible(false)
        end
        self.Menus[i] = nil
    end
    for i = 0, countPause do
        if self.PauseMenus[i] ~= nil and self.PauseMenus[i]:Visible() then
            self.PauseMenus[i]:Visible(false)
        end
        self.PauseMenus[i] = nil
    end
end
