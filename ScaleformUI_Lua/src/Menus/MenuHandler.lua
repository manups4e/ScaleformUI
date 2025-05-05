MenuHandler = setmetatable({
    _currentMenu = nil,
    _currentPauseMenu = nil,
    ableToDraw = false
}, MenuHandler)
MenuHandler.__index = MenuHandler
MenuHandler.__call = function()
    return "MenuHandler"
end

---@class MenuHandler
---@field _currentMenu UIMenu
---@field _currentPauseMenu table
---@field ableToDraw boolean

function MenuHandler:SwitchTo(currentMenu, newMenu, newMenuCurrentSelection, inheritOldMenuParams, data)
    local current = currentMenu()
    local new = newMenu()
    assert(currentMenu ~= nil, "The menu you're switching from cannot be null")
    assert(currentMenu == self._currentMenu, "The menu you're switching from must be opened")
    assert(newMenu ~= nil, "The menu you're switching to cannot be null")
    assert(newMenu ~= currentMenu, "You cannot switch a menu to itself")
    assert(not newMenu:Visible(), "The menu you're switching to is already open!")
    if BreadcrumbsHandler.SwitchInProgress then return end
    BreadcrumbsHandler.SwitchInProgress = true

    if newMenuCurrentSelection == nil then newMenuCurrentSelection = 1 end
    if current == "UIMenu" and new == "UIMenu" then
        if inheritOldMenuParams == nil then inheritOldMenuParams = false end
        if inheritOldMenuParams then
            if currentMenu.TxtDictionary ~= "" and currentMenu.TxtDictionary ~= nil and currentMenu.TxtName ~= "" and currentMenu.TxtName ~= nil then
                newMenu.TxtDictionary = currentMenu.TxtDictionary
                newMenu.TxtName = currentMenu.TxtName
            end
            newMenu:MenuAlignment(currentMenu:MenuAlignment())
            newMenu:SetMenuOffset(currentMenu.Position.x, currentMenu.Position.y)
            
            if currentMenu.Logo ~= nil then
                newMenu.Logo = currentMenu.Logo
            else
                newMenu.Logo = nil
                newMenu.Banner = currentMenu.Banner
            end
            newMenu._differentBanner = currentMenu.TxtDictionary ~= newMenu.TxtDictionary and currentMenu.TxtName ~= newMenu.TxtName;
            newMenu.Glare = currentMenu.Glare
            newMenu.AlternativeTitle = currentMenu.AlternativeTitle
            newMenu:MaxItemsOnScreen(currentMenu:MaxItemsOnScreen())
            newMenu:MouseSettings(currentMenu:MouseControlsEnabled(), currentMenu:MouseEdgeEnabled(), currentMenu:MouseWheelControlEnabled(), currentMenu.Settings.ResetCursorOnOpen, currentMenu.leftClickEnabled)
            newMenu:SubtitleColor(currentMenu:SubtitleColor())
            --[[
                newMenu.Settings.MouseControlsEnabled = currentMenu.Settings.MouseControlsEnabled
                newMenu.Settings.MouseEdgeEnabled = currentMenu.Settings.MouseEdgeEnabled
            ]]
        end
    end
    if newMenuCurrentSelection > 1 then

        local max = #newer.Items;

        if max >= newer._maxItemsOnScreen then
            max = newer._maxItemsOnScreen
        end

        newer._currentSelection = math.max(1, math.min(newMenuCurrentSelection, #newer.Items));
        if newMenuCurrentSelection >= newer.topEdge + newer._visibleItems then
            newer.topEdge = math.max(1, math.min(newMenuCurrentSelection, #newer.Items - newer._visibleItems))
        elseif newMenuCurrentSelection < newer.topEdge then
            newer.topEdge = newMenuCurrentSelection
        end
    end


    currentMenu:Visible(false)
    newMenu:Visible(true)
    BreadcrumbsHandler:Forward(newMenu, data)
    BreadcrumbsHandler.SwitchInProgress = false
end

function MenuHandler:ProcessMenus()
    self:Draw()
    self:ProcessControl()
    self:ProcessMenuExtensionMethod()
end

function MenuHandler:ProcessMenuExtensionMethod()
    if self._currentMenu ~= nil then
        if self._currentMenu() == "UIMenu" then
            self._currentMenu:CallExtensionMethod()
        end
    end
end

---ProcessControl
function MenuHandler:ProcessControl()
    if self._currentMenu ~= nil then
        self._currentMenu:ProcessMouse()
        self._currentMenu:ProcessControl()
    end

    if self._currentPauseMenu ~= nil then
        self._currentPauseMenu:ProcessMouse()
        self._currentPauseMenu:ProcessControl()
    end
end

---Draw
function MenuHandler:Draw()
    if self._currentMenu ~= nil then
        self._currentMenu:Draw()
    end
    if self._currentPauseMenu ~= nil then
        self._currentPauseMenu:Draw()
    end
end

function MenuHandler:CloseAndClearHistory()
    if self._currentMenu ~= nil and self._currentMenu:Visible() then
        self._currentMenu:Visible(false)
    end
    if self._currentPauseMenu ~= nil and self._currentPauseMenu:Visible() then
        self._currentPauseMenu:Visible(false)
    end
    BreadcrumbsHandler:Clear()
    ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
end

---IsAnyMenuOpen
function MenuHandler:IsAnyMenuOpen()
    return BreadcrumbsHandler:Count() > 0
end

function MenuHandler:IsAnyPauseMenuOpen()
    return self._currentPauseMenu ~= nil and self._currentPauseMenu:Visible()
end
