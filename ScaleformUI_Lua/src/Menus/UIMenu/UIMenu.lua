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
---@field public JustOpened boolean -- If the menu was just opened
---@field public Title fun(self: UIMenu, title: string|nil):string -- Menu title
---@field public DescriptionFont fun(self: UIMenu, fontTable: ScaleformFonts|nil):ScaleformFonts -- Menu description font
---@field public Subtitle fun(self: UIMenu, subTitle: string|nil):string -- Menu subtitle
---@field public CounterColor fun(self: UIMenu, color: SColor|nil):SColor -- Counter color
---@field public SubtitleColor fun(self: UIMenu, color: HudColours|nil):SColor -- Description color
---@field public DisableGameControls fun(self: UIMenu, bool: boolean|nil):boolean -- Disable non menu controls
---@field public HasInstructionalButtons fun(self: UIMenu, enabled: boolean|nil):boolean -- If the menu has instructional buttons
---@field public CanPlayerCloseMenu fun(self: UIMenu, playerCanCloseMenu: boolean|nil):boolean -- If the player can close the menu
---@field public MouseEdgeEnabled fun(self: UIMenu, enabled: boolean|nil):boolean -- If the mouse edge is enabled
---@field public MouseWheelControlEnabled fun(self: UIMenu, enabled: boolean|nil):boolean -- If the mouse wheel is enabled
---@field public MouseControlsEnabled fun(self: UIMenu, enabled: boolean|nil):boolean -- If the mouse controls are enabled
---@field public RefreshMenu fun(self: UIMenu, keepIndex: boolean|nil)
---@field public SetBannerSprite fun(self: UIMenu, txtDictionary: string, txtName: string)
---@field public SetBannerColor fun(self: UIMenu, color: SColor)
---@field public AnimationEnabled fun(self: UIMenu, enabled: boolean|nil):boolean -- If the menu animation is enabled or disabled (default: true)
---@field public Enabled3DAnimations fun(self: UIMenu, enabled: boolean|nil):boolean -- If the 3D animations are enabled or disabled (default: true)
---@field public AnimationType fun(self: UIMenu, type: MenuAnimationType|nil):MenuAnimationType -- Animation type for the menu (default: MenuAnimationType.LINEAR)
---@field public BuildingAnimation fun(self: UIMenu, type: MenuBuildingAnimation|nil):MenuBuildingAnimation -- Build animation type for the menu (default: MenuBuildingAnimation.LEFT)
---@field public ScrollingType fun(self: UIMenu, type: MenuScrollingType|nil):MenuScrollingType -- Scrolling type for the menu (default: MenuScrollingType.CLASSIC)
---@field public FadeOutMenu fun(self: UIMenu) -- Fade out the menu
---@field public FadeInMenu fun(self: UIMenu) -- Fade in the menu
---@field public FadeOutItems fun(self: UIMenu) -- Fade out the menu items
---@field public FadeInItems fun(self: UIMenu) -- Fade in the menu items
---@field public CurrentSelection fun(self: UIMenu, value: number|nil):number -- Current selected item index
---@field public AddWindow fun(self: UIMenu, window: table) -- Add a new window to the menu
---@field public RemoveWindowAt fun(self: UIMenu, Index: number) -- Remove a window at the specified index
---@field public AddItem fun(self: UIMenu, item: UIMenuItem) -- Add a new item to the menu
---@field public AddItemAt fun(self: UIMenu, item: UIMenuItem, index: number) -- Add a new item at the specified index
---@field public RemoveItemAt fun(self: UIMenu, Index: number) -- Remove an item at the specified index
---@field public RemoveItem fun(self: UIMenu, item: table) -- Remove an item from the menu
---@field public Clear fun(self: UIMenu) -- Clear the menu
---@field public MaxItemsOnScreen fun(self: UIMenu, max: number|nil):number -- Maximum number of items that can be displayed (default: 7)
---@field public SwitchTo fun(self: UIMenu, newMenu: UIMenu, newMenuCurrentSelection: number|nil, inheritOldMenuParams: boolean|nil) -- Switch to a new menu
---@field public MouseSettings fun(self: UIMenu, enableMouseControls: boolean, enableEdge: boolean, isWheelEnabled: boolean, resetCursorOnOpen: boolean, leftClickSelect: boolean) -- Set the mouse settings for the menu
---@field public Visible fun(self: UIMenu, bool: boolean|nil):boolean -- If the menu is visible
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
---@field private counterColor SColor -- Set the counter color (default: SColor.HUD_Freemode)
---@field private enableAnimation boolean -- Enable or disable the menu animation (default: true)
---@field private animationType MenuAnimationType -- Sets the menu animation type (default: MenuAnimationType.LINEAR)
---@field private buildingAnimation MenuBuildingAnimation -- Sets the menu building animation type (default: MenuBuildingAnimation.NONE)
---@field private descFont ScaleformFonts -- Sets the desctiption text font. (default: ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
---@field private subtitleColor HudColours -- Sets the subtitle color (default: HudColours.NONE)
---@field private leftClickEnabled boolean -- Enable or disable left click controls (default: false)
---@field private bannerColor SColor -- Sets the menu banner color (default: SColor.HUD_None)
---@field private _unfilteredMenuItems table -- {}
---@field private _menuGlare number -- Menu glare effect
---@field private _canBuild boolean -- If the menu can be built
---@field private _isBuilding boolean -- If the menu is building
---@field private _time number -- Time
---@field private _times number -- Times
---@field private _delay number -- Delay
---@field private _delayBeforeOverflow number -- Delay before overflow
---@field private _timeBeforeOverflow number -- Time before overflow
---@field private _canHe boolean -- If the player can close the menu
---@field private _scaledWidth number -- Scaled width
---@field private enabled3DAnimations boolean -- If the 3D animations are enabled
---@field private isFading boolean -- If the menu is fading
---@field private fadingTime number -- Fading time
---@field private ParentPool table -- {}
---@field private _Visible boolean -- If the menu is visible
---@field private Dirty boolean -- If the menu is dirty
---@field private disableGameControls boolean -- If the game controls are disabled
---@field private InstructionalButtons table -- {}
---@field private _itemless boolean -- If the menu has no items
---@field private _keyboard boolean -- If the menu is using the keyboard
---@field private _changed boolean -- If the menu has changed
---@field private _maxItem number -- Maximum number of items

---Creates a new UIMenu.
---@param title string -- Menu title
---@param subTitle string -- Menu subtitle
---@param x number|nil -- Menu Offset X position
---@param y number|nil -- Menu Offset Y position
---@param glare boolean|nil -- Menu glare effect
---@param txtDictionary string|nil -- Custom texture dictionary for the menu banner background (default: commonmenu)
---@param txtName string|nil -- Custom texture name for the menu banner background (default: interaction_bgd)
---@param alternativeTitleStyle boolean|nil -- Use alternative title style (default: false)
function UIMenu.New(title, subTitle, x, y, glare, txtDictionary, txtName, alternativeTitleStyle, longdesc, align)
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
        txtDictionary = tostring(txtDictionary) or ""
    else
        txtDictionary = ""
    end
    if txtName ~= nil then
        txtName = tostring(txtName) or ""
    else
        txtName = ""
    end
    if alternativeTitleStyle == nil then
        alternativeTitleStyle = false
    end
    if longdesc ~= nil and string.IsNullOrEmpty(longdesc) then
        AddTextEntry("ScaleformUILongDesc", longdesc)
    end
    local _UIMenu = {
        _Title = title,
        _Subtitle = subTitle,
        AlternativeTitle = alternativeTitleStyle,
        counterColor = SColor.HUD_Freemode,
        Position = vector2(X, Y),
        descFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        subtitleColor = HudColours.NONE,
        leftClickEnabled = false,
        _maxItemsOnScreen = 7,
        _currentSelection = 1,
        _visibleItems = 1,
        topEdge = 1,
        bannerColor = SColor.HUD_None,
        Extra = {},
        Description = {},
        Items = {},
        ParentItem = nil,
        _unfilteredMenuItems = {},
        _unfilteredSelection = 1,
        _unfilteredTopEdge = 1,
        mouseReset = false,
        Windows = {},
        TxtDictionary = txtDictionary,
        TxtName = txtName,
        Glare = glare or false,
        Logo = nil,
        _itemless = longdesc ~= nil,
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
        _differentBanner = false,
        _canHe = true,
        _scaledWidth = (720 * GetAspectRatio(false)),
        _glarePos = { x = 0, y = 0 },
        _glareSize = { w = 1.0, h = 1.0 },
        menuAlignment = align or 0,
        _mouseOnMenu = false,
        fSavedGlareDirection = 0,
        enabled3DAnimations = true,
        isFading = false,
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
        disableGameControls = true,
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
        ExtensionMethod = function(menu)
        end,
        Settings = {
            InstructionalButtons = true,
            MultilineFormats = true,
            ScaleWithSafezone = true,
            ResetCursorOnOpen = true,
            MouseControlsEnabled = true,
            MouseWheelEnabled = true,
            MouseEdgeEnabled = true,
            Audio = {
                Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                UpDown = "NAV_UP_DOWN",
                LeftRight = "NAV_LEFT_RIGHT",
                Select = "SELECT",
                Back = "BACK",
                Error = "ERROR",
            },
        }
    }
    if subTitle ~= "" and subTitle ~= nil then
        _UIMenu._Subtitle = subTitle
    end
    if (_UIMenu._menuGlare == 0) then
        _UIMenu._menuGlare = Scaleform.Request("mp_menu_glare")
    end

    _UIMenu.Position = vector2(X, Y)
    local safezone = (1.0 - math.round(GetSafeZoneSize(), 2)) * 100 * 0.005
    local rightAlign = _UIMenu.menuAlignment == MenuAlignment.RIGHT
    local glareX = 0.45 + safezone

    local pos1080 = ConvertScaleformCoordsToResolutionCoords(X, Y)
    local screenCoords = ConvertResolutionCoordsToScreenCoords(pos1080.x, pos1080.y)
    _UIMenu._glarePos = vector2(screenCoords.x + glareX, screenCoords.y + 0.45 + safezone)
    if rightAlign then
        glareX = 1.225 - safezone
        local w, h = GetActualScreenResolution()
        screenCoords = ConvertResolutionCoordsToScreenCoords(1920 - pos1080.x, pos1080.y)
        _UIMenu._glarePos = vector2(screenCoords.x - 1 + glareX, screenCoords.y + 0.45 + safezone)
    end

    _UIMenu._glareSize = { w = glareW, h = 1.0 }

    return setmetatable(_UIMenu, UIMenu)
end

---Getter / Setter for the menu title.
---@param title any
---@return any
function UIMenu:Title(title)
    if title == nil then
        return self._Title
    else
        self._Title = title
        if self:Visible() then
            if self.subtitleColor == HudColours.NONE then
                ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_TITLE_SUBTITLE", self._Title, self._Subtitle,
                    self.alternativeTitle)
            else
                ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_TITLE_SUBTITLE", self._Title,
                    "~HC_" .. self.subtitleColor .. "~" .. self._Subtitle,
                    self.alternativeTitle)
            end
        end
    end
