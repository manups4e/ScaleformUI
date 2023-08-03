UIMenu = setmetatable({}, UIMenu)
UIMenu.__index = UIMenu
UIMenu.__call = function()
    return "UIMenu"
end

---@class UIMenu
---@field public _Title string -- Sets the menu title
---@field public _Subtitle string -- Sets the menu subtitle
---@field public AlternativeTitle boolean -- Enable or disable the alternative title (default: false)
---@field public Position vector2 -- Sets the menu position (default: { X = 0.0, Y = 0.0 })
---@field public Pagination table -- Menu pagination settings (default: { Min = 0, Max = 7, Total = 7 })
---@field public Banner table -- Menu banner settings [Setting not fully understood or possibly not used]
---@field public Extra table -- {}
---@field public Description table -- {}
---@field public Items table<UIMenuItem> -- {}
---@field public Windows table -- {}
---@field public Glare boolean -- Sets if the glare animation is enabled or disabled (default: false)
---@field public Controls table -- { Back = { Enabled = true }, Select = { Enabled = true }, Up = { Enabled = true }, Down = { Enabled = true }, Left = { Enabled = true }, Right = { Enabled = true } }
---@field public TxtDictionary string -- Texture dictionary for the menu banner background (default: commonmenu)
---@field public TxtName string -- Texture name for the menu banner background (default: interaction_bgd)
---@field public Logo Sprite -- nil
---@field public Settings table -- Defines the menus settings
---@field public MaxItemsOnScreen fun(self: UIMenu, max: number?):number -- Maximum number of items that can be displayed (default: 7)
---@field public AddItem fun(self: UIMenu, item: UIMenuItem)
---@field public OnIndexChange fun(menu: UIMenu, newindex: number)
---@field public OnListChange fun(menu: UIMenu, list: UIMenuListItem, newindex: number)
---@field public OnSliderChange fun(menu: UIMenu, slider: UIMenuSliderItem, newindex: number)
---@field public OnProgressChange fun(menu: UIMenu, progress: UIMenuProgressItem, newindex: number)
---@field public OnCheckboxChange fun(menu: UIMenu, checkbox: UIMenuCheckboxItem, checked: boolean)
---@field public OnListSelect fun(menu: UIMenu, item: UIMenuItem, index: number)
---@field public OnSliderSelect fun(menu: UIMenu, item: UIMenuItem, index: number)
---@field public OnStatsSelect fun(menu: UIMenu, item: UIMenuItem, index: number)
---@field public OnItemSelect fun(menu: UIMenu, item: UIMenuItem, checked: boolean)
---@field public OnMenuOpen fun(menu: UIMenu)
---@field public OnMenuClose fun(menu: UIMenu)
---@field public BuildAsync fun(self: UIMenu, enabled: boolean?):boolean -- If the menu should be built async (default: false)
---@field public AnimationEnabled fun(self: UIMenu, enabled: boolean?):boolean -- If the menu animation is enabled or disabled (default: true)
---@field public AnimationType fun(self: UIMenu, type: MenuAnimationType?):MenuAnimationType -- Animation type for the menu (default: MenuAnimationType.LINEAR)
---@field public BuildingAnimation fun(self: UIMenu, type: MenuBuildingAnimation?):MenuBuildingAnimation -- Build animation type for the menu (default: MenuBuildingAnimation.LEFT)
---@field public Visible fun(self: UIMenu, visible: boolean?):boolean -- If the menu is visible or not (default: false)
---@field private counterColor Colours -- Set the counter color (default: Colours.HUD_COLOUR_FREEMODE)
---@field private enableAnimation boolean -- Enable or disable the menu animation (default: true)
---@field private animationType MenuAnimationType -- Sets the menu animation type (default: MenuAnimationType.LINEAR)
---@field private buildingAnimation MenuBuildingAnimation -- Sets the menu building animation type (default: MenuBuildingAnimation.NONE)
---@field private descFont ScaleformFonts -- Sets the desctiption text font. (default: ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)

