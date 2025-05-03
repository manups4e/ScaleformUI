PauseMenu = setmetatable({}, PauseMenu)
PauseMenu.__index = PauseMenu
PauseMenu.__call = function()
    return "PauseMenu"
end

---@class PauseMenu: Scaleform
---@field public _header Scaleform
---@field public _pause Scaleform
---@field public _pauseBG Scaleform
---@field public Loaded boolean
---@field public _visible boolean
---@field public BGEnabled boolean
---@field public Visible fun(self:PauseMenu, visible:boolean):boolean
---@field public SetHeaderTitle fun(self:PauseMenu, title:string, subtitle:string | nil, shiftUpHeader:boolean | nil):nil
---@field public SetHeaderDetails fun(self:PauseMenu, topDetail:string, midDetail:string, botDetail:string):nil
---@field public ShiftCoronaDescription fun(self:PauseMenu, shiftDesc:boolean, hideTabs:boolean):nil
---@field public ShowHeaderDetails fun(self:PauseMenu, show:boolean):nil
---@field public SetHeaderCharImg fun(self:PauseMenu, txd:string, charTexturePath:string, show:boolean):nil
---@field public SetHeaderSecondaryImg fun(self:PauseMenu, txd:string, charTexturePath:string, show:boolean):nil
---@field public HeaderGoRight fun(self:PauseMenu):nil
---@field public HeaderGoLeft fun(self:PauseMenu):nil
---@field public AddPauseMenuTab fun(self:PauseMenu, title:string, _type:number, _tabContentType:number, color:SColor | nil):nil
---@field public AddLobbyMenuTab fun(self:PauseMenu, title:string, _type:number, _tabContentType:number, color:SColor | nil):nil
---@field public SelectTab fun(self:PauseMenu, tab:number):nil
---@field public SetFocus fun(self:PauseMenu, focus:number):nil
---@field public AddLeftItem fun(self:PauseMenu, _type:number, title:string, _tabContentType:number, color:SColor, enabled:boolean):nil
---@field public AddRightTitle fun(self:PauseMenu, leftItemIndex:number, title:string):nil
---@field public AddRightListLabel fun(self:PauseMenu, leftItemIndex:number, title:string, fontName:string, fontId:number):nil
---@field public AddRightStatItemLabel fun(self:PauseMenu, leftItemIndex:number, label:string, rightLabel:string, labelFont:Font, rLabelFont:Font):nil
---@field public AddRightStatItemColorBar fun(self:PauseMenu, leftItemIndex:number, label:string, value:number, color:SColor, labelFont:Font):nil
---@field public AddRightSettingsBaseItem fun(self:PauseMenu, leftItemIndex:number, label:string, rightLabel:string, enabled:boolean):nil
---@field public AddRightSettingsListItem fun(self:PauseMenu, leftItemIndex:number, label:string, items:table, startIndex:number, enabled:boolean):nil
---@field public AddRightSettingsProgressItem fun(self:PauseMenu, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsProgressItemAlt fun(self:PauseMenu, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsSliderItem fun(self:PauseMenu, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsCheckboxItem fun(self:PauseMenu, leftItemIndex:number, label:string, style:number, check:boolean, enabled:boolean):nil
---@field public AddKeymapTitle fun(self:PauseMenu, leftItemIndex:number, title:string, rightLabel:string, rightLabel2:string):nil
---@field public AddKeymapItem fun(self:PauseMenu, leftItemIndex:number, label:string, control:string, control2:string):nil
---@field public UpdateKeymap fun(self:PauseMenu, leftItemIndex:number, rightIndex:number, control:string, control2:string):nil
---@field public SetRightSettingsItemBool fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, check:boolean):nil
---@field public SetRightSettingsItemIndex fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, value:number):nil
---@field public SetRightSettingsItemValue fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, value:number):nil
---@field public UpdateItemRightLabel fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, rightLabel:string):nil
---@field public UpdateStatsItemBasic fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, label:string, rightLabel:string):nil
---@field public UpdateStatsItemBar fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, label:string, value:number, color:SColor):nil
---@field public UpdateItemColoredBar fun(self:PauseMenu, leftItemIndex:number, rightItemIndex:number, colour:SColor):nil
---@field public SendInputEvent fun(self:PauseMenu, inputEvent:string):nil
---@field public SendScrollEvent fun(self:PauseMenu, scrollEvent:number):nil
---@field public SendClickEvent fun(self:PauseMenu):nil
---@field public Dispose fun(self:PauseMenu):nil
---@field public Draw fun(self:PauseMenu, isLobby:boolean | nil):nil
---@field public Load fun(self:PauseMenu):nil
---@field public IsLoaded fun(self:PauseMenu):boolean

---Creates a new instance of the pause menu
---@return PauseMenu
function PauseMenu.New()
    local _data = {
        _header = nil,
        _pause = nil,
        _pauseBG = nil,
        BGEnabled = false,
        Loaded = false,
        _visible = false,
        firstTick = true,
    }
    return setmetatable(_data, PauseMenu)
end

---Toggle the visibility of the pause menu
---@param visible boolean
---@return boolean
function PauseMenu:Visible(visible)
    if ToBool(visible) then
        self._visible = visible
    end
    return self._visible
