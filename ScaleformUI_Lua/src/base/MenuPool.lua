MenuPool = setmetatable({}, MenuPool)
MenuPool.__index = MenuPool

---@class MenuPool
---@field Menus table
---@field PauseMenus table
---@field ableToDraw boolean


---Create a new MenuPool
---@return table
function MenuPool.New()
    local _MenuPool = {
        Menus = {},
        PauseMenus = {},
        ableToDraw = false
    }
    return setmetatable(_MenuPool, MenuPool)
end

--- Add a new Submenu
---@param subMenu UIMenu
---@param text string
---@param description string
---@param keepPosition boolean
---@param keepBanner boolean
---@return UIMenu
function MenuPool:AddSubMenu(subMenu, text, description, keepPosition, keepBanner)
    if subMenu() == "UIMenu" then
        ---@diagnostic disable-next-line: missing-parameter
        local item = UIMenuItem.New(tostring(text), description or "")
        subMenu:AddItem(item)
        local _subMenu
        if keepPosition then
            _subMenu = UIMenu.New(subMenu.Title, text, subMenu.Position.x, subMenu.Position.y, subMenu.Glare,
                subMenu.TxtDictionary,
                subMenu.TxtName, subMenu.AlternativeTitle)
        else
            _subMenu = UIMenu.New(subMenu.Title, text)
        end
        if keepBanner then
            if subMenu.Logo ~= nil then
                _subMenu.Logo = subMenu.Logo
            else
                _subMenu.Logo = nil
                _subMenu.Banner = subMenu.Banner
            end
        end

        _subMenu.Glare = subMenu.Glare
        _subMenu.Settings.MouseControlsEnabled = subMenu.Settings.MouseControlsEnabled
        _subMenu.Settings.MouseEdgeEnabled = subMenu.Settings.MouseEdgeEnabled
        _subMenu:MaxItemsOnScreen(subMenu:MaxItemsOnScreen())
        self:Add(_subMenu)
        subMenu:BindMenuToItem(_subMenu, item)
        return _subMenu
    end
end

---Add
---@param Menu table
function MenuPool:Add(Menu)
    if Menu() == "UIMenu" then
        Menu.ParentPool = self
        self.Menus[#self.Menus + 1] = Menu
    end
end

function MenuPool:AddPauseMenu(Menu)
    if Menu() == "PauseMenu" or Menu() == "LobbyMenu" then
        Menu.ParentPool = self,
            table.insert(self.PauseMenus, Menu)
    end
end

---Toggle whether to rotate the camera when the mouse is at the edge of the screen
---@param bool boolean
function MenuPool:MouseEdgeEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseEdgeEnabled = ToBool(bool)
        end
    end
end

---Toggle whether to disable controls when a menu is open
---@param bool boolean
function MenuPool:ControlDisablingEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ControlDisablingEnabled = ToBool(bool)
        end
    end
end

---Reset the cursors position when a menu is opened
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
---@param preText string
function MenuPool:CounterPreText(preText)
    if preText ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.PageCounter.PreText = tostring(preText)
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
    for k, v in pairs(self.Menus) do
        if v:Visible() then
            v:Visible(false)
        end
    end
    ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL", false)
    if ScaleformUI.Scaleforms.InstructionalButtons:Enabled() then
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
    end
end

---SetBannerSprite
---@param sprite Sprite
---@see Sprite
function MenuPool:SetBannerSprite(sprite)
    if sprite() == "Sprite" then
        for _, Menu in pairs(self.Menus) do
            Menu:SetBannerSprite(sprite)
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

---Will flush all menus from the pool
function MenuPool:FlushMenus()
    local countMenu = #self.Menus
    for i = 0, countMenu do
        if self.Menus[i] ~= nil and self.Menus[i]:Visible() then
            self.Menus[i]:Visible(false)
        end
        self.Menus[i] = nil
    end
end

---Will flush all pause menus from the pool
function MenuPool:FlushPauseMenus()
    local countPause = #self.PauseMenus
    for i = 0, countPause do
        if self.PauseMenus[i] ~= nil and self.PauseMenus[i]:Visible() then
            self.PauseMenus[i]:Visible(false)
        end
        self.PauseMenus[i] = nil
    end
end

---Will flush all menus and pause menus from the pool
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