---Creates a new UIMenu.
---@param title string -- Menu title
---@param subTitle string -- Menu subtitle
---@param x number? -- Menu Offset X position
---@param y number? -- Menu Offset Y position
---@param glare boolean? -- Menu glare effect
---@param txtDictionary string? -- Custom texture dictionary for the menu banner background (default: commonmenu)
---@param txtName string? -- Custom texture name for the menu banner background (default: interaction_bgd)
---@param alternativeTitleStyle boolean? -- Use alternative title style (default: false)
function UIMenu.New(title, subTitle, x, y, glare, txtDictionary, txtName, alternativeTitleStyle, fadeTime)
    local X, Y = tonumber(x) or 0, tonumber(y) or 0
    if title ~= nil then
        title = tostring(title) or ""
    else
        title = ""
    end
    if subTitle ~= nil then
        subTitle = tostring(subTitle) or ""
    else
        subTitle = ""
    end
    if txtDictionary ~= nil then
        txtDictionary = tostring(txtDictionary) or "commonmenu"
    else
        txtDictionary = "commonmenu"
    end
    if txtName ~= nil then
        txtName = tostring(txtName) or "interaction_bgd"
    else
        txtName = "interaction_bgd"
    end
    if alternativeTitleStyle == nil then
        alternativeTitleStyle = false
    end
    local _UIMenu = {
        _Title = title,
        _Subtitle = subTitle,
        AlternativeTitle = alternativeTitleStyle,
        counterColor = Colours.HUD_COLOUR_FREEMODE,
        Position = { x = X, y = Y },
        Pagination = PaginationHandler.New(),
        enableAnimation = true,
        animationType = MenuAnimationType.LINEAR,
        buildingAnimation = MenuBuildingAnimation.NONE,
        scrollingType = MenuScrollingType.CLASSIC,
        descFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        Extra = {},
        Description = {},
        Items = {},
        Windows = {},
        TxtDictionary = txtDictionary,
        TxtName = txtName,
        Glare = glare or false,
        Logo = nil,
        _keyboard = false,
        _changed = false,
        _maxItem = 7,
        _menuGlare = 0,
        _canBuild = true,
        _isBuilding = false,
        _time = 0,
        _times = 0,
        _delay = 100,
        _delayBeforeOverflow = 350,
        _timeBeforeOverflow = 0,
        _canHe = true,
        _scaledWidth = (720 * GetAspectRatio(false)),
        isFading = false,
        fadingTime = fadeTime or 0.1,
        Controls = {
            Back = {
                Enabled = true,
            },
            Select = {
                Enabled = true,
            },
            Left = {
                Enabled = true,
            },
            Right = {
                Enabled = true,
            },
            Up = {
                Enabled = true,
            },
            Down = {
                Enabled = true,
            },
        },
        ParentPool = nil,
        _Visible = false,
        Dirty = false,
        ReDraw = true,
        InstructionalButtons = {
            InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1)
        },
        OnIndexChange = function(menu, newindex)
        end,
        OnListChange = function(menu, list, newindex)
        end,
        OnSliderChange = function(menu, slider, newindex)
        end,
        OnProgressChange = function(menu, progress, newindex)
        end,
        OnCheckboxChange = function(menu, item, checked)
        end,
        OnListSelect = function(menu, list, index)
        end,
        OnSliderSelect = function(menu, slider, index)
        end,
        OnProgressSelect = function(menu, progress, index)
        end,
        OnStatsSelect = function(menu, progress, index)
        end,
        OnItemSelect = function(menu, item, index)
        end,
        OnMenuOpen = function(menu)
        end,
        OnMenuClose = function(menu)
        end,
        OnColorPanelChanged = function(menu, item, index)
        end,
        OnPercentagePanelChanged = function(menu, item, index)
        end,
        OnGridPanelChanged = function(menu, item, index)
        end,
        Settings = {
            InstructionalButtons = true,
            MultilineFormats = true,
            ScaleWithSafezone = true,
            ResetCursorOnOpen = true,
            MouseControlsEnabled = true,
            MouseEdgeEnabled = true,
            ControlDisablingEnabled = true,
            Audio = {
                Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                UpDown = "NAV_UP_DOWN",
                LeftRight = "NAV_LEFT_RIGHT",
                Select = "SELECT",
                Back = "BACK",
                Error = "ERROR",
            },
            EnabledControls = {
                Controller = {
                    { 0, 2 },  -- Look Up and Down
                    { 0, 1 },  -- Look Left and Right
                    { 0, 25 }, -- Aim
                    { 0, 24 }, -- Attack
                    { 0, 71 }, -- Accelerate Vehicle
                    { 0, 72 }, -- Vehicle Brake
                    { 0, 30 }, -- Move Left and Right
                    { 0, 31 }, -- Move Up and Down
                    { 0, 59 }, -- Move Vehicle Left and Right
                    { 0, 75 }, -- Exit Vehicle
                },
                Keyboard = {
                    { 0, 2 },   -- Look Up and Down
                    { 0, 1 },   -- Look Left and Right
                    { 0, 201 }, -- Select
                    { 0, 195 }, -- X axis
                    { 0, 196 }, -- Y axis
                    { 0, 187 }, -- Down
                    { 0, 188 }, -- Up
                    { 0, 189 }, -- Left
                    { 0, 190 }, -- Right
                    { 0, 202 }, -- Back
                    { 0, 217 }, -- Select
                    { 0, 242 }, -- Scroll down
                    { 0, 241 }, -- Scroll up
                    { 0, 239 }, -- Cursor X
                    { 0, 240 }, -- Cursor Y
                    { 0, 237 },
                    { 0, 238 },
                    { 0, 31 }, -- Move Up and Down
                    { 0, 30 }, -- Move Left and Right
                    { 0, 21 }, -- Sprint
                    { 0, 22 }, -- Jump
                    { 0, 23 }, -- Enter
                    { 0, 75 }, -- Exit Vehicle
                    { 0, 71 }, -- Accelerate Vehicle
                    { 0, 72 }, -- Vehicle Brake
                    { 0, 59 }, -- Move Vehicle Left and Right
                    { 0, 89 }, -- Fly Yaw Left
                    { 0, 9 },  -- Fly Left and Right
                    { 0, 8 },  -- Fly Up and Down
                    { 0, 90 }, -- Fly Yaw Right
                    { 0, 76 }, -- Vehicle Handbrake
                },
            },
        }
    }
    _UIMenu.Pagination.itemsPerPage = 7
    if subTitle ~= "" and subTitle ~= nil then
        _UIMenu._Subtitle = subTitle
    end
    if (_UIMenu._menuGlare == 0) then
        _UIMenu._menuGlare = Scaleform.Request("mp_menu_glare")
    end
    return setmetatable(_UIMenu, UIMenu)
end

function UIMenu:Title(title)
    if title == nil then
        return self._Title
    else
        self._Title = title
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_TITLE_SUBTITLE", false, self._Title, self._Subtitle,
                self.alternativeTitle)
        end
    end
end

function UIMenu:DescriptionFont(fontTable)
    if fontTable == nil then
        return self.descFont
    else
        self.descFont = fontTable
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_DESC_FONT", false, self.descFont.FontName, self.descFont.FontID)
        end
    end
end

function UIMenu:Subtitle(sub)
    if sub == nil then
        return self._Subtitle
    else
        self._Subtitle = sub
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_TITLE_SUBTITLE", false, self._Title, self._Subtitle,
                self.alternativeTitle)
        end
    end
end

function UIMenu:CounterColor(color)
    if color == nil then
        return self.counterColor
    else
        self.counterColor = color
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_COUNTER_COLOR", false, self.counterColor)
        end
    end
end

---DisEnableControls
---@param bool boolean
function UIMenu:DisEnableControls(bool)
    if bool then
        EnableAllControlActions(2)
    else
        DisableAllControlActions(2)
    end

    if bool then
        return
    else
        if not IsUsingKeyboard(2) then
            for Index = 1, #self.Settings.EnabledControls.Controller do
                EnableControlAction(self.Settings.EnabledControls.Controller[Index][1],
                    self.Settings.EnabledControls.Controller[Index][2], true)
            end
        else
            for Index = 1, #self.Settings.EnabledControls.Keyboard do
                EnableControlAction(self.Settings.EnabledControls.Keyboard[Index][1],
                    self.Settings.EnabledControls.Keyboard[Index][2], true)
            end
        end
    end
end

---InstructionalButtons
---@param enabled boolean?
---@return boolean
function UIMenu:HasInstructionalButtons(enabled)
    if enabled ~= nil then
        self.Settings.InstructionalButtons = ToBool(enabled)
    end
    return self.Settings.InstructionalButtons
end

--- Sets if the menu can be closed by the player.
---@param playerCanCloseMenu boolean?
---@return boolean
function UIMenu:CanPlayerCloseMenu(playerCanCloseMenu)
    if playerCanCloseMenu ~= nil then
        self._canHe = playerCanCloseMenu
        if playerCanCloseMenu then
            self.InstructionalButtons = {
                InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
                InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1)
            }
        else
            self.InstructionalButtons = {
                InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            }
        end
        if self:Visible() then
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
        end
    end
    return self._canHe
end

-- TODO: Refactor this method and process as its rather backwards.
---Sets if some controls (attack, game camera movement) are disabled when the menu is open. (Default: true) (set to false to disable default left click controls)
---@param enabled boolean?
---@return boolean
function UIMenu:ControlDisablingEnabled(enabled)
    if enabled ~= nil then
        self.Settings.ControlDisablingEnabled = ToBool(enabled)
    end
    return self.Settings.ControlDisablingEnabled
end