end

---Load the pause menu scaleforms
function PauseMenu:Load()
    if (self._header ~= nil and self._pause ~= nil and self._pauseBG ~= nil) then return end
    self._header = Scaleform.RequestWidescreen("pausemenuheader")
    self._pause = Scaleform.RequestWidescreen("ScaleformUIPause")
    self._pauseBG = Scaleform.RequestWidescreen("store_background")
end

function PauseMenu:FadeInMenus()
    self._header:CallFunction("DRAW_MENU")
    self._pause:CallFunction("DRAW_MENU")
end

function PauseMenu:IsLoaded()
    return self._header ~= nil and self._header:IsLoaded() and self._pause ~= nil and self._pause:IsLoaded() and self._pauseBG ~= nil and self._pauseBG:IsLoaded()
end

---Set the header title and subtitle text of the pause menu header
---@param title string
---@param subtitle string | nil
---@param shiftUpHeader boolean | nil
function PauseMenu:SetHeaderTitle(title, subtitle, shiftUpHeader)
    if (subtitle == nil) then subtitle = "" end
    if (shiftUpHeader == nil) then shiftUpHeader = false end
    self._header:CallFunction("SET_HEADER_TITLE", title, subtitle, shiftUpHeader)
end

---Set the header details of the pause menu header
---@param topDetail string
---@param midDetail string
---@param botDetail string
function PauseMenu:SetHeaderDetails(topDetail, midDetail, botDetail)
    self._header:CallFunction("SET_HEADER_DETAILS", topDetail, midDetail, botDetail, false)
end

---Shift the corona description of the pause menu header
---@param shiftDesc boolean
---@param hideTabs boolean
function PauseMenu:ShiftCoronaDescription(shiftDesc, hideTabs)
    self._header:CallFunction("SHIFT_CORONA_DESC", shiftDesc, hideTabs)
end

---Toggle the header details of the pause menu header
---@param show boolean
function PauseMenu:ShowHeadingDetails(show)
    self._header:CallFunction("SHOW_HEADING_DETAILS", show)
end

---Set the header character headshot of the pause menu header
---@param txd string
---@param charTexturePath string
---@param show boolean
function PauseMenu:SetHeaderCharImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CHAR_IMG", txd, charTexturePath, show)
end

---Set the header secondary image of the pause menu header
---@param txd string
---@param charTexturePath string
---@param show boolean
function PauseMenu:SetHeaderSecondaryImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CREW_IMG", txd, charTexturePath, show)
end

---Move selection of the header to the right
function PauseMenu:HeaderGoRight()
    self._header:CallFunction("GO_RIGHT")
end

---Move selection of the header to the left
function PauseMenu:HeaderGoLeft()
    self._header:CallFunction("GO_LEFT")
end

---Add a tab to the pause menu
---@param title string
---@param _type number
---@param color SColor Sets the color of the tab (default: SColor.HUD_Freemode)
function PauseMenu:AddPauseMenuTab(title, _type, color)
    if color == nil then color = SColor.HUD_Freemode end
    self._header:CallFunction("ADD_HEADER_TAB", title, _type, color)
end

---Select a tab in the pause menu
function PauseMenu:SelectTab(tab)
    self._header:CallFunction("SET_TAB_INDEX", tab)
end

---Set the focued item of the pause menu
---@param focus number
function PauseMenu:SetFocus(focus, bDontFallOff, bSkipInputSpamCheck)
    if bDontFallOff == nil then bDontFallOff = false end
    if  bSkipInputSpamCheck == nil then  bSkipInputSpamCheck = false end
    self._pause:CallFunction("MENU_SHIFT_DEPTH", focus, bDontFallOff, bSkipInputSpamCheck)
end

---Dispose the pause menu
function PauseMenu:Dispose()
    self._visible = false
    self._pause:CallFunction("CLEAR_ALL")
    self._header:CallFunction("CLEAR_ALL")
    -- self._pause:Dispose()
    -- self._header:Dispose()
    -- self._pauseBG:Dispose()
    self.firstTick = true;
end

---Draw the pause menu
---@param isLobby boolean|nil
function PauseMenu:Draw(isLobby)
    if isLobby == nil then isLobby = false end
    if self._visible then
        if IsFrontendReadyForControl() then
            SetScriptGfxDrawBehindPausemenu(true)
            if IsUsingKeyboard(2) then
                SetMouseCursorActiveThisFrame()
            end
            if self.firstTick then
                self:FadeInMenus()
                self.firstTick = false;
            end
            if self.BGEnabled then
                self._pauseBG:Render2D()
            end

            local headx, heady, headw, headh = AdjustNormalized16_9ValuesForCurrentAspectRatio(0.501, 0.162, 0.6782, 0.145)
            local pausex, pausey, pausew, pauseh = AdjustNormalized16_9ValuesForCurrentAspectRatio(0.6617187, 0.7226667, 1.0, 1.0)

            self._header:Render2DNormal(headx, heady, headw, headh)
            self._pause:Render2DNormal(pausex, pausey, pausew, pauseh)
        end
    end
end