end

---Getter / Setter for the description font.
---@param fontTable ItemFont
---@return ItemFont
function UIMenu:DescriptionFont(fontTable)
    if fontTable == nil then
        return self.descFont
    else
        self.descFont = fontTable
        if self:Visible() then
            self:SetMenuData(true)
        end
    end
end

---Getter / Setter for the subtitle.
---@param sub string
---@return string | nil
function UIMenu:Subtitle(sub)
    if sub == nil then
        return self._Subtitle
    else
        self._Subtitle = sub
        if self:Visible() then
            self:SetMenuData(true)
        end
    end
end

---Getter / Setter for the counter color.
---@param color SColor
---@return any
function UIMenu:CounterColor(color)
    if color == nil then
        return self.counterColor
    else
        self.counterColor = color
        if self:Visible() then
            self:SetMenuData(true)
        end
    end
end

---Getter / Setter for the subtitle color.
---@param color HudColours
---@return any
function UIMenu:SubtitleColor(color)
    if color == nil then
        return self.subtitleColor
    else
        self.subtitleColor = color
        if self:Visible() then
            self:SetMenuData(true)
        end
    end
end

---Getter / Setter for the Menu Alignment.
---@param align MenuAlignment
---@return MenuAlignment | nil
function UIMenu:MenuAlignment(align)
    if align == nil then
        return self.menuAlignment
    else
        self.menuAlignment = align
        self:SetMenuOffset(self.Position.x, self.Position.y)
        if self:Visible() then
            self:SetMenuData(true)
        end
    end
end

---DisableNonMenuControls
---@param bool? boolean
---@return boolean | nil
function UIMenu:DisableGameControls(bool)
    if bool ~= nil then
        self.disableGameControls = bool
    else
        return self.disableGameControls
    end
end

---InstructionalButtons
---@param enabled boolean|nil
---@return boolean
function UIMenu:HasInstructionalButtons(enabled)
    if enabled ~= nil then
        self.Settings.InstructionalButtons = ToBool(enabled)
    end
    return self.Settings.InstructionalButtons
end

--- Sets if the menu can be closed by the player.
---@param playerCanCloseMenu boolean|nil
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

---Sets if the camera can be rotated when the mouse cursor is near the edges of the screen. (Default: true)
---@param enabled boolean|nil
---@return boolean
function UIMenu:MouseEdgeEnabled(enabled)
    if enabled ~= nil then
        self.Settings.MouseEdgeEnabled = ToBool(enabled)
    end
    return self.Settings.MouseEdgeEnabled
end

function UIMenu:MouseWheelControlEnabled(enabled)
    if enabled ~= nil then
        self.Settings.MouseWheelEnabled = ToBool(enabled)
    end
    return self.Settings.MouseWheelEnabled
end

---Enables or disables mouse controls for the menu. (Default: true)
---@param enabled boolean|nil
---@return boolean
function UIMenu:MouseControlsEnabled(enabled)
    if enabled ~= nil then
        self.Settings.MouseControlsEnabled = ToBool(enabled)
        if self:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_MOUSE", self.Settings.MouseControlsEnabled)
        end
    end
    return self.Settings.MouseControlsEnabled
end

function UIMenu:RefreshMenu(keepIndex)
    if keepIndex == nil then keepIndex = false end
    if (self:Visible()) then
        if not keepIndex then
            self:CurrentSelection(0)
        end
        ScaleformUI.Scaleforms._ui:CallFunction("REFRESH_MENU", self._currentSelection - 1, self.topEdge - 1)
    end
end

---SetBannerSprite
---@param txtDictionary string
---@param txtName string
function UIMenu:SetBannerSprite(txtDictionary, txtName)
    self.TxtDictionary = txtDictionary
    self.TxtName = txtName
    if self:Visible() then
        self:SetMenuData(true)
    end
end

---SetBannerColor
---@param color SColor
function UIMenu:SetBannerColor(color)
    self.bannerColor = color
    if self:Visible() then
        self:SetMenuData(true)
    end
end

--- Legacy function to be removed
function UIMenu:SetMenuAnimations(enableScrollingAnim, enable3DAnim, scrollingAnimation, buildingAnimation, fadingTime)
end