---Sets if the camera can be rotated when the mouse cursor is near the edges of the screen. (Default: true)
---@param enabled boolean?
---@return boolean
function UIMenu:MouseEdgeEnabled(enabled)
    if enabled ~= nil then
        self.Settings.MouseEdgeEnabled = ToBool(enabled)
    end
    return self.Settings.MouseEdgeEnabled
end

---Enables or disables mouse controls for the menu. (Default: true)
---@param enabled boolean?
---@return boolean
function UIMenu:MouseControlsEnabled(enabled)
    if enabled ~= nil then
        self.Settings.MouseControlsEnabled = ToBool(enabled)
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_MOUSE", false, self.Settings.MouseControlsEnabled)
        end
    end
    return self.Settings.MouseControlsEnabled
end

---SetBannerSprite
---@param sprite Sprite
---@param includeChildren boolean
---@see Sprite
function UIMenu:SetBannerSprite(sprite, includeChildren)
    if sprite() == "Sprite" then
        self.Logo = sprite
        self.Logo:Size(431 + self.WidthOffset, 107)
        self.Logo:Position(self.Position.X, self.Position.Y)
        self.Banner = nil
        if includeChildren then
            for item, menu in pairs(self.Children) do
                menu.Logo = sprite
                menu.Logo:Size(431 + self.WidthOffset, 107)
                menu.Logo:Position(self.Position.X, self.Position.Y)
                menu.Banner = nil
            end
        end
    end
end

--- Enables or disabls the menu's animations while the menu is visible.
---@param enable boolean?
---@return boolean
function UIMenu:AnimationEnabled(enable)
    if enable ~= nil then
        self.enableAnimation = enable
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_SCROLLING_ANIMATION", false, enable)
        end
    end
    return self.enableAnimation
end

--- Sets the menu's scrolling animationType while the menu is visible.
---@param menuAnimationType MenuAnimationType?
---@return number MenuAnimationType
---@see MenuAnimationType
function UIMenu:AnimationType(menuAnimationType)
    if menuAnimationType ~= nil then
        self.animationType = menuAnimationType
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("CHANGE_SCROLLING_ANIMATION_TYPE", false, menuAnimationType)
        end
    end

    return self.animationType
end

--- Enables or disables the menu's building animationType.
---@param buildingAnimationType MenuBuildingAnimation?
---@return MenuBuildingAnimation
---@see MenuBuildingAnimation
function UIMenu:BuildingAnimation(buildingAnimationType)
    if buildingAnimationType ~= nil then
        self.buildingAnimation = buildingAnimationType
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("CHANGE_BUILDING_ANIMATION_TYPE", false, buildingAnimationType)
        end
    end
    return self.buildingAnimation
end

--- Decides how menu behaves on scrolling and overflowing.
---@param scrollType MenuScrollingType?
---@return MenuScrollingType
---@see MenuScrollingType
function UIMenu:ScrollingType(scrollType)
    if scrollType ~= nil then
        self.scrollingType = scrollType
        self.Pagination.scrollType = scrollType
    end
    return self.scrollingType
end

function UIMenu:FadeOutMenu()
    ScaleformUI.Scaleforms._ui:CallFunction("FADE_OUT_MENU", false)
    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._ui:CallFunction("GET_IS_FADING", true) --[[@as number]]
        while not IsScaleformMovieMethodReturnValueReady(return_value) do
            Citizen.Wait(0)
        end
        self.isFading = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isFading
end

function UIMenu:FadeInMenu()
    ScaleformUI.Scaleforms._ui:CallFunction("FADE_IN_MENU", false)

    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._ui:CallFunction("GET_IS_FADING", true) --[[@as number]]
        while not IsScaleformMovieMethodReturnValueReady(return_value) do
            Citizen.Wait(0)
        end
        self.isFading = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isFading
end

function UIMenu:FadeOutItems()
    ScaleformUI.Scaleforms._ui:CallFunction("FADE_OUT_ITEMS", false)

    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._ui:CallFunction("GET_IS_FADING", true) --[[@as number]]
        while not IsScaleformMovieMethodReturnValueReady(return_value) do
            Citizen.Wait(0)
        end
        self.isFading = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isFading
end

function UIMenu:FadeInItems()
    ScaleformUI.Scaleforms._ui:CallFunction("FADE_IN_ITEMS", false)

    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._ui:CallFunction("GET_IS_FADING", true) --[[@as number]]
        while not IsScaleformMovieMethodReturnValueReady(return_value) do
            Citizen.Wait(0)
        end
        self.isFading = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isFading
end

---CurrentSelection
---@param value number?
function UIMenu:CurrentSelection(value)
    if value ~= nil then
        if value < 1 then
            self.Pagination:CurrentMenuIndex(1)
        elseif value > #self.Items then
            self.Pagination:CurrentMenuIndex(#self.Items)
        end

        self.Items[self:CurrentSelection()]:Selected(false)
        self.Pagination:CurrentMenuIndex(value);
        self.Pagination:CurrentPage(self.Pagination:GetPage(self.Pagination:CurrentMenuIndex()));
        self.Pagination:CurrentPageIndex(value);
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()));
        self.Items[self:CurrentSelection()]:Selected(true)
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_ITEM", false,
                self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()))
        end
    else
        return self.Pagination:CurrentMenuIndex()
    end
end

