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
    assert(#newMenu.Items > 0, "You cannot switch to an empty menu.")
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
                newMenu.Position = currentMenu.Position

            if currentMenu.Logo ~= nil then
                newMenu.Logo = currentMenu.Logo
            else
                newMenu.Logo = nil
                newMenu.Banner = currentMenu.Banner
            end

            newMenu.Glare = currentMenu.Glare
            newMenu:MaxItemsOnScreen(currentMenu:MaxItemsOnScreen())
            newMenu:AnimationEnabled(currentMenu:AnimationEnabled())
            newMenu:AnimationType(currentMenu:AnimationType())
            newMenu:BuildingAnimation(currentMenu:BuildingAnimation())
            newMenu:ScrollingType(currentMenu:ScrollingType())
            newMenu:MouseSettings(currentMenu:MouseControlsEnabled(), currentMenu:MouseEdgeEnabled(), currentMenu:MouseWheelControlEnabled(), currentMenu.Settings.ResetCursorOnOpen, currentMenu.leftClickEnabled)
            newMenu.enabled3DAnimations = currentMenu.enabled3DAnimations
            newMenu.fadingTime = currentMenu.fadingTime
            newMenu.SubtitleColor = currentMenu.SubtitleColor
            --[[
                newMenu.Settings.MouseControlsEnabled = currentMenu.Settings.MouseControlsEnabled
                newMenu.Settings.MouseEdgeEnabled = currentMenu.Settings.MouseEdgeEnabled
            ]]

        end
    end
    newMenu:CurrentSelection(newMenuCurrentSelection)
    if(current == "UIMenu") then
        currentMenu:FadeOutMenu()
    end
    currentMenu:Visible(false)
    newMenu:Visible(true)
    if(new == "UIMenu") then
        newMenu:FadeInMenu()
    end
    BreadcrumbsHandler:Forward(newMenu, data)
    BreadcrumbsHandler.SwitchInProgress = false
end

function MenuHandler:ProcessMenus()
    self:Draw()
    self:ProcessControl()
end

---ProcessControl
function MenuHandler:ProcessControl()
    if self._currentMenu ~= nil then
        self._currentMenu:ProcessControl()
        self._currentMenu:ProcessMouse()
    end

    if self._currentPauseMenu ~= nil then
        self._currentPauseMenu:ProcessControl()
        self._currentPauseMenu:ProcessMouse()
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