--- Legacy function to be removed.
---@param enable boolean|nil
---@return boolean
function UIMenu:AnimationEnabled(enable)
    return false
end

function UIMenu:Enabled3DAnimations(enable)
    return false
end

--- Legacy function to be removed.
---@param menuAnimationType MenuAnimationType|nil
---@return number MenuAnimationType
---@see MenuAnimationType
function UIMenu:AnimationType(menuAnimationType)
    return 0
end

--- Legacy function to be removed
---@param buildingAnimationType MenuBuildingAnimation|nil
---@return MenuBuildingAnimation
---@see MenuBuildingAnimation
function UIMenu:BuildingAnimation(buildingAnimationType)
    return 0
end

--- Legacy function to be removed
---@param scrollType MenuScrollingType|nil
---@return MenuScrollingType
---@see MenuScrollingType
function UIMenu:ScrollingType(scrollType)
    return 0
end

---CurrentSelection
---@param value number|nil
function UIMenu:CurrentSelection(value)
    if value ~= nil then
        if #self.Items == 0 then return end
        self:CurrentItem():Selected(false)
        self._currentSelection = math.max(1, math.min(value, #self.Items))

        if self._currentSelection >= self.topEdge + self._visibleItems then
            self.topEdge = math.max(1, math.min(self._currentSelection, #self.Items - self._visibleItems))
        elseif self._currentSelection < self.topEdge then
            self.topEdge = self._currentSelection
        end

        if self:Visible() then
            AddTextEntry("UIMenu_Current_Description", self:CurrentItem():Description())
            ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_SELECTION", self._currentSelection - 1, self.topEdge - 1)
            self:SendPanelsToItemScaleform(self._currentSelection)
            self:SendSidePanelToScaleform(self._currentSelection)
        end
        self.Items[self._currentSelection]:Selected(true)
    else
        if #self.Items == 0 then
            return 1
        end
        return self._currentSelection
    end
end

---AddWindow
---@param window table
function UIMenu:AddWindow(window)
    assert(not self._itemless, "ScaleformUI - You cannot add windows to an itemless menu, only a long description")

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
    assert(not self._itemless, "ScaleformUI - You cannot add items to an itemless menu, only a long description")
    item:SetParentMenu(self)
    self.Items[#self.Items + 1] = item
    if self:Visible() then
        local idx = #self.Items
        self:SendItemToScaleform(idx, false, false, #self.Items <= self:MaxItemsOnScreen())
        self.Items[idx]:Selected(idx == 1)
    end
end

function UIMenu:AddItemAt(item, index)
    assert(not self._itemless, "ScaleformUI - You cannot add items to an itemless menu, only a long description")
    item:SetParentMenu(self)
    table.insert(self.Items, index, item)
    if self:Visible() then
        self:SendItemToScaleform(index, false, true)
        self:RefreshMenu(true)
    end
end

--- Add multiple new items to the menu.
---@param items table
---@see UIMenuItem
function UIMenu:AddItems(items)
    for i = 1, #items do
        self:AddItem(items[i])
    end
end

---RemoveItemAt
---@param index number
function UIMenu:RemoveItemAt(idx)
    if tonumber(idx) then
        if #self.Items >= idx then
            self.Items[idx]:Selected(false)
            local curItem = self._currentSelection
            table.remove(self.Items, idx)
            if self:Visible() then
                ScaleformUI.Scaleforms._ui:CallFunction("REMOVE_DATA_SLOT", idx - 1)
            end
            if #self.Items > 0 then
                if idx == self._currentSelection then
                    if idx > #self.Items then
                        self._currentSelection = #self.Items
                    elseif idx > 1 and idx <= #self.Items then
                        self._currentSelection = idx
                    else
                        self._currentSelection = 1
                    end
                else
                    if curItem <= #self.Items then
                        self._currentSelection = curItem
                    else
                        self._currentSelection = #self.Items
                    end
                end
                self.Items[self._currentSelection]:Selected(true)
                if self:Visible() then
                    AddTextEntry("UIMenu_Current_Description", self:CurrentItem():Description())
                    ScaleformUI.Scaleforms._ui:CallFunction("SET_CURRENT_SELECTION", self._currentSelection - 1, self.topEdge - 1)
                    self:SendPanelsToItemScaleform(self._currentSelection)
                    self:SendSidePanelToScaleform(self._currentSelection)
                end
            end
        end
    end
end

---RemoveItemsRange
---@param startIndex number An integer that specifies the index of the element in the array where the deletion begins.
---@param count number An integer that specifies the number of elements to be deleted. This number includes the element specified in the startIndex parameter. If no value is specified for the deleteCount parameter, the method deletes only 1 item. If the value is 0, no elements are deleted
function UIMenu:RemoveItemsRange(startIndex, count)
    local idx = self:CurrentSelection()
    local n = #self.Items

    if startIndex < 1 or startIndex > n then return end
    count = count or 1
    count = math.min(count, n - startIndex + 1)
    if count == 0 then return end

    if idx == startIndex then
        --[[
            Failsafe workaround because Lua sucks shit so bad that is not even able
            to handle the last index in a table without crashing the entire game...
            I HATE YOU LUA!!! W C# FOR EVER!
            And they say C# has bigger overhead and it's slow... at least C# handles arrays like it should!!!
        ]]
        self:CurrentSelection(1)
    end

    local j = startIndex
    for i = startIndex + count, n do
        self.Items[j] = self.Items[i]
        j = j + 1
    end

    for i = j, n do
        self.Items[i] = nil
    end

    if self:Visible() then
        self:BuildMenu(true)
    end
    while self._isBuilding do Wait(0) end
    if #self.Items > 0 then
        -- if menu has enough items to cover last selection
        if #self.Items >= idx then
            self:CurrentSelection(idx)
        else
            -- else we select last item possible
            self:CurrentSelection(#self.Items)
        end
    else
        print("ScaleformUI - UIMenu:RemoveItemAt - Index out of range (Index: " ..
            index .. ", Items: " .. #self.Items .. ")")
    end
end

---RemoveItem
---@param item table
function UIMenu:RemoveItem(item)
    local idx = 0
    for k, v in pairs(self.Items) do
        if v:Label () == item:Label() then
            idx = k
            break
        end
    end
    if idx > 0 then
        self:RemoveItemAt(idx)
    end
end

---Clear
function UIMenu:Clear()
    self.Items = {}
    self._currentSelection = 1
    self.topEdge = 1
    if self:Visible() then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_DATA_SLOT_EMPTY")
    end
end

---MaxItemsOnScreen
---@param max number|nil
function UIMenu:MaxItemsOnScreen(max)
    if max == nil then
        return self._maxItemsOnScreen
    end
    self._maxItemsOnScreen = max
    self:BuildMenu()
end

function UIMenu:SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
    assert(newMenu ~= nil, "ScaleformUI - cannot switch to a null menu")
    if newMenuCurrentSelection == nil then newMenuCurrentSelection = 1 end
    if inheritOldMenuParams == nil then inheritOldMenuParams = true end
    MenuHandler:SwitchTo(self, newMenu, newMenuCurrentSelection, inheritOldMenuParams)
end

function UIMenu:MouseSettings(enableMouseControls, enableEdge, isWheelEnabled, resetCursorOnOpen, leftClickSelect)
    self:MouseControlsEnabled(enableMouseControls)
    self:MouseEdgeEnabled(enableEdge)
    self:MouseWheelControlEnabled(isWheelEnabled)
    self.Settings.ResetCursorOnOpen = resetCursorOnOpen
    self.leftClickEnabled = leftClickSelect
end

---Visible
---@param bool boolean|nil
function UIMenu:Visible(bool)
    if bool ~= nil then
        self.JustOpened = ToBool(bool)
        self.Dirty = ToBool(bool)

        if bool then
            if self._Visible then
                return
            end
            self._Visible = bool
            if not self._itemless and #self.Items == 0 then
                MenuHandler:CloseAndClearHistory()
                assert(self._itemless or #self.Items == 0,
                    "UIMenu " .. self:Title() .. " menu is empty... Closing and clearing history.")
            end
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
            self:BuildMenu()
            MenuHandler._currentMenu = self
            MenuHandler.ableToDraw = true
            self.OnMenuOpen(self)
            if BreadcrumbsHandler:Count() == 0 then
                BreadcrumbsHandler:Forward(self)
            end
            if #self.Items > 0 then
                AddTextEntry("UIMenu_Current_Description", self:CurrentItem():Description())
            end
        else
            ScaleformUI.Scaleforms._ui:CallFunction("SET_DATA_SLOT_EMPTY")
            self._Visible = bool
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            MenuHandler._currentMenu = nil
            MenuHandler.ableToDraw = false
            if #self._unfilteredMenuItems > 0 then
                self:Clear()
                self.Items = self._unfilteredMenuItems
                self._currentSelection = self._unfilteredSelection
                self.topEdge = self._unfilteredTopEdge
                self._unfilteredMenuItems = {}
                self._unfilteredSelection = 1
                self._unfilteredTopEdge = 1
            end
            self.OnMenuClose(self)
        end
        ScaleformUI.Scaleforms._ui:CallFunction("SET_VISIBLE", self._Visible, self:CurrentSelection() - 1,
            self.topEdge - 1)
        --hack to make sure the current item is selected
        self:CurrentSelection(self._currentSelection)
        if self.Settings.ResetCursorOnOpen then
            SetCursorLocation(0.5, 0.5)
            SetCursorSprite(1)
        end
    else
        return self._Visible
    end
end

---BuildUpMenu
function UIMenu:BuildMenu(itemsOnly)
    if itemsOnly == nil then itemsOnly = false end
    self._isBuilding = true

    if (not itemsOnly) then
        self:SetMenuData()
        self:SetWindows()
    end
    if not self:Visible() then
        return
    end
    if #self.Items > 0 then
        self:SendItems()
        self:SendPanelsToItemScaleform(self:CurrentSelection())
        self:SendSidePanelToScaleform(self:CurrentSelection())
        if self._Visible then
            while self:CurrentItem().ItemId == 6 and self:CurrentItem().Jumpable do
                Wait(0)
                self:GoDown()
            end
        end
    end
    ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_MOUSE", self.Settings.MouseControlsEnabled)
    self._isBuilding = false
end

function UIMenu:SetMenuData(skipViewInitialization)
    if skipViewInitialization == nil then skipViewInitialization = false end
    local subtitle = self._Subtitle
    if self.subtitleColor ~= HudColours.NONE then
        subtitle = "~HC_" .. self.subtitleColor .. "~" .. self._Subtitle
    end

    if self._itemless then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._ui.handle, "SET_MENU_DATA")
        PushScaleformMovieMethodParameterString(self._Title)
        PushScaleformMovieMethodParameterString(subtitle)
        PushScaleformMovieMethodParameterFloat(self.Position.x)
        PushScaleformMovieMethodParameterFloat(self.Position.y)
        PushScaleformMovieMethodParameterBool(self.AlternativeTitle)
        PushScaleformMovieMethodParameterString(self.TxtDictionary)
        PushScaleformMovieMethodParameterString(self.TxtName)
        PushScaleformMovieFunctionParameterInt(self:MaxItemsOnScreen())
        PushScaleformMovieFunctionParameterInt(#self.Items)
        PushScaleformMovieFunctionParameterInt(self.counterColor:ToArgb())
        PushScaleformMovieMethodParameterString(self.descFont.FontName)
        PushScaleformMovieFunctionParameterInt(self.descFont.FontID)
        PushScaleformMovieFunctionParameterInt(self.bannerColor:ToArgb())
        PushScaleformMovieFunctionParameterBool(true)
        BeginTextCommandScaleformString("ScaleformUILongDesc")
        EndTextCommandScaleformString_2()
        PushScaleformMovieMethodParameterString("")
        PushScaleformMovieMethodParameterString("")
        PushScaleformMovieFunctionParameterInt(self.menuAlignment)
        PushScaleformMovieFunctionParameterBool(true)
        EndScaleformMovieMethod()
        self._isBuilding = false
        return
    end


    ScaleformUI.Scaleforms._ui:CallFunction("SET_MENU_DATA", self._Title, subtitle, self.Position.x, self.Position.y,
        self.AlternativeTitle, self.TxtDictionary, self.TxtName, self:MaxItemsOnScreen(), #self.Items, self.counterColor,
        self.descFont.FontName, self.descFont.FontID, self.bannerColor:ToArgb(), false, "", "", "", self.menuAlignment,
        skipViewInitialization)
end

function UIMenu:SetWindows(update)
    if update == nil then update = false end
    if #self.Windows == 0 then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_WINDOWS_SLOT_DATA_EMPTY")
        return
    end
    local str = "UPDATE_WINDOWS_SLOT_DATA"
    if not update then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_WINDOWS_SLOT_DATA_EMPTY")
        str = "SET_WINDOWS_SLOT_DATA"
    end

    for w_id, window in pairs(self.Windows) do
        local _, SubType = window()
        if SubType == "UIMenuHeritageWindow" then
            ScaleformUI.Scaleforms._ui:CallFunction(str, w_id - 1, window.id, window.Mom, window.Dad)
        elseif SubType == "UIMenuDetailsWindow" then
            ScaleformUI.Scaleforms._ui:CallFunction(str, w_id - 1, window.id, window.DetailBottom,
                window.DetailMid, window.DetailTop, window.DetailLeft.Txd, window.DetailLeft.Txn,
                window.DetailLeft.Pos.x, window.DetailLeft.Pos.y, window.DetailLeft.Size.x,
                window.DetailLeft.Size.y)
            if window.StatWheelEnabled then
                for key, value in pairs(window.DetailStats) do
                    ScaleformUI.Scaleforms._ui:CallFunction("SET_WINDOWS_SLOT_EXTRA_DATA", w_id - 1, key - 1,
                        value.Percentage, value.HudColor)
                end
            end
        end
    end
    if not update then
        ScaleformUI.Scaleforms._ui:CallFunction("SHOW_WINDOWS")
    end
end

function UIMenu:SendItems()
    ScaleformUI.Scaleforms._ui:CallFunction("SET_DATA_SLOT_EMPTY")
    self._visibleItems = 0
    for k, v in pairs(self.Items) do
        if (#self.Items < k) then
            break
        end
        self:SendItemToScaleform(k, false)
        if self._visibleItems < self:MaxItemsOnScreen() then
            self._visibleItems = self._visibleItems + 1
        end
    end
end

function UIMenu:SendSidePanelToScaleform(i, update)
    if update == nil then update = false end
    local index = i - self.topEdge
    if (#self.Items < i or self.Items[i].SidePanel == nil or not self.Items[i].Enabled or index < 0 or index > self:MaxItemsOnScreen()) then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_SIDE_PANEL_DATA_SLOT_EMPTY")
        return
    end

    local item = self.Items[i]

    if not update then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_SIDE_PANEL_DATA_SLOT_EMPTY")
    end
    local str = "UPDATE_SIDE_PANEL_DATA_SLOT"
    if not update then
        str = "SET_SIDE_PANEL_DATA_SLOT"
    end

    if item.SidePanel() == "UIMissionDetailsPanel" then
        ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, 0,
            item.SidePanel.PanelSide, item.SidePanel.TitleType, item.SidePanel.Title,
            item.SidePanel.TitleColor,
            item.SidePanel.TextureDict, item.SidePanel.TextureName)
        for key, value in pairs(item.SidePanel.Items) do
            ScaleformUI.Scaleforms._ui:CallFunction("SET_SIDE_PANEL_SLOT", index - 1,
                value.Type, value.label, value.TextRight, value.Icon, value.IconColor, value.Tick,
                value.LabelFont.FontName, value.LabelFont.FontID,
                value._rightLabelFont.FontName, value._rightLabelFont.FontID)
        end
    elseif item.SidePanel() == "UIVehicleColorPickerPanel" then
        ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, 1,
            item.SidePanel.PanelSide, item.SidePanel.TitleType, item.SidePanel.Title,
            item.SidePanel.TitleColor)
    end
    if not update then
        ScaleformUI.Scaleforms._ui:CallFunction("SHOW_SIDE_PANEL")
    end
end

function UIMenu:SendPanelsToItemScaleform(i, update)
    if update == nil then update = false end
    local index = i - self.topEdge

    if (#self.Items < i or self.Items[i].Panels.Count == 0 or not self.Items[i].Enabled or index < 0 or index > self:MaxItemsOnScreen()) then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_PANEL_DATA_SLOT_EMPTY")
        return
    end

    local item = self.Items[i]

    local str = "UPDATE_PANEL_DATA_SLOT"
    if (not update) then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_PANEL_DATA_SLOT_EMPTY")
        str = "SET_PANEL_DATA_SLOT"
    end
    for pan, panel in pairs(item.Panels) do
        local pType, pSubType = panel()
        if pSubType == "UIMenuColorPanel" then
            if panel.CustomColors ~= nil then
                local colors = {}
                for l, m in pairs(panel.CustomColors) do
                    table.insert(colors, m:ToArgb())
                end
                ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 0, panel.Title,
                    panel.ColorPanelColorType, panel.value, table.concat(colors, ","))
            else
                ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 0, panel.Title,
                    panel.ColorPanelColorType, panel.value)
            end
        elseif pSubType == "UIMenuPercentagePanel" then
            ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 1, panel.Title, panel.Min,
                panel.Max, panel._percentage)
        elseif pSubType == "UIMenuGridPanel" then
            ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 2, panel.TopLabel,
            panel.LeftLabel, panel.RightLabel, panel.BottomLabel, panel._CirclePosition.x,
            panel._CirclePosition.y, true, panel.GridType)
    elseif pSubType == "UIMenuStatisticsPanel" then
            local arr = {}
            for k, v in pairs(panel.Items) do
                table.insert(arr, v['name'] .. ":" .. v['value'])
            end
            ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 3, table.concat(arr, ","))
        elseif pSubType == "UIMenuVehicleColourPickerPanel" then
            ScaleformUI.Scaleforms._ui:CallFunction(str, index - 1, pan - 1, 4)
        end
    end
    if (not update) then
        ScaleformUI.Scaleforms._ui:CallFunction("SHOW_PANELS")
    end
end

function UIMenu:SendItemToScaleform(i, update, newItem, isSlot)
    if update == nil then update = false end
    if newItem == nil then newItem = false end
    if isSlot == nil then isSlot = false end
    if i < 1 then 
        i = 1
    elseif i > #self.Items then
        i = #sef.Items
    end
    local item = self.Items[i]
    local str = "SET_DATA_SLOT"
    if update then
        str = "UPDATE_DATA_SLOT"
    end
    if newItem then
        str = "SET_DATA_SLOT_SPLICE"
    end
    if isSlot then
        str = "ADD_SLOT"
    end

    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._ui.handle, str)
    PushScaleformMovieFunctionParameterInt(i - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(item.ItemId)

    if item.ItemId == 1 then
        local rlabel = "SCUI_UIMENU_RLBL"
        AddTextEntry(rlabel, item:CurrentListItem())
        BeginTextCommandScaleformString(rlabel)
        EndTextCommandScaleformString_2()
    elseif item.ItemId == 2 then
        PushScaleformMovieFunctionParameterBool(item:Checked())
    elseif item.ItemId == 3 or item.ItemId == 4 or item.ItemId == 5 then
        PushScaleformMovieFunctionParameterInt(item:Index())
    else
        PushScaleformMovieFunctionParameterInt(0)
    end
    PushScaleformMovieFunctionParameterBool(item:Enabled())
    local label = "SCUI_UIMENU_LBL"
    AddTextEntry(label, item:Label())
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString_2()
    PushScaleformMovieFunctionParameterBool(item:BlinkDescription())
    if item.ItemId == 1 then -- dynamic list item are handled like list items in the scaleform.. so the type remains 1
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
        PushScaleformMovieMethodParameterString(item._rightLabelFont.FontName)
    elseif item.ItemId == 2 then
        PushScaleformMovieFunctionParameterInt(item.CheckBoxStyle)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 3 then
        PushScaleformMovieFunctionParameterInt(item._Max)
        PushScaleformMovieFunctionParameterInt(item._Multiplier)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterBool(item._heritage)
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 4 then
        PushScaleformMovieFunctionParameterInt(item._Max)
        PushScaleformMovieFunctionParameterInt(item._Multiplier)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 5 then
        PushScaleformMovieFunctionParameterInt(item._Type)
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 6 then
        PushScaleformMovieFunctionParameterBool(item.Jumpable)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    else
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        BeginTextCommandScaleformString("CELL_EMAIL_BCON")
        AddTextComponentScaleform(item:RightLabel())
        EndTextCommandScaleformString_2()
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieFunctionParameterInt(item._rightBadge)
        PushScaleformMovieMethodParameterString(item.customRightIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customRightIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
        PushScaleformMovieMethodParameterString(item._rightLabelFont.FontName)
    end
    PushScaleformMovieMethodParameterBool(item:KeepTextColorWhite())
    EndScaleformMovieMethod()
end

function UIMenu:FilterMenuItems(predicate, fail)
    assert(not self._itemless, "ScaleformUI - You can't compare or sort an itemless menu")
    self:CurrentItem():Selected(false)
    if self._unfilteredMenuItems == nil or #self._unfilteredMenuItems == 0 then
        self._unfilteredMenuItems = self.Items
        self._unfilteredSelection = self._currentSelection
        self._unfilteredTopEdge = self.topEdge
    end
    self:Clear()
    for i, item in ipairs(self._unfilteredMenuItems) do
        if predicate(item) then
            table.insert(self.Items, item)
        end
    end
    if #self.Items == 0 then
        self:Clear()
        self.Items = self._unfilteredMenuItems
        self:CurrentSelection(self._unfilteredSelection)
        self.topEdge = self._unfilteredTopEdge
        self:SendItems()
        self:RefreshMenu()
        fail()
        return
    end
    self:CurrentSelection(1)
    self.topEdge = 1
    self:SendItems()
    self:RefreshMenu()
end

function UIMenu:SortMenuItems(compare)
    assert(not self._itemless, "ScaleformUI - You can't compare or sort an itemless menu")
    self:CurrentItem():Selected(false)
    if self._unfilteredMenuItems == nil or #self._unfilteredMenuItems == 0 then
        self._unfilteredMenuItems = self.Items
        self._unfilteredSelection = self._currentSelection
        self._unfilteredTopEdge = self.topEdge
    end
    self:Clear()
    local list = self._unfilteredMenuItems
    table.sort(list, compare)
    self.Items = list
    self:CurrentSelection(1)
    self.topEdge = 1
    self:SendItems()
    self:RefreshMenu()
end

function UIMenu:ResetFilter()
    assert(not self._itemless, "ScaleformUI - You can't compare or sort an itemless menu")
    if self._unfilteredMenuItems ~= nil and #self._unfilteredMenuItems > 0 then
        self:CurrentItem():Selected(false)
        self:Clear()
        self.Items = self._unfilteredMenuItems
        self:CurrentSelection(self._unfilteredSelection)
        self.topEdge = self._unfilteredTopEdge
        self:SendItems()
        self:RefreshMenu()
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

    if UpdateOnscreenKeyboard() == 0 or IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing() or BreadcrumbsHandler.SwitchInProgress then return end

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

    if (IsDisabledControlJustPressed(0, 37)) then
        self.Items[self:CurrentSelection()].OnTabPressed(this);
    end

    if self.Controls.Up.Enabled then
        if IsDisabledControlJustPressed(0, 172) or IsDisabledControlJustPressed(1, 172) or IsDisabledControlJustPressed(2, 172) or (self.Settings.MouseWheelEnabled and (IsDisabledControlJustPressed(0, 241) or IsDisabledControlJustPressed(1, 241) or IsDisabledControlJustPressed(2, 241) or IsDisabledControlJustPressed(2, 241))) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoUp()
            end)
        elseif IsDisabledControlPressed(0, 172) or IsDisabledControlPressed(1, 172) or IsDisabledControlPressed(2, 172) or (self.Settings.MouseWheelEnabled and (IsDisabledControlPressed(0, 241) or IsDisabledControlPressed(1, 241) or IsDisabledControlPressed(2, 241) or IsDisabledControlPressed(2, 241))) then
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
        if IsDisabledControlJustPressed(0, 173) or IsDisabledControlJustPressed(1, 173) or IsDisabledControlJustPressed(2, 173) or (self.Settings.MouseWheelEnabled and (IsDisabledControlJustPressed(0, 242) or IsDisabledControlJustPressed(1, 242) or IsDisabledControlJustPressed(2, 242))) then
            self._timeBeforeOverflow = GlobalGameTimer
            Citizen.CreateThread(function()
                self:GoDown()
            end)
        elseif IsDisabledControlPressed(0, 173) or IsDisabledControlPressed(1, 173) or IsDisabledControlPressed(2, 173) or (self.Settings.MouseWheelEnabled and (IsDisabledControlPressed(0, 242) or IsDisabledControlPressed(1, 242) or IsDisabledControlPressed(2, 242))) then
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

    -- if IsDisabledControlJustPressed(0, 10) then
    --     local index = self:CurrentSelection() - self.Pagination:ItemsPerPage()
    --     if index < 0 then
    --         local pagIndex = self.Pagination:GetPageIndexFromMenuIndex(self:CurrentSelection())
    --         local newPage = self.Pagination:TotalPages()
    --         index = self.Pagination:GetMenuIndexFromPageIndex(newPage, pageIndex)
    --         local menuMaxItem = #self.Items
    --         if index > menuMaxItem then
    --             index = menuMaxItem
    --         end
    --     end
    --     self:CurrentSelection(index)
    --     self.OnIndexChange(self, self:CurrentSelection())
    -- end
    -- if IsDisabledControlJustPressed(0, 11) then
    --     local index = self:CurrentSelection() + self.Pagination:ItemsPerPage()
    --     if index >= #self.Items and self.Pagination:CurrentPage() < self.Pagination:TotalPages() then
    --         index = #self.Items
    --     elseif index >= #self.Items and self.Pagination:CurrentPage() == self.Pagination:TotalPages() then
    --         local pagIndex = self.Pagination:GetPageIndexFromMenuIndex(self:CurrentSelection())
    --         local newPage = 0
    --         index = self.Pagination:GetMenuIndexFromPageIndex(newPage, pagIndex)
    --     end
    --     self:CurrentSelection(index)
    --     self.OnIndexChange(self, self:CurrentSelection())
    -- end

    if self.Controls.Select.Enabled and ((IsDisabledControlJustPressed(0, 201) or IsDisabledControlJustPressed(1, 201) or IsDisabledControlJustPressed(2, 201)) or (self.leftClickEnabled and IsDisabledControlJustPressed(0, 24))) then
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

function UIMenu:CurrentItem()
    if self:CurrentSelection() > #self.Items then
        self:CurrentSelection(1)
        self.topEdge = 1
    end
    return self.Items[self:CurrentSelection()]
end

---GoUp
function UIMenu:GoUp()
    self:CurrentItem():Selected(false)
    repeat
        Citizen.Wait(0)
        self._currentSelection = self._currentSelection - 1
        if self._currentSelection < self.topEdge then
            self.topEdge = self.topEdge - 1
        end
        if self._currentSelection < 1 then
            self._currentSelection = #self.Items
            self.topEdge = #self.Items - self._visibleItems + 1
        end
    until self:CurrentItem().ItemId ~= 6 or (self:CurrentItem().ItemId == 6 and not self:CurrentItem().Jumpable)
    ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", 8)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    AddTextEntry("UIMenu_Current_Description", self:CurrentItem():Description())
    self:SendPanelsToItemScaleform(self._currentSelection)
    self:SendSidePanelToScaleform(self._currentSelection)
    self:CurrentItem():Selected(true)
    self.OnIndexChange(self, self:CurrentSelection())
end

---GoDown
function UIMenu:GoDown()
    self:CurrentItem():Selected(false)
    repeat
        Citizen.Wait(0)
        self._currentSelection = self._currentSelection + 1
        if self._currentSelection >= self.topEdge + self._visibleItems then
            self.topEdge = self.topEdge + 1
        end
        if self._currentSelection > #self.Items then
            self._currentSelection = 1
            self.topEdge = 1
        end
    until self:CurrentItem().ItemId ~= 6 or (self:CurrentItem().ItemId == 6 and not self:CurrentItem().Jumpable)
    ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", 9)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    AddTextEntry("UIMenu_Current_Description", self:CurrentItem():Description())
    self:SendPanelsToItemScaleform(self._currentSelection)
    self:SendSidePanelToScaleform(self._currentSelection)
    self:CurrentItem():Selected(true)
    self.OnIndexChange(self, self:CurrentSelection())
end

---GoLeft
function UIMenu:GoLeft()
    local Item = self:CurrentItem()
    if Item.ItemId == 0 or Item.ItemId == 2 or Item.ItemId == 6 or not Item:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    if Item.ItemId == 1 then
        if Item() == "UIMenuListItem" then
            Item:Index(Item:Index() - 1)
            self.OnListChange(self, Item, Item._Index)
            Item.OnListChanged(self, Item, Item._Index)
        else
            local result = tostring(Item.Callback(Item, "left"))
            Item:CurrentListItem(result)
        end
    elseif Item.ItemId == 3 then
        Item:Index(Item:Index() - 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
    elseif Item.ItemId == 4 then
        Item:Index(Item:Index() - 1)
        self.OnProgressChange(self, Item, Item:Index())
        Item.OnProgressChanged(self, Item, Item:Index())
    elseif Item.ItemId == 5 then
        Item:Index(Item:Index() - 1)
        self.OnStatsChanged(self, Item, Item:Index())
        Item.OnStatsChanged(self, Item, Item._Index)
    end
    PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
end

---GoRight
function UIMenu:GoRight()
    local Item = self:CurrentItem()
    if Item.ItemId == 0 or Item.ItemId == 2 or Item.ItemId == 6 or not Item:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    if Item.ItemId == 1 then
        if Item() == "UIMenuListItem" then
            Item:Index(Item:Index() + 1)
            self.OnListChange(self, Item, Item._Index)
            Item.OnListChanged(self, Item, Item._Index)
        else
            local result = tostring(Item.Callback(Item, "right"))
            Item:CurrentListItem(result)
        end
    elseif Item.ItemId == 3 then
        Item:Index(Item:Index() + 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
    elseif Item.ItemId == 4 then
        Item:Index(Item:Index() + 1)
        self.OnProgressChange(self, Item, Item:Index())
        Item.OnProgressChanged(self, Item, Item:Index())
    elseif Item.ItemId == 5 then
        Item:Index(Item:Index() + 1)
        self.OnStatsChanged(self, Item, Item:Index())
        Item.OnStatsChanged(self, Item, Item._Index)
    end
    PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
end

---SelectItem
---@param play boolean|nil
function UIMenu:SelectItem(play)
    if not self:CurrentItem():Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    if play then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
    end

    local Item = self:CurrentItem()
    if Item.ItemId == 2 then
        Item:Checked(not Item:Checked())
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        Item.OnCheckboxChanged(self, Item, Item:Checked())
        self.OnCheckboxChange(self, Item, Item:Checked())
    elseif Item.ItemId == 1 then
        if Item() == "UIMenuListItem" then
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            Item.OnListSelected(self, Item, Item._Index)
            self.OnListSelect(self, Item, Item._Index)
        else
            PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
            Item.OnListSelected(self, Item, Item._currentItem)
            self.OnListSelect(self, Item, Item._currentItem)
        end
    elseif Item.ItemId == 3 then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        Item.OnSliderSelected(self, Item, Item._Index)
        self.OnSliderSelect(self, Item, Item._Index)
    elseif Item.ItemId == 4 then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        Item.OnProgressSelected(self, Item, Item._Index)
        self.OnProgressSelect(self, Item, Item._Index)
    elseif Item.ItemId == 5 then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        Item.OnStatsSelected(self, Item, Item._Index)
        self.OnStatsSelect(self, Item, Item._Index)
    end
    if Item.ItemId ~= 2 then
        Item.Activated(self, Item)
        self.OnItemSelect(self, Item, self:CurrentSelection())
    end
end

---Go back to the previous menu
---@param boolean boolean|nil Play sound
---@param bypass boolean|nil Bypass the CanPlayerCloseMenu condition
function UIMenu:GoBack(boolean, bypass)
    local playSound = true

    if type(boolean) == "boolean" then
        playSound = boolean
    end

    if self:CanPlayerCloseMenu() or bypass then
        if playSound then
            PlaySoundFrontend(-1, self.Settings.Audio.Back, self.Settings.Audio.Library, true)
        end
        if BreadcrumbsHandler:CurrentDepth() == 1 then
            MenuHandler:CloseAndClearHistory()
            BreadcrumbsHandler:Clear()
        else
            BreadcrumbsHandler.SwitchInProgress = true
            local prevMenu = BreadcrumbsHandler:PreviousMenu()
            BreadcrumbsHandler:Backwards()
            self:Visible(false)
            if prevMenu ~= nil then
                prevMenu.menu:Visible(true)
            end
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

---Refreshes the menu description
function UIMenu:UpdateDescription()
    ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_ITEM_DESCRIPTION")
end

---Draw
function UIMenu:Draw()
    if not self._Visible or ScaleformUI.Scaleforms.Warning:IsShowing() then return end
    while not ScaleformUI.Scaleforms._ui:IsLoaded() do Citizen.Wait(0) end

    HideHudComponentThisFrame(19)

    Controls:ToggleAll(not self:DisableGameControls())

    self:SetMenuOffset(self.Position.x, self.Position.y)
    ScaleformUI.Scaleforms._ui:Render2D()

    if self.Glare then
        local fRotationTolerance = 0.5
        local dir = GetFinalRenderedCamRot(2)
        local fvar = Wrap(dir.z, 0, 360)
        if self.fSavedGlareDirection == 0 or (self.fSavedGlareDirection - fvar) > fRotationTolerance or (self.fSavedGlareDirection - fvar) < -fRotationTolerance then
            self.fSavedGlareDirection = fvar
            self._menuGlare:CallFunction("SET_DATA_SLOT", self.fSavedGlareDirection)
        end
        DrawScaleformMovie(self._menuGlare.handle, self._glarePos.x, self._glarePos.y, self._glareSize.w,
            self._glareSize.h, 255, 255, 255, 255, 0)
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
    Citizen.CreateThread(function()
        self:mouseCheck()
    end)
end

function UIMenu:CallExtensionMethod()
    self.ExtensionMethod(self)
end

function UIMenu:mouseCheck()
    self._mouseOnMenu = self:MouseControlsEnabled() and
        ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnBool("IS_MOUSE_ON_MENU")
end

function UIMenu:IsMouseOverTheMenu()
    return self._mouseOnMenu
end

local pressedInsidePanel = false
local cursor_pressed = false
local pressedInsideItem = false
local cursorPressedItem = false
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
        if event_type == 5 then --ON CLICK
            if context == -1 then
                if itemId == 2 then
                    self:GoUp()
                elseif itemId == 2 then
                    self:GoDown()
                end
            elseif context == 0 then -- normal menu items
                local item = self.Items[item_id + 1]
                if (item == nil) then return end
                if item:Selected() then
                    if item.ItemId == 0 or item.ItemId == 2 then
                        self:SelectItem(false)
                    elseif item.ItemId == 1 or item.ItemId == 3 or item.ItemId == 4 then
                        Citizen.CreateThread(function()
                            local value = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnInt("SELECT_ITEM", item_id) --[[@as number]]

                            local curr_select_item = self:CurrentItem()
                            local item_subtype_curr = curr_select_item()
                            if item.ItemId == 1 then
                                if item_subtype_curr == "UIMenuListItem" then
                                    if curr_select_item:Index() ~= value then
                                        curr_select_item:Index(value)
                                        self.OnListChange(self, curr_select_item, curr_select_item:Index())
                                        curr_select_item.OnListChanged(self, curr_select_item, curr_select_item:Index())
                                    else
                                        self:SelectItem(false)
                                    end
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
                self:CurrentSelection(item_id + 1)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            elseif context == 1 then
                local item = self.Items[item_id + 1]
                if (item == nil) then return end
                if (item.ItemId == 6 and item.Jumpable == true) or not item:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                if item:Selected() then
                    if item.ItemId == 1 or item.ItemId == 3 or item.ItemId == 4 then
                        cursorPressedItem = true
                        pressedInsideItem = true
                    end
                end
            elseif context == 2 then
                local item = self.Items[item_id + 1]
                if (item == nil) then return end
                if (item.ItemId == 6 and item.Jumpable == true) or not item:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                if item:Selected() then
                    if item.ItemId == 1 or item.ItemId == 3 or item.ItemId == 4 then
                        self:GoLeft()
                    end
                end
            elseif context == 3 then
                local item = self.Items[item_id + 1]
                if (item == nil) then return end
                if (item.ItemId == 6 and item.Jumpable == true) or not item:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                if item:Selected() then
                    if item.ItemId == 1 or item.ItemId == 3 or item.ItemId == 4 then
                        self:GoRight()
                    end
                end
            elseif context == 10 then -- panels (10 => context 1, panel_type 0) // ColorPanel
                Citizen.CreateThread(function()
                    local res = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnString("SELECT_PANEL",
                        self._currentSelection - 1) --[[@as number]]
                    local split = Split(res, ",")
                    local panel = self:CurrentItem().Panels[tonumber(split[1]) + 1]
                    panel.value = tonumber(split[2]) + 1
                    self.OnColorPanelChanged(panel.ParentItem, panel, panel:CurrentSelection())
                    panel.OnColorPanelChanged(panel.ParentItem, panel, panel:CurrentSelection())
                end)
            elseif context == 14 then
                Citizen.CreateThread(function()
                    local res = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnInt("SELECT_PANEL",
                        self:CurrentSelection() - 1)
                    local picker = self:CurrentItem().Panels[res]
                    if item_id ~= -1 then
                        local colString = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnString("GET_PICKER_COLOR",
                            item_id)
                        local split = Split(colString, ",")
                        picker._value = item_id
                        picker:_pickerSelect(SColor.FromArgb(tonumber(split[1]), tonumber(split[2]), tonumber(split[3])))
                    end
                end)
            elseif context == 11 then -- panels (11 => context 1, panel_type 1) // PercentagePanel
                pressedInsidePanel = true
                cursor_pressed = true
            elseif context == 12 then -- panels (12 => context 1, panel_type 2) // GridPanel
                pressedInsidePanel = true
                cursor_pressed = true
            elseif context == 20 then -- sidepanel
                local panel = self:CurrentItem().SidePanel
                if item_id ~= -1 then
                    panel.Value = item_id - 1
                    panel.PickerSelect(panel.ParentItem, panel, panel.Value)
                end
            end
        elseif event_type == 6 then -- ON CLICK RELEASED
            pressedInsidePanel = false
            cursor_pressed = false
            pressedInsideItem = false
            cursorPressedItem = false
        elseif event_type == 7 then -- ON CLICK RELEASED OUTSIDE
            pressedInsidePanel = false
            cursor_pressed = false
            pressedInsideItem = false
            cursorPressedItem = false
            SetMouseCursorSprite(1)
            if (self.mouseReset) then
                self.mouseReset = false
            end
        elseif event_type == 8 then -- ON NOT HOVER
            cursor_pressed = false
            cursorPressedItem = false
            if context == 0 then
                self.Items[item_id + 1]:Hovered(false)
            elseif context == 20 then
                local panel = self:CurrentItem().SidePanel
                panel:_PickerRollout()
            elseif context == 14 then
                local res = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnInt("SELECT_PANEL",
                    self:CurrentSelection() - 1)
                local picker = self:CurrentItem().Panels[res]
                picker:_PickerRollout()
            end
            if not self:IsMouseOverTheMenu() then
                return
            end
            SetMouseCursorSprite(1)
            if (self.mouseReset) then
                self.mouseReset = false
            end
        elseif event_type == 9 then -- ON HOVERED
            if context == 0 then
                self.Items[item_id + 1]:Hovered(true)
            elseif context == 2 then
                local panel = self:CurrentItem().SidePanel
                if item_id ~= -1 then
                    panel:_PickerHovered(item_id, VehicleColors:GetColorById(item_id))
                end
            elseif context == 14 then
                if item_id ~= -1 then
                    local res = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnInt("SELECT_PANEL",
                        self:CurrentSelection() - 1)
                    local picker = self:CurrentItem().Panels[res]
                    picker:_PickerHovered(item_id, VehicleColors:GetColorById(item_id))
                end
            end
            if self.mouseReset then
                self.mouseReset = true
            end
            SetMouseCursorSprite(5)
        elseif event_type == 0 then -- DRAGGED OUTSIDE
            cursor_pressed = false
            cursorPressedItem = false
        elseif event_type == 1 then -- DRAGGED INSIDE
            if pressedInsidePanel then
                cursor_pressed = true
            end
            if pressedInsideItem then
                cursorPressedItem = true
            end
        end
    end

    if cursorPressedItem == true then
        if HasSoundFinished(menuSound) then
            menuSound = GetSoundId()
            PlaySoundFrontend(menuSound, "CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        end
        Citizen.CreateThread(function()
            local value = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnInt("SELECT_ITEM", item_id) --[[@as number]]
            local item = self:CurrentItem()
            if item.ItemId == 3 then
                item._Index = value
                item.OnSliderChanged(self, item, value)
                self.OnSliderChange(self, item, value)
            elseif item.ItemId == 4 then
                item._Index = value
                item.OnProgressChanged(self, item, value)
                self.OnProgressChange(self, item, value)
            end
        end)
    else
        if not HasSoundFinished(menuSound) then
            StopSound(menuSound)
            ReleaseSoundId(menuSound)
        end
    end


    if cursor_pressed == true then
        if HasSoundFinished(menuSound) then
            menuSound = GetSoundId()
            PlaySoundFrontend(menuSound, "CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        end

        Citizen.CreateThread(function()
            local value = ScaleformUI.Scaleforms._ui:CallFunctionAsyncReturnString("SET_INPUT_MOUSE_EVENT_CONTINUE") --[[@as number]]

            local split = Split(value, ",")
            local panel = self:CurrentItem().Panels[tonumber(split[1]) + 1]
            local panel_type, panel_subtype = panel()

            if panel_subtype == "UIMenuGridPanel" then
                panel._CirclePosition = vector2(tonumber(split[2]) or 0, tonumber(split[3]) or 0)
                self.OnGridPanelChanged(panel.ParentItem, panel, panel._CirclePosition)
                panel.OnGridPanelChanged(panel.ParentItem, panel, panel._CirclePosition)
            elseif panel_subtype == "UIMenuPercentagePanel" then
                panel._percentage = tonumber(split[2])
                self.OnPercentagePanelChanged(panel.ParentItem, panel, panel._percentage)
                panel.OnPercentagePanelChange(panel.ParentItem, panel, panel._percentage)
            end
        end)
    else
        if not HasSoundFinished(menuSound) then
            StopSound(menuSound)
            ReleaseSoundId(menuSound)
        end
    end
    if self.Settings.MouseEdgeEnabled then
        local mouseVariance = GetDisabledControlNormal(2, 239)
        if IsMouseInBounds(0, 0, 30, 1080) then
            if mouseVariance < (0.05 * 0.75) then
                local mouseSpeed = 0.05 - mouseVariance
                if mouseSpeed > 0.05 then
                    mouseSpeed = 0.05
                end
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + (70 * mouseSpeed))
                SetCursorSprite(6)
                if self.mouseReset then
                    self.mouseReset = false
                end
            end
        elseif IsMouseInBounds(1920 - 30, 0, 30, 1080) then
            if mouseVariance > (1 - (0.05 * 0.75)) then
                local mouseSpeed = 0.05 - (1 - mouseVariance)
                if mouseSpeed > 0.05 then
                    mouseSpeed = 0.05
                end
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - (70 * mouseSpeed))
                SetCursorSprite(7)
                if self.mouseReset then
                    self.mouseReset = false
                end
            end
        else
            if not self:IsMouseOverTheMenu() then
                if not self.mouseReset then
                    SetCursorSprite(1)
                end
                self.mouseReset = true
            end
        end
    else
        if not self:IsMouseOverTheMenu() then
            if not self.mouseReset then
                SetCursorSprite(1)
            end
            self.mouseReset = true
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

function UIMenu:SetMenuOffset(x, y)
    self.Position = vector2(x, y)
    if self:Visible() then
        local safezone = (1.0 - math.round(GetSafeZoneSize(), 2)) * 100 * 0.005
        local rightAlign = self.menuAlignment == MenuAlignment.RIGHT
        local glareX = 0.45 + safezone

        local pos1080 = ConvertScaleformCoordsToResolutionCoords(x, y)
        local screenCoords = ConvertResolutionCoordsToScreenCoords(pos1080.x, pos1080.y)
        self._glarePos = vector2(screenCoords.x + glareX, screenCoords.y + 0.45 + safezone)
        if rightAlign then
            glareX = 1.225 - safezone
            local w, h = GetActualScreenResolution()
            screenCoords = ConvertResolutionCoordsToScreenCoords(1920 - pos1080.x, pos1080.y)
            self._glarePos = vector2(screenCoords.x - 1 + glareX, screenCoords.y + 0.45 + safezone)
        end
        self._glareSize = { w = 1.0, h = 1.0 }
        self:SetMenuData(true)
    end
end