---AddWindow
---@param window table
function UIMenu:AddWindow(window)
    if window() == "UIMenuWindow" then
        window:SetParentMenu(self)
        self.Windows[#self.Windows + 1] = window
    end
end

---RemoveWindowAt
---@param Index number
function UIMenu:RemoveWindowAt(Index)
    if tonumber(Index) then
        if self.Windows[Index] then
            table.remove(self.Windows, Index)
        end
    end
end

--- Add a new item to the menu.
---@param item UIMenuItem
---@see UIMenuItem
function UIMenu:AddItem(item)
    if item() ~= "UIMenuItem" then
        return
    end
    item:SetParentMenu(self)
    self.Items[#self.Items + 1] = item
    self.Pagination:TotalItems(#self.Items)
end

---RemoveItemAt
---@param Index number
function UIMenu:RemoveItemAt(Index)
    if tonumber(Index) then
        if self.Items[Index] then
            local SelectedItem = self:CurrentSelection()
            table.remove(self.Items, tonumber(Index))
            if self:Visible() then
                ScaleformUI.Scaleforms._ui:CallFunction("REMOVE_ITEM", false, Index - 1) -- scaleform index starts at 0, better remove 1 to the index
            end
            self:CurrentSelection(SelectedItem)
            self.Pagination:TotalItems(#self.Items)
        end
    end
end

---RemoveItem
---@param item table
function UIMenu:RemoveItem(item)
    local idx = 0
    for k, v in pairs(self.Items) do
        if v:Label() == item:Label() then
            idx = k
        end
    end
    if idx > 0 then
        self:RemoveItemAt(idx)
    end
end

---Clear
function UIMenu:Clear()
    self.Items = {}
    self.Pagination:TotalItems(0)
    if self:Visible() then
        ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL", false)
    end
end

---MaxItemsOnScreen
---@param max number?
function UIMenu:MaxItemsOnScreen(max)
    if max == nil then
        return self.Pagination:ItemsPerPage()
    end
    self.Pagination:ItemsPerPage(max)
end

function UIMenu:SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
    MenuHandler:SwitchTo(self, newMenu, newMenuCurrentSelection, inheritOldMenuParams)
end

---Visible
---@param bool boolean?
function UIMenu:Visible(bool)
    if bool ~= nil then
        self._Visible = ToBool(bool)
        self.JustOpened = ToBool(bool)
        self.Dirty = ToBool(bool)

        if bool then
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
            self.OnMenuOpen(self)
            self:BuildUpMenuAsync()
            MenuHandler._currentMenu = self
            MenuHandler.ableToDraw = true
        else
            self:FadeOutMenu()
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            self.OnMenuClose(self)
            ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL", false)
            MenuHandler._currentMenu = nil
            MenuHandler.ableToDraw = false
        end
        if self.Settings.ResetCursorOnOpen then
            local W, H = GetScreenResolution()
            SetCursorLocation(W / 2, H / 2)
        end
    else
        return self._Visible
    end
end

---BuildUpMenu
function UIMenu:BuildUpMenuAsync()
    Citizen.CreateThread(function()
        self._isBuilding = true
        local enab = self:AnimationEnabled()
        self:AnimationEnabled(false)
        while not ScaleformUI.Scaleforms._ui:IsLoaded() do Citizen.Wait(0) end
        ScaleformUI.Scaleforms._ui:CallFunction("CREATE_MENU", false, self._Title, self._Subtitle, self.Position.x,
            self.Position.y,
            self.AlternativeTitle, self.TxtDictionary, self.TxtName, self:MaxItemsOnScreen(), #self.Items, true,
            self:AnimationType(), self:BuildingAnimation(), self.counterColor, self.descFont.FontName,
            self.descFont.FontID, self.fadingTime)
        if #self.Windows > 0 then
            for w_id, window in pairs(self.Windows) do
                local Type, SubType = window()
                if SubType == "UIMenuHeritageWindow" then
                    ScaleformUI.Scaleforms._ui:CallFunction("ADD_WINDOW", false, window.id, window.Mom, window.Dad)
                elseif SubType == "UIMenuDetailsWindow" then
                    ScaleformUI.Scaleforms._ui:CallFunction("ADD_WINDOW", false, window.id, window.DetailBottom,
                        window.DetailMid, window.DetailTop, window.DetailLeft.Txd, window.DetailLeft.Txn,
                        window.DetailLeft.Pos.x, window.DetailLeft.Pos.y, window.DetailLeft.Size.x,
                        window.DetailLeft.Size.y)
                    if window.StatWheelEnabled then
                        for key, value in pairs(window.DetailStats) do
                            ScaleformUI.Scaleforms._ui:CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", false,
                                window.id, value.Percentage, value.HudColor)
                        end
                    end
                end
            end
        end
        local timer = GlobalGameTimer
        if #self.Items == 0 then
            while #self.Items == 0 do
                Citizen.Wait(0)
                if GlobalGameTimer - timer > 150 then
                    ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_ITEM", false, 0)
                    assert(#self.Items ~= 0, "ScaleformUI cannot build a menu with no items")
                    return
                end
            end
        end


        local i = 1
        local max = self.Pagination:ItemsPerPage()
        if #self.Items < max then
            max = #self.Items
        end
        self.Pagination:MinItem(self.Pagination:CurrentPageStartIndex())

        if self.scrollingType == MenuScrollingType.CLASSIC and self.Pagination:TotalPages() > 1 then
            local missingItems = self.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.Pagination:ScaleformIndex(self.Pagination:GetPageIndexFromMenuIndex(self.Pagination
                    :CurrentPageEndIndex()) + missingItems - 1)
                self.Pagination.minItem = self.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.Pagination:MaxItem(self.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self:CurrentSelection()))
        self.Items[self:CurrentSelection()]:Selected(true)

        ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_ITEM", false,
            self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._ui:CallFunction("SET_COUNTER_QTTY", false, self:CurrentSelection(), #self.Items)

        local Item = self.Items[self:CurrentSelection()]
        local _, subtype = Item()
        if subtype == "UIMenuSeparatorItem" then
            if (self.Items[self:CurrentSelection()].Jumpable) then
                self:GoDown()
            end
        end
        ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_MOUSE", false, self.Settings.MouseControlsEnabled)
        self:AnimationEnabled(enab)
        self:FadeInMenu()
        self._isBuilding = false
        if BreadcrumbsHandler:Count() == 0 then
            BreadcrumbsHandler:Forward(self)
        end
    end)
end

function UIMenu:_itemCreation(page, pageIndex, before, overflow)
    local menuIndex = self.Pagination:GetMenuIndexFromPageIndex(page, pageIndex)
    if not before then
        if self.Pagination:GetPageItemsCount(page) < self.Pagination:ItemsPerPage() and self.Pagination:TotalPages() > 1 then
            if self.scrollingType == MenuScrollingType.ENDLESS then
                if menuIndex > #self.Items then
                    menuIndex = menuIndex - #self.Items
                    self.Pagination:MaxItem(menuIndex)
                end
            elseif self.scrollingType == MenuScrollingType.CLASSIC and overflow then
                local missingItems = self.Pagination:ItemsPerPage() - self.Pagination:GetPageItemsCount(page)
                menuIndex = menuIndex - missingItems
            elseif self.scrollingType == MenuScrollingType.PAGINATED then
                if menuIndex > #self.Items then return end
            end
        end
    end

    local scaleformIndex = self.Pagination:GetScaleformIndex(menuIndex)

    local item = self.Items[menuIndex]
    local Type, SubType = item()
    local textEntry = "menu_" .. BreadcrumbsHandler:CurrentDepth() .. "_desc_" .. menuIndex
    AddTextEntry(textEntry, item:Description())

    if SubType == "UIMenuListItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 1, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), table.concat(item.Items, ","), item:Index() - 1,
            item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
            item.Base._highlightedTextColor)
    elseif SubType == "UIMenuDynamicListItem" then -- dynamic list item are handled like list items in the scaleform.. so the type remains 1
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 1, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item:CurrentListItem(), 0, item.Base._mainColor,
            item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
    elseif SubType == "UIMenuCheckboxItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 2, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item.CheckBoxStyle, item._Checked, item.Base._mainColor,
            item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
    elseif SubType == "UIMenuSliderItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 3, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item._Max, item._Multiplier, item:Index(),
            item.Base._mainColor,
            item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor, item.SliderColor,
            item._heritage)
    elseif SubType == "UIMenuProgressItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 4, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item._Max, item._Multiplier, item:Index(),
            item.Base._mainColor,
            item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor, item.SliderColor)
    elseif SubType == "UIMenuStatsItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 5, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item:Index(), item._Type, item._Color, item.Base._mainColor,
            item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
    elseif SubType == "UIMenuSeparatorItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 6, menuIndex, item.Base._formatLeftLabel,
            textEntry,
            item:Enabled(), item:BlinkDescription(), item.Jumpable, item.Base._mainColor,
            item.Base._highlightColor,
            item.Base._textColor, item.Base._highlightedTextColor)
    else
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_ITEM", false, before, 0, menuIndex, item._formatLeftLabel, textEntry,
            item:Enabled(), item:BlinkDescription(), item._mainColor, item._highlightColor, item._textColor,
            item._highlightedTextColor)
        ScaleformUI.Scaleforms._ui:CallFunction("SET_RIGHT_LABEL", false, scaleformIndex, item._formatRightLabel)
        if item._rightBadge ~= BadgeStyle.NONE then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_RIGHT_BADGE", false, scaleformIndex, item._rightBadge)
        end
    end

    if SubType ~= "UIMenuItem" then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_LABEL_FONT", false, scaleformIndex,
            item.Base._labelFont.FontName, item.Base._labelFont.FontID)
        ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_RIGHT_LABEL_FONT", false, scaleformIndex,
            item.Base._rightLabelFont.FontName, item.Base._rightLabelFont.FontID)
        if item.Base._leftBadge ~= BadgeStyle.NONE then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_LEFT_BADGE", false, scaleformIndex, item.Base._leftBadge)
        end
    else
        ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_LABEL_FONT", false, scaleformIndex, item._labelFont.FontName,
            item._labelFont.FontID)
        ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_RIGHT_LABEL_FONT", false, scaleformIndex,
            item._rightLabelFont.FontName, item._rightLabelFont.FontID)
        if item._leftBadge ~= BadgeStyle.NONE then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_LEFT_BADGE", false, scaleformIndex, item._leftBadge)
        end
    end
    if item.SidePanel ~= nil then
        if item.SidePanel() == "UIMissionDetailsPanel" then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, scaleformIndex, 0,
                item.SidePanel.PanelSide, item.SidePanel.TitleType, item.SidePanel.Title,
                item.SidePanel.TitleColor,
                item.SidePanel.TextureDict, item.SidePanel.TextureName)
            for key, value in pairs(item.SidePanel.Items) do
                ScaleformUI.Scaleforms._ui:CallFunction("ADD_MISSION_DETAILS_DESC_ITEM", false, scaleformIndex,
                    value.Type, value.TextLeft, value.TextRight, value.Icon, value.IconColor, value.Tick,
                    value._labelFont.FontName, value._labelFont.FontID,
                    value._rightLabelFont.FontName, value._rightLabelFont.FontID)
            end
        elseif item.SidePanel() == "UIVehicleColorPickerPanel" then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, scaleformIndex, 1,
                item.SidePanel.PanelSide, item.SidePanel.TitleType, item.SidePanel.Title,
                item.SidePanel.TitleColor)
        end
    end
    if #item.Panels > 0 then
        for pan, panel in pairs(item.Panels) do
            local pType, pSubType = panel()
            if pSubType == "UIMenuColorPanel" then
                if panel.CustomColors ~= nil then
                    ScaleformUI.Scaleforms._ui:CallFunction("ADD_PANEL", false, scaleformIndex, 0, panel.Title,
                        panel.ColorPanelColorType, panel.value, table.concat(panel.CustomColors, ","))
                else
                    ScaleformUI.Scaleforms._ui:CallFunction("ADD_PANEL", false, scaleformIndex, 0, panel.Title,
                        panel.ColorPanelColorType, panel.value)
                end
            elseif pSubType == "UIMenuPercentagePanel" then
                ScaleformUI.Scaleforms._ui:CallFunction("ADD_PANEL", false, scaleformIndex, 1, panel.Title, panel.Min,
                    panel.Max, panel.Percentage)
            elseif pSubType == "UIMenuGridPanel" then
                ScaleformUI.Scaleforms._ui:CallFunction("ADD_PANEL", false, scaleformIndex, 2, panel.TopLabel,
                    panel.RightLabel, panel.LeftLabel, panel.BottomLabel, panel._CirclePosition.x,
                    panel._CirclePosition.y, true, panel.GridType)
            elseif pSubType == "UIMenuStatisticsPanel" then
                ScaleformUI.Scaleforms._ui:CallFunction("ADD_PANEL", false, scaleformIndex, 3)
                if #panel.Items then
                    for key, stat in pairs(panel.Items) do
                        ScaleformUI.Scaleforms._ui:CallFunction("ADD_STATISTIC_TO_PANEL", false, scaleformIndex, pan - 1,
                            stat['name'], stat['value'])
                    end
                end
            end
        end
    end
end

---ProcessControl
function UIMenu:ProcessControl()
    if not self._Visible then
        return
    end

    if self.JustOpened then
        self.JustOpened = false
        return
    end

    if UpdateOnscreenKeyboard() == 0 or IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing() or BreadcrumbsHandler.SwitchInProgress or self.isFading then return end

    if self.Controls.Back.Enabled then
        if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(1, 177) or IsDisabledControlJustReleased(2, 177) or IsDisabledControlJustReleased(0, 199) or IsDisabledControlJustReleased(1, 199) or IsDisabledControlJustReleased(2, 199) then
            Citizen.CreateThread(function()
                self:GoBack()
                Citizen.Wait(125)
                return
            end)
        end
    end

    if #self.Items == 0 or self._isBuilding then return end

    if self.Controls.Up.Enabled then
        if IsDisabledControlJustPressed(0, 172) or IsDisabledControlJustPressed(1, 172) or IsDisabledControlJustPressed(2, 172) or IsDisabledControlJustPressed(0, 241) or IsDisabledControlJustPressed(1, 241) or IsDisabledControlJustPressed(2, 241) or IsDisabledControlJustPressed(2, 241) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoUp()
            end)
        elseif IsDisabledControlPressed(0, 172) or IsDisabledControlPressed(1, 172) or IsDisabledControlPressed(2, 172) or IsDisabledControlPressed(0, 241) or IsDisabledControlPressed(1, 241) or IsDisabledControlPressed(2, 241) or IsDisabledControlPressed(2, 241) then
            if GlobalGameTimer - self._timeBeforeOverflow > self._delayBeforeOverflow then
                if GlobalGameTimer - self._time > self._delay then
                    self:ButtonDelay()
                    Citizen.CreateThread(function()
                        self:GoUp()
                    end)
                end
            end
        end
    end

    if self.Controls.Down.Enabled then
        if IsDisabledControlJustPressed(0, 173) or IsDisabledControlJustPressed(1, 173) or IsDisabledControlJustPressed(2, 173) or IsDisabledControlJustPressed(0, 242) or IsDisabledControlJustPressed(1, 242) or IsDisabledControlJustPressed(2, 242) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoDown()
            end)
        elseif IsDisabledControlPressed(0, 173) or IsDisabledControlPressed(1, 173) or IsDisabledControlPressed(2, 173) or IsDisabledControlPressed(0, 242) or IsDisabledControlPressed(1, 242) or IsDisabledControlPressed(2, 242) then
            if GlobalGameTimer - self._timeBeforeOverflow > self._delayBeforeOverflow then
                if GlobalGameTimer - self._time > self._delay then
                    self:ButtonDelay()
                    Citizen.CreateThread(function()
                        self:GoDown()
                    end)
                end
            end
        end
    end

    if self.Controls.Left.Enabled then
        if IsDisabledControlJustPressed(0, 174) or IsDisabledControlJustPressed(1, 174) or IsDisabledControlJustPressed(2, 174) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoLeft()
                return
            end)
        elseif IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174) then
            if GlobalGameTimer - self._timeBeforeOverflow > self._delayBeforeOverflow then
                if GlobalGameTimer - self._time > self._delay then
                    self:ButtonDelay()
                    Citizen.CreateThread(function()
                        self:GoLeft()
                        return
                    end)
                end
            end
        end
    end

    if self.Controls.Right.Enabled then
        if IsDisabledControlJustPressed(0, 175) or IsDisabledControlJustPressed(1, 175) or IsDisabledControlJustPressed(2, 175) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoRight()
                return
            end)
        elseif IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175) then
            if GlobalGameTimer - self._timeBeforeOverflow > self._delayBeforeOverflow then
                if GlobalGameTimer - self._time > self._delay then
                    self:ButtonDelay()
                    Citizen.CreateThread(function()
                        self:GoRight()
                        return
                    end)
                end
            end
        end
    end

    if self.Controls.Select.Enabled and ((IsDisabledControlJustPressed(0, 201) or IsDisabledControlJustPressed(1, 201) or IsDisabledControlJustPressed(2, 201)) or
            (IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(1, 24) or IsDisabledControlJustPressed(2, 24)) and not self.Settings.MouseControlsEnabled) then
        Citizen.CreateThread(function()
            self:SelectItem()
            Citizen.Wait(125)
            return
        end)
    end

    if (IsDisabledControlJustReleased(0, 172) or IsDisabledControlJustReleased(1, 172) or IsDisabledControlJustReleased(2, 172) or IsDisabledControlJustReleased(0, 241) or IsDisabledControlJustReleased(1, 241) or IsDisabledControlJustReleased(2, 241) or IsDisabledControlJustReleased(2, 241)) or
        (IsDisabledControlJustReleased(0, 173) or IsDisabledControlJustReleased(1, 173) or IsDisabledControlJustReleased(2, 173) or IsDisabledControlJustReleased(0, 242) or IsDisabledControlJustReleased(1, 242) or IsDisabledControlJustReleased(2, 242)) or
        (IsDisabledControlJustReleased(0, 174) or IsDisabledControlJustReleased(1, 174) or IsDisabledControlJustReleased(2, 174)) or
        (IsDisabledControlJustReleased(0, 175) or IsDisabledControlJustReleased(1, 175) or IsDisabledControlJustReleased(2, 175))
    then
        self._times = 0
        self._delay = 100
    end
end

function UIMenu:ButtonDelay()
    self._times = self._times + 1
    if self._times % 5 == 0 then
        self._delay = self._delay - 10
        if self._delay < 50 then
            self._delay = 50
        end
    end
    self._time = GlobalGameTimer
end

---GoUp
function UIMenu:GoUp()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == 1 and self.Pagination:TotalPages() > 1
        if self.Pagination:GoUp() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(),
                    true, false)
                ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", false, 8, self._delay) --[[@as number]]
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                self._isBuilding = true
                self:FadeOutItems()
                self.isFading = true
                ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ITEMS", false)
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                    i = i + 1
                end
                self._isBuilding = false
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_ITEM", false, self.Pagination:ScaleformIndex())
    ScaleformUI.Scaleforms._ui:CallFunction("SET_COUNTER_QTTY", false, self:CurrentSelection(), #self.Items)
    self.Items[self:CurrentSelection()]:Selected(true)
    if self.isFading then
        self:FadeInItems()
    end
    self.OnIndexChange(self, self:CurrentSelection())
end

---GoDown
function UIMenu:GoDown()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == #self.Items and self.Pagination:TotalPages() > 1
        if self.Pagination:GoDown() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(),
                    false, overflow)
                ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", false, 9, self._delay) --[[@as number]]
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                self._isBuilding = true
                self:FadeOutItems()
                self.isFading = true
                ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ITEMS", false)
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, overflow)
                    i = i + 1
                end
                self._isBuilding = false
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_ITEM", false, self.Pagination:ScaleformIndex())
    ScaleformUI.Scaleforms._ui:CallFunction("SET_COUNTER_QTTY", false, self:CurrentSelection(), #self.Items)
    self.Items[self:CurrentSelection()]:Selected(true)
    if self.isFading then
        self:FadeInItems()
    end
    self.OnIndexChange(self, self:CurrentSelection())
end

---GoLeft
function UIMenu:GoLeft()
    local Item = self.Items[self:CurrentSelection()]
    local type, subtype = Item()
    if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuDynamicListItem" and subtype ~= "UIMenuSliderItem" and subtype ~= "UIMenuProgressItem" and subtype ~= "UIMenuStatsItem" then
        return
    end

    if not Item:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end

    local return_value = ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", true, 10) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local res = GetScaleformMovieMethodReturnValueInt(return_value)

    if subtype == "UIMenuListItem" then
        Item:Index(res + 1)
        self.OnListChange(self, Item, Item._Index)
        Item.OnListChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif (subtype == "UIMenuDynamicListItem") then
        local result = tostring(Item.Callback(Item, "left"))
        Item:CurrentListItem(result)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderItem" then
        Item:Index(res)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuProgressItem" then
        Item:Index(res)
        self.OnProgressChange(self, Item, Item:Index())
        Item.OnProgressChanged(self, Item, Item:Index())
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuStatsItem" then
        Item:Index(res)
        self.OnStatsChanged(self, Item, Item:Index())
        Item.OnStatsChanged(self, Item, Item._Index)
    end
end

---GoRight
function UIMenu:GoRight()
    local Item = self.Items[self:CurrentSelection()]
    local type, subtype = Item()
    if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuDynamicListItem" and subtype ~= "UIMenuSliderItem" and subtype ~= "UIMenuProgressItem" and subtype ~= "UIMenuStatsItem" then
        return
    end
    if not Item:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end

    local return_value = ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", true, 11) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local res = GetScaleformMovieMethodReturnValueInt(return_value)

    if subtype == "UIMenuListItem" then
        Item:Index(res + 1)
        self.OnListChange(self, Item, Item._Index)
        Item.OnListChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif (subtype == "UIMenuDynamicListItem") then
        local result = tostring(Item.Callback(Item, "right"))
        Item:CurrentListItem(result)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderItem" then
        Item:Index(res)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuProgressItem" then
        Item:Index(res)
        self.OnProgressChange(self, Item, Item:Index())
        Item.OnProgressChanged(self, Item, Item:Index())
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuStatsItem" then
        Item:Index(res)
        self.OnStatsChanged(self, Item, Item:Index())
        Item.OnStatsChanged(self, Item, Item._Index)
    end
end

---SelectItem
---@param play boolean?
function UIMenu:SelectItem(play)
    if not self.Items[self:CurrentSelection()]:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    if play then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
    end

    local Item = self.Items[self:CurrentSelection()]
    local type, subtype = Item()
    if subtype == "UIMenuCheckboxItem" then
        Item:Checked(not Item:Checked())
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnCheckboxChange(self, Item, Item:Checked())
        Item.OnCheckboxChanged(self, Item, Item:Checked())
    elseif subtype == "UIMenuListItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnListSelect(self, Item, Item._Index)
        Item.OnListSelected(self, Item, Item._Index)
    elseif subtype == "UIMenuDynamicListItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnListSelect(self, Item, Item._currentItem)
        Item.OnListSelected(self, Item, Item._currentItem)
    elseif subtype == "UIMenuSliderItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnSliderSelect(self, Item, Item._Index)
        Item.OnSliderSelected(self, Item, Item._Index)
    elseif subtype == "UIMenuProgressItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnProgressSelect(self, Item, Item._Index)
        Item.OnProgressSelected(self, Item, Item._Index)
    elseif subtype == "UIMenuStatsItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnStatsSelect(self, Item, Item._Index)
        Item.OnStatsSelected(self, Item, Item._Index)
    else
        self.OnItemSelect(self, Item, self:CurrentSelection())
        Item.Activated(self, Item)
    end
end

---Go back to the previous menu
---@param boolean boolean? Play sound
function UIMenu:GoBack(boolean)
    local playSound = true

    if type(boolean) == "boolean" then
        playSound = boolean
    end

    if self:CanPlayerCloseMenu() then
        self:FadeOutMenu()
        if playSound then
            PlaySoundFrontend(-1, self.Settings.Audio.Back, self.Settings.Audio.Library, true)
        end
        if BreadcrumbsHandler:CurrentDepth() == 1 then
            self:Visible(false)
            BreadcrumbsHandler:Clear()
        else
            BreadcrumbsHandler.SwitchInProgress = true
            local prevMenu = BreadcrumbsHandler:PreviousMenu()
            BreadcrumbsHandler:Backwards()
            self:Visible(false)
            prevMenu:Visible(true)
            BreadcrumbsHandler.SwitchInProgress = false
        end
    end
end

---BindMenuToItem
---@param Menu table
---@param Item table
function UIMenu:BindMenuToItem(Menu, Item)
    if Menu() == "UIMenu" and Item() == "UIMenuItem" then
        Menu.ParentMenu = self
        Menu.ParentItem = Item
        self.Children[Item] = Menu
    end
end

---ReleaseMenuFromItem
---@param Item table
function UIMenu:ReleaseMenuFromItem(Item)
    if Item() == "UIMenuItem" then
        if not self.Children[Item] then
            return false
        end
        self.Children[Item].ParentMenu = nil
        self.Children[Item].ParentItem = nil
        self.Children[Item] = nil
        return true
    end
end

function UIMenu:UpdateDescription()
    ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_ITEM_DESCRIPTION", false,
        self.Pagination:GetScaleformIndex(self:CurrentSelection()),
        "menu_" .. BreadcrumbsHandler:CurrentDepth() .. "_desc_" .. self:CurrentSelection())
end

---Draw
function UIMenu:Draw()
    if not self._Visible or ScaleformUI.Scaleforms.Warning:IsShowing() then return end
    while not ScaleformUI.Scaleforms._ui:IsLoaded() do Citizen.Wait(0) end

    HideHudComponentThisFrame(19)

    if self.Settings.ControlDisablingEnabled then
        self:DisEnableControls(false)
    end

    ScaleformUI.Scaleforms._ui:Render2D()

    if self.Glare then
        self._menuGlare:CallFunction("SET_DATA_SLOT", false, GetGameplayCamRelativeHeading())

        local gx = self.Position.x / 1280 + 0.4499
        local gy = self.Position.y / 720 + 0.449

        self._menuGlare:Render2DNormal(gx, gy, 1.0, 1.0)
    end

    if not IsUsingKeyboard(2) then
        if self._keyboard then
            self._keyboard = false
            self._changed = true
        end
    else
        if not self._keyboard then
            self._keyboard = true
            self._changed = true
        end
    end
    if self._changed then
        self:UpdateDescription()
        self._changed = false
    end
end

local cursor_pressed = false
local menuSound = -1
local success, event_type, context, item_id

function UIMenu:ProcessMouse()
    if not self._Visible or self.JustOpened or #self.Items == 0 or not IsUsingKeyboard(2) or not self.Settings.MouseControlsEnabled then
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(1, 1, true)
        EnableControlAction(1, 2, true)
        EnableControlAction(2, 1, true)
        EnableControlAction(2, 2, true)
        if self.Dirty then
            for _, Item in pairs(self.Items) do
                if Item:Hovered() then
                    Item:Hovered(false)
                end
            end
            self.Dirty = false
        end
        return
    end

    SetMouseCursorActiveThisFrame()
    SetInputExclusive(2, 239)
    SetInputExclusive(2, 240)
    SetInputExclusive(2, 237)
    SetInputExclusive(2, 238)

    success, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._ui.handle)

    if success == 1 then
        if event_type == 5 then  --ON CLICK
            if context == 0 then -- normal menu items
                local item = self.Items[item_id]
                if (item == nil) then return end
                if item:Selected() then
                    if item.ItemId == 0 or item.ItemId == 2 then
                        self:SelectItem(false)
                    elseif item.ItemId == 1 or item.ItemId == 3 or item.ItemId == 4 then
                        Citizen.CreateThread(function()
                            local return_value = ScaleformUI.Scaleforms._ui:CallFunction("SELECT_ITEM", true, item_id) --[[@as number]]
                            while not IsScaleformMovieMethodReturnValueReady(return_value) do
                                Citizen.Wait(0)
                            end
                            local value = GetScaleformMovieMethodReturnValueInt(return_value)

                            local curr_select_item = self.Items[self:CurrentSelection()]
                            local item_type_curr, item_subtype_curr = curr_select_item()
                            if item.ItemId == 1 then
                                if curr_select_item:Index() ~= value then
                                    curr_select_item:Index(value)
                                    self.OnListChange(self, curr_select_item, curr_select_item:Index())
                                    curr_select_item.OnListChanged(self, curr_select_item, curr_select_item:Index())
                                else
                                    self:SelectItem(false)
                                end
                            elseif item.ItemId == 3 then
                                if (value ~= curr_select_item:Index()) then
                                    curr_select_item:Index(value)
                                    curr_select_item.OnSliderChanged(self, curr_select_item, curr_select_item:Index())
                                    self.OnSliderChange(self, curr_select_item, curr_select_item:Index())
                                else
                                    self:SelectItem(false)
                                end
                            elseif item.ItemId == 4 then
                                if (value ~= curr_select_item:Index()) then
                                    curr_select_item:Index(value)
                                    curr_select_item.OnProgressChanged(self, curr_select_item, curr_select_item:Index())
                                    self.OnProgressChange(self, curr_select_item, curr_select_item:Index())
                                else
                                    self:SelectItem(false)
                                end
                            end
                        end)
                    end
                    return
                end
                if (item.ItemId == 6 and item.Jumpable == true) or not item:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                self:CurrentSelection(item_id)
                ScaleformUI.Scaleforms._ui:CallFunction("SET_COUNTER_QTTY", false, self:CurrentSelection(), #self.Items)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            elseif context == 10 then -- panels (10 => context 1, panel_type 0) // ColorPanel
                Citizen.CreateThread(function()
                    local return_value = ScaleformUI.Scaleforms._ui:CallFunction("SELECT_PANEL", true,
                        self:CurrentSelection() - 1) --[[@as number]]
                    while not IsScaleformMovieMethodReturnValueReady(return_value) do
                        Citizen.Wait(0)
                    end
                    local res = GetScaleformMovieMethodReturnValueString(return_value)
                    local split = Split(res, ",")
                    local panel = self.Items[self:CurrentSelection()].Panels[tonumber(split[1]) + 1]
                    panel.value = tonumber(split[2]) + 1
                    self.OnColorPanelChanged(panel.ParentItem, panel, panel:CurrentSelection())
                    panel.OnColorPanelChanged(panel.ParentItem, panel, panel:CurrentSelection())
                end)
            elseif context == 11 then -- panels (11 => context 1, panel_type 1) // PercentagePanel
                cursor_pressed = true
            elseif context == 12 then -- panels (12 => context 1, panel_type 2) // GridPanel
                cursor_pressed = true
            elseif context == 2 then  -- sidepanel
                local panel = self.Items[self:CurrentSelection()].SidePanel
                if item_id ~= -1 then
                    panel.Value = item_id - 1
                    panel.PickerSelect(panel.ParentItem, panel, panel.Value)
                end
            end
        elseif event_type == 6 then -- ON CLICK RELEASED
            cursor_pressed = false
        elseif event_type == 7 then -- ON CLICK RELEASED OUTSIDE
            cursor_pressed = false
            SetMouseCursorSprite(1)
        elseif event_type == 8 then -- ON NOT HOVER
            cursor_pressed = false
            if context == 0 then
                self.Items[item_id]:Hovered(false)
            end
            SetMouseCursorSprite(1)
        elseif event_type == 9 then -- ON HOVERED
            if context == 0 then
                self.Items[item_id]:Hovered(true)
            end
            SetMouseCursorSprite(5)
        elseif event_type == 0 then -- DRAGGED OUTSIDE
            cursor_pressed = false
        elseif event_type == 1 then -- DRAGGED INSIDE
            cursor_pressed = true
        end
    end

    if cursor_pressed == true then
        if HasSoundFinished(menuSound) then
            menuSound = GetSoundId()
            PlaySoundFrontend(menuSound, "CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        end

        Citizen.CreateThread(function()
            local return_value = ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_MOUSE_EVENT_CONTINUE", true) --[[@as number]]
            while not IsScaleformMovieMethodReturnValueReady(return_value) do
                Citizen.Wait(0)
            end
            local value = GetScaleformMovieMethodReturnValueString(return_value)

            local split = Split(value, ",")
            local panel = self.Items[self:CurrentSelection()].Panels[tonumber(split[1]) + 1]
            local panel_type, panel_subtype = panel()

            if panel_subtype == "UIMenuGridPanel" then
                panel._CirclePosition = vector2(tonumber(split[2]) or 0, tonumber(split[3]) or 0)
                self.OnGridPanelChanged(panel.ParentItem, panel, panel._CirclePosition)
                panel.OnGridPanelChanged(panel.ParentItem, panel, panel._CirclePosition)
            elseif panel_subtype == "UIMenuPercentagePanel" then
                panel.Percentage = tonumber(split[2])
                self:OnPercentagePanelChanged(panel.ParentItem, panel, panel.Percentage)
                panel.OnPercentagePanelChange(panel.ParentItem, panel, panel.Percentage)
            end
        end)
    else
        if not HasSoundFinished(menuSound) then
            StopSound(menuSound)
            ReleaseSoundId(menuSound)
        end
    end
end

---AddInstructionButton
---@param button InstructionalButton
function UIMenu:AddInstructionButton(button)
    if type(button) == "table" then
        self.InstructionalButtons[#self.InstructionalButtons + 1] = button
        if self:Visible() and not ScaleformUI.Scaleforms.Warning:IsShowing() then
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
        end
    end
end

---RemoveInstructionButton
---@param button table
function UIMenu:RemoveInstructionButton(button)
    if type(button) == "table" then
        for i = 1, #self.InstructionalButtons do
            if button == self.InstructionalButtons[i] then
                table.remove(self.InstructionalButtons, i)
                break
            end
        end
    else
        if tonumber(button) then
            if self.InstructionalButtons[tonumber(button)] then
                table.remove(self.InstructionalButtons, tonumber(button))
            end
        end
    end
    if self:Visible() and not ScaleformUI.Scaleforms.Warning:IsShowing() then
        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
    end
end

---AddEnabledControl
---@param Inputgroup number
---@param Control number
---@param Controller table
function UIMenu:AddEnabledControl(Inputgroup, Control, Controller)
    if tonumber(Inputgroup) and tonumber(Control) then
        table.insert(self.Settings.EnabledControls[(Controller and "Controller" or "Keyboard")], { Inputgroup, Control })
    end
end

---RemoveEnabledControl
---@param Inputgroup number
---@param Control number
---@param Controller table
function UIMenu:RemoveEnabledControl(Inputgroup, Control, Controller)
    local Type = (Controller and "Controller" or "Keyboard")
    for Index = 1, #self.Settings.EnabledControls[Type] do
        if Inputgroup == self.Settings.EnabledControls[Type][Index][1] and Control == self.Settings.EnabledControls[Type][Index][2] then
            table.remove(self.Settings.EnabledControls[Type], Index)
            break
        end
    end
end